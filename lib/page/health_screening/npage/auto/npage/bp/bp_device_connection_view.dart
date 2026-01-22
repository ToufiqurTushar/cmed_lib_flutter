import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/nview/device_disconnected_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/bp/bp_device_connection_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/enum/screen_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_device_connection_view.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_running_message.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';

class BpDeviceConnectionView extends RapidView<BpDeviceConnectionLogic> {
  static String routeName = '/bp_device_connection_page';

  const BpDeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('label_connecting_device'.tr,),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => Expanded(
                  child: Stack(
                    children: [
                    
                      Visibility(
                        visible: controller.isResultFound.isFalse && (controller.screen_status.value ==
                                ScreenEnum.CONNECT.name ||
                            controller.screen_status.value ==
                                ScreenEnum.CONNECTING.name ||
                            controller.screen_status.value ==
                                ScreenEnum.SEARCHING.name),
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
                        visible: controller.screen_status.value == ScreenEnum.DISCONNECTED.name,
                        child: Center(
                          child: DeviceReconnectView(
                            imageAsset: 'assets/images/measurement/img_bp_ihealth_bp3l_third.png',
                            suggestion: 'label_keep_device_switch_on'.tr,
                            message: 'label_device_disconnected_please_reconnect_to_get_measurements'.tr,
                            onReconnectDevice:() async {
                              await controller.reconnect();
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value == ScreenEnum.DEVICE_NOT_FOUND.name,
                        child: Center(
                          child: DeviceReconnectView(
                            imageAsset: 'assets/images/measurement/img_bp_ihealth_bp3l_third.png',
                            suggestion: 'label_keep_device_switch_on'.tr,
                            message: 'label_device_not_found'.tr,
                            onReconnectDevice:() async {
                              await controller.reconnect();
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.CONNECTED.name && controller.pressure.value.isEmpty,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                    "assets/images/screening/ic_bp_connect.svg",
                                    semanticsLabel: "label"),
                              ),
                              CMEDDeviceConnectionView(
                                  'Wear the cuffs properly'.tr,
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
                        visible: (controller.screen_status.value ==
                            ScreenEnum.MEASURING.name || controller.pressure.value.isNotEmpty) && controller.screen_status.value != ScreenEnum.DISCONNECTED.name,
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  controller.pressure.value.trAmount(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CMEDMeasurementRunningMessage(
                                  'label_please_wait_while_taking_measurement'.tr),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.RESULT_FOUND.name,
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
                                height: 220,
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
                                                controller
                                                    .sendBpAndPulseMeasurement(),
                                                controller.pressure.value = "",
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
                                                controller.screen_status.value =
                                                    ScreenEnum.CONNECTED.name,
                                                controller.pressure.value = "",
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
                      Obx(() {
                        if (controller.isSuccess.value) {
                          controller.isSuccess.value = false;
                          Future.delayed(Duration.zero, () async {
                            Get.offNamed('/screening_report_result_details',
                                arguments: [
                                  {
                                    "screeningReport":
                                        controller.screeningReport.value,
                                    "isAuto": true,
                                  }
                                ]);
                          });
                        }
                        return Visibility(
                            visible: controller.isLoading.value,
                            child: const Center(
                                child: CircularProgressIndicator()));
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
    Get.put(BpDeviceConnectionLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
