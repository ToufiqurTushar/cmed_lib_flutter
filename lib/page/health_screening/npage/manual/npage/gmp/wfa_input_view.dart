
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/gmp/wfa_input_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import '../../../../../../common/widget/cmed_birth_date_picker.dart';
import '../../../../../user_management/repository/profile_repository.dart';

class WfaInputView extends RapidView<WfaInputLogic> {
  static String routeName = '/gmp_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BasicAppBar('label_wfa'.tr),
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
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     const SizedBox(
                            //       width: 2,
                            //     ),
                            //     Expanded(
                            //         flex: 7,
                            //         child: Obx(() {
                            //           return Text(
                            //               controller.heightUnit.value ==
                            //                       GmpUnit.FEET_INCH.name
                            //                   ? 'title_measurement_centimeter'
                            //                       .tr
                            //                   : 'title_measurement_in_feet_inch'.tr,
                            //               style: const TextStyle(
                            //                   color: Colors.black,
                            //                   fontSize: 14,
                            //                   fontWeight: FontWeight.bold));
                            //         })),
                            //     const SizedBox(
                            //       width: 8,
                            //     ),
                            //     Expanded(
                            //       flex: 1,
                            //       child: InkWell(
                            //         onTap: () => {controller.toggleHeightUnit()},
                            //         child: SvgPicture.asset(
                            //           width: 42,
                            //           "assets/images/measurement/icon_reverse.svg",
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 16,
                            // ),
                            // Obx(
                            //   () => Visibility(
                            //     visible: controller.heightUnit.value ==
                            //         GmpUnit.CENTIMETER.name,
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               horizontal: 2.0),
                            //           child: Text(
                            //             'input_label_input_height_cm'.tr,
                            //             style: CMEDTextUtils.inputTextLabelStyle,
                            //           ),
                            //         ),
                            //         const SizedBox(
                            //           height: 4,
                            //         ),
                            //         CMEDTextField('input_hint_cm'.tr,
                            //             autovalidateMode: AutovalidateMode.onUserInteraction,
                            //             keyboardType: const TextInputType.numberWithOptions(),
                            //             textEditingController: controller
                            //                 .heightInCentimeterEditTextController,
                            //             onSaved: (value) {},
                            //             onValidator: (value) {
                            //           return controller.validateHeightInCentimeter(value!);
                            //         }),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // Obx(() => Visibility(
                            //     visible: controller.heightUnit.value ==
                            //         GmpUnit.FEET_INCH.name,
                            //     child: Column(
                            //       children: [
                            //         Row(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           children: [
                            //             const SizedBox(
                            //               width: 2,
                            //             ),
                            //             Expanded(
                            //                 flex: 1,
                            //                 child: Text(
                            //                     'label_input_height_feet'.tr,
                            //                     style: CMEDTextUtils.inputTextLabelStyle)),
                            //             const SizedBox(
                            //               width: 4,
                            //             ),
                            //             Expanded(
                            //                 flex: 1,
                            //                 child: Text(
                            //                     'label_input_height_inch'.tr,
                            //                     style: CMEDTextUtils.inputTextLabelStyle)),
                            //           ],
                            //         ),
                            //         const SizedBox(
                            //           height: 4,
                            //         ),
                            //         Row(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           children: [
                            //             Expanded(
                            //               flex: 1,
                            //               child: CMEDTextField(
                            //                   'input_label_hint_height_feet'.tr,
                            //                   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //                   keyboardType: TextInputType.number,
                            //                   textEditingController: controller
                            //                       .heightInFeetEditTextController,
                            //                   onSaved: (value) {},
                            //                   onValidator: (value) {
                            //                 return controller
                            //                     .validateHeightInFeet(value!);
                            //               }),
                            //             ),
                            //             const SizedBox(
                            //               width: 4,
                            //             ),
                            //             Expanded(
                            //               flex: 1,
                            //               child: CMEDTextField(
                            //                   'input_label_hint_height_inch'.tr,
                            //                   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //                   keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            //                   inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                            //                   textEditingController: controller
                            //                       .heightInInchEditTextController,
                            //                   onSaved: (value) {},
                            //                   onValidator: (value) {
                            //                 return controller
                            //                     .validateHeightInInch(value!);
                            //               }),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ))),
                            // const SizedBox(
                            //   height: 16,
                            // ),
                            Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*Row(
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
                                    ),*/
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
                            ))
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
        "Severe Underweight": "Severe Underweight",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.": "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.",
        "Moderate Underweight": "Moderate Underweight",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.": "Your child is moderately underweight according to age, please consult with doctor for evaluation.",
        "Mild Underweight": "Mild Underweight",
        "Your child has mild underweight according to age, please consult doctor for evaluation.": "Your child has mild underweight according to age, please consult doctor for evaluation.",
        "Normal": "Normal",
        "Your child is well nourished, please continue balanced diet as usual.": "Your child is well nourished, please continue balanced diet as usual.",
        "Overweight": "Overweight",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.": "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life."
      },
      "bn_BD": {
        "Severe Underweight": "মারাত্মক কম ওজন",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.": "আপনার শিশুর  ওজন বয়স অনুযায়ী  অনেক কম, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন।",
        "Moderate Underweight": "মাঝারি কম ওজন",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.": "আপনার শিশুর ওজন বয়স অনুযায়ী স্বাভাবিকের চেয়ে মাঝারি কম।এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Mild Underweight": "স্বল্প কম ওজন",
        "Your child has mild underweight according to age, please consult doctor for evaluation.": "আপনার শিশুর ওজন বয়স অনুযায়ী  স্বাভাবিকের চেয়ে কম, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Normal": "স্বাভাবিক",
        "Your child is well nourished, please continue balanced diet as usual.": "বয়স অনুযায়ী আপনার শিশু স্বাভাবিক পুষ্টিমাত্রা সম্পন্ন, শিশুকে সুষম খাবার প্রদানের মাধ্যমে এই মাত্রা বজায় রাখুন।",
        "Overweight": "বেশি ওজন",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.": "বয়স অনুযায়ী আপনার শিশুর ওজন স্বাভাবিকের চেয়ে বেশি। ওজন কমাতে  চিকিৎসক বা পুষ্টিবিদের পরামর্শ নিন । পাশাপাশি অতিরিক্ত তৈলাক্ত ও চর্বিযুক্ত (ফাস্ট ফুড/ভাজা পোড়া) খাবার পরিহার করুন । প্রতিদিন কমপক্ষে এক ঘন্টা নিয়মিত শারীরিক কর্মকান্ড (খেলাধুলা) করুন | অন্যথায় স্থূলতার কারণে ভবিষ্যত আপনার বাচ্চার উচ্চ রক্তচাপ এবং ডায়াবেটিস হতে পারে |"
      },
      "kn_IN": {
        "Severe Underweight": "ತೀವ್ರ ಕಡಿಮೆ ತೂಕ",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.": "ನಿಮ್ಮ ಮಗುವಿನ ವಯಸ್ಸಿಗೆ ಅನುಗುಣವಾಗಿ ತುಂಬಾ ಕಡಿಮೆ ತೂಕವಿದೆ, ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ತಕ್ಷಣ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ಭೇಟಿ ನೀಡಿ.",
        "Moderate Underweight": "ಮಧ್ಯಮ ಕಡಿಮೆ ತೂಕ",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.": "ನಿಮ್ಮ ಮಗುವಿನ ವಯಸ್ಸಿಗೆ ಅನುಗುಣವಾಗಿ ಮಧ್ಯಮ ತೂಕ ಕಡಿಮೆ ಇದೆ, ದಯವಿಟ್ಟು ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Mild Underweight": "ಕಡಿಮೆ ತೂಕ",
        "Your child has mild underweight according to age, please consult doctor for evaluation.": "ನಿಮ್ಮ ಮಗುವಿನ ವಯಸ್ಸಿಗೆ ಅನುಗುಣವಾಗಿ ಸ್ವಲ್ಪ ಕಡಿಮೆ ತೂಕವಿದೆ, ದಯವಿಟ್ಟು ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Your child is well nourished, please continue balanced diet as usual.": "ನಿಮ್ಮ ಮಗುವಿಗೆ ಉತ್ತಮ ಪೋಷಣೆ ಇದೆ, ದಯವಿಟ್ಟು ಎಂದಿನಂತೆ ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಮುಂದುವರಿಸಿ.",
        "Overweight": "ಅಧಿಕ ತೂಕ",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.": "ನಿಮ್ಮ ಮಗು ವಯಸ್ಸಿಗೆ ಅನುಗುಣವಾಗಿ ಅಧಿಕ ತೂಕ ಹೊಂದಿದೆ. ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ. ನಿಮ್ಮ ಮಗುವಿಗೆ ಎಣ್ಣೆಯುಕ್ತ ಮತ್ತು ಕೊಬ್ಬಿನ ಆಹಾರವನ್ನು (ಫಾಸ್ಟ್ ಫುಡ್ ಅಥವಾ ಕರಿದ ಆಹಾರ ಪದಾರ್ಥಗಳು) ನೀಡುವುದನ್ನು ನೀವು ನಿಯಂತ್ರಿಸಬೇಕು. ಮತ್ತು ನಿಮ್ಮ ಮಗು ದಿನಕ್ಕೆ ಕನಿಷ್ಠ ಒಂದು ಗಂಟೆಯಾದರೂ ನಿಯಮಿತ ದೈಹಿಕ ಚಟುವಟಿಕೆಯನ್ನು (ಆಟವಾಡುವುದು) ಮಾಡಬೇಕಾಗುತ್ತದೆ. ಇಲ್ಲದಿದ್ದರೆ ಅಧಿಕ ತೂಕವು ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಮಧುಮೇಹದಂತಹ ಹಲವಾರು ರೋಗಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು."
      },
      "hi_IN": {
        "Severe Underweight": "गंभीर कम वजन",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "आपके बच्चे का वजन उम्र के अनुसार बहुत कम है, कृपया तुरंत डॉक्टर से परामर्श लें या नजदीकी अस्पताल जाएँ।",
        "Moderate Underweight": "मध्यम कम वजन",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "आपके बच्चे का वजन उम्र के अनुसार मध्यम रूप से कम है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Mild Underweight": "हल्का कम वजन",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "आपके बच्चे का वजन उम्र के अनुसार थोड़ा कम है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Normal": "सामान्य",
        "Your child is well nourished, please continue balanced diet as usual.":
            "आपका बच्चा अच्छी तरह से पोषित है, कृपया हमेशा की तरह संतुलित आहार जारी रखें।",
        "Overweight": "अधिक वजन",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "आपके बच्चे का वजन उम्र के अनुसार अधिक है। वजन कम करने के लिए पोषण विशेषज्ञ या डॉक्टर से परामर्श लें। अपने बच्चे को तैलीय और वसायुक्त भोजन (फास्ट फूड या तले हुए खाद्य पदार्थ) देने से बचें। आपके बच्चे को प्रतिदिन कम से कम एक घंटे नियमित शारीरिक गतिविधि (खेलकूद) करनी चाहिए। अन्यथा अधिक वजन के कारण भविष्य में उच्च रक्तचाप, मधुमेह जैसी कई बीमारियाँ हो सकती हैं।",
      },

      "ta_IN": {
        "Severe Underweight": "கடுமையான குறைந்த எடை",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை மிகவும் குறைவாக உள்ளது, தயவுசெய்து உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
        "Moderate Underweight": "மிதமான குறைந்த எடை",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை மிதமாக குறைவாக உள்ளது, தயவுசெய்து மதிப்பீட்டிற்காக மருத்துவரை அணுகவும்.",
        "Mild Underweight": "லேசான குறைந்த எடை",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை சற்று குறைவாக உள்ளது, தயவுசெய்து மதிப்பீட்டிற்காக மருத்துவரை அணுகவும்.",
        "Normal": "சாதாரணம்",
        "Your child is well nourished, please continue balanced diet as usual.":
            "உங்கள் குழந்தை நன்கு ஊட்டச்சத்து பெற்றுள்ளது, வழக்கம்போல் சமச்சீர் உணவைத் தொடர்ந்து வழங்குங்கள்.",
        "Overweight": "அதிக எடை",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை அதிகமாக உள்ளது. எடையைக் குறைக்க ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும். உங்கள் குழந்தைக்கு எண்ணெய் மற்றும் கொழுப்பு நிறைந்த உணவுகளை (துரித உணவு அல்லது வறுத்த உணவுகள்) வழங்குவதை கட்டுப்படுத்துங்கள். உங்கள் குழந்தை தினமும் குறைந்தது ஒரு மணி நேரம் வழக்கமான உடல் செயல்பாடுகளில் (விளையாட்டு) ஈடுபட வேண்டும். இல்லையெனில் அதிக எடை காரணமாக எதிர்காலத்தில் உயர் இரத்த அழுத்தம், நீரிழிவு போன்ற பல நோய்கள் ஏற்படலாம்.",
      },

      "te_IN": {
        "Severe Underweight": "తీవ్ర తక్కువ బరువు",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "మీ పిల్లల వయస్సుకు అనుగుణంగా బరువు చాలా తక్కువగా ఉంది, దయచేసి వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రిని సందర్శించండి.",
        "Moderate Underweight": "మధ్యస్థ తక్కువ బరువు",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "మీ పిల్లల వయస్సుకు అనుగుణంగా బరువు మధ్యస్థంగా తక్కువగా ఉంది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Mild Underweight": "స్వల్ప తక్కువ బరువు",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "మీ పిల్లల వయస్సుకు అనుగుణంగా బరువు కొద్దిగా తక్కువగా ఉంది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Normal": "సాధారణం",
        "Your child is well nourished, please continue balanced diet as usual.":
            "మీ పిల్లలకు మంచి పోషకాహారం అందుతోంది, ఎప్పటిలాగే సమతుల్య ఆహారాన్ని కొనసాగించండి.",
        "Overweight": "అధిక బరువు",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "మీ పిల్లల వయస్సుకు అనుగుణంగా బరువు ఎక్కువగా ఉంది. బరువు తగ్గించడానికి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి. మీ పిల్లలకు నూనె మరియు కొవ్వు అధికంగా ఉన్న ఆహారాలు (ఫాస్ట్ ఫుడ్ లేదా వేయించిన ఆహార పదార్థాలు) ఇవ్వడాన్ని నియంత్రించండి. మీ పిల్లలు ప్రతిరోజూ కనీసం ఒక గంట క్రమం తప్పకుండా శారీరక కార్యకలాపాల్లో (ఆటలు) పాల్గొనాలి. లేకపోతే అధిక బరువు కారణంగా భవిష్యత్తులో అధిక రక్తపోటు, మధుమేహం వంటి అనేక వ్యాధులు రావచ్చు.",
      },

      "or_IN": {
        "Severe Underweight": "ଗୁରୁତର କମ୍ ଓଜନ",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ବହୁତ କମ୍ ଅଛି, ଦୟାକରି ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ଡାକ୍ତରଖାନାକୁ ଯାଆନ୍ତୁ।",
        "Moderate Underweight": "ମଧ୍ୟମ କମ୍ ଓଜନ",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ମଧ୍ୟମ ଭାବରେ କମ୍ ଅଛି, ଦୟାକରି ମୂଲ୍ୟାଙ୍କନ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Mild Underweight": "ସାମାନ୍ୟ କମ୍ ଓଜନ",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ସାମାନ୍ୟ କମ୍ ଅଛି, ଦୟାକରି ମୂଲ୍ୟାଙ୍କନ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Normal": "ସାଧାରଣ",
        "Your child is well nourished, please continue balanced diet as usual.":
            "ଆପଣଙ୍କ ଶିଶୁ ଭଲ ଭାବରେ ପୁଷ୍ଟି ପାଇଛି, ପୂର୍ବପରି ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଜାରି ରଖନ୍ତୁ।",
        "Overweight": "ଅଧିକ ଓଜନ",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ଅଧିକ ଅଛି। ଓଜନ କମାଇବା ପାଇଁ ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ। ଆପଣଙ୍କ ଶିଶୁକୁ ତେଲିଆ ଏବଂ ଚର୍ବିଯୁକ୍ତ ଖାଦ୍ୟ (ଫାଷ୍ଟ ଫୁଡ୍ କିମ୍ବା ଭଜା ଖାଦ୍ୟ) ଦେବାକୁ ନିୟନ୍ତ୍ରଣ କରନ୍ତୁ। ଆପଣଙ୍କ ଶିଶୁ ପ୍ରତିଦିନ ଅତି କମରେ ଏକ ଘଣ୍ଟା ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ (ଖେଳକୁଦ) କରିବା ଆବଶ୍ୟକ। ଅନ୍ୟଥା ଅଧିକ ଓଜନ ଯୋଗୁଁ ଭବିଷ୍ୟତରେ ଉଚ୍ଚ ରକ୍ତଚାପ, ମଧୁମେହ ଭଳି ଅନେକ ରୋଗ ହୋଇପାରେ।",
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
    Get.put(WfaInputLogic(repository: Get.find<ScreeningReportRepository>(), profileRepository:  Get.find<ProfileRepository>()));
  }
}
