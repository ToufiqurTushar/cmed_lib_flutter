import 'dart:io';

import 'package:cmed_lib_flutter/page/pos_printer/posprinter_logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:image/image.dart' as img;

import '../../common/widget/basic_app_bar.dart';



class PosPrinterView extends RapidView<PosPrinterLogic> {
  static String routeName = "/PosPrinterView";

  const PosPrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        backgroundColor: Colors.white,
        appBar: BasicAppBar("Select Printer".tr),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(controller.isScanning.value?"Searching...".tr: "Found Devices: ${controller.scanResults.length}".tr),
                  Spacer(),
                  if (controller.isScanning.value)
                  SizedBox(width:12, height: 12, child: CircularProgressIndicator()),

                  if (!controller.isScanning.value)
                  SizedBox(
                    height: 30,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: controller.scanDevice,
                      icon: const Icon(Icons.search),
                      label: const Text("Search Printers"),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.scanResults.length,
              itemBuilder: (context, index) {
                final device = controller.scanResults[index].device;
                final deviceInfo = controller.scanResults[index].toString();
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text('${device.id.id}'),
                  trailing: const Icon(Icons.print),
                  onTap: () {
                    controller.printImageToPrinter(device, controller.selectedImageFilePath.value);
                  }
                );
              },
            ),
            Expanded(
              child:Padding(
                padding: const EdgeInsets.all(24.0),
                child: controller.selectedImageFilePath.value.isEmpty? Container():Image.file(
                  File(controller.selectedImageFilePath.value),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            // Visibility(
            //   visible: kDebugMode,
            //   child: Expanded(
            //     child:Padding(
            //       padding: const EdgeInsets.all(24.0),
            //       child: (controller.resizedImageFilePath.value?.isEmpty??true)? Container():Image.memory(
            //         img.encodePng(controller.resizedImageFilePath.value!),
            //         fit: BoxFit.fitWidth,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void loadDependentLogics() {
    Get.put(PosPrinterLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {};
  }
}
