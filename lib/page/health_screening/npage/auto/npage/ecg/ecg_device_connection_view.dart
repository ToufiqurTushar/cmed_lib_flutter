import 'package:cmed_ecg_devices_lib/ecg_graph_view.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/ecg/ecg_device_connection_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get/get.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_button.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_running_message.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import '../../enum/screen_enum.dart';

class EcgDeviceConnectionView extends RapidView<EcgDeviceConnectionLogic> {
  static String routeName = '/ecg_device_connection_page';

  const EcgDeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('label_ecg'.tr),
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
                                ScreenEnum.DEVICE_NOT_FOUND.name ||
                            controller.screen_status.value ==
                                ScreenEnum.DISCONNECTED.name),
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
                            ScreenEnum.SEARCHING.name || controller.screen_status.value ==
                      ScreenEnum.CONNECTING.name,
                        child: Center(
                          child: Obx(
                            () => CMEDDeviceConnectionButton(
                              controller.buttonText.value,
                              Icons.bluetooth,
                              () {},
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.CONNECTED.name,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 240,
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColorLight  ,
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      )),
                                  child: ECGGraphView(
                                      onMapViewCreated: _onMapViewCreated,
                                      text: '${controller.reading}')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: LinearProgressIndicator(
                                    value: (double.parse(
                                            controller.progress.value) /
                                        38),
                                    minHeight: 6,
                                    color: Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Colors.grey,
                                  )),
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'label_pulse'.tr,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 48,
                                ),
                                Text(
                                  'unit_bpm'.tr,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: Text(
                                controller.reading.value,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CMEDMeasurementRunningMessage(
                                  'label_please_wait_while_taking_measurement'.tr),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.screen_status.value ==
                            ScreenEnum.RESULT_FOUND.name,
                        child: Stack(
                          children: [
                            // Column(
                            //   children: [
                            //     const Spacer(),
                            //     Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: CMEDMeasurementRunningMessage(
                            //           'label_please_wait_while_taking_measurement'.tr),
                            //     )
                            //   ],
                            // ),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                                controller
                                                    .screen_status.value =
                                                    ScreenEnum.CONNECT.name,Get.back(),
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

  void _onMapViewCreated(ECGGraphViewController controller) {
    this.controller.ecgGraphViewController = controller;
    this.controller.ecgGraphViewController.initView();
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
    Get.put(EcgDeviceConnectionLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
