import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/widget/app_dialog.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/muac/muac_input_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:themed/themed.dart';



class MuacInputView extends RapidView<MuacInputLogic> {
  static String routeName = '/muac_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: controller.isNestedRoute?Colors.transparent:null,
        appBar: controller.isNestedRoute? null:BasicAppBar('label_muac'.tr),
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    flex: 7,
                                    child: Obx(() {
                                      return Text(
                                          controller.muacUnit.value ==
                                              GmpUnit.CENTIMETER.name
                                              ? 'title_measurement_in_inch'.tr
                                              : 'title_measurement_centimeter'.tr,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold));
                                    })),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () => {controller.toggleMuacUnit()},
                                    child: ChangeColors(
                                      hue: AppUidConfig.getHueOnGreen(),
                                      child: SvgPicture.asset(
                                        width: 42,
                                        "assets/images/measurement/icon_reverse.svg",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Obx(
                                    ()=> Text(
                                  controller.muacUnit.value == MuacUnit.CENTIMETER.name
                                      ? 'input_label_muac_cm'.tr
                                      : 'input_label_muac_inch'.tr,
                                  style: CMEDTextUtils.inputTextLabelStyle,
                                ),
                              ),
                            ),
                            Obx(
                                  ()=> CMEDTextField(
                                  controller.muacUnit.value == MuacUnit.CENTIMETER.name
                                      ? 'input_label_muac_cm'.tr
                                      : 'input_label_muac_inch'.tr,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                  textEditingController: controller.muacController,
                                  onSaved: (value) {}, onValidator: (value) {
                                return controller.validateMuac(value!);
                              }),
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
                        vertical: 8.0, horizontal: 16.0),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CMEDWhiteElevatedButton(
                                'label_enter'.tr,
                                    () => {
                                  if (controller.isValidInput())
                                    AppDialogs.showDoubleButtonDialog(
                                        'label_measurement_store_warning'.tr,
                                        bodyText: controller.getInputText(),
                                        onPositiveButtonClick: () => {
                                          controller.sendMeasurement(),
                                        }),
                                },
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          if (controller.isSuccess.value) {
                            controller.isSuccess.value = false;
                            Future.delayed(Duration.zero, () async {
                              Get.offNamed('/screening_report_result_details',
                                  arguments: [
                                    {
                                      "screeningReport":
                                      controller.screeningReport.value
                                    }
                                  ]);
                            });
                          }
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
        "Severe Acute Malnutrition": "Severe Acute Malnutrition",
        "High Risk": "High Risk",
        "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.": "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.",
        "Moderate Acute Malnutrition": "Moderate Acute Malnutrition",
        "Moderate Risk": "Moderate Risk",
        "Malnourished child , please consult doctor/nutritionist for further evaluation and advice.": "Malnourished child , please consult doctor/nutritionist for further evaluation and advice.",
        "Normal": "Normal",
        "Healthy": "Healthy",
        "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet.": "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet."
      },
      "bn_BD": {
        "Severe Acute Malnutrition": "মারাত্মক তীব্র অপুষ্টি",
        "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.": "আপনার  শিশু তীব্র মারাত্মক অপুষ্টি রয়েছে।  আতঙ্কিত না হয়ে শিশুর বাড়তি যত্ন নিন, দ্রুত​ চিকিৎসকের পরামর্শ নিন অথবা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন। ",
        "Moderate Acute Malnutrition": "মাঝারি তীব্র অপুষ্টি",
        "Malnourished child , please consult doctor/nutritionist for further evaluation and advice.": "আপনার শিশুর পুষ্টিমাত্রা স্বাভাবিকের চেয়ে কম, এ ব্যাপারে দ্রুত নিশ্চিত হওয়া প্রয়োজন। চিকিৎসা এবং পরামর্শের জন্য  চিকিৎসক/পুষ্টিবিদের পরামর্শ নিন |",
        "Normal": "স্বাভাবিক",
        "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet.": "অভিনন্দন! শিশুর পুষ্টিমাত্রা স্বাভাবিক । শিশুকে প্রতিদিন সুষম খাবার প্রদানের মাধ্যমে এই মাত্রা বজায় রাখুন।"
      },
      "kn_IN": {
        "Severe Acute Malnutrition": "ತೀವ್ರ ಅಪೌಷ್ಟಿಕತೆ",
        "High Risk": "ತೀವ್ರ ಅಪೌಷ್ಟಿಕತೆ",
        "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.": "ತೀವ್ರ ಅಪೌಷ್ಟಿಕತೆಯಿಂದ ಬಳಲುತ್ತಿರುವ ಮಗು. ದಯವಿಟ್ಟು ಭಯಪಡಬೇಡಿ ಮತ್ತು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ತಕ್ಷಣ ಹೋಗಿ.",
        "Moderate Acute Malnutrition": "ಮಧ್ಯಮ ತೀವ್ರ ಅಪೌಷ್ಟಿಕತೆ",
        "Moderate Risk": "ಮಧ್ಯಮ ತೀವ್ರ ಅಪೌಷ್ಟಿಕತೇ",
        "Malnourished child , please consult doctor/nutritionist for further evaluation and advice.": "ಅಪೌಷ್ಟಿಕತೆಯಿಂದ ಬಳಲುತ್ತಿರುವ ಮಗು, ಹೆಚ್ಚಿನ ಮೌಲ್ಯಮಾಪನ ಮತ್ತು ಸಲಹೆಗಾಗಿ ದಯವಿಟ್ಟು ವೈದ್ಯರು/ಪೌಷ್ಟಿಕತಜ್ಞರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Healthy": "ಸಾಮಾನ್ಯ",
        "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet.": "ಅಭಿನಂದನೆಗಳು! ಉತ್ತಮ ಪೋಷಣೆ ಪಡೆದ ಮಗು. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಮಗುವಿಗೆ ಸರಿಯಾದ ನಿಯಮಿತ ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ನೀಡುವ ಮೂಲಕ ಈ ಮಟ್ಟವನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ."
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
    Get.put(MuacInputLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
