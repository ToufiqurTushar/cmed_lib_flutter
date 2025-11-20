import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class FileUtils {
  static const int DEFAULT_IMAGE_QUALITY_PERCENT = 80;
  static const double DEFAULT_IMAGE_HEIGHT = 720;
  static const double DEFAULT_IMAGE_WIDTH = 1280;

  static const int TERGET_IMAGE_HEIGHT = 600;
  static const int TERGET_IMAGE_WIDTH = 600;

  static final ImagePicker _picker = ImagePicker();

  static void takePhoto(ImageSource source, Function onImageSelect) async {
    final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: DEFAULT_IMAGE_QUALITY_PERCENT,
        maxWidth: DEFAULT_IMAGE_HEIGHT,
        maxHeight: DEFAULT_IMAGE_WIDTH);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      int sizeInBytes = imageFile.lengthSync();
      // double sizeInKb = sizeInBytes / (1024 * 1);
      // if (sizeInKb > 1026) {
      File compressedFile = await _compressFile(imageFile);
      onImageSelect(compressedFile);
      // } else {
      //   onImageSelect(imageFile);
      // }
    }
  }

  static void takeFile(
      {List<String>? allowedExtensions,
      required double sizeLimitInMB,
      required Function onFileSelect}) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['jpg', 'png', 'jpeg', 'pdf']);

    if (pickedFile != null) {
      File file = File(pickedFile.files.single.path!);
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      RLog.error("selected file sizeInMb:$sizeInMb");
      if(isImage(file)) {
        File comressedImageFile = await _compressFile(file);
        sizeInBytes = comressedImageFile.lengthSync();
        double sizeInMbAfterCompressed = sizeInBytes / (1024 * 1024);
        RLog.error("size: $sizeInMb after compressed:$sizeInMbAfterCompressed");
        onFileSelect(comressedImageFile);
      } else {
        print(sizeInMb);
        if (sizeInMb <= sizeLimitInMB) {
          onFileSelect(file);
        } else {
          RLog.error("$sizeInMb > $sizeLimitInMB");
        }
      }
    }
  }

  static bool isImage(File f) {
    String? mime = lookupMimeType(f.path);
    String? fileType;
    String? mimeType;
    try {
      if (mime != null) {
        fileType = mime.split("/")[0];
        mimeType = mime.split("/")[1];
      }
      if (mimeType == null || fileType == null) {
        return false;
      } else {
        return fileType == "image";
      }
    } catch (e) {
      return false;
    }
  }

  static Future<File> _compressFile(File file) async {
    try {
      var compressedFile = await compressImageAndGetFile(file);
      return compressedFile ?? file;
    } catch (e) {
      RLog.error('error ');
      return file;
    }
  }

  static String? getFileNameFromFile(File? f) {
    return f?.path.split("/").last;
  }

  static MediaType? getMediaTypeFromFile(File f) {
    String? mime = lookupMimeType(f.path);
    String? fileType;
    String? mimeType;
    try {
      if (mime != null) {
        fileType = mime.split("/")[0];
        mimeType = mime.split("/")[1];
      }
      if (mimeType == null || fileType == null) {
        return null;
      } else {
        return MediaType(fileType, mimeType);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        //final directory = await getExternalStorageDirectory();
        final directory = await getApplicationDocumentsDirectory();
        externalStorageDirPath = directory.path;
        //externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        //final directory = await getExternalStorageDirectory();
        final directory = await getTemporaryDirectory();
        externalStorageDirPath = directory.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  static Future<String?> findDownloadPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        //final directory = await getExternalStorageDirectory();
        final directory = await getDownloadsDirectory();
        externalStorageDirPath = directory?.path;
        //externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        //final directory = await getExternalStorageDirectory();
        final directory = await getTemporaryDirectory();
        externalStorageDirPath = directory.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  static Future<bool> checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt > 29) {
      final status = await Permission.mediaLibrary.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.mediaLibrary.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  static Future shareFiles(List<String> filePaths,
      {required BuildContext context, String? subject, String? text}) async {
    final box = context.findRenderObject() as RenderBox?;

    if (filePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < filePaths.length; i++) {
        files.add(XFile(filePaths[i], name: filePaths[i]));
      }
      Share.shareXFiles(
        files,
        text: text,
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } else {
      Share.share(
        text ?? "Susastho App",
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }
  }

  static SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  static Future<File?> compressImageAndGetFile(File file) async {
    final tempDir = await getTemporaryDirectory();
    File targetImageFile = await File('${tempDir.path}/image.jpg').create();
    var imageInUnit8List = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      format: CompressFormat.jpeg,
      quality: 85,
    );
    targetImageFile.writeAsBytesSync(imageInUnit8List?.toList() ?? []);
    return targetImageFile;
  }
}
