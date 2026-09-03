
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';

import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import '../../../../../../common/widget/basic_app_bar.dart';
import '../../../../../../common/widget/cmed_birth_date_picker.dart';
import '../../../../../user_management/repository/profile_repository.dart';
import 'hfa_input_logic.dart';

class HfaInputView extends RapidView<HfaInputLogic> {
  static String routeName = '/hfa_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BasicAppBar('label_hfa'.tr),
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
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                'label_select_date'.tr,
                                style: CMEDTextUtils.inputTextLabelStyle,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: CMEDBirthDatePicker(
                                title:  controller.dateController.text.isEmpty ? null : CustomDateUtils.formatDatePicker(controller.dateController.text),
                                isShowCurrentDate: true,
                                onDateSelect: (DateTime date) {
                                  controller.dateController.text = date.millisecondsSinceEpoch.toString();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 2,
                                ),
                                Expanded(
                                    flex: 7,
                                    child: Obx(() {
                                      return Text(
                                          controller.heightUnit.value ==
                                              GmpUnit.FEET_INCH.name
                                              ? 'title_measurement_centimeter'
                                              .tr
                                              : 'title_measurement_in_feet_inch'.tr,
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
                                    onTap: () => {controller.toggleHeightUnit()},
                                    child: SvgPicture.asset(
                                      width: 42,
                                      "assets/images/measurement/icon_reverse.svg",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Obx(
                                  () => Visibility(
                                visible: controller.heightUnit.value ==
                                    GmpUnit.CENTIMETER.name,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Text(
                                        'input_label_input_height_cm'.tr,
                                        style: CMEDTextUtils.inputTextLabelStyle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    CMEDTextField('input_hint_cm'.tr,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: const TextInputType.numberWithOptions(),
                                        textEditingController: controller
                                            .heightInCentimeterEditTextController,
                                        onSaved: (value) {},
                                        onValidator: (value) {
                                          return controller.validateHeightInCentimeter(value!);
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Obx(() => Visibility(
                                visible: controller.heightUnit.value ==
                                    GmpUnit.FEET_INCH.name,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                                'label_input_height_feet'.tr,
                                                style: CMEDTextUtils.inputTextLabelStyle)),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                                'label_input_height_inch'.tr,
                                                style: CMEDTextUtils.inputTextLabelStyle)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: CMEDTextField(
                                              'input_label_hint_height_feet'.tr,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              keyboardType: TextInputType.number,
                                              textEditingController: controller
                                                  .heightInFeetEditTextController,
                                              onSaved: (value) {},
                                              onValidator: (value) {
                                                return controller
                                                    .validateHeightInFeet(value!);
                                              }),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CMEDTextField(
                                              'input_label_hint_height_inch'.tr,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                              textEditingController: controller
                                                  .heightInInchEditTextController,
                                              onSaved: (value) {},
                                              onValidator: (value) {
                                                return controller
                                                    .validateHeightInInch(value!);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))),
                            const SizedBox(
                              height: 16,
                            ),
                            /*Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    *//*Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                            flex: 7,
                                            child: Text(
                                              controller.weightUnit.value ==
                                                      GmpUnit.KG.name
                                                  ? 'title_measurement_in_lb'.tr
                                                  : 'title_measurement_in_kg'.tr,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () =>
                                                {controller.toggleWeightUnit()},
                                            child: SvgPicture.asset(
                                              width: 42,
                                              "assets/images/measurement/icon_reverse.svg",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),*//*
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Text(
                                        controller.weightUnit.value ==
                                                GmpUnit.KG.name
                                            ? 'input_label_input_weight_kg'.tr
                                            : 'input_label_input_weight_lb'.tr,
                                        style: CMEDTextUtils.inputTextLabelStyle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Obx(() => CMEDTextField(
                                        controller.weightUnit.value ==
                                            GmpUnit.KG.name
                                            ? 'label_weight'.tr
                                            : 'label_weight'.tr,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                        textEditingController: controller.weightEditTextController,
                                        onSaved: (value) {},
                                        onValidator: (value) {
                                          return controller.validateWeight(value!);
                                        })),
                                  ],
                                ))*/
                          ],
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CMEDWhiteElevatedButton(
                                'label_enter'.tr,
                                    () => {
                                  if (controller.isValidInput())
                                    controller.sendMeasurement(),
                                  // CMEDDialogs.showDoubleButtonDialog(
                                  //     'label_measurement_store_warning'.tr,
                                  //     bodyText:
                                  //     controller.getInputText(),
                                  //     onPositiveButtonClick: () => {
                                  //       controller.sendMeasurement(),
                                  //     }),
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        return Visibility(
                            visible: controller.isLoading.value,
                            child:
                            const Center(child: CircularProgressIndicator()));
                      }),
                    ],
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
        "Severe Stunting": "Severe Stunting",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.",
        "Moderate Stunting": "Moderate Stunting",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "Your child is moderately stunted comparing to age, please consult doctor for evaluation.",
        "Mild  Stunting": "Mild  Stunting",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "Your child has mild stunting comparing to age, please consult doctor for evaluation.",
        "Normal": "Normal",
        "Normal Height": "Normal Height",
        "Tall": "Tall",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "Your child is more tall comparing to age.  Please consult with nutritionist or physician.",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "Your child is moderately stunted, please consult doctor for evaluation.",
        "Mild Stunting": "Mild Stunting",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "Your child has mild stunting, please consult doctor for evaluation.",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "Your child is more tall. Please consult with nutritionist or physician for weight reduction.",
      },

      "bn_BD": {
        "Severe Stunting": "মারাত্মক খর্ব",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "আপনার শিশু বয়সের তুলনায় মারাত্মক খর্ব, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন।",
        "Moderate Stunting": "মাঝারি খর্ব",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "আপনার শিশু বয়সের তুলনায় মাঝারি খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Mild  Stunting": "স্বল্প খর্ব",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "আপনার শিশু বয়সের তুলনায় স্বল্প খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Normal": "স্বাভাবিক",
        "Normal Height": "আপনার শিশুর উচ্চতা স্বাভাবিক |",
        "Tall": "বেশি লম্বা",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "আপনার শিশু বয়সের তুলনায় স্বাভাবিকের চেয়ে লম্বা। কারণ জানতে চিকিৎসকের পরামর্শ নিন ।",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "আপনার শিশু বয়সের তুলনায় স্বাভাবিকের চেয়ে লম্বা। কারণ জানতে চিকিৎসকের পরামর্শ নিন ।",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "আপনার শিশু বয়সের তুলনায় মারাত্মক খর্ব, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন।",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "আপনার শিশু বয়সের তুলনায় মাঝারি খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Mild Stunting": "স্বল্প খর্ব",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "আপনার শিশু বয়সের তুলনায় স্বল্প খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "আপনার শিশু বয়সের তুলনায় স্বাভাবিকের চেয়ে লম্বা। কারণ জানতে চিকিৎসকের পরামর্শ নিন ।",
      },

      "kn_IN": {
        "Severe Stunting": "ತೀವ್ರ ಕುಂಠಿತ ಬೆಳವಣಿಗೆ",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "ವಯಸ್ಸಿಗೆ ಹೋಲಿಸಿದರೆ ನಿಮ್ಮ ಮಗುವಿನ ಬೆಳವಣಿಗೆ ತೀವ್ರವಾಗಿ ಕುಂಠಿತವಾಗಿದೆ, ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ತಕ್ಷಣ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ಭೇಟಿ ನೀಡಿ.",
        "Moderate Stunting": "ಮಧ್ಯಮ ಕುಂಠಿತ ಬೆಳವಣಿಗೆ",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "ವಯಸ್ಸಿಗೆ ಹೋಲಿಸಿದರೆ ನಿಮ್ಮ ಮಗುವಿನ ಬೆಳವಣಿಗೆ ಮಧ್ಯಮವಾಗಿ ಕುಂಠಿತವಾಗಿದೆ, ದಯವಿಟ್ಟು ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Mild  Stunting": "ಸ್ವಲ್ಪ ಕುಂಠಿತ ಬೆಳವಣಿಗೆ",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "ನಿಮ್ಮ ಮಗುವಿನ ಬೆಳವಣಿಗೆ ವಯಸ್ಸಿಗೆ ಹೋಲಿಸಿದರೆ ಸ್ವಲ್ಪ ಕುಂಠಿತವಾಗಿದೆ, ದಯವಿಟ್ಟು ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Normal Height": "ಸಾಮಾನ್ಯ ಎತ್ತರ",
        "Tall": "ಎತ್ತರ",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "ನಿಮ್ಮ ಮಗು ವಯಸ್ಸಿಗೆ ಹೋಲಿಸಿದರೆ ಹೆಚ್ಚು ಎತ್ತರವಾಗಿದೆ. ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "ನಿಮ್ಮ ಮಗು ವಯಸ್ಸಿಗೆ ಹೋಲಿಸಿದರೆ ಹೆಚ್ಚು ಎತ್ತರವಾಗಿದೆ. ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "ನಿಮ್ಮ ಮಗುವಿನ ಬೆಳವಣಿಗೆ ತೀವ್ರವಾಗಿ ಕುಂಠಿತವಾಗಿದೆ, ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ತಕ್ಷಣ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ಭೇಟಿ ನೀಡಿ.",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "ನಿಮ್ಮ ಮಗುವಿನ ಬೆಳವಣಿಗೆ ಮಧ್ಯಮವಾಗಿ ಕುಂಠಿತವಾಗಿದೆ, ದಯವಿಟ್ಟು ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Mild Stunting": "ಸ್ವಲ್ಪ ಕುಂಠಿತ ಬೆಳವಣಿಗೆ",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "ನಿಮ್ಮ ಮಗುವಿನ ಬೆಳವಣಿಗೆ ಸ್ವಲ್ಪ ಕುಂಠಿತವಾಗಿದೆ, ದಯವಿಟ್ಟು ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "ನಿಮ್ಮ ಮಗು ಹೆಚ್ಚು ಎತ್ತರವಾಗಿದೆ. ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
      },

      "hi_IN": {
        "Severe Stunting": "गंभीर विकास अवरोध",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "आपके बच्चे का विकास उम्र की तुलना में गंभीर रूप से अवरुद्ध है, कृपया तुरंत डॉक्टर से परामर्श लें या नजदीकी अस्पताल जाएँ।",
        "Moderate Stunting": "मध्यम विकास अवरोध",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "आपके बच्चे का विकास उम्र की तुलना में मध्यम रूप से अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Mild  Stunting": "हल्का विकास अवरोध",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "आपके बच्चे का विकास उम्र की तुलना में थोड़ा अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Normal": "सामान्य",
        "Normal Height": "सामान्य ऊंचाई",
        "Tall": "लंबा",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "आपका बच्चा उम्र की तुलना में अधिक लंबा है। कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श लें।",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "आपका बच्चा उम्र की तुलना में अधिक लंबा है। कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श लें।",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "आपके बच्चे का विकास गंभीर रूप से अवरुद्ध है, कृपया तुरंत डॉक्टर से परामर्श लें या नजदीकी अस्पताल जाएँ।",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "आपके बच्चे का विकास मध्यम रूप से अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Mild Stunting": "हल्का विकास अवरोध",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "आपके बच्चे का विकास थोड़ा अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "आपका बच्चा अधिक लंबा है। वजन कम करने के लिए कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श लें।",
      },

      "ta_IN": {
        "Severe Stunting": "கடுமையான வளர்ச்சி குன்றல்",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "உங்கள் குழந்தையின் வளர்ச்சி வயதுடன் ஒப்பிடும்போது கடுமையாக குன்றியுள்ளது, தயவுசெய்து உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
        "Moderate Stunting": "மிதமான வளர்ச்சி குன்றல்",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி வயதுடன் ஒப்பிடும்போது மிதமாக குன்றியுள்ளது, தயவுசெய்து மதிப்பீட்டிற்காக மருத்துவரை அணுகவும்.",
        "Mild  Stunting": "லேசான வளர்ச்சி குன்றல்",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி வயதுடன் ஒப்பிடும்போது லேசாக குன்றியுள்ளது, தயவுசெய்து மதிப்பீட்டிற்காக மருத்துவரை அணுகவும்.",
        "Normal": "சாதாரணம்",
        "Normal Height": "சாதாரண உயரம்",
        "Tall": "உயரம்",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "உங்கள் குழந்தை வயதுடன் ஒப்பிடும்போது அதிக உயரமாக உள்ளது. தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "உங்கள் குழந்தை வயதுடன் ஒப்பிடும்போது அதிக உயரமாக உள்ளது. தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "உங்கள் குழந்தையின் வளர்ச்சி கடுமையாக குன்றியுள்ளது, தயவுசெய்து உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி மிதமாக குன்றியுள்ளது, தயவுசெய்து மதிப்பீட்டிற்காக மருத்துவரை அணுகவும்.",
        "Mild Stunting": "லேசான வளர்ச்சி குன்றல்",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி லேசாக குன்றியுள்ளது, தயவுசெய்து மதிப்பீட்டிற்காக மருத்துவரை அணுகவும்.",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "உங்கள் குழந்தை அதிக உயரமாக உள்ளது. எடையைக் குறைக்க ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
      },

      "te_IN": {
        "Severe Stunting": "తీవ్రమైన ఎదుగుదల లోపం",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "మీ పిల్లల ఎదుగుదల వయస్సుతో పోలిస్తే తీవ్రంగా లోపించింది, దయచేసి వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రిని సందర్శించండి.",
        "Moderate Stunting": "మధ్యస్థ ఎదుగుదల లోపం",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల వయస్సుతో పోలిస్తే మధ్యస్థంగా లోపించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Mild  Stunting": "స్వల్ప ఎదుగుదల లోపం",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల వయస్సుతో పోలిస్తే స్వల్పంగా లోపించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Normal": "సాధారణం",
        "Normal Height": "సాధారణ ఎత్తు",
        "Tall": "ఎత్తుగా",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "మీ పిల్లలు వయస్సుతో పోలిస్తే ఎక్కువ ఎత్తుగా ఉన్నారు. దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "మీ పిల్లలు వయస్సుతో పోలిస్తే ఎక్కువ ఎత్తుగా ఉన్నారు. దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "మీ పిల్లల ఎదుగుదల తీవ్రంగా లోపించింది, దయచేసి వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రిని సందర్శించండి.",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల మధ్యస్థంగా లోపించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Mild Stunting": "స్వల్ప ఎదుగుదల లోపం",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల స్వల్పంగా లోపించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "మీ పిల్లలు ఎక్కువ ఎత్తుగా ఉన్నారు. బరువు తగ్గించడానికి దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
      },

      "or_IN": {
        "Severe Stunting": "ଗୁରୁତର ଖର୍ବତା",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ତୁଳନାରେ ବିକାଶ ଗୁରୁତର ଭାବେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ଡାକ୍ତରଖାନାକୁ ଯାଆନ୍ତୁ।",
        "Moderate Stunting": "ମଧ୍ୟମ ଖର୍ବତା",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ତୁଳନାରେ ବିକାଶ ମଧ୍ୟମ ଭାବେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ମୂଲ୍ୟାଙ୍କନ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Mild  Stunting": "ସାମାନ୍ୟ ଖର୍ବତା",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ତୁଳନାରେ ବିକାଶ ସାମାନ୍ୟ ଭାବେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ମୂଲ୍ୟାଙ୍କନ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Normal": "ସାଧାରଣ",
        "Normal Height": "ସାଧାରଣ ଉଚ୍ଚତା",
        "Tall": "ଉଚ୍ଚ",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "ଆପଣଙ୍କ ଶିଶୁ ବୟସ ତୁଳନାରେ ଅଧିକ ଉଚ୍ଚ ଅଟେ। ଦୟାକରି ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "ଆପଣଙ୍କ ଶିଶୁ ବୟସ ତୁଳନାରେ ଅଧିକ ଉଚ୍ଚ ଅଟେ। ଦୟାକରି ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ଗୁରୁତର ଭାବେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ଡାକ୍ତରଖାନାକୁ ଯାଆନ୍ତୁ।",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ମଧ୍ୟମ ଭାବେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ମୂଲ୍ୟାଙ୍କନ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Mild Stunting": "ସାମାନ୍ୟ ଖର୍ବତା",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ସାମାନ୍ୟ ଭାବେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ମୂଲ୍ୟାଙ୍କନ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "ଆପଣଙ୍କ ଶିଶୁ ଅଧିକ ଉଚ୍ଚ। ଓଜନ କମାଇବା ପାଇଁ ଦୟାକରି ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
      },
    };
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {

    Get.put(ScreeningReportRepository());
    Get.put(HfaInputLogic(repository: Get.find<ScreeningReportRepository>(), profileRepository:  Get.find<ProfileRepository>()));
  }
}
