import 'dart:math';

import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_device_connection_view.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_pulsator.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_running_message.dart';
import 'package:cmed_lib_flutter/common/widget/widget_v2.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/blood_glucose/blood_glucose_device_connection_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/enum/screen_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/loop_animation_builder.dart';
import 'package:themed/themed.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';

class BloodGlucoseDeviceConnectionView extends RapidView<BloodGlucoseDeviceConnectionLogic> {
  static String routeName = '/blood_glucose_device_connection_page';

  final RxBool isMmol = true.obs;

  bool isStep1Completed() {
    if (controller.status.isEmpty) return false;
    final s = controller.status[0];
    final result =  s == "DN_SP1_DEVICE_RECOGNIZED" ||
        s == "DN_SP1_TEST_PAPER_REMOVED" || isStep2Completed() || isStep3Completed();
    return result;
  }

  bool isStep2Completed() {
    if (controller.status.isEmpty) return false;
    final s = controller.status[0];
    return s == "DN_SP1_TEST_PAPER_INSERTED" || isStep3Completed();
  }

  bool isStep3Completed() {
    if (controller.status.isEmpty) return false;
    final s = controller.status[0];
    return s == "DN_SP1_START_TEST" ||
        s == "DN_SP1_TEST_RESULT";
  }

  Map<String, String> getLocalStatus(double value, int? periodId) {
    if (periodId == 10) { // Fasting
      if (value < 5.6) {
        return {
          'status': 'label_normal'.tr,
          'desc': 'Your reading is in a healthy range. A balanced diet and regular exercise will help to maintain it.'.tr,
          'color': 'green',
        };
      } else if (value < 7.0) {
        return {
          'status': 'label_pre_diabetic'.tr,
          'desc': 'Your reading is slightly high. Please consult with a doctor for further confirmation.'.tr,
          'color': 'orange',
        };
      } else {
        return {
          'status': 'label_diabetic'.tr,
          'desc': 'Your reading is high. Please consult with a doctor immediately.'.tr,
          'color': 'red',
        };
      }
    } else { // Random / OGTT / 2hab
      if (value < 7.8) {
        return {
          'status': 'label_normal'.tr,
          'desc': 'Your reading is in a healthy range. A balanced diet and regular exercise will help to maintain it.'.tr,
          'color': 'green',
        };
      } else if (value < 11.1) {
        return {
          'status': 'label_pre_diabetic'.tr,
          'desc': 'Your reading is slightly high. Please consult with a doctor for further confirmation.'.tr,
          'color': 'orange',
        };
      } else {
        return {
          'status': 'label_diabetic'.tr,
          'desc': 'Your reading is high. Please consult with a doctor immediately.'.tr,
          'color': 'red',
        };
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return widgetV(
      v2: GradientWhiteToPrimary(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: controller.isNestedRoute?null:MiniAppBar('label_connecting_device'.tr, hasProfile: false, elevation: 0),
          body: SafeArea(
            child: Stack(
              children: [
                kDebugMode ? Text(controller.deviceEvent.value) : const SizedBox.shrink(),
                kDebugMode ? InkWell(
                    onTap: (){
                      changeEvent(context);
                    },
                    child: Text('ChangeEvent')
                ) : const SizedBox.shrink(),
                Obx(() {
                  if (controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name || controller.screenStatus.value == ScreenEnum.MEASURING.name) {
                    // RESULT DISPLAY MODE
                    final String rawValueStr = controller.result.value.isEmpty ? "0.00" : controller.result.value;
                    final double rawValue = double.tryParse(rawValueStr) ?? 0.00;
                    final statusInfo = getLocalStatus(rawValue, controller.tag.value.id);
                    final statusText = statusInfo['status'] ?? 'label_normal'.tr;
                    final descText = statusInfo['desc'] ?? '';
                    final colorName = statusInfo['color'] ?? 'green';
                    final Color statusColor = colorName == 'green'
                        ? const Color(0xFF00b965)
                        : (colorName == 'orange' ? Colors.orange : Colors.red);

                    final String displayedValue = isMmol.value
                        ? rawValueStr
                        : (rawValue * 18.0).toStringAsFixed(0);
                    final String displayedUnit = isMmol.value ? "mmol/L" : "mg/dL";
                    final String convertedStr = isMmol.value
                        ? "${(rawValue * 18.0).toStringAsFixed(0)} mg/dL"
                        : "$rawValueStr mmol/L";
                    final String dateStr = CustomDateUtils.format(DateTime.now().millisecondsSinceEpoch, format: "dd/MM/yyyy h:mm a");

                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              // Result Card
                              GestureDetector(
                                onTap: () {
                                  isMmol.toggle();
                                },
                                child: Card(
                                  color: Color(0xffdbf9e8),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.4), width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${'label_time_period'.tr}: ${Utils.isLocaleBn() ? controller.tag.value.labelBn ?? '' : controller.tag.value.labelEn ?? ''}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Icon(
                                              Icons.sync,
                                              color: Theme.of(context).primaryColor,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: EdgeInsets.only(left: 50),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            textBaseline: TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                displayedValue,
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: 80,
                                                  fontWeight: FontWeight.bold,
                                                  color: displayedValue == "0.00"? Colors.black12: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                displayedUnit,
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              convertedStr,
                                              style: const TextStyle(fontSize: 12, color: Colors.black45),
                                            ),
                                            Text(
                                              dateStr,
                                              style: const TextStyle(fontSize: 12, color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Status Badge
                              if(controller.screenStatus.value == ScreenEnum.MEASURING.name)
                              Text('Measuring...'.tr),

                              if(controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2F5EC), width: 1.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        LoopAnimationBuilder<double>(
                                          tween: Tween(begin: 0.0, end: 2 * pi), // 0° to 360° (2π)
                                          duration: const Duration(seconds: 4), // for 2 seconds per iteration
                                          builder: (context, value, _) {
                                            return Transform.rotate(
                                              angle: value, // use value
                                              child: Image.asset('assets/images/screening/success_green_bg.png', package: 'cmed_lib_flutter', color: statusColor, width: 70,),
                                            );
                                          },
                                        ),
                                        Icon(
                                          colorName == 'green' ? Icons.check_circle : Icons.warning_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        )
                                      ],
                                    ),
                                    // Container(
                                    //   padding: const EdgeInsets.all(6),
                                    //   decoration: BoxDecoration(
                                    //     color: statusColor.withOpacity(0.1),
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: Icon(
                                    //     colorName == 'green' ? Icons.check_circle : Icons.warning_rounded,
                                    //     color: statusColor,
                                    //     size: 28,
                                    //   ),
                                    // ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${'label_blood_glucose'.tr}: $statusText",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: statusColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            descText,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              // Action Buttons

                              if(controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name)
                              Row(
                                children: [
                                  Expanded(
                                    child: CMEDPrimaryElevatedButton(
                                      'label_next'.tr,
                                      () {
                                        controller.sendMeasurement();
                                      },
                                      width: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if(controller.screenStatus.value == ScreenEnum.RESULT_FOUND.name)
                              Row(
                                children: [
                                  Expanded(
                                    child: CMEDWhiteElevatedButton(
                                      'label_measure_again'.tr,
                                      () {
                                        controller.stopMeasurement();
                                        controller.screenStatus.value = ScreenEnum.CONNECT.name;
                                        controller.result.value = "";
                                        controller.connect();
                                      },
                                      width: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        if (controller.isLoading.value)
                          Container(
                            color: Colors.black.withOpacity(0.3),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    );
                  }

                  // CONNECTION FLOW MODE
                  final bool isAllCompleted = isStep1Completed() && isStep2Completed() && isStep3Completed();

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            // Illustration card
                            Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F6F0),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Image.asset(
                                controller.getImageFromStep().value,
                                fit: BoxFit.contain,
                                package: 'cmed_lib_flutter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Checklist
                            Expanded(
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  buildBloodGlucoseDeviceStepRow(
                                    context: context,
                                    title: 'label_step_1_title'.tr,
                                    description: 'label_step_1_desc'.tr,
                                    isCompleted: isStep1Completed(),
                                    isActive: true,
                                    stepNumber: '1',
                                  ),
                                  const Divider(height: 24, indent: 52),
                                  buildBloodGlucoseDeviceStepRow(
                                    context: context,
                                    title: 'label_step_2_title'.tr,
                                    description: 'label_step_2_desc'.tr,
                                    isCompleted: isStep2Completed(),
                                    isActive: true,
                                    stepNumber: '2',
                                  ),
                                  const Divider(height: 24, indent: 52),
                                  buildBloodGlucoseDeviceStepRow(
                                    context: context,
                                    title: 'label_step_3_title'.tr,
                                    description: 'label_step_3_desc'.tr,
                                    isCompleted: isStep3Completed(),
                                    isActive: true,
                                    stepNumber: '3',
                                  ),
                                ],
                              ),
                            ),
                            // // Bottom Action Button
                            Row(
                              children: [
                                Expanded(
                                  child: CMEDPrimaryElevatedButton(
                                    'label_measure_blood_glucose'.tr,
                                    () {},
                                    isEnable: isAllCompleted,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      if (controller.screenStatus.value == ScreenEnum.MEASURING.name)
                        Container(
                          color: Colors.transparent,
                          child: Center(
                            child: CMEDMeasurementPulsator(
                              'label_measuring'.tr,
                              Icons.speed_outlined,
                            ),
                          ),
                        ),
                      if (!controller.isListning.value)
                        Stack(
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
                                          '${'label_glucometer_step_3'.tr}.\n',
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: CMEDPrimaryElevatedButton(
                                              'label_ok'.tr,
                                              () {
                                                controller.connect();
                                              },
                                              buttonBgColor: Theme.of(context).primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              height: 42,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (controller.isLoading.value)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  );
                }),
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
      ),
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    final base = HealthScreeningHomeI18N.getTranslations();
    final custom = {
      'en_US': {
        'label_glucometer_step_0': 'Step 0 - Connect Glucometer',
        'label_glucometer_step_1': 'Step 1 - Connect Glucometer',
        'label_step_1_title': 'Connect the Meter',
        'label_step_1_desc': 'Plug the device into your phone\'s 3.5mm jack.',
        'label_step_2_title': 'Insert a Test Strip',
        'label_step_2_desc': 'Get a new strip ready and insert it.',
        'label_step_3_title': 'Apply Blood Sample',
        'label_step_3_desc': 'Touch the blood to the edge of the test strip.',
        'label_measure_again': 'Measure Again',
        'label_next_vital_check': 'Next Vital Check',
        'label_measure_blood_glucose': 'Measure Blood Glucose',
      },
      'bn_BD': {
        'label_glucometer_step_0': 'ধাপ ০ - গ্লুকোমিটার সংযোগ করুন',
        'label_glucometer_step_1': 'ধাপ ১ - গ্লুকোমিটার সংযোগ করুন',
        'label_step_1_title': 'মিটার সংযোগ করুন',
        'label_step_1_desc': 'ডিভাইসটি আপনার ফোনের ৩.৫মিমি জ্যাক এ প্রবেশ করান।',
        'label_step_2_title': 'টেস্ট স্ট্রিপ প্রবেশ করান',
        'label_step_2_desc': 'একটি নতুন স্ট্রিপ বের করে প্রবেশ করান।',
        'label_step_3_title': 'রক্তের নমুনা প্রদান করুন',
        'label_step_3_desc': 'রক্তের ফোঁটাটি টেস্ট স্ট্রিপের প্রান্তে স্পর্শ করান।',
        'label_measure_again': 'পুনরায় পরিমাপ করুন',
        'label_next_vital_check': 'পরবর্তী পরীক্ষা',
        'label_measure_blood_glucose': 'রক্তের গ্লুকোজ পরিমাপ করুন',
      }
    };

    final merged = <String, Map<String, String>>{};
    base.forEach((key, val) {
      merged[key] = Map<String, String>.from(val);
    });
    custom.forEach((lang, trans) {
      if (merged.containsKey(lang)) {
        merged[lang]!.addAll(trans);
      } else {
        merged[lang] = trans;
      }
    });
    return merged;
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
  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<BloodGlucoseDeviceConnectionLogic>().isNestedRoute) {
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
                  title: Text('DN_SP1_DEVICE_RECOGNIZED'),
                  onTap: () {
                    controller.status = ['DN_SP1_DEVICE_RECOGNIZED', ''].obs;
                    controller.onStepOne();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('DN_SP1_TEST_PAPER_INSERTED'),
                  onTap: () {
                    controller.status = ['DN_SP1_TEST_PAPER_INSERTED', ''].obs;
                    controller.onStepTwo();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Apply blood'),
                  onTap: () {
                    controller.status = ['DN_SP1_START_TEST', ''].obs;
                    controller.onStepThree();
                    Future.delayed(Duration(seconds: 1), () async {
                      controller.onStartMeasurement();
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('DN_SP1_START_TEST'),
                  onTap: () {
                    controller.status = ['DN_SP1_START_TEST', ''].obs;
                    controller.onStepThree();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('DN_SP1_TEST_RESULT'),
                  onTap: () {
                    controller.status = ['DN_SP1_TEST_RESULT', ''].obs;
                    controller.onStepThree();
                    controller.onStartMeasurement();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.onGetMeasurement(Random().nextInt(20).toString());
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


Widget buildBloodGlucoseDeviceStepRow({
  required BuildContext context,
  required String title,
  required String description,
  required bool isCompleted,
  required bool isActive,
  required String stepNumber,
}) {
  final Color activeColor = Theme.of(context).primaryColor;
  const Color inactiveColor = Colors.grey;

  Widget iconWidget;
  Color textColor;
  Color descColor;

  if (isCompleted) {
    iconWidget = Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: activeColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 14,
      ),
    );
    textColor = activeColor;
    descColor = activeColor.withOpacity(0.8);
  } else if (isActive) {
    iconWidget = Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: activeColor, width: 2),
      ),
      child: Center(
        child: Text(
          stepNumber,
          style: TextStyle(
            color: activeColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
    textColor = Colors.black87;
    descColor = Colors.black54;
  } else {
    iconWidget = Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: inactiveColor, width: 2),
      ),
      child: Center(
        child: Text(
          stepNumber,
          style: const TextStyle(
            color: inactiveColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
    textColor = inactiveColor;
    descColor = inactiveColor.withOpacity(0.7);
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconWidget,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: descColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}