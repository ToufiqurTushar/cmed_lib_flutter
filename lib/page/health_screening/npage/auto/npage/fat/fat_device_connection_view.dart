import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/fat/fat_device_connection_logic.dart';
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
      child: Scaffold(
        appBar: BasicAppBar(
          'label_body_composition_only'.tr),
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
                                  ScreenEnum.DEVICE_NOT_FOUND.name ||
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
                        // Container(child: Text(""),),
                      ],
                    ),
                  ))
            ],
          ),
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
    Get.put(FatDeviceConnectionLogic(repository: Get.find<ScreeningReportRepository>(), profileRepository: Get.find<ProfileRepository>() ));
  }
}
