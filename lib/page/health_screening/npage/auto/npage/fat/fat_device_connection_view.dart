import 'dart:convert';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/fat/fat_device_connection_logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import '../../../../../../common/widget/basic_app_bar.dart';

import '../../../../../../common/widget/device/cmed_measurement_button.dart';
import '../../../../../../common/widget/device/cmed_measurement_running_message.dart';
import '../../../../../user_management/repository/profile_repository.dart';
import '../../../../nview/device_disconnected_view.dart';
import '../../enum/screen_enum.dart';

class FatDeviceConnectionView extends RapidView<FatDeviceConnectionLogic> {
  static String routeName = '/fat_device_connection_page';

  const FatDeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(controller.screen_status.value != ScreenEnum.MEASURING.name) {
          return true;
        }
        return false;
      },
      child: widgetV(
        v2: Scaffold(
          appBar: controller.isNestedRoute? null:MiniAppBar(
              'label_body_fat_composition'.tr),
          body: SafeArea(
            child: Column(
              children: [
                Obx(() => Expanded(
                  child: Stack(
                    children: [
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.CONNECT.name ||
                            controller.screen_status.value ==
                                ScreenEnum.CONNECTING.name,
                        child: Center(
                          child: Obx(
                                () => CMEDDeviceConnectionButton(
                              controller.buttonText.value,
                              Icons.bluetooth,
                                  () {
                                controller.connect();
                              },
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value == ScreenEnum.DEVICE_NOT_FOUND.name,
                        child: Center(
                          child: DeviceReconnectView(
                            imageAsset: 'assets/images/device/img_bmi_first.svg',
                            suggestion: 'label_keep_device_switch_on'.tr,
                            message: 'label_device_not_found'.tr,
                            onReconnectDevice: () async {
                              await controller.connect();
                            },
                            //onManualSelect: ()=> Get.offNamed(BmiHeightInputView.routeName, id:controller.isNestedRoute?1: null),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.SEARCHING.name,
                        child: Center(
                          child: Obx(
                                () => CMEDDeviceConnectionButton(
                              controller.buttonText.value,
                              Icons.bluetooth,
                                  () {
                                controller.connect();
                              },
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.MEASURING.name,
                        child: Column(
                          children: [
                            Expanded(
                                child: Center(
                                  child: Text(
                                    controller.reading.value.trAmount(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            SvgPicture.asset("assets/images/screening/ic_bmi_connect.svg"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CMEDMeasurementRunningMessage(
                                  'label_place_the_device_on_an_even_horizontal_place'.tr),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.RESULT_FOUND.name || controller.resultFound.value,
                        child: Column(
                          children: [
                            Expanded(
                                child: Center(
                                  child: Text(
                                    controller.reading.value.trAmount(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            SvgPicture.asset("assets/images/screening/ic_bmi_connect.svg"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CMEDMeasurementRunningMessage(
                                  'label_place_the_device_on_an_even_horizontal_place'.tr),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CMEDPrimaryElevatedButton(
                                        'label_next'.tr,
                                            () => {
                                          controller.sendMeasurement(),
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value == ScreenEnum.DISCONNECTED.name && !controller.resultFound.value,
                        child: Center(
                          child: DeviceReconnectView(
                            imageAsset: 'assets/images/screening/ic_bmi_connect.svg',
                            suggestion: 'label_keep_device_switch_on'.tr,
                            message: 'label_device_disconnected_please_reconnect_to_get_measurements'.tr,
                            onReconnectDevice:()=> controller.connect(),
                          ),
                        ),
                      ),
                      Obx(() {
                        return Visibility(
                            visible: controller.isLoading.value,
                            child: const Center(
                                child: CircularProgressIndicator())
                        );
                      }),

                      kDebugMode ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: (){
                                changeEvent(context);
                              },
                              child: Text('ChangeEvent')
                          ),
                        ],
                      ) : const SizedBox.shrink(),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
        v1: Scaffold(
          appBar: BasicAppBar(
            'label_body_fat_composition'.tr),
          body: SafeArea(
            child: Column(
              children: [
                Obx(() => Expanded(
                      child: Stack(
                        children: [
                          Visibility(
                            visible: controller.screen_status.value ==
                                    ScreenEnum.CONNECT.name ||
                                controller.screen_status.value ==
                                    ScreenEnum.CONNECTING.name,
                            child: Center(
                              child: Obx(
                                () => CMEDDeviceConnectionButton(
                                  controller.buttonText.value,
                                  Icons.bluetooth,
                                  () {
                                    controller.connect();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.screen_status.value == ScreenEnum.DEVICE_NOT_FOUND.name,
                            child: Center(
                              child: DeviceReconnectView(
                                imageAsset: 'assets/images/device/img_bmi_first.svg',
                                suggestion: 'label_keep_device_switch_on'.tr,
                                message: 'label_device_not_found'.tr,
                                onReconnectDevice: () async {
                                  await controller.connect();
                                },
                                //onManualSelect: ()=> Get.offNamed(BmiHeightInputView.routeName, id:controller.isNestedRoute?1: null),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.screen_status.value ==
                                ScreenEnum.SEARCHING.name,
                            child: Center(
                              child: Obx(
                                () => CMEDDeviceConnectionButton(
                                  controller.buttonText.value,
                                  Icons.bluetooth,
                                  () {
                                    controller.connect();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.screen_status.value ==
                                ScreenEnum.MEASURING.name,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    controller.reading.value.trAmount(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                                SvgPicture.asset("assets/images/screening/ic_bmi_connect.svg"),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CMEDMeasurementRunningMessage(
                                      'label_place_the_device_on_an_even_horizontal_place'.tr),
                                ),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Padding(
                                //         padding: const EdgeInsets.all(16.0),
                                //         child: CMEDWhiteElevatedButton(
                                //             'label_done'.tr,
                                //             () => {
                                //                   controller.stopMeasurement(),
                                //                   controller.screen_status.value =
                                //                       ScreenEnum.RESULT_FOUND.name,
                                //                 }),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.screen_status.value == ScreenEnum.DISCONNECTED.name && !controller.resultFound.value,
                            child: Center(
                              child: DeviceReconnectView(
                                imageAsset: 'assets/images/screening/ic_bmi_connect.svg',
                                suggestion: 'label_keep_device_switch_on'.tr,
                                message: 'label_device_disconnected_please_reconnect_to_get_measurements'.tr,
                                onReconnectDevice:()=> controller.connect(),
                              ),
                            ),
                          ),
                          Obx(
                            ()=> Visibility(
                              visible: controller.screen_status.value ==
                                  ScreenEnum.RESULT_FOUND.name || controller.resultFound.value,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CMEDMeasurementRunningMessage(
                                            'label_please_wait_while_taking_measurement'.tr),
                                      )
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(70),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 320,
                                      height: 180,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'label_measurement_store_warning'.tr,
                                              textAlign: TextAlign.center,
                                              style:
                                                  CMEDTextUtils.alertTitleTextStyle,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              controller.getInputText(),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: CMEDPrimaryElevatedButton(
                                                    'yes'.tr,
                                                    () => {
                                                      controller.sendMeasurement()
                                                    },
                                                    buttonBgColor: Theme.of(context).primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    height: 42,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: CMEDPrimaryElevatedButton(
                                                    'no'.tr,
                                                    () => {
                                                      controller.disconnect(),
                                                      controller.resultFound.value = false,
                                                      Get.back(),
                                                    },
                                                    buttonBgColor: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    height: 42,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(() {
                            return Visibility(
                                visible: controller.isLoading.value,
                                child: const Center(
                                    child: CircularProgressIndicator())
                            );
                          }),
                          Visibility(visible:controller.isLoading.value, child: Center(child: CircularProgressIndicator(color: Colors.white,))),
                          kDebugMode ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: (){
                                    changeEvent(context);
                                  },
                                  child: Text('ChangeEvent')
                              ),
                            ],
                          ) : const SizedBox.shrink(),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );

  }


  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<FatDeviceConnectionLogic>().isThemeV2) {
      return v2 ?? v1;
    }
    return v1;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
      return HealthScreeningHomeI18N.getTranslations();
  }

  @override
  String getRouteName() {
      return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.put(ScreeningReportRepository());
    Get.put(FatDeviceConnectionLogic(repository: Get.find<ScreeningReportRepository>(), profileRepository: Get.find<ProfileRepository>() ));
  }

  void changeEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an Item'),
          content: SizedBox(
            // Essential: Gives the AlertDialog a finite width boundary
            width: double.maxFinite,
            child: Column(
              children: [
                ListTile(
                  title: Text('MEASURING'),
                  onTap: () {
                    controller.screen_status.value = ScreenEnum.MEASURING.name;
                    controller.result.value = "10";
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.result.value = "10";
                controller.screen_status.value = ScreenEnum.RESULT_FOUND.name;
                String jsonString = '''{
  "bodyFatData": {
    "adc": null,
    "age": null,
    "bfr": null,
    "bm": null,
    "bmi": null,
    "bmr": null,
    "bodyAge": null,
    "date": null,
    "height": null,
    "number": null,
    "pp": null,
    "rom": null,
    "sex": null,
    "sfr": null,
    "time": null,
    "uvi": null,
    "vwc": null,
    "weight": null
  },
  "c_adc": 550,
  "c_age": 40,
  "c_bfr": 21.5,
  "c_bm": 2.2,
  "c_bmi": 22.7,
  "c_bmr": 1168.0,
  "c_bodyAge": 42,
  "c_fatMass": 11.76,
  "c_fatNotWeight": 42.94,
  "c_height": 155,
  "c_muscleMass": 36.48,
  "c_number": 1,
  "c_obesityStatus": "Normal",
  "c_pp": 23.2,
  "c_proteinMass": 12.69,
  "c_rom": 66.7,
  "c_sex": 1,
  "c_sfr": 14.5,
  "c_stdWeight": 50.8,
  "c_uvi": 11.0,
  "c_vwc": 54.8,
  "c_weight": 54.7,
  "c_weightDiff": 3.9,
  "c_weightDiffStatus": "Need to loose",
  "maleWeight": {
    "135.0": [28.5, 34.9],
    "140.0": [30.8, 38.1],
    "142.0": [33.5, 40.8],
    "145.0": [35.8, 43.9],
    "147.0": [38.5, 46.7],
    "150.0": [40.8, 49.9],
    "152.0": [43.1, 53.0],
    "155.0": [45.8, 55.8],
    "157.0": [48.1, 58.9],
    "160.0": [50.8, 61.6],
    "163.0": [53.0, 64.8],
    "165.0": [55.3, 68.0],
    "168.0": [58.0, 70.7],
    "170.0": [60.3, 73.9],
    "173.0": [63.0, 76.6],
    "175.0": [65.3, 79.8],
    "178.0": [67.6, 83.0],
    "180.0": [70.3, 85.7],
    "183.0": [72.6, 88.9],
    "185.0": [75.3, 91.6],
    "188.0": [77.5, 94.8],
    "190.0": [79.8, 98.0],
    "193.0": [82.5, 100.6],
    "195.0": [84.8, 103.8],
    "198.0": [87.5, 106.5],
    "200.0": [89.8, 109.7],
    "203.0": [92.0, 112.9],
    "205.0": [94.8, 115.6],
    "208.0": [97.0, 118.8],
    "210.0": [99.8, 121.5],
    "215.0": [102.0, 124.7]
  }
}''';
                controller.bodyComposition.value = BodyComposition.fromRawJson(jsonString);
                Navigator.pop(context);
              },
              child: const Text('Result Found'),
            ),
          ],
        );
      },
    );
  }

}
