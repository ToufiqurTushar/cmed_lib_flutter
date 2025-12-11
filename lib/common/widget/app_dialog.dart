import 'dart:io';

import 'package:cmed_lib_flutter/common/helper/digit_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import '../helper/text_utils.dart';

class AppDialogs {
  static void showDoubleButtonDialog(String titleText,
      {String? bodyText, Color? bodyTextColor, String? positiveButtonText, String? negativeButtonText, Function? onPositiveButtonClick, Function? onNegativeButtonClick, String? centerImageUrl, bool? cancelable = true}) {
    Get.defaultDialog(
        title: titleText,
        radius: 0,
        barrierDismissible: cancelable ?? true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        titleStyle: CMEDTextUtils.alertTitleTextStyle,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(Utils.notNullOrEmpty(centerImageUrl))SvgPicture.asset(centerImageUrl!),
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
                    name:negativeButtonText ?? 'no'.tr,
                    onPressed: () => {
                      Get.back(),
                      if (onNegativeButtonClick != null) onNegativeButtonClick(),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FrElevatedButton(
                    name:positiveButtonText ?? 'yes'.tr,
                    onPressed: () => {
                      Get.back(),
                      if (onPositiveButtonClick != null) onPositiveButtonClick(),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(Get.context!).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  static void showDoubleButtonDialogWithContent(
      {String title='', Widget? content, String? positiveButtonText, String? negativeButtonText, Function? onPositiveButtonClick, Function? onNegativeButtonClick,  bool? cancelable = true}) {
    Get.defaultDialog(
        title: title,
        radius: 0,
        barrierDismissible: cancelable ?? true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        titleStyle: CMEDTextUtils.alertTitleTextStyle,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: content,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FrElevatedButton(
                      name:positiveButtonText ?? 'yes'.tr,
                      onPressed: () => {
                        Get.back(),
                        if (onPositiveButtonClick != null) onPositiveButtonClick(),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(Get.context!).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      )
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FrElevatedButton(
                      name:negativeButtonText ?? 'no'.tr,
                      onPressed: () => {
                        Get.back(),
                        if (onNegativeButtonClick != null) onNegativeButtonClick(),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      )
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        )
    );
  }


  static void showSingleButtonDialog(String titleText, {String? positiveButtonText, String? centerImageUrl, Function? onButtonClick, bool? cancelable = true, bool? isGoBack = true, Color? buttonBgColor}) {
    Get.defaultDialog(
        title: titleText,
        barrierDismissible: cancelable ?? true,
        radius: 0,
        titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        titleStyle: CMEDTextUtils.alertTitleTextStyle,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(centerImageUrl!=null)
            SvgPicture.asset(centerImageUrl),
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FrElevatedButton(
                      name: positiveButtonText ?? 'label_continue'.tr,
                      onPressed: () => {
                        if(isGoBack ?? true) Get.back(),
                        if (onButtonClick != null) onButtonClick(),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBgColor??Theme.of(Get.context!).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      )
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        )
    );
  }


  static void showDialogWithContent(Widget child) {
    Get.dialog(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                child,
              ],
            ),
          ],
        )
    );
  }
  static void showDialogWithContentAndClose(Widget child) {
    Get.dialog(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        child,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: ()=> Get.back(),
                      child: const Icon(
                          Icons.close,
                          color: Colors.white
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        )
    );
  }


  static void showTelemedicineNotAllowedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Makes the dialog non-cancellable
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "label_telemedicine".tr,
              style: const TextStyle(
                color: Colors.red, // Red color for the title
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            "message_no_telemedicine_service".tr,
            textAlign: TextAlign.center, // Center-align the content text
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Button shape
                  ),
                ),
                child: Text(
                  "label_ok".tr,
                  style: const TextStyle(color: Colors.white), // White text color for better contrast
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  static void showImageUploadDialog(BuildContext context, Function(File file) onFilePicked) {
    final picker = ImagePicker();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0, bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title with Close Button overlaid
                  Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 25, top: 5),
                          child: Text(
                            'label_upload_image'.tr,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Gallery and Camera Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            onFilePicked(File(pickedFile.path));
                          } else {
                            ShowToast.error('No file selected');
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/images/ic_gallery.svg",
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 8),
                            Text('label_upload_from_gallery'.tr),
                          ],
                        ),
                      ),
                      // Camera
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          final pickedFile = await picker.pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            onFilePicked(File(pickedFile.path));
                          } else {
                            ShowToast.error('No file selected');
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/images/icon_camera.svg",
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 8),
                            Text('label_take_photo'.tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  static Widget showBookingSuccessDialog() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/swasti/images/ic_success_logo.svg',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  'Appointment Booked Successfully! Doctor will call you back.'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: FrElevatedButton(
                      name:'OK'.tr,
                      onPressed: () => {
                      Get.back(),
                      Get.back(),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      )
                  ),
                )
              ],
            ),
          ),
        )
    )
    );
  }
}
