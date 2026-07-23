import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/widget_v2.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/oxygen_saturation/oxygen_saturation_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/nview/device_disconnected_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/oxygen_saturation/oxygen_saturation_device_connection_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/enum/screen_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_device_connection_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../common/helper/date_utils.dart';
import '../../../../../../common/widget/cmed_primary_elevated_button.dart';
import '../../../../../../common/widget/device/cmed_measurement_button.dart';
import '../../../../../../common/widget/device/cmed_measurement_running_message.dart';


class OxygenSaturationDeviceConnectionView
    extends RapidView<OxygenSaturationDeviceConnectionLogic> {
  static String routeName = '/oxygen_saturation_device_connection_page';

  const OxygenSaturationDeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return widgetV(
      v2: GradientWhiteToPrimary(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: controller.isNestedRoute? null: MiniAppBar('label_connecting_device'.tr),
          body: SafeArea(
            child: Column(
              children: [
                kDebugMode ? InkWell(
                    onTap: (){
                      changeEvent(context);
                    },
                    child: Text('ChangeEvent')
                ) : const SizedBox.shrink(),
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
                            onManualSelect: ()=> Get.offNamed(OxygenSaturationInputView.routeName, id:controller.isNestedRoute?1: null),
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
                            onManualSelect: ()=> Get.offNamed(OxygenSaturationInputView.routeName, id:controller.isNestedRoute?1: null),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.screenStatus.value == ScreenEnum.MEASURING.name || controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PulseOximeterCard(
                                        spo2Value: controller.spo2Result.value.isEmpty?"0":controller.reading.value.trAmount(),
                                        prBpmValue: controller.pulseResult.value.isEmpty?"0":controller.reading.value.trAmount(),
                                        time: CustomDateUtils.format(DateTime.now().microsecondsSinceEpoch, format: "h:mm a"),
                                        date: CustomDateUtils.format(DateTime.now().microsecondsSinceEpoch, format: "MM-dd-yyyy"),
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.screenStatus.value == ScreenEnum.MEASURING.name,
                                      child: PlacementInstructionCard(imagePath: 'assets/images/screening/insert_finger_spo2.png',),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: CMEDPrimaryElevatedButton(
                                      'Next'.tr,
                                      () => {
                                        controller.sendMeasurement()
                                      },
                                      isEnable: controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name,
                                      buttonBgColor: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 42,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
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
        ),
      ),
      v1: Scaffold(
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
                              onManualSelect: ()=> Get.offNamed(OxygenSaturationInputView.routeName, id:controller.isNestedRoute?1: null),
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
                              onManualSelect: ()=> Get.offNamed(OxygenSaturationInputView.routeName, id:controller.isNestedRoute?1: null),
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

  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<OxygenSaturationDeviceConnectionLogic>().isThemeV2) {
      return v2 ?? v1;
    }
    return v1;
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
                  title: Text('CONNECTING'),
                  onTap: () {
                    controller.screenStatus.value = ScreenEnum.CONNECTING.name;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('FINGER_OUT'),
                  onTap: () {
                    controller.screenStatus.value = ScreenEnum.FINGER_OUT.name;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('FINGER_IN'),
                  onTap: () {
                    controller.screenStatus.value = ScreenEnum.FINGER_IN.name;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('MEASURING'),
                  onTap: () {
                    controller.screenStatus.value = ScreenEnum.MEASURING.name;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('RESULT_FOUND'),
                  onTap: () {
                    controller.screenStatus.value = ScreenEnum.RESULT_FOUND.name;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {

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


class PulseOximeterCard extends StatelessWidget {
  final String spo2Value;
  final String prBpmValue;
  final String time;
  final String date;

  const PulseOximeterCard({
    super.key,
    this.spo2Value = '0',
    this.prBpmValue = '0',
    this.time = '4:15',
    this.date = '6-18-2026',
  });

  @override
  Widget build(BuildContext context) {
    // Custom color definitions based on design
    const backgroundColor = Color(0xFFE2F7E9);
    const borderColor = Color(0xFF9EE0B4);
    const labelColor = Color(0xFF536257);
    final spo2ValueColor = spo2Value == "0"?Color(0xFFC7DBCB): Colors.black;
    final prBpmValueColor = prBpmValue == "0"?Color(0xFFC7DBCB): Colors.black;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 1. SpO2 Column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RichText for subscript "2" in SpO₂
              RichText(
                text: TextSpan(
                  style: GoogleFonts.rajdhani(
                    color: labelColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    const TextSpan(text: '%SpO'),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0, 3), // Lowers the subscript "2"
                        child: const Text(
                          '2',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                spo2Value,
                style: GoogleFonts.rajdhani(
                  color: prBpmValueColor,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ],
          ),

          // 2. PRbpm Column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRbpm'.tr,
                style: GoogleFonts.rajdhani(
                  color: labelColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                prBpmValue,
                style: GoogleFonts.rajdhani(
                  color: prBpmValueColor,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ],
          ),

          // 3. Time & Date Column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: GoogleFonts.rajdhani(
                  color: labelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: GoogleFonts.rajdhani(
                  color: labelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlacementInstructionCard extends StatelessWidget {
  final String imagePath; // Path to your local asset image

  const PlacementInstructionCard({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF00A859);
    const textDark = Color(0xFF2B2D2F);
    const textGrey = Color(0xFF6C757D);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Circular Illustration Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryGreen,
                width: 2.0,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                package: 'cmed_lib_flutter',
                // Fallback icon if image asset is loading/missing
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFEAF9F1),
                    child: const Icon(
                      Icons.back_hand_outlined,
                      color: primaryGreen,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16.0),

          // 2. Text Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Place the Finger Properly',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8.0),

                // Description with Highlighted Green Text
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12.0,
                      color: textGrey,
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(text: 'Place your index finger '),
                      TextSpan(
                        text: 'inside the device with the nail facing up,',
                        style: TextStyle(
                          color: primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' and remain still for 60 seconds'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}