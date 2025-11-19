import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get/get.dart';


class AppDialogs {
  static void showDoubleButtonDialog(String titleText,
      {String? bodyText, Color? bodyTextColor, String? positiveButtonText, String? negativeButtonText, Function? onPositiveButtonClick, Function? onNegativeButtonClick, String? centerImageUrl, bool? cancelable = true}) {
    Get.defaultDialog(
        title: titleText,
        radius: 0,
        barrierDismissible: cancelable ?? true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(visible: bodyText?.isNotEmpty ?? false, child: Text(bodyText ?? "", textAlign:  TextAlign.center, style:TextStyle(color:bodyTextColor))),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FrElevatedButton(
                    name: negativeButtonText ?? 'no'.tr,
                    onPressed: () => {
                      Get.back(),
                      if (onNegativeButtonClick != null) onNegativeButtonClick(),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 10, // Shadow elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FrElevatedButton(
                    name: positiveButtonText ?? 'yes'.tr,
                    onPressed: () => {
                      Get.back(),
                      if (onPositiveButtonClick != null) onPositiveButtonClick(),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(Get.context!).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 10, // Shadow elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

}
