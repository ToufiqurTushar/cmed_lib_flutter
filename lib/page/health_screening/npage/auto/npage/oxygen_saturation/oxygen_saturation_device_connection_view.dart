import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/oxygen_saturation/oxygen_saturation_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/nview/device_disconnected_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/oxygen_saturation/oxygen_saturation_device_connection_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/enum/screen_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_device_connection_view.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../../common/widget/device/cmed_measurement_button.dart';
import '../../../../../../common/widget/device/cmed_measurement_running_message.dart';


class OxygenSaturationDeviceConnectionView
    extends RapidView<OxygenSaturationDeviceConnectionLogic> {
  static String routeName = '/oxygen_saturation_device_connection_page';

  const OxygenSaturationDeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('label_connecting_device'.tr),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => Expanded(
                  child: Stack(
                    children: [
                      Visibility(
                        visible: controller.screenStatus.value ==
                                ScreenEnum.CONNECT.name ||
                            controller.screenStatus.value ==
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
                        visible: controller.screenStatus.value ==
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
                        visible: controller.screenStatus.value ==
                            ScreenEnum.CONNECTED.name || controller.screenStatus.value == ScreenEnum.FINGER_OUT.name,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  "assets/images/device/img_instruction_spo2.png",
                                ),
                              ),
                              const Spacer(),
                              CMEDDeviceConnectionView(
                                  'Insert your finger'.tr,
                                  'Your device is connected and ready to use'.tr,
                                  Icon(
                                    Icons.bluetooth,
                                    color: Theme.of(context).primaryColor,
                                    size: 32,
                                  )),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CMEDWhiteElevatedButton(
                                          'label_start'.tr,
                                          () =>
                                              {controller.startMeasurement()}),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screenStatus.value ==
                            ScreenEnum.CONNECTED.name,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  "assets/images/device/img_instruction_spo2.png",
                                ),
                              ),
                              const Spacer(),
                              CMEDDeviceConnectionView(
                                  'Insert your finger'.tr,
                                  'Your device is connected and ready to use'.tr,
                                  Icon(
                                    Icons.bluetooth,
                                    color: Theme.of(context).primaryColor,
                                    size: 32,
                                  )),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CMEDWhiteElevatedButton(
                                          'label_start'.tr,
                                          () =>
                                              {controller.startMeasurement()}),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screenStatus.value == ScreenEnum.DEVICE_NOT_FOUND.name,
                        child: Center(
                          child: DeviceReconnectView(
                            imageAsset: 'assets/images/device/img_contec.png',
                            suggestion: 'label_keep_device_switch_on'.tr,
                            message: 'label_device_not_found'.tr,
                            onReconnectDevice: () async {
                              await controller.reconnect();
                            },
                            onManualSelect: ()=> Get.offNamed(OxygenSaturationInputView.routeName),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screenStatus.value == ScreenEnum.DISCONNECTED.name,
                        child: Center(
                          child: DeviceReconnectView(
                            imageAsset: 'assets/images/device/img_contec.png',
                            suggestion: 'label_keep_device_switch_on'.tr,
                            message: 'label_device_disconnected_please_reconnect_to_get_measurements'.tr,
                            onReconnectDevice: () async {
                              await controller.reconnect();
                            },
                            onManualSelect: ()=> Get.offNamed(OxygenSaturationInputView.routeName),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screenStatus.value == ScreenEnum.MEASURING.name || controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CMEDMeasurementRunningMessage(
                                  'label_please_wait_while_taking_measurement'.tr),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CMEDWhiteElevatedButton(
                                        'label_done'.tr,
                                        () => {
                                              controller.stopMeasurement(),
                                              controller.screenStatus.value =
                                                  ScreenEnum.RESULT_FOUND.name,
                                              controller.isResultFound.value = true,
                                          controller.sendMeasurement()
                                       }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Visibility(
                      //   visible: controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name || controller.isResultFound.value,
                      //   child: Stack(
                      //     children: [
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           color: AppColor.blackColor.withAlpha(70),
                      //         ),
                      //       ),
                      //       Align(
                      //         alignment: Alignment.center,
                      //         child: SizedBox(
                      //           width: 320,
                      //           height: 220,
                      //           child: Card(
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   'label_measurement_store_warning'.tr,
                      //                   textAlign: TextAlign.center,
                      //                   style:
                      //                       CMEDTextUtils.alertTitleTextStyle,
                      //                 ),
                      //                 const SizedBox(
                      //                   height: 8,
                      //                 ),
                      //                 Text(
                      //                   controller.getInputText(),
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //                 const SizedBox(
                      //                   height: 16,
                      //                 ),
                      //                 Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     const SizedBox(
                      //                       width: 10,
                      //                     ),
                      //                     Expanded(
                      //                       child: CMEDPrimaryElevatedButton(
                      //                         'yes'.tr,
                      //                         () => {
                      //                           controller.sendMeasurement()
                      //                         },
                      //                         buttonBgColor: Theme.of(context).primaryColor,
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         height: 42,
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 10,
                      //                     ),
                      //                     Expanded(
                      //                       child: CMEDPrimaryElevatedButton(
                      //                         'no'.tr,
                      //                         () => {
                      //                           controller.disconnect(),
                      //                         },
                      //                         buttonBgColor: Colors.red,
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         height: 42,
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 10,
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Obx(() {
                        return Visibility(
                            visible: controller.isLoading.value,
                            child: const Center(
                                child: CircularProgressIndicator()
                            )
                        );
                      }),
                      // Container(child: Text(""),),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
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
    Get.put(OxygenSaturationDeviceConnectionLogic(
        repository: Get.find<ScreeningReportRepository>()));
  }
}
