import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/widget_v2.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/temp/temp_input_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:themed/themed.dart';

import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';

import '../../../../../../common/widget/cmed_primary_elevated_button.dart';

class TempInputView extends RapidView<TempInputLogic> {
  static String routeName = '/temp_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: widgetV(
        v2: GradientWhiteToPrimary(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: controller.isNestedRoute? null: BasicAppBarV2('label_body_temperature'.tr),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SafeArea(
                child: Form(
                  key: controller.screeningReportFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  isShowCurrentDate: true,
                                  title:  controller.dateController.text.isEmpty ? null : CustomDateUtils.formatDatePicker(controller.dateController.text),
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
                                              controller.temperatureUnit.value ==
                                                  TemperatureUnit.FAHRENHEIT.name
                                                  ? 'title_measurement_in_f'.tr
                                                  : 'title_measurement_in_c'.tr,
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
                                        onTap: ()
                                        {
                                          controller.toggleTemperatureUnitWithValue();
                                        },
                                        child:  ChangeColors(
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
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Text(
                                    'input_label_temp'.tr,
                                    style: CMEDTextUtils.inputTextLabelStyle,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Obx(() => CMEDTextField(
                                    controller.temperatureUnit.value ==
                                        TemperatureUnit.FAHRENHEIT.name
                                        ? 'input_hint_temp_f'.tr
                                        : 'input_hint_temp_c'.tr,
                                    keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'))
                                    ],
                                    textEditingController:
                                    controller.temperatureEditTextController,
                                    onSaved: (value) {}, onValidator: (value) {
                                  return controller
                                      .validateTemperatureInput(value!);
                                })),
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
                                  child: CMEDPrimaryElevatedButton(
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
          ),
        ),
        v1: Scaffold(
          appBar: BasicAppBar('label_body_temperature'.tr),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Form(
                key: controller.screeningReportFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                isShowCurrentDate: true,
                                title:  controller.dateController.text.isEmpty ? null : CustomDateUtils.formatDatePicker(controller.dateController.text),
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
                                            controller.temperatureUnit.value ==
                                                    TemperatureUnit.FAHRENHEIT.name
                                                ? 'title_measurement_in_f'.tr
                                                : 'title_measurement_in_c'.tr,
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
                                      onTap: () =>
                                          {controller.toggleTemperatureUnitWithValue()},
                                      child:  ChangeColors(
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
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  'input_label_temp'.tr,
                                  style: CMEDTextUtils.inputTextLabelStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(() => CMEDTextField(
                                      controller.temperatureUnit.value ==
                                              TemperatureUnit.FAHRENHEIT.name
                                          ? 'input_hint_temp_f'.tr
                                          : 'input_hint_temp_c'.tr,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}'))
                                      ],
                                      textEditingController:
                                          controller.temperatureEditTextController,
                                      onSaved: (value) {}, onValidator: (value) {
                                    return controller
                                        .validateTemperatureInput(value!);
                                  })),
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
        ),
      ),
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
      return {
        "en_US": {
          "Very low": "Very low",
          "High Risk": "High Risk",
          "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.": "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.",
          "Low": "Low",
          "LOW temperature, cover yourself with blanket or bed sheet and check again.": "LOW temperature, cover yourself with blanket or bed sheet and check again.",
          "Normal": "Normal",
          "NORMAL temperature": "NORMAL temperature",
          "High": "High",
          "HIGH temperature, consult with doctor or visit nearby hospital.": "HIGH temperature, consult with doctor or visit nearby hospital.",
          "Very high": "Very high",
          "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital.": "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital."
        },
        "bn_BD": {
          "Very low": "মাত্রাতিরিক্ত নিম্ন",
          "High Risk": "বেশি ঝুঁকি সম্পন্ন",
          "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.": "মাত্রাতিরিক্ত কম তাপমাত্রা, কম্বল বা চাদর সহকারে নিজেকে ঢাকুন ও কিছুক্ষণ পর পুনরায় মাপুন না হলে দ্রুত চিকিৎসকের পরামর্শ নিন।",
          "Low": "নিম্ন",
          "LOW temperature, cover yourself with blanket or bed sheet and check again.": "কম তাপমাত্রা, কম্বল বা চাদর সহকারে নিজেকে ঢাকুন ও কিছুক্ষণ পর পুনরায় মাপুন। ",
          "Normal": "ঝুকিমুক্ত",
          "NORMAL temperature": "স্বাভাবিক তাপমাত্রা।",
          "High": "উচ্চ",
          "HIGH temperature, consult with doctor or visit nearby hospital.": "বেশি তাপমাত্রা, চিকিৎসকের পরামর্শ নিন।",
          "Very high": "মাত্রাতিরিক্ত",
          "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital.": "মাত্রাতিরিক্ত বেশি তাপমাত্রা, দ্রুত চিকিৎসকের পরামর্শ নিন। "
        },
        "kn_IN": {
          "Very low": "ತುಂಬಾ ಕಡಿಮೆ",
          "High Risk": "ಹೆಚ್ಚಿನ ಅಪಾಯ",
          "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.": "ತುಂಬಾ ಕಡಿಮೆ ತಾಪಮಾನದಲ್ಲಿ ಕಂಬಳಿ / ಬೆಡ್ ಶೀಟ್ ಹೊದ್ದುಕೊಂಡು ಮತ್ತೊಮ್ಮೆ ಪರೀಕ್ಷಿಸಿಕೊಳ್ಳಿ ಅಥವಾ ತಕ್ಷಣ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ಭೇಟಿ ನೀಡಿ.",
          "Low": "ಕಡಿಮೆ",
          "LOW temperature, cover yourself with blanket or bed sheet and check again.": "ಕಡಿಮೆ ತಾಪಮಾನ, ಕಂಬಳಿ ಅಥವಾ ಬೆಡ್ ಶೀಟ್ ನಿಂದ ನಿಮ್ಮನ್ನು ಮುಚ್ಚಿಕೊಂಡು ಮತ್ತೊಮ್ಮೆ ಪರಿಶೀಲಿಸಿ.",
          "Normal": "ಸಾಮಾನ್ಯ",
          "NORMAL temperature": "ಸಾಮಾನ್ಯ ತಾಪಮಾನ",
          "High": "ಹೆಚ್ಚಿನ",
          "HIGH temperature, consult with doctor or visit nearby hospital.": "ಹೆಚ್ಚಿನ ತಾಪಮಾನ, ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ಭೇಟಿ ನೀಡಿ.",
          "Very high": "ತುಂಬಾ ಹೆಚ್ಚು",
          "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital.": "ತುಂಬಾ ಹೆಚ್ಚಿನ ತಾಪಮಾನ, ತಕ್ಷಣ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಅಥವಾ ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗೆ ಭೇಟಿ ನೀಡಿ."
        },
        "hi_IN": {
          "Very low": "बहुत कम",
          "High Risk": "उच्च जोखिम",
          "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.": "बहुत कम तापमान होने पर अपने आप को कंबल / बेड शीट से ढकें और दोबारा जांच करें या तुरंत डॉक्टर से परामर्श लें या निकटतम अस्पताल जाएं।",
          "Low": "कम",
          "LOW temperature, cover yourself with blanket or bed sheet and check again.": "कम तापमान होने पर अपने आप को कंबल या बेड शीट से ढकें और दोबारा जांच करें।",
          "Normal": "सामान्य",
          "NORMAL temperature": "सामान्य तापमान",
          "High": "अधिक",
          "HIGH temperature, consult with doctor or visit nearby hospital.": "अधिक तापमान होने पर डॉक्टर से परामर्श लें या निकटतम अस्पताल जाएं।",
          "Very high": "बहुत अधिक",
          "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital.": "बहुत अधिक तापमान होने पर तुरंत डॉक्टर से परामर्श लें या निकटतम अस्पताल जाएं।"
        },

        "ta_IN": {
          "Very low": "மிகவும் குறைவு",
          "High Risk": "அதிக ஆபத்து",
          "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.": "வெப்பநிலை மிகவும் குறைவாக இருந்தால் போர்வை / படுக்கை விரிப்பால் உங்களை மூடிக்கொண்டு மீண்டும் பரிசோதிக்கவும் அல்லது உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
          "Low": "குறைவு",
          "LOW temperature, cover yourself with blanket or bed sheet and check again.": "வெப்பநிலை குறைவாக இருந்தால் போர்வை அல்லது படுக்கை விரிப்பால் உங்களை மூடிக்கொண்டு மீண்டும் பரிசோதிக்கவும்.",
          "Normal": "இயல்பு",
          "NORMAL temperature": "இயல்பான வெப்பநிலை",
          "High": "அதிகம்",
          "HIGH temperature, consult with doctor or visit nearby hospital.": "வெப்பநிலை அதிகமாக இருந்தால் மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
          "Very high": "மிகவும் அதிகம்",
          "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital.": "வெப்பநிலை மிகவும் அதிகமாக இருந்தால் உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்."
        },

        "te_IN": {
          "Very low": "చాలా తక్కువ",
          "High Risk": "అధిక ప్రమాదం",
          "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.": "ఉష్ణోగ్రత చాలా తక్కువగా ఉంటే దుప్పటి / బెడ్ షీట్‌తో మిమ్మల్ని మీరు కప్పుకుని మళ్లీ తనిఖీ చేయండి లేదా వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రికి వెళ్లండి.",
          "Low": "తక్కువ",
          "LOW temperature, cover yourself with blanket or bed sheet and check again.": "ఉష్ణోగ్రత తక్కువగా ఉంటే దుప్పటి లేదా బెడ్ షీట్‌తో మిమ్మల్ని మీరు కప్పుకుని మళ్లీ తనిఖీ చేయండి.",
          "Normal": "సాధారణం",
          "NORMAL temperature": "సాధారణ ఉష్ణోగ్రత",
          "High": "అధికం",
          "HIGH temperature, consult with doctor or visit nearby hospital.": "ఉష్ణోగ్రత ఎక్కువగా ఉంటే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రికి వెళ్లండి.",
          "Very high": "చాలా ఎక్కువ",
          "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital.": "ఉష్ణోగ్రత చాలా ఎక్కువగా ఉంటే వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రికి వెళ్లండి."
        },

        "or_IN": {
          "Very low": "ବହୁତ କମ୍",
          "High Risk": "ଅଧିକ ବିପଦ",
          "VERY LOW temperature cover yourself with blanket / bed sheet and check again or, consult with doctor immediately or visit nearby hospital.": "ତାପମାତ୍ରା ବହୁତ କମ୍ ଥିଲେ କମ୍ବଳ / ବେଡ୍ ସିଟ୍ ଦ୍ୱାରା ନିଜକୁ ଘୋଡ଼ାଇ ନିଅନ୍ତୁ ଏବଂ ପୁଣି ଯାଞ୍ଚ କରନ୍ତୁ କିମ୍ବା ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ସହ ପରାମର୍ଶ କରନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ହସ୍ପିଟାଲକୁ ଯାଆନ୍ତୁ।",
          "Low": "କମ୍",
          "LOW temperature, cover yourself with blanket or bed sheet and check again.": "ତାପମାତ୍ରା କମ୍ ଥିଲେ କମ୍ବଳ କିମ୍ବା ବେଡ୍ ସିଟ୍ ଦ୍ୱାରା ନିଜକୁ ଘୋଡ଼ାଇ ନିଅନ୍ତୁ ଏବଂ ପୁଣି ଯାଞ୍ଚ କରନ୍ତୁ।",
          "Normal": "ସାଧାରଣ",
          "NORMAL temperature": "ସାଧାରଣ ତାପମାତ୍ରା",
          "High": "ଅଧିକ",
          "HIGH temperature, consult with doctor or visit nearby hospital.": "ତାପମାତ୍ରା ଅଧିକ ଥିଲେ ଡାକ୍ତରଙ୍କ ସହ ପରାମର୍ଶ କରନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ହସ୍ପିଟାଲକୁ ଯାଆନ୍ତୁ।",
          "Very high": "ବହୁତ ଅଧିକ",
          "VERY HIGH temperature, consult with doctor immediately or visit nearby hospital.": "ତାପମାତ୍ରା ବହୁତ ଅଧିକ ଥିଲେ ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ସହ ପରାମର୍ଶ କରନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ହସ୍ପିଟାଲକୁ ଯାଆନ୍ତୁ।"
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
    Get.put(TempInputLogic(repository: Get.find<ScreeningReportRepository>()));
  }

  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<TempInputLogic>().isThemeV2) {
      return v2 ?? v1;
    }
    return v1;
  }
}
