import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widget/basic_app_bar.dart';

Widget DeviceReconnectPage({
  required String imageAsset,
  required String suggestion,
  required String message,
  required Function onReconnectDevice,
  Function? onManualSelect
}) {
  return Scaffold(
    appBar: BasicAppBar('label_connecting_device'.tr,),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: DeviceReconnectView(
                    imageAsset: imageAsset,
                    suggestion: suggestion,
                    message: message,
                    onReconnectDevice:onReconnectDevice,
                    onManualSelect:onManualSelect,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}


Widget DeviceReconnectView({
  required String imageAsset,
  required String suggestion,
  required String message,
  required Function onReconnectDevice,
  Function? onManualSelect
}) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: imageAsset.contains(".svg")?  SvgPicture.asset(imageAsset): Image.asset(imageAsset),
          ),
        ),
        SizedBox(height: 20,),
        // Row with blue background and white text
        Container(
          width: double.infinity, // Full width
          color: Theme.of(Get.context!).primaryColorLight, // Background color
          padding: const EdgeInsets.all(10.0), // Padding for text
          child: Text(
            suggestion,
            style: TextStyle(
              color: Theme.of(Get.context!).primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center, // Center align the text
          ),
        ),

        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/measurement/ic_power_disconnect.png', width: 50,),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      color: Theme.of(Get.context!).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () async{
                          await onReconnectDevice();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'label_reconnect'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: onManualSelect == null?Container():Card(
                      elevation: 4,
                      color: Theme.of(Get.context!).primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          onManualSelect();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'label_manual'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(Get.context!).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}