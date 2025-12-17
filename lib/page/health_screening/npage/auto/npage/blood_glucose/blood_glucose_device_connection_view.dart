import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_device_connection_view.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_pulsator.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_running_message.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/blood_glucose/blood_glucose_device_connection_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/enum/screen_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:themed/themed.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import '../../../../../../common/widget/basic_app_bar.dart';

class BloodGlucoseDeviceConnectionView extends RapidView<BloodGlucoseDeviceConnectionLogic> {
  static String routeName = '/blood_glucose_device_connection_page';

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
                  kDebugMode? Text(controller.deviceEvent.value): SizedBox.shrink(),
                  Visibility(
                    visible: controller.screenStatus.value ==
                        ScreenEnum.CONNECT.name,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Obx(() => ChangeColors(
                              //  hue: AppUidConfig.getHueOnGreen(),
                              child: Image.asset(
                                controller.instructionImageSrc.value,
                              ),
                            )),
                          ),
                          Obx(() => CMEDDeviceConnectionView(
                              controller.instructionTitle.value,
                              controller.instructionDesc.value,
                              ChangeColors(
                                hue: AppUidConfig.getHueOnGreen(),
                                child: SvgPicture.asset(
                                  controller.stepImageSrc.value,
                                ),
                              ),
                              indicatorIcon: controller.indicatorIcon.value,
                              iconColor: controller.iconColor.value,
                              isCenterIconOnly:
                              controller.isCenterIconOnly.value)),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !controller.isListning.value,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(70),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 320,
                            height: 170,
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '${'Step 1 - Reconnect Blood Glucose device'.tr}.\n'
                                            '${'label_glucometer_step_2'.tr}.\n'
                                            '${'label_glucometer_step_3'.tr}.\n'
                                    ),
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
                                          'label_ok'.tr,
                                              () => {
                                            controller.connect()
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
                  Visibility(
                    visible: controller.screenStatus.value ==
                        ScreenEnum.MEASURING.name,
                    child: Center(
                      child: CMEDMeasurementPulsator(
                        'label_measuring'.tr,
                        Icons.speed_outlined,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.screenStatus.value ==
                        ScreenEnum.RESULT_FOUND.name,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(child: Container()),
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
                                          'label_yes'.tr,
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
                                          'label_no'.tr,
                                              () => {
                                                controller.stopMeasurement(),
                                                controller.screenStatus.value = ScreenEnum.CONNECT.name,
                                                controller.result.value = "",
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
                    return Visibility(
                        visible: controller.isLoading.value,
                        child: const Center(
                            child: CircularProgressIndicator()
                        )
                    );
                  }),
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
    Get.put(BloodGlucoseDeviceConnectionLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
