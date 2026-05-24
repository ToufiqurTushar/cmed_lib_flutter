import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/oxygen_saturation/oxygen_saturation_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';

class OxygenSaturationInputView extends RapidView<OxygenSaturationLogic> {
  static String routeName = '/oxygen_saturation_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BasicAppBar('label_oxygen_saturation'.tr),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: controller.screeningReportFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      shadowColor: Theme.of(context).primaryColor,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                'label_select_date'.tr,
                                style: CMEDTextUtils.inputTextLabelStyle,
                              ),
                            ),
                            CMEDBirthDatePicker(
                              bottomMargin: 12,
                              title:  controller.dateController.text.isEmpty ? null : CustomDateUtils.formatDatePicker(controller.dateController.text),
                              isShowCurrentDate: true,
                              onDateSelect: (DateTime date) {
                                controller.dateController.text = date.millisecondsSinceEpoch.toString();
                              },
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                'input_label_oxygen_saturation'.tr,
                                style: CMEDTextUtils.inputTextLabelStyle,
                              ),
                            ),
                            CMEDTextField('input_hint_oxygen_saturation'.tr,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                textEditingController: controller.spo2Controller,
                                onSaved: (value) {}, onValidator: (value) {
                                  return controller.validateSPO2(value!);
                                }),
                            const SizedBox(
                              height: 4,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'input_label_pulse_rate'.tr,
                              style: CMEDTextUtils.inputTextLabelStyle,
                            ),
                            CMEDTextField('input_hint_bpm'.tr,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                textEditingController: controller.pulseController,
                                onSaved: (value) {}, onValidator: (value) {
                                  return controller.validatePulse(value!);
                                }
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CMEDWhiteElevatedButton(
                                'label_enter'.tr,
                                    () => {
                                  if (controller.isValidInput())
                                    controller.sendMeasurement(),
                                  // CMEDDialogs.showDoubleButtonDialog(
                                  //     'label_measurement_store_warning'.tr,
                                  //     bodyText: controller.getInputText(),
                                  //     onPositiveButtonClick: () => {
                                  //       controller.sendMeasurement(),
                                  //     }),
                                },
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          return Visibility(
                              visible: controller.isLoading.value,
                              child:
                              const Center(child: CircularProgressIndicator()));
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {
      "en_US": {
        "Normal": "Normal",
        "Healthy": "Healthy",
        "Oxygen saturation level is NORMAL.": "Oxygen saturation level is NORMAL.",
        "Low": "Low",
        "High Risk": "High Risk",
        "Oxygen saturation level is LOW, please consult doctor for evaluation.": "Oxygen saturation level is LOW, please consult doctor for evaluation.",
        "Very low": "Very low",
        "Oxygen saturation level is VERY LOW, please consult with doctor or visit nearby hospital immediately.": "Oxygen saturation level is VERY LOW, please consult with doctor or visit nearby hospital immediately."
      },
      "bn_BD": {
        "Normal": "স্বাভাবিক",
        "Healthy": "ঝুকিমুক্ত",
        "Oxygen saturation level is NORMAL.": "স্বাভাবিক অক্সিজেন মাত্রা। নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে এই মাত্রা বজায় রাখুন।",
        "Low": "নিম্ন",
        "High Risk": "বেশি ঝুঁকি সম্পন্ন",
        "Oxygen saturation level is LOW, please consult doctor for evaluation.": "অক্সিজেনের মাত্রা কম, এ ব্যাপারে নিশ্চিত হওয়ার  চিকিৎসকের পরামর্শ নিন |",
        "Very low": "মাত্রাতিরিক্ত নিম্ন",
        "Oxygen saturation level is VERY LOW, please consult with doctor or visit nearby hospital immediately.": "অক্সিজেনের মাত্রা অনেক কম, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন। "
      },
      "kn_IN": {
        "Normal": "ಸಾಮಾನ್ಯ",
        "Healthy": "ಆರೋಗ್ಯಕರ",
        "Oxygen saturation level is NORMAL.": "ಆಮ್ಲಜನಕದ ಶುದ್ಧತ್ವ ಮಟ್ಟವು ಸಾಮಾನ್ಯವಾಗಿದೆ.",
        "Low": "ಕಡಿಮೆ",
        "High Risk": "ಹೆಚ್ಚಿನ ಅಪಾಯ",
        "Oxygen saturation level is LOW, please consult doctor for evaluation.": "ಆಮ್ಲಜನಕದ ಶುದ್ಧತ್ವ ಮಟ್ಟ ಕಡಿಮೆಯಾಗಿದೆ, ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Very low": "ತುಂಬಾ ಕಡಿಮೆ",
        "Oxygen saturation level is VERY LOW, please consult with doctor or visit nearby hospital immediately.": "ಆಮ್ಲಜನಕದ ಶುದ್ಧತ್ವ ಮಟ್ಟ ತುಂಬಾ ಕಡಿಮೆಯಾಗಿದೆ, ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ತಕ್ಷಣ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ಭೇಟಿ ನೀಡಿ."
      }
    };
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {

    Get.put(ScreeningReportRepository());
    Get.put(OxygenSaturationLogic(
        repository: Get.find<ScreeningReportRepository>()));
  }
}
