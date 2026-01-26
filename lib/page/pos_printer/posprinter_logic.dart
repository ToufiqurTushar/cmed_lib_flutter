import 'dart:io';
import 'dart:typed_data';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/pos_printer/posprinter_arg.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:image/image.dart' as img;
import '../../common/api/app_http.dart';
import '../../common/helper/toast_utils.dart';

class PosPrinterLogic extends BaseLogic {
  final arg = Get.arguments as PosPrinterArg;
  final httpProvider = Get.find<HttpProvider>();
  final scanResults = <ScanResult>[].obs;
  final selectedImageFilePath = "".obs;
  final selectedImageAsResized = Rxn<img.Image>();
  final selectedDevice = Rxn<BluetoothDevice>();
  BluetoothCharacteristic? bluetoothWriteCharacteristic;
  final isScanning = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    scanDevice();
    if(arg.imageUrl != null){
      downloadPngFile(arg.imageUrl!);
    }
    else if(arg.imageFilePath != null){
      await modifyAndResaveImageForPosPrinter(arg.imageFilePath!);
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (selectedDevice.value != null) {
      selectedDevice.value!.disconnect();
    }
  }

  Future<void> downloadPngFile(String url) async{
    showLoader();
    httpProvider.downloadPngFile(url).then((value) async {
      await modifyAndResaveImageForPosPrinter(value.path);
      RLog.error(value.path);
      hideLoader();
    }).catchError((e){
      RLog.error(e);
      hideLoader();
      ShowToast.error('error_message_something_went_wrong'.tr);
    });
  }

  modifyAndResaveImageForPosPrinter(String imagePath) async {
    final image = await loadImage(imagePath);
    final resizedImage = autoCropWhite(image);
    await File(imagePath).writeAsBytes(img.encodePng(resizedImage));
    selectedImageAsResized.value = resizedImage;
    selectedImageFilePath.value = imagePath;
  }

  printImage() {
    if(selectedDevice.value != null && selectedImageFilePath.value.isNotEmpty) {
      printImageToPrinter(selectedDevice.value!, selectedImageFilePath.value);
    } else {
      ShowToast.error('Please select device and image');
    }
  }

  // Scan & connect to printer
  Future<void> scanDevice() async {
    if (isScanning.value) return;
    isScanning.value = true;
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
    FlutterBluePlus.scanResults.listen((results) async {
      isScanning.value = false;
      scanResults.value = results.where((result) => result.device.name.isNotEmpty && !result.device.name.toLowerCase().contains("tv")).map((m)=>m).toList();
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    FlutterBluePlus.stopScan();
    selectedDevice.value = device;
    await selectedDevice.value!.connect(autoConnect: false, timeout: const Duration(seconds: 15),);
    await discoverServices();
    print('${device.name} connected');
  }

  //Find writable characteristic
  Future<void> discoverServices() async {
    final services = await selectedDevice.value!.discoverServices();
    for (var s in services) {
      for (var c in s.characteristics) {
        if (c.properties.writeWithoutResponse) {
          bluetoothWriteCharacteristic = c;
          return;
        }
      }
    }
    throw Exception("No writable characteristic found");
  }

  Future<void> printImageToPrinter(BluetoothDevice device, String imageFilePath) async {
    if(selectedImageFilePath.value.isEmpty){
      if(arg.imageUrl != null){
        await downloadPngFile(arg.imageUrl!);
        if(selectedImageFilePath.value.isNotEmpty){
          await printImageToPrinter(device, selectedImageFilePath.value);
        }
      } else {
        ShowToast.error("Invalid Image File");
      }
      return ;
    }

    try {
      showLoader();
      await connectToDevice(device);
      final bytes = await getBytesFromImageFile(imageFilePath);
      //final bytes = await getBytesFromTestPage(deviceName:selectedDevice.value?.name);
      await printBytes(bytes);
      ShowToast.success("Printed successfully");
      hideLoader();
    } catch (e) {
      print(e);
      ShowToast.error("Print failed: $e");
      hideLoader();
    }
  }





  //Load image from file
  Future<img.Image> loadImage(String path) async {
    final bytes = await File(path).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception("Invalid image file");
    return image;
  }

  //Resize image for thermal printer (58mm = 384px)
  img.Image resizeForThermal(img.Image image) {
    return img.copyResize(
      image,
      width: 384,
      interpolation: img.Interpolation.average,
    );
  }

  //crop white part
  img.Image autoCropWhite(img.Image src, {int threshold = 250}) {
    int top = 0, bottom = src.height - 1;
    int left = 0, right = src.width - 1;

    bool isWhite(img.Color p) =>
        p.r > threshold && p.g > threshold && p.b > threshold;

    // Top
    while (top < src.height &&
        List.generate(src.width, (x) => isWhite(src.getPixel(x, top))).every((v) => v)) {
      top++;
    }

    // Bottom
    while (bottom > top &&
        List.generate(src.width, (x) => isWhite(src.getPixel(x, bottom))).every((v) => v)) {
      bottom--;
    }

    // Left
    while (left < src.width &&
        List.generate(src.height, (y) => isWhite(src.getPixel(left, y))).every((v) => v)) {
      left++;
    }

    // Right
    while (right > left &&
        List.generate(src.height, (y) => isWhite(src.getPixel(right, y))).every((v) => v)) {
      right--;
    }

    return img.copyCrop(
      src,
      x: left,
      y: top,
      width: right - left + 1,
      height: bottom - top + 1,
    );
  }

  //get image byte for printing
  Future<List<int>> getBytesFromImageFile(String imageFilePath) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final image = await loadImage(imageFilePath);

    //final resizedImage = autoCropWhite(image);
    //final resizedImage = resizeForThermal(image);
    //final resizedImage = prepareImageForThermal(image);

    //resizedImageFilePath.value = resizedImage;
    // Save local image
    //await File(selectedImageFilePath.value).writeAsBytes(img.encodePng(resizedImage));

    List<int> bytes = [];
    bytes += generator.image(image, align: PosAlign.center);
    bytes += generator.feed(1);
    bytes += generator.cut();

    return bytes;
  }


  img.Image prepareImageForThermal(img.Image original) {
    // Create white background (no alpha)
    final background = img.Image(width: original.width, height: original.height);

    // Fill white using the required named argument
    img.fill(background, color: img.ColorRgba8(255, 255, 255, 255));

    // Composite original over white background (removes alpha)
    img.compositeImage(
      background,
      original,
      blend: img.BlendMode.direct,
    );

    // Resize to printer width (e.g., 384px for 58mm printer)
    final resized = img.copyResize(
      background,
      width: 384,
      interpolation: img.Interpolation.average,
    );

    // Convert to grayscale
    final gray = img.grayscale(resized);

    // Increase contrast
    final contrasted = img.contrast(gray, contrast: 150); // `amount` is required in 4.x

    final blackWhite = toBlackAndWhite(contrasted); // 1-bit ready for thermal printer
    return blackWhite;
  }

  img.Image toBlackAndWhite(img.Image src, {int threshold = 128}) {
    final bw = img.Image.from(src); // clone the image

    for (int y = 0; y < bw.height; y++) {
      for (int x = 0; x < bw.width; x++) {
        final pixel = bw.getPixel(x, y); // returns a Color object

        // get RGB channels
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        // compute grayscale luminance
        final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();

        // set pixel to black or white
        final value = gray > threshold ? 255 : 0;
        bw.setPixel(x, y,img.ColorRgba8(value, value, value, value));
      }
    }

    return bw;
  }


  //Print ESC/POS bytes
  Future<void> printBytes(List<int> bytes) async {
    if (bluetoothWriteCharacteristic == null) {
      throw Exception("Printer not connected");
    }

    const chunkSize = 157;

    for (int i = 0; i < bytes.length; i += chunkSize) {
      final chunk = bytes.sublist(
        i,
        (i + chunkSize > bytes.length) ? bytes.length : i + chunkSize,
      );

      await bluetoothWriteCharacteristic!.write(
        Uint8List.fromList(chunk),
        withoutResponse: true,
      );
    }
  }

  Future<List<int>> getBytesFromTestPage({String? deviceName}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes += generator.text(
      'FLUTTER THERMAL PRINTER',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Item',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: 'Price',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Apple', width: 6),
      PosColumn(
          text: '\$1.00',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Banana', width: 6),
      PosColumn(
          text: '\$0.50',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Orange', width: 6),
      PosColumn(
          text: '\$0.75',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: '\$2.25',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.feed(1);
    bytes += generator.text(
      'Printer Type: ${deviceName ?? "Unknown"}',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.feed(1);
    bytes += generator.text(
      'Thank you for your purchase!',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += generator.cut();
    return bytes;
  }
}