import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import '../../../../../../common/widget/cmed_dropdown_select.dart';
import 'blood_glucose_input_logic.dart';


class BloodGlucoseInputView extends RapidView<BloodGlucoseInputLogic> {
  static String routeName = '/blood_glucose_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: controller.isNestedRoute? null:BasicAppBar('label_blood_glucose'.tr),
        body: SafeArea(
          child: Form(
            key: controller.screeningReportFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
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

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              'input_label_glucose'.tr,
                              style: CMEDTextUtils.inputTextLabelStyle,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CMEDTextField(AppUidConfig.getGlucoseLabelHint('input_hint_glucose_mmol_dl'.tr),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, ),
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                    textEditingController:
                                        controller.bloodGlucoseEditTextController,
                                    onSaved: (value) {}, onValidator: (value) {
                                  return controller.validateGlucoseInput(value!);
                                }),
                              ),

                              SizedBox(width: 10,),

                          if (!AppUidConfig.isCmedApp)
                                Expanded(
                                  child: Obx(
                                    () => CMEDDropdownSelect(
                                      height: 40,
                                      controller.glucoseUnit,
                                      item: controller
                                          .selectedGlucoseMasterData
                                          .value,
                                      onItemSelected: (data) {
                                        controller
                                                .selectedGlucoseMasterData
                                                .value =
                                            data;
                                        controller.selectedGlucoseUnit =
                                            data.labelEn!;
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
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
                                  //     bodyText: controller.getInputText(),
                                  //     onPositiveButtonClick: () => {
                                  //           controller.sendMeasurement(),
                                  //         }),
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
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
      return {
        "en_US": {
          "Normal": "Normal",
          "Healthy": "Healthy",
          "NORMAL blood sugar level, please keep it regular.": "NORMAL blood sugar level, please keep it regular.",
          "Low": "Low",
          "High Risk": "High Risk",
          "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.": "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.",
          "High": "High",
          "HIGH blod sugar level, please consult with doctor for further evaluation.": "HIGH blod sugar level, please consult with doctor for further evaluation.",
          "LOW (Hypoglycemia)": "LOW (Hypoglycemia)",
          "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.": "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.": "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.",
          "PRE- DIABETIC": "PRE- DIABETIC",
          "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.",
          "DIABETIC (need confirmation)": "DIABETIC (need confirmation)",
          "DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "DIABETIC condition. Make sure by doing OGTT with doctors consultation.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.": "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.",
          "HIGH (Borderline)": "HIGH (Borderline)",
          "At Risk": "At Risk",
          "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.": "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.",
          "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.": "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.",
          "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.": "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.",
          "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.": "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.",
          "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.",
          "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.",
          "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ": "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ",
          "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage.": "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage."
        },
        "bn_BD": {
          "Normal": "স্বাভাবিক",
          "Healthy": "ঝুঁকিমুক্ত",
          "NORMAL blood sugar level, please keep it regular.": "রক্তে গ্লুকোজের মাত্রা স্বাভাবিক আছে।",
          "Low": "নিম্ন",
          "High Risk": "বেশি ঝুঁকি সম্পন্ন",
          "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.": "রক্তে গ্লুকোজের মাত্রা স্বাভাবিকের থেকে কম, জরুরি ভিত্তিতে চিনিযুক্ত খাবার গ্রহণের মাধ্যমে রক্তে গ্লুকোজের মাত্রা স্বাভাবিকে আনুন ও পুনরায় পরিমাপ করুন। ",
          "High": "উচ্চ",
          "HIGH blod sugar level, please consult with doctor for further evaluation.": "রক্তে গ্লুকোজের মাত্রা বেশি, নিশ্চিত হওয়ার জন্য চিকিৎসকের পরামর্শ নিন।",
          "LOW (Hypoglycemia)": "নিম্ন ( হাইপোগ্লাইসেমিয়া)",
          "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.": "রক্তে গ্লুকোজের মাত্রা স্বাভাবিকের থেকে কম, জরুরি ভিত্তিতে চিনিযুক্ত খাবার গ্রহণের মাধ্যমে রক্তে গ্লুকোজের মাত্রা স্বাভাবিকে আনুন ও পুনরায় পরিমাপ করুন। ",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.": "রক্তে গ্লুকোজের মাত্রা স্বাভাবিক আছে। নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে এই মাত্রা বজায় রাখুন।",
          "PRE- DIABETIC": "ডায়াবেটিস (পূর্বাবস্থা)",
          "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "রক্তে গ্লুকোজের মাত্রা বেশি যা প্রি-ডায়াবেটিস নির্দেশ করে, চিকিৎসকের পরামর্শ অনুযায়ী ও জি টি টি করে নিশ্চিত হোন।",
          "DIABETIC (need confirmation)": "ডায়াবেটিস (নিশ্চিত হোন)",
          "DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "রক্তে গ্লুকোজের মাত্রা অনেক বেশি যা ডায়াবেটিস নির্দেশ করে, অতিসত্বর চিকিৎসকের পরামর্শ নিয়ে ও জি টি টি করে নিশ্চিত হোন। ",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.": "রক্তে গ্লুকোজের মাত্রা স্বাভাবিক আছে। নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে এই মাত্রা বজায় রাখুন।",
          "HIGH (Borderline)": "উচ্চ (ঝুঁকিপূর্ণ সীমায়)",
          "At Risk": "ঝুঁকি সম্পন্ন",
          "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.": "রক্তে গ্লুকোজের মাত্রা বেশি। আপনার ওষুধের ডোজ ঠিক আছে কিনা তা চিকিৎসকের পরামর্শ অনুযায়ী নিশ্চিত হোন।",
          "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.": "রক্তের গ্লুকোজ মাত্রাতিরিক্ত বেশি। ওষুধের ডোজ ঠিক করার জন্য চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্যকেন্দ্রে যোগাযোগ করুন।",
          "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.": "আপনার রক্তে গ্লুকোজের মাত্রা স্বাভাবিকের চেয়ে কম। জরুরি ভিত্তিতে চিনিযুক্ত খাবার বা চিনি পাণীয় গ্রহণের মাধ্যমে রক্তে গ্লুকোজের মাত্রা স্বাভাবিকে আনুন। পুনরায় গ্লুকোজ পরিমাপ করুন এবং নিয়মিত রক্তের গ্লুকোজ পরিমাপ করুন।",
          "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.": "অভিনন্দন! আপনার রক্তে গ্লুকোজের মাত্রা স্বাভাবিক। নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও পরিমিত শুষম খাবার গ্রহণের মাধ্যমে এই মাত্রা বজায় রাখুন। নিয়মিত রক্তের গ্লুকোজ পরিমাপ করুন। নিজে সুস্থ থাকুন এবং পরিবারকে নিরাপদ রাখুন",
          "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "আপনার রক্তে গ্লুকোজের মাত্রা স্বাভাবিকের থেকে বেশি যা ডায়াবেটিসের পূ্র্বাবস্থা বলে বিবেচিত এবং যেকোন সময় আপনার ডায়াবেটিস হয়ে যেতে পারে। ডাক্তারের পরামর্শ নিয়ে ডায়াবেটিস আছে কি না নিশ্চিত হোন। খাদ্য তালিকা থেকে ফাস্ট ফুড, অতিরিক্ত মিষ্টিজাতীয় খাবার, সফট ড্রিঙ্কস ও অতিরিক্ত শর্করা (ভাত/রুটি) খাওয়া পরিহার করুন। নিয়মিত রক্তের গ্লুকোজ পরিমাপ করুন। চিকিৎসকের পরামর্শ নিন এবং নিয়মিত দৈহিক পরিশ্রম ও পরিমিত খাবার গ্রহণের মাধ্যমে রক্তে গ্লুকোজের স্বাভাবিক মাত্রা বজায় রাখুন।",
          "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "আপনার রক্তে গ্লুকোজের মাত্রা স্বাভাবিকের থেকে অনেক বেশি। আপনার ডায়াবেটিস হবার সম্ভাবনা রয়েছে। ডাক্তারের পরামর্শ নিয়ে ডায়াবেটিস আছে কি না নিশ্চিত হোন। খাদ্য তালিকা থেকে ফাস্ট ফুড, অতিরিক্ত মিষ্টিজাতীয় খাবার, সফট ড্রিঙ্কস ও অতিরিক্ত শর্করা (ভাত/রুটি) খাওয়া পরিহার করুন। নিয়মিত দৈহিক পরিশ্রম ও পরিমিত সুষম খাবার গ্রহণের মাধ্যমে রক্তে গ্লুকোজের স্বাভাবিক মাত্রা বজায় রাখুন। । নিয়মিত রক্তের গ্লুকোজ পরিমাপ করুন।",
          "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ": "আপনার রক্তে গ্লুকোজের মাত্রা স্বাভাবিকের চেয়ে বেশি। চিকিৎসকের পরামর্শ অনুযায়ী ঔষধ সেবনের পাশাপাশি নিয়মিত দৈহিক পরিশ্রম ও পরিমিত শুষম খাবার গ্রহণের মাধ্যমে রক্তে গ্লুকোজের স্বাভাবিক মাত্রা বজায় রাখুন। খাদ্য তালিকা থেকে ফাস্ট ফুড, অতিরিক্ত মিষ্টিজাতীয় খাবার, সফট ড্রিঙ্কস ও অতিরিক্ত শর্করা (ভাত/রুটি) খাওয়া পরিহার করুন। নিয়মিত রক্তের গ্লুকোজ পরিমাপ করুন।",
          "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage.": "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage."
        },
        "kn_IN": {
          "Normal": "ಸಾಮಾನ್ಯ",
          "Healthy": "ಆರೋಗ್ಯಕರ",
          "NORMAL blood sugar level, please keep it regular.": "ಸಾಮಾನ್ಯ ರಕ್ತದಲ್ಲಿನ ಸಕ್ಕರೆ ಮಟ್ಟ, ದಯವಿಟ್ಟು ಅದನ್ನು ನಿಯಮಿತವಾಗಿ ಇರಿಸಿ.",
          "Low": "ಕಡಿಮೆ",
          "High Risk": "ಹೆಚ್ಚಿನ ಅಪಾಯ",
          "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.": "ಕಡಿಮೆ ರಕ್ತದಲ್ಲಿನ ಸಕ್ಕರೆ, ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಸಿಹಿಕಾರಕ, ಕ್ಯಾಂಡಿ ಅಥವಾ ಸ್ವಲ್ಪ ಜ್ಯೂಸ್ ತೆಗೆದುಕೊಳ್ಳಿ ಅಥವಾ ತಕ್ಷಣ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
          "High": "ಹೆಚ್ಚಿನ",
          "HIGH blod sugar level, please consult with doctor for further evaluation.": "ಅಧಿಕ ರಕ್ತದ ಸಕ್ಕರೆ ಮಟ್ಟ, ಹೆಚ್ಚಿನ ಮೌಲ್ಯಮಾಪನಕ್ಕಾಗಿ ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
          "LOW (Hypoglycemia)": "ಕಡಿಮೆ (ಹೈಪೋಗ್ಲಿಸಿಮಿಯಾ)",
          "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.": "ಕಡಿಮೆ ರಕ್ತದ ಸಕ್ಕರೆ, ಇದು ತುರ್ತು ಸ್ಥಿತಿ. ನಿಮ್ಮ ಸಕ್ಕರೆ ಮಟ್ಟವನ್ನು ಹೆಚ್ಚಿಸಲು ಕ್ಯಾಂಡಿ ಅಥವಾ ಸಿಹಿತಿಂಡಿಗಳು ಅಥವಾ ಸಕ್ಕರೆ ಅಥವಾ ರಸವನ್ನು ತೆಗೆದುಕೊಳ್ಳಿ.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.": "ಸಾಮಾನ್ಯ ರಕ್ತದಲ್ಲಿನ ಸಕ್ಕರೆ ಮಟ್ಟವನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಲು - ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ - ಇವೆರಡೂ ನಿಮಗೆ ಉತ್ತಮವಾಗಿ ಕಾಣಲು ಮತ್ತು ಅನುಭವಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ ಮತ್ತು ಮಧುಮೇಹವನ್ನು ದೂರವಿಡುತ್ತದೆ.",
          "PRE- DIABETIC": "ಮಧುಮೇಹ ಪೂರ್ವ",
          "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "ಮಧುಮೇಹ ಪೂರ್ವ ಸ್ಥಿತಿ. ವೈದ್ಯರ ಸಮಾಲೋಚನೆಯೊಂದಿಗೆ OGTT ಮಾಡುವ ಮೂಲಕ ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ.",
          "DIABETIC (need confirmation)": "ಮಧುಮೇಹ (ದೃಢೀಕರಣದ ಅಗತ್ಯವಿದೆ)",
          "DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "ಮಧುಮೇಹ ಸ್ಥಿತಿ. ವೈದ್ಯರ ಸಮಾಲೋಚನೆಯೊಂದಿಗೆ OGTT ಮಾಡುವ ಮೂಲಕ ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.": "ಸಾಮಾನ್ಯ ರಕ್ತದಲ್ಲಿನ ಸಕ್ಕರೆ ಮಟ್ಟವನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಲು - ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ - ಇವೆರಡೂ ನಿಮಗೆ ಉತ್ತಮವಾಗಿ ಕಾಣಲು ಮತ್ತು ಅನುಭವಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ ಮತ್ತು ಮಧುಮೇಹವನ್ನು ನಿಯಂತ್ರಣದಲ್ಲಿಡುತ್ತದೆ.",
          "HIGH (Borderline)": "ಎತ್ತರ (ಗಡಿ)",
          "At Risk": "ಅಪಾಯದಲ್ಲಿದೆ",
          "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.": "ಅಧಿಕ ರಕ್ತದ ಸಕ್ಕರೆ, ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ, ನಿಮ್ಮ ಔಷಧಿಯನ್ನು ಸರಿಹೊಂದಿಸಬೇಕಾಗಬಹುದು ಅಥವಾ ಬದಲಾಯಿಸಬೇಕಾಗಬಹುದು.",
          "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.": "ರಕ್ತದಲ್ಲಿನ ಸಕ್ಕರೆ ಪ್ರಮಾಣ ಹೆಚ್ಚಿದೆ, ತಕ್ಷಣ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ, ನಿಮ್ಮ ಔಷಧಿಯನ್ನು ಸರಿಹೊಂದಿಸಬೇಕಾಗಬಹುದು ಅಥವಾ ಬದಲಾಯಿಸಬೇಕಾಗಬಹುದು.",
          "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.": "ನಿಮ್ಮ ರಕ್ತದ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟ ಕಡಿಮೆ ಇದ್ದು, ತುರ್ತು ಪರಿಸ್ಥಿತಿಯಲ್ಲಿದ್ದೀರಿ. ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ಹೆಚ್ಚಿಸಲು ದಯವಿಟ್ಟು ತಕ್ಷಣ ಕ್ಯಾಂಡಿ, ಸಿಹಿತಿಂಡಿಗಳು, ಸಕ್ಕರೆ ನೀರು ಅಥವಾ ರಸವನ್ನು ಸೇವಿಸಿ. ನಿಮ್ಮ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ಮರುಪರಿಶೀಲಿಸಿ ಮತ್ತು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.",
          "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.": "ಅಭಿನಂದನೆಗಳು! ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವು ಸಾಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿದೆ. ನಿಯಮಿತ ದೈಹಿಕ ಚಟುವಟಿಕೆ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರದ ಮೂಲಕ ದಯವಿಟ್ಟು ಈ ಮಟ್ಟವನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ. ನಿಮ್ಮ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ. ನಿಮ್ಮನ್ನು ಆರೋಗ್ಯವಾಗಿಡಿ ಮತ್ತು ನಿಮ್ಮ ಕುಟುಂಬವನ್ನು ಸುರಕ್ಷಿತವಾಗಿರಿಸಿಕೊಳ್ಳಿ.",
          "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವು ನೀವು ಪೂರ್ವ-ಮಧುಮೇಹ ಹಂತದಲ್ಲಿದ್ದೀರಿ ಮತ್ತು ಯಾವುದೇ ಸಮಯದಲ್ಲಿ ಮಧುಮೇಹ ಬರಬಹುದು ಎಂದು ಸೂಚಿಸುತ್ತದೆ. ನಿಮ್ಮ ರೋಗನಿರ್ಣಯವನ್ನು ಖಚಿತಪಡಿಸಲು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ. ತ್ವರಿತ ಆಹಾರ, ಸಿಹಿ ಆಹಾರಗಳು, ಅತಿಯಾದ ಕಾರ್ಬೋಹೈಡ್ರೇಟ್‌ಗಳು ಅಥವಾ ತಂಪು ಪಾನೀಯಗಳನ್ನು ಸೇವಿಸುವುದನ್ನು ತಪ್ಪಿಸಲು ನಿಮಗೆ ಸೂಚಿಸಲಾಗಿದೆ. ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ, ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ, ಇದು ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ಸಾಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ. ನಿಮ್ಮ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.",
          "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "ನಿಮಗೆ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟ ಹೆಚ್ಚಿದ್ದು, ಯಾವುದೇ ಸಮಯದಲ್ಲಿ ಮಧುಮೇಹ ಬರಬಹುದು. ರೋಗನಿರ್ಣಯವನ್ನು ಖಚಿತಪಡಿಸಲು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ. ತ್ವರಿತ ಆಹಾರ, ಸಿಹಿ ಆಹಾರಗಳು, ಅತಿಯಾದ ಕಾರ್ಬೋಹೈಡ್ರೇಟ್‌ಗಳು ಅಥವಾ ತಂಪು ಪಾನೀಯಗಳನ್ನು ಸೇವಿಸುವುದನ್ನು ತಪ್ಪಿಸಲು ನಿಮಗೆ ಸೂಚಿಸಲಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ, ಇದು ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ಸಾಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ. ನಿಮ್ಮ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.",
          "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ": "ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವು ಮಿತಿ ಮೀರಿದೆ. ಅಗತ್ಯವಿದ್ದರೆ, ಸಲಹೆ ಮತ್ತು ನಿಮ್ಮ ಔಷಧಿ ಸೇವನೆಯ ಹೊಂದಾಣಿಕೆಗಾಗಿ ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ. ದಯವಿಟ್ಟು ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆಯನ್ನು ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ, ಇದು ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ಸಾಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ. ತ್ವರಿತ ಆಹಾರ, ಸಿಹಿ ಆಹಾರಗಳು, ಅತಿಯಾದ ಕಾರ್ಬೋಹೈಡ್ರೇಟ್‌ಗಳು ಅಥವಾ ತಂಪು ಪಾನೀಯಗಳನ್ನು ಸೇವಿಸುವುದನ್ನು ತಪ್ಪಿಸಲು ನಿಮಗೆ ಸೂಚಿಸಲಾಗಿದೆ. ನಿಮ್ಮ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.",
          "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage.": "ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟ ಹೆಚ್ಚಾಗಿದೆ. ಸಲಹೆ ಮತ್ತು ಔಷಧಿ ಸೇವನೆಯ ಹೊಂದಾಣಿಕೆಗಾಗಿ ತಕ್ಷಣ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ಹತ್ತಿರದ ಆರೋಗ್ಯ ಕೇಂದ್ರವನ್ನು ಸಂಪರ್ಕಿಸಿ. ಕನಿಷ್ಠ 30-40 ನಿಮಿಷಗಳ ಕಾಲ ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆಗಳನ್ನು ಮಾಡಿ, ನಿಮ್ಮ ಹೃದಯ ಬಡಿತ ಹೆಚ್ಚಾಗುವ ರೀತಿಯಲ್ಲಿ ನಡೆಯಿರಿ. ನೀವು ಆರೋಗ್ಯಕರ ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ತೆಗೆದುಕೊಳ್ಳಬೇಕು ಮತ್ತು ತ್ವರಿತ ಆಹಾರ, ಕಾರ್ಬೋಹೈಡ್ರೇಟ್ ಭರಿತ ಆಹಾರ (ಅಕ್ಕಿ/ಬ್ರೆಡ್), ಕೊಬ್ಬು, ತಂಪು ಪಾನೀಯ ಇತ್ಯಾದಿಗಳನ್ನು ತಪ್ಪಿಸಬೇಕು, ಇದು ನಿಮ್ಮ ರಕ್ತದಲ್ಲಿನ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ಸಾಮಾನ್ಯ ವ್ಯಾಪ್ತಿಯಲ್ಲಿಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ. ನಿಮ್ಮ ಗ್ಲೂಕೋಸ್ ಮಟ್ಟವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ. ಜೀವನದ ಪ್ರತಿಯೊಂದು ಹಂತದಲ್ಲೂ ಶಿಸ್ತನ್ನು ಅನುಸರಿಸಿ."
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
    Get.put(BloodGlucoseInputLogic(
        repository: Get.find<ScreeningReportRepository>()));
  }
}
