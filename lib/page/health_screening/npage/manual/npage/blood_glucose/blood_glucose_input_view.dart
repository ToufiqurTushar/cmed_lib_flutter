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
        backgroundColor: controller.isNestedRoute?Colors.transparent:null,
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
                                      height: 48,
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
        },
        "hi_IN": {
          "Normal": "सामान्य",
          "Healthy": "स्वस्थ",
          "NORMAL blood sugar level, please keep it regular.": "सामान्य रक्त शर्करा स्तर, कृपया इसे नियमित बनाए रखें।",
          "Low": "कम",
          "High Risk": "उच्च जोखिम",
          "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.": "रक्त शर्करा का स्तर कम है, कृपया कुछ मीठा, कैंडी या जूस लें या तुरंत डॉक्टर से परामर्श करें।",
          "High": "उच्च",
          "HIGH blod sugar level, please consult with doctor for further evaluation.": "रक्त शर्करा का स्तर अधिक है, कृपया आगे की जांच के लिए डॉक्टर से परामर्श करें।",
          "LOW (Hypoglycemia)": "कम (हाइपोग्लाइसीमिया)",
          "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.": "रक्त शर्करा का स्तर कम है। यह एक आपातकालीन स्थिति है। अपने शर्करा स्तर को बढ़ाने के लिए कैंडी, मिठाई, चीनी या जूस लें।",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.": "सामान्य रक्त शर्करा स्तर को बनाए रखने के लिए नियमित शारीरिक गतिविधि करें और संतुलित आहार लें — ये दोनों आपको स्वस्थ महसूस करने और मधुमेह को दूर रखने में मदद करते हैं।",
          "PRE- DIABETIC": "प्री-डायबिटिक",
          "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "प्री-डायबिटिक स्थिति। डॉक्टर की सलाह से OGTT करवाकर इसकी पुष्टि करें।",
          "DIABETIC (need confirmation)": "डायबिटिक (पुष्टि आवश्यक)",
          "DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "डायबिटीज की स्थिति। डॉक्टर की सलाह से OGTT करवाकर इसकी पुष्टि करें।",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.": "सामान्य रक्त शर्करा स्तर को बनाए रखने के लिए नियमित शारीरिक गतिविधि करें और संतुलित आहार लें — ये दोनों आपको स्वस्थ महसूस करने और मधुमेह को नियंत्रण में रखने में मदद करते हैं।",
          "HIGH (Borderline)": "उच्च (सीमावर्ती)",
          "At Risk": "जोखिम में",
          "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.": "रक्त शर्करा का स्तर अधिक है, डॉक्टर से परामर्श करें। आपकी दवा की खुराक को समायोजित या बदला जा सकता है।",
          "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.": "रक्त शर्करा का स्तर अधिक है, तुरंत डॉक्टर से परामर्श करें। आपकी दवा की खुराक को समायोजित या बदला जा सकता है।",
          "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.": "आपके रक्त ग्लूकोज़ का स्तर कम है और यह एक आपातकालीन स्थिति है। अपने रक्त ग्लूकोज़ स्तर को बढ़ाने के लिए कृपया तुरंत कैंडी, मिठाई, चीनी का पानी या जूस लें। अपने ग्लूकोज़ को दोबारा मापें और नियमित रूप से निगरानी करें।",
          "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.": "बधाई हो! आपका रक्त ग्लूकोज़ स्तर सामान्य सीमा में है। नियमित शारीरिक गतिविधि और संतुलित आहार के माध्यम से कृपया इस स्तर को बनाए रखें। अपने ग्लूकोज़ स्तर की नियमित निगरानी करें। स्वयं को स्वस्थ रखें और अपने परिवार को सुरक्षित रखें।",
          "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "आपका रक्त ग्लूकोज़ स्तर दर्शाता है कि आप प्री-डायबिटिक अवस्था में हैं और किसी भी समय मधुमेह विकसित हो सकता है। अपने निदान की पुष्टि करने के लिए डॉक्टर से परामर्श करें। आपको फास्ट फूड, मीठे खाद्य पदार्थ, अत्यधिक कार्बोहाइड्रेट या शीतल पेय लेने से बचने की सलाह दी जाती है। कृपया डॉक्टर से परामर्श करें, नियमित शारीरिक गतिविधि करें और संतुलित आहार लें, जो आपके रक्त ग्लूकोज़ स्तर को सामान्य सीमा में रखने में मदद करेगा। अपने ग्लूकोज़ स्तर की नियमित निगरानी करें।",
          "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "आपका रक्त ग्लूकोज़ स्तर अधिक है और आपको किसी भी समय मधुमेह हो सकता है। अपने निदान की पुष्टि करने के लिए डॉक्टर से परामर्श करें। आपको फास्ट फूड, मीठे खाद्य पदार्थ, अत्यधिक कार्बोहाइड्रेट या शीतल पेय लेने से बचने की सलाह दी जाती है। कृपया नियमित शारीरिक गतिविधि करें और संतुलित आहार लें, जो आपके रक्त ग्लूकोज़ स्तर को सामान्य सीमा में रखने में मदद करेगा। अपने ग्लूकोज़ स्तर की नियमित निगरानी करें।",
          "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ": "आपका रक्त ग्लूकोज़ स्तर सीमावर्ती रूप से अधिक है। यदि आवश्यक हो, तो सलाह और अपनी दवा की खुराक में समायोजन के लिए डॉक्टर से परामर्श करें। कृपया नियमित शारीरिक गतिविधि करें और संतुलित आहार लें, जो आपके रक्त ग्लूकोज़ स्तर को सामान्य सीमा में रखने में मदद करेगा। आपको फास्ट फूड, मीठे खाद्य पदार्थ, अत्यधिक कार्बोहाइड्रेट या शीतल पेय लेने से बचने की सलाह दी जाती है। अपने ग्लूकोज़ स्तर की नियमित निगरानी करें।",
          "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage.": "आपका रक्त ग्लूकोज़ स्तर अधिक है। अपनी दवा की खुराक के संबंध में सलाह और समायोजन के लिए तुरंत डॉक्टर से परामर्श करें या निकटतम स्वास्थ्य केंद्र से संपर्क करें। प्रतिदिन कम से कम 30-40 मिनट नियमित शारीरिक गतिविधि करें और इस तरह चलें कि आपकी हृदय गति बढ़े। आपको स्वस्थ संतुलित आहार लेना चाहिए और फास्ट फूड, कार्बोहाइड्रेट से भरपूर भोजन (चावल/ब्रेड), वसा, शीतल पेय आदि से बचना चाहिए। इससे आपके रक्त ग्लूकोज़ स्तर को सामान्य सीमा में रखने में मदद मिलेगी। अपने ग्लूकोज़ स्तर की नियमित निगरानी करें। जीवन के हर चरण में अनुशासन का पालन करें।"
        },

        "ta_IN": {
          "Normal": "சாதாரணம்",
          "Healthy": "ஆரோக்கியமான",
          "NORMAL blood sugar level, please keep it regular.": "சாதாரண இரத்தச் சர்க்கரை அளவு, தயவுசெய்து இதை சீராக பராமரிக்கவும்.",
          "Low": "குறைவு",
          "High Risk": "அதிக ஆபத்து",
          "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.": "இரத்தச் சர்க்கரை அளவு குறைவாக உள்ளது, தயவுசெய்து சிறிது இனிப்பு, மிட்டாய் அல்லது சாறு எடுத்துக்கொள்ளுங்கள் அல்லது உடனடியாக மருத்துவரை அணுகவும்.",
          "High": "அதிகம்",
          "HIGH blod sugar level, please consult with doctor for further evaluation.": "இரத்தச் சர்க்கரை அளவு அதிகமாக உள்ளது, மேலதிக மதிப்பீட்டிற்காக தயவுசெய்து மருத்துவரை அணுகவும்.",
          "LOW (Hypoglycemia)": "குறைவு (இரத்தச் சர்க்கரைக் குறைவு)",
          "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.": "இரத்தச் சர்க்கரை அளவு குறைவாக உள்ளது. இது ஒரு அவசர நிலையாகும். உங்கள் சர்க்கரை அளவை அதிகரிக்க மிட்டாய், இனிப்பு, சர்க்கரை அல்லது சாறு எடுத்துக்கொள்ளுங்கள்.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.": "சாதாரண இரத்தச் சர்க்கரை அளவைப் பராமரிக்க, தொடர்ந்து உடற்பயிற்சி செய்து சமச்சீர் உணவை உட்கொள்ளுங்கள் — இவை இரண்டும் உங்களை ஆரோக்கியமாக உணரவும் நீரிழிவு நோயைத் தடுக்கவும் உதவும்.",
          "PRE- DIABETIC": "முன் நீரிழிவு",
          "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "முன் நீரிழிவு நிலை. மருத்துவரின் ஆலோசனையுடன் OGTT பரிசோதனை செய்து உறுதிப்படுத்திக்கொள்ளுங்கள்.",
          "DIABETIC (need confirmation)": "நீரிழிவு (உறுதிப்படுத்தல் தேவை)",
          "DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "நீரிழிவு நிலை. மருத்துவரின் ஆலோசனையுடன் OGTT பரிசோதனை செய்து உறுதிப்படுத்திக்கொள்ளுங்கள்.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.": "சாதாரண இரத்தச் சர்க்கரை அளவைப் பராமரிக்க, தொடர்ந்து உடற்பயிற்சி செய்து சமச்சீர் உணவை உட்கொள்ளுங்கள் — இவை இரண்டும் உங்களை ஆரோக்கியமாக உணரவும் நீரிழிவு நோயைக் கட்டுப்பாட்டில் வைத்திருக்கவும் உதவும்.",
          "HIGH (Borderline)": "அதிகம் (எல்லைக்குட்பட்ட)",
          "At Risk": "ஆபத்தில்",
          "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.": "இரத்தச் சர்க்கரை அளவு அதிகமாக உள்ளது. மருத்துவரை அணுகுங்கள்; உங்கள் மருந்தின் அளவை மாற்றியமைக்கவோ அல்லது மாற்றவோ வேண்டியிருக்கலாம்.",
          "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.": "இரத்தச் சர்க்கரை அளவு அதிகமாக உள்ளது. உடனடியாக மருத்துவரை அணுகுங்கள்; உங்கள் மருந்தின் அளவை மாற்றியமைக்கவோ அல்லது மாற்றவோ வேண்டியிருக்கலாம்.",
          "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.": "உங்கள் இரத்த குளுக்கோஸ் அளவு குறைவாக உள்ளது மற்றும் நீங்கள் அவசர நிலையில் உள்ளீர்கள். உங்கள் இரத்த குளுக்கோஸ் அளவை அதிகரிக்க தயவுசெய்து உடனடியாக மிட்டாய், இனிப்பு, சர்க்கரை நீர் அல்லது சாறு எடுத்துக்கொள்ளுங்கள். உங்கள் குளுக்கோஸ் அளவை மீண்டும் அளந்து, தொடர்ந்து கண்காணிக்கவும்.",
          "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.": "வாழ்த்துகள்! உங்கள் இரத்த குளுக்கோஸ் அளவு சாதாரண வரம்பில் உள்ளது. தொடர்ந்து உடற்பயிற்சி செய்து, சமச்சீர் உணவை உட்கொள்வதன் மூலம் இந்த அளவைப் பராமரிக்கவும். உங்கள் குளுக்கோஸ் அளவை தொடர்ந்து கண்காணிக்கவும். உங்களை ஆரோக்கியமாக வைத்துக்கொண்டு உங்கள் குடும்பத்தையும் பாதுகாப்பாக வைத்திருங்கள்.",
          "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "உங்கள் இரத்த குளுக்கோஸ் அளவு நீங்கள் முன் நீரிழிவு நிலையில் இருப்பதைக் குறிக்கிறது, மேலும் எந்த நேரத்திலும் நீரிழிவு நோய் ஏற்படலாம். உங்கள் நோயறிதலை உறுதிப்படுத்த மருத்துவரை அணுகவும். துரித உணவு, இனிப்பு உணவுகள், அதிகப்படியான கார்போஹைட்ரேட்டுகள் அல்லது குளிர்பானங்களைத் தவிர்க்குமாறு அறிவுறுத்தப்படுகிறீர்கள். தயவுசெய்து மருத்துவரை அணுகி, தொடர்ந்து உடற்பயிற்சி செய்து, சமச்சீர் உணவை உட்கொள்ளுங்கள். இது உங்கள் இரத்த குளுக்கோஸ் அளவை சாதாரண வரம்பில் வைத்திருக்க உதவும். உங்கள் குளுக்கோஸ் அளவை தொடர்ந்து கண்காணிக்கவும்.",
          "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "உங்கள் இரத்த குளுக்கோஸ் அளவு அதிகமாக உள்ளது, மேலும் எந்த நேரத்திலும் நீரிழிவு நோய் ஏற்படலாம். உங்கள் நோயறிதலை உறுதிப்படுத்த மருத்துவரை அணுகவும். துரித உணவு, இனிப்பு உணவுகள், அதிகப்படியான கார்போஹைட்ரேட்டுகள் அல்லது குளிர்பானங்களைத் தவிர்க்குமாறு அறிவுறுத்தப்படுகிறீர்கள். தொடர்ந்து உடற்பயிற்சி செய்து, சமச்சீர் உணவை உட்கொள்ளுங்கள். இது உங்கள் இரத்த குளுக்கோஸ் அளவை சாதாரண வரம்பில் வைத்திருக்க உதவும். உங்கள் குளுக்கோஸ் அளவை தொடர்ந்து கண்காணிக்கவும்.",
          "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ": "உங்கள் இரத்த குளுக்கோஸ் அளவு எல்லைக்குட்பட்ட அளவில் அதிகமாக உள்ளது. தேவைப்பட்டால், ஆலோசனை மற்றும் உங்கள் மருந்து உட்கொள்ளும் அளவை மாற்றியமைக்க மருத்துவரை அணுகவும். தொடர்ந்து உடற்பயிற்சி செய்து, சமச்சீர் உணவை உட்கொள்ளுங்கள். இது உங்கள் இரத்த குளுக்கோஸ் அளவை சாதாரண வரம்பில் வைத்திருக்க உதவும். துரித உணவு, இனிப்பு உணவுகள், அதிகப்படியான கார்போஹைட்ரேட்டுகள் அல்லது குளிர்பானங்களைத் தவிர்க்குமாறு அறிவுறுத்தப்படுகிறீர்கள். உங்கள் குளுக்கோஸ் அளவை தொடர்ந்து கண்காணிக்கவும்.",
          "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage.": "உங்கள் இரத்த குளுக்கோஸ் அளவு அதிகமாக உள்ளது. உங்கள் மருந்து உட்கொள்ளும் அளவு தொடர்பான ஆலோசனை மற்றும் மாற்றத்திற்காக உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள சுகாதார மையத்தைத் தொடர்புகொள்ளவும். தினமும் குறைந்தது 30-40 நிமிடங்கள் தொடர்ந்து உடற்பயிற்சி செய்யுங்கள்; உங்கள் இதயத் துடிப்பு அதிகரிக்கும் வகையில் நடக்கவும். ஆரோக்கியமான சமச்சீர் உணவை உட்கொண்டு, துரித உணவு, கார்போஹைட்ரேட் நிறைந்த உணவு (அரிசி/ரொட்டி), கொழுப்பு, குளிர்பானங்கள் போன்றவற்றைத் தவிர்க்கவும். இது உங்கள் இரத்த குளுக்கோஸ் அளவை சாதாரண வரம்பில் வைத்திருக்க உதவும். உங்கள் குளுக்கோஸ் அளவை தொடர்ந்து கண்காணிக்கவும். வாழ்க்கையின் ஒவ்வொரு நிலையிலும் ஒழுக்கத்தைப் பின்பற்றவும்."
        },

        "te_IN": {
          "Normal": "సాధారణం",
          "Healthy": "ఆరోగ్యకరమైన",
          "NORMAL blood sugar level, please keep it regular.": "సాధారణ రక్తంలో చక్కెర స్థాయి, దయచేసి దీనిని క్రమంగా కొనసాగించండి.",
          "Low": "తక్కువ",
          "High Risk": "అధిక ప్రమాదం",
          "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.": "రక్తంలో చక్కెర స్థాయి తక్కువగా ఉంది. దయచేసి కొంత తీపి పదార్థం, క్యాండీ లేదా జ్యూస్ తీసుకోండి లేదా వెంటనే వైద్యుడిని సంప్రదించండి.",
          "High": "అధికం",
          "HIGH blod sugar level, please consult with doctor for further evaluation.": "రక్తంలో చక్కెర స్థాయి ఎక్కువగా ఉంది. తదుపరి పరిశీలన కోసం దయచేసి వైద్యుడిని సంప్రదించండి.",
          "LOW (Hypoglycemia)": "తక్కువ (హైపోగ్లైసీమియా)",
          "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.": "రక్తంలో చక్కెర స్థాయి తక్కువగా ఉంది. ఇది అత్యవసర పరిస్థితి. మీ చక్కెర స్థాయిని పెంచడానికి క్యాండీ, స్వీట్లు, చక్కెర లేదా జ్యూస్ తీసుకోండి.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.": "సాధారణ రక్తంలో చక్కెర స్థాయిని కొనసాగించడానికి క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి — ఇవి రెండూ మీరు ఆరోగ్యంగా ఉండటానికి మరియు మధుమేహాన్ని దూరంగా ఉంచడానికి సహాయపడతాయి.",
          "PRE- DIABETIC": "ప్రీ-డయాబెటిక్",
          "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "ప్రీ-డయాబెటిక్ పరిస్థితి. వైద్యుని సలహాతో OGTT పరీక్ష చేయించుకుని నిర్ధారించుకోండి.",
          "DIABETIC (need confirmation)": "డయాబెటిక్ (నిర్ధారణ అవసరం)",
          "DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "డయాబెటిస్ పరిస్థితి. వైద్యుని సలహాతో OGTT పరీక్ష చేయించుకుని నిర్ధారించుకోండి.",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.": "సాధారణ రక్తంలో చక్కెర స్థాయిని కొనసాగించడానికి క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి — ఇవి రెండూ మీరు ఆరోగ్యంగా ఉండటానికి మరియు మధుమేహాన్ని నియంత్రణలో ఉంచడానికి సహాయపడతాయి.",
          "HIGH (Borderline)": "అధికం (సరిహద్దు స్థాయి)",
          "At Risk": "ప్రమాదంలో",
          "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.": "రక్తంలో చక్కెర స్థాయి ఎక్కువగా ఉంది. వైద్యుడిని సంప్రదించండి. మీ మందుల మోతాదును సర్దుబాటు చేయాల్సి రావచ్చు లేదా మార్చాల్సి రావచ్చు.",
          "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.": "రక్తంలో చక్కెర స్థాయి ఎక్కువగా ఉంది. వెంటనే వైద్యుడిని సంప్రదించండి. మీ మందుల మోతాదును సర్దుబాటు చేయాల్సి రావచ్చు లేదా మార్చాల్సి రావచ్చు.",
          "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.": "మీ రక్తంలో గ్లూకోజ్ స్థాయి తక్కువగా ఉంది మరియు ఇది అత్యవసర పరిస్థితి. మీ రక్తంలో గ్లూకోజ్ స్థాయిని పెంచడానికి దయచేసి వెంటనే క్యాండీ, స్వీట్లు, చక్కెర నీరు లేదా జ్యూస్ తీసుకోండి. మీ గ్లూకోజ్‌ను మళ్లీ కొలిచి, క్రమం తప్పకుండా పర్యవేక్షించండి.",
          "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.": "అభినందనలు! మీ రక్తంలో గ్లూకోజ్ స్థాయి సాధారణ పరిధిలో ఉంది. క్రమం తప్పకుండా శారీరక వ్యాయామం చేయడం మరియు సమతుల్య ఆహారం తీసుకోవడం ద్వారా ఈ స్థాయిని కొనసాగించండి. మీ గ్లూకోజ్ స్థాయిని క్రమం తప్పకుండా పర్యవేక్షించండి. మిమ్మల్ని ఆరోగ్యంగా ఉంచుకోండి మరియు మీ కుటుంబాన్ని సురక్షితంగా ఉంచండి.",
          "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "మీ రక్తంలో గ్లూకోజ్ స్థాయి మీరు ప్రీ-డయాబెటిక్ దశలో ఉన్నారని మరియు ఎప్పుడైనా మధుమేహం అభివృద్ధి చెందవచ్చని సూచిస్తోంది. మీ నిర్ధారణను ధృవీకరించడానికి వైద్యుడిని సంప్రదించండి. ఫాస్ట్ ఫుడ్, తీపి పదార్థాలు, అధిక కార్బోహైడ్రేట్లు లేదా శీతల పానీయాలను తీసుకోవడం నివారించమని సూచించబడింది. దయచేసి వైద్యుడిని సంప్రదించి, క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి. ఇది మీ రక్తంలో గ్లూకోజ్ స్థాయిని సాధారణ పరిధిలో ఉంచడానికి సహాయపడుతుంది. మీ గ్లూకోజ్ స్థాయిని క్రమం తప్పకుండా పర్యవేక్షించండి.",
          "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "మీ రక్తంలో గ్లూకోజ్ స్థాయి ఎక్కువగా ఉంది మరియు ఎప్పుడైనా మధుమేహం రావచ్చు. మీ నిర్ధారణను ధృవీకరించడానికి వైద్యుడిని సంప్రదించండి. ఫాస్ట్ ఫుడ్, తీపి పదార్థాలు, అధిక కార్బోహైడ్రేట్లు లేదా శీతల పానీయాలను తీసుకోవడం నివారించమని సూచించబడింది. దయచేసి క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి. ఇది మీ రక్తంలో గ్లూకోజ్ స్థాయిని సాధారణ పరిధిలో ఉంచడానికి సహాయపడుతుంది. మీ గ్లూకోజ్ స్థాయిని క్రమం తప్పకుండా పర్యవేక్షించండి.",
          "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ": "మీ రక్తంలో గ్లూకోజ్ స్థాయి సరిహద్దు స్థాయిలో ఎక్కువగా ఉంది. అవసరమైతే, సలహా మరియు మీ మందుల మోతాదును సర్దుబాటు చేయడానికి వైద్యుడిని సంప్రదించండి. క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి. ఇది మీ రక్తంలో గ్లూకోజ్ స్థాయిని సాధారణ పరిధిలో ఉంచడానికి సహాయపడుతుంది. ఫాస్ట్ ఫుడ్, తీపి పదార్థాలు, అధిక కార్బోహైడ్రేట్లు లేదా శీతల పానీయాలను తీసుకోవడం నివారించమని సూచించబడింది. మీ గ్లూకోజ్ స్థాయిని క్రమం తప్పకుండా పర్యవేక్షించండి.",
          "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage.": "మీ రక్తంలో గ్లూకోజ్ స్థాయి ఎక్కువగా ఉంది. మీ మందుల మోతాదుకు సంబంధించి సలహా మరియు సర్దుబాటు కోసం వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆరోగ్య కేంద్రాన్ని సంప్రదించండి. ప్రతిరోజూ కనీసం 30-40 నిమిషాలు క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి. మీ గుండె వేగం పెరిగే విధంగా నడవండి. ఆరోగ్యకరమైన సమతుల్య ఆహారం తీసుకోండి మరియు ఫాస్ట్ ఫుడ్, కార్బోహైడ్రేట్ అధికంగా ఉన్న ఆహారం (బియ్యం/బ్రెడ్), కొవ్వు, శీతల పానీయాలు మొదలైన వాటిని నివారించండి. ఇది మీ రక్తంలో గ్లూకోజ్ స్థాయిని సాధారణ పరిధిలో ఉంచడానికి సహాయపడుతుంది. మీ గ్లూకోజ్ స్థాయిని క్రమం తప్పకుండా పర్యవేక్షించండి. జీవితంలోని ప్రతి దశలో క్రమశిక్షణను పాటించండి."
        },

        "or_IN": {
          "Normal": "ସାଧାରଣ",
          "Healthy": "ସୁସ୍ଥ",
          "NORMAL blood sugar level, please keep it regular.": "ସାଧାରଣ ରକ୍ତ ଶର୍କରା ସ୍ତର, ଦୟାକରି ଏହାକୁ ନିୟମିତ ରଖନ୍ତୁ।",
          "Low": "କମ୍",
          "High Risk": "ଅଧିକ ବିପଦ",
          "LOW blood sugar, please take some sweeteners , a candy or some juice or consult with doctor immediately.": "ରକ୍ତ ଶର୍କରା ସ୍ତର କମ୍ ଅଛି। ଦୟାକରି କିଛି ମିଠା, କ୍ୟାଣ୍ଡି କିମ୍ବା ଜୁସ୍ ନିଅନ୍ତୁ କିମ୍ବା ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
          "High": "ଅଧିକ",
          "HIGH blod sugar level, please consult with doctor for further evaluation.": "ରକ୍ତ ଶର୍କରା ସ୍ତର ଅଧିକ ଅଛି। ଅଧିକ ମୂଲ୍ୟାଙ୍କନ ପାଇଁ ଦୟାକରି ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
          "LOW (Hypoglycemia)": "କମ୍ (ହାଇପୋଗ୍ଲାଇସେମିଆ)",
          "LOW blood sugar, It’s an emergency condition. Take a candy or sweets or sugar or juice to increase your sugar level.": "ରକ୍ତ ଶର୍କରା ସ୍ତର କମ୍ ଅଛି। ଏହା ଏକ ଜରୁରୀକାଳୀନ ସ୍ଥିତି। ଆପଣଙ୍କ ଶର୍କରା ସ୍ତର ବଢ଼ାଇବା ପାଇଁ କ୍ୟାଣ୍ଡି, ମିଠା, ଚିନି କିମ୍ବା ଜୁସ୍ ନିଅନ୍ତୁ।",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes off.": "ସାଧାରଣ ରକ୍ତ ଶର୍କରା ସ୍ତରକୁ ବଜାୟ ରଖିବା ପାଇଁ ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ — ଏହି ଦୁଇଟି ଆପଣଙ୍କୁ ସୁସ୍ଥ ଅନୁଭବ କରିବା ଏବଂ ମଧୁମେହକୁ ଦୂରେଇ ରଖିବାରେ ସାହାଯ୍ୟ କରେ।",
          "PRE- DIABETIC": "ପ୍ରି-ଡାଇବେଟିକ୍",
          "PRE- DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "ପ୍ରି-ଡାଇବେଟିକ୍ ସ୍ଥିତି। ଡାକ୍ତରଙ୍କ ପରାମର୍ଶରେ OGTT ପରୀକ୍ଷା କରାଇ ନିଶ୍ଚିତ କରନ୍ତୁ।",
          "DIABETIC (need confirmation)": "ଡାଇବେଟିକ୍ (ନିଶ୍ଚିତକରଣ ଆବଶ୍ୟକ)",
          "DIABETIC condition. Make sure by doing OGTT with doctors consultation.": "ଡାଇବେଟିସ୍ ସ୍ଥିତି। ଡାକ୍ତରଙ୍କ ପରାମର୍ଶରେ OGTT ପରୀକ୍ଷା କରାଇ ନିଶ୍ଚିତ କରନ୍ତୁ।",
          "NORMAL blood sugar level, to maintain this level - do regular physical activity and eat balanced diet — both of which help you look and feel good and keep diabetes in control.": "ସାଧାରଣ ରକ୍ତ ଶର୍କରା ସ୍ତରକୁ ବଜାୟ ରଖିବା ପାଇଁ ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ — ଏହି ଦୁଇଟି ଆପଣଙ୍କୁ ସୁସ୍ଥ ଅନୁଭବ କରିବା ଏବଂ ମଧୁମେହକୁ ନିୟନ୍ତ୍ରଣରେ ରଖିବାରେ ସାହାଯ୍ୟ କରେ।",
          "HIGH (Borderline)": "ଅଧିକ (ସୀମାବର୍ତ୍ତୀ)",
          "At Risk": "ବିପଦରେ",
          "HIGH blood sugar, consult with doctor, your medicine may need to be adjusted or changed.": "ରକ୍ତ ଶର୍କରା ସ୍ତର ଅଧିକ ଅଛି। ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ଆପଣଙ୍କ ଔଷଧର ମାତ୍ରା ସମନ୍ୱୟ କିମ୍ବା ପରିବର୍ତ୍ତନ କରିବା ଆବଶ୍ୟକ ହୋଇପାରେ।",
          "HIGH blood sugar, immediately consult with doctor, your medicine may need to be adjusted or changed.": "ରକ୍ତ ଶର୍କରା ସ୍ତର ଅଧିକ ଅଛି। ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ଆପଣଙ୍କ ଔଷଧର ମାତ୍ରା ସମନ୍ୱୟ କିମ୍ବା ପରିବର୍ତ୍ତନ କରିବା ଆବଶ୍ୟକ ହୋଇପାରେ।",
          "You have a LOW Blood Glucose level and is in an emergency condition. Kindly immediately take candy, sweets, sugar water or juice to increase your blood glucose level. Remasure your glucose and monitor regularly.": "ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତର କମ୍ ଅଛି ଏବଂ ଏହା ଏକ ଜରୁରୀକାଳୀନ ସ୍ଥିତି। ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତର ବଢ଼ାଇବା ପାଇଁ ଦୟାକରି ତୁରନ୍ତ କ୍ୟାଣ୍ଡି, ମିଠା, ଚିନି ପାଣି କିମ୍ବା ଜୁସ୍ ନିଅନ୍ତୁ। ଆପଣଙ୍କ ଗ୍ଲୁକୋଜ୍ ପୁନର୍ବାର ମାପନ୍ତୁ ଏବଂ ନିୟମିତ ଭାବରେ ନଜର ରଖନ୍ତୁ।",
          "Congratulations! Your Blood Glucose level is within the NORMAL range. Kindly maintain this level by doing regular physical activity and with a balanced diet. Monitor your glucose level regularly. Keep yourself healthy and safe your family.": "ଅଭିନନ୍ଦନ! ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତର ସାଧାରଣ ସୀମା ମଧ୍ୟରେ ଅଛି। ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଦ୍ୱାରା ଦୟାକରି ଏହି ସ୍ତରକୁ ବଜାୟ ରଖନ୍ତୁ। ଆପଣଙ୍କ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ନିୟମିତ ଭାବରେ ନଜର ରଖନ୍ତୁ। ନିଜକୁ ସୁସ୍ଥ ରଖନ୍ତୁ ଏବଂ ନିଜ ପରିବାରକୁ ସୁରକ୍ଷିତ ରଖନ୍ତୁ।",
          "Your Blood Glucose level indicates that you are in a PRE-DIABETIC stage and may develop diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly consult with a doctor, do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତର ସୂଚାଉଛି ଯେ ଆପଣ ପ୍ରି-ଡାଇବେଟିକ୍ ପର୍ଯ୍ୟାୟରେ ଅଛନ୍ତି ଏବଂ ଯେକୌଣସି ସମୟରେ ମଧୁମେହ ହୋଇପାରେ। ଆପଣଙ୍କ ନିରାକରଣ ନିଶ୍ଚିତ କରିବା ପାଇଁ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ଫାଷ୍ଟ ଫୁଡ୍, ମିଠା ଖାଦ୍ୟ, ଅତ୍ୟଧିକ କାର୍ବୋହାଇଡ୍ରେଟ୍ କିମ୍ବା ଥଣ୍ଡା ପାନୀୟ ନେବାରୁ ଦୂରେଇ ରହିବାକୁ ଆପଣଙ୍କୁ ପରାମର୍ଶ ଦିଆଯାଉଛି। ଦୟାକରି ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ, ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ। ଏହା ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ସାଧାରଣ ସୀମା ମଧ୍ୟରେ ରଖିବାରେ ସାହାଯ୍ୟ କରିବ। ଆପଣଙ୍କ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ନିୟମିତ ଭାବରେ ନଜର ରଖନ୍ତୁ।",
          "You have a HIGH Blood Glucose level and may have diabetes at any time. Consult with a doctor to confirm your diagnosis. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly.": "ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତର ଅଧିକ ଅଛି ଏବଂ ଯେକୌଣସି ସମୟରେ ମଧୁମେହ ହୋଇପାରେ। ଆପଣଙ୍କ ନିରାକରଣ ନିଶ୍ଚିତ କରିବା ପାଇଁ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ଫାଷ୍ଟ ଫୁଡ୍, ମିଠା ଖାଦ୍ୟ, ଅତ୍ୟଧିକ କାର୍ବୋହାଇଡ୍ରେଟ୍ କିମ୍ବା ଥଣ୍ଡା ପାନୀୟ ନେବାରୁ ଦୂରେଇ ରହିବାକୁ ଆପଣଙ୍କୁ ପରାମର୍ଶ ଦିଆଯାଉଛି। ଦୟାକରି ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ। ଏହା ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ସାଧାରଣ ସୀମା ମଧ୍ୟରେ ରଖିବାରେ ସାହାଯ୍ୟ କରିବ। ଆପଣଙ୍କ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ନିୟମିତ ଭାବରେ ନଜର ରଖନ୍ତୁ।",
          "Your Blood Glucose level is Borderline HIGH. If required, please consult with a doctor for advice and adjustment of your medicine intake. Kindly do regular physical activity and eat a balanced diet, which will help keep your blood glucose level within the normal range. You are advised to avoid taking fast food, sweetened foods, excessive carbohydrates or soft drinks. Monitor your glucose level regularly. ": "ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତର ସୀମାବର୍ତ୍ତୀ ଭାବରେ ଅଧିକ ଅଛି। ଆବଶ୍ୟକ ହେଲେ, ପରାମର୍ଶ ଏବଂ ଆପଣଙ୍କ ଔଷଧ ସେବନର ସମନ୍ୱୟ ପାଇଁ ଦୟାକରି ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ, ଯାହା ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ସାଧାରଣ ସୀମା ମଧ୍ୟରେ ରଖିବାରେ ସାହାଯ୍ୟ କରିବ। ଫାଷ୍ଟ ଫୁଡ୍, ମିଠା ଖାଦ୍ୟ, ଅତ୍ୟଧିକ କାର୍ବୋହାଇଡ୍ରେଟ୍ କିମ୍ବା ଥଣ୍ଡା ପାନୀୟ ନେବାରୁ ଦୂରେଇ ରହିବାକୁ ଆପଣଙ୍କୁ ପରାମର୍ଶ ଦିଆଯାଉଛି। ଆପଣଙ୍କ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ନିୟମିତ ଭାବରେ ନଜର ରଖନ୍ତୁ।",
          "Your Blood Glucose level is HIGH. Immediately consult with a doctor or contact with the nearest health center for advice and adjustment of your medicine intake. Do regular physical activities minimum 30-40 minutes, walk in such a way that your heart rate increases. You should take healthy balanced diet and avoid fast food, carbohydrate rich food (rice/bread), fat, soft drink, etc, which will help keep your blood glucose level within the normal range. Monitor your glucose level regularly. Follow discipline at every life stage.": "ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତର ଅଧିକ ଅଛି। ଆପଣଙ୍କ ଔଷଧ ସେବନ ସମ୍ପର୍କରେ ପରାମର୍ଶ ଏବଂ ସମନ୍ୱୟ ପାଇଁ ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ସ୍ୱାସ୍ଥ୍ୟ କେନ୍ଦ୍ର ସହିତ ଯୋଗାଯୋଗ କରନ୍ତୁ। ପ୍ରତିଦିନ ଅତି କମରେ 30-40 ମିନିଟ୍ ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ କରନ୍ତୁ ଏବଂ ଆପଣଙ୍କ ହୃଦସ୍ପନ୍ଦନ ବଢ଼ିବା ଭଳି ଭାବରେ ଚାଲନ୍ତୁ। ସୁସ୍ଥ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ ଏବଂ ଫାଷ୍ଟ ଫୁଡ୍, କାର୍ବୋହାଇଡ୍ରେଟ୍ ଭରପୂର ଖାଦ୍ୟ (ଭାତ/ରୁଟି), ଚର୍ବି, ଥଣ୍ଡା ପାନୀୟ ଇତ୍ୟାଦିରୁ ଦୂରେଇ ରହନ୍ତୁ। ଏହା ଆପଣଙ୍କ ରକ୍ତ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ସାଧାରଣ ସୀମା ମଧ୍ୟରେ ରଖିବାରେ ସାହାଯ୍ୟ କରିବ। ଆପଣଙ୍କ ଗ୍ଲୁକୋଜ୍ ସ୍ତରକୁ ନିୟମିତ ଭାବରେ ନଜର ରଖନ୍ତୁ। ଜୀବନର ପ୍ରତ୍ୟେକ ପର୍ଯ୍ୟାୟରେ ଶୃଙ୍ଖଳା ପାଳନ କରନ୍ତୁ।"
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
