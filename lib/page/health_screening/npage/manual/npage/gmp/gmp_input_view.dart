
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/app_dialog.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/gmp/gmp_input_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:themed/themed.dart';

import '../../../../../../common/widget/basic_app_bar.dart';
import '../../../../../user_management/repository/profile_repository.dart';

class GmpInputView extends RapidView<GmpInputLogic> {
  static String routeName = '/gmp_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: controller.isNestedRoute?Colors.transparent:null,
        appBar: controller.isNestedRoute? null: BasicAppBar('label_gmp'.tr),
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
                            /*Padding(
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
                            ),*/
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
                            vertical: 8.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CMEDWhiteElevatedButton(
                                'label_enter'.tr,
                                    () => {
                                  if (controller.isValidInput())
                                    AppDialogs.showDoubleButtonDialog(
                                        'label_measurement_store_warning'.tr,
                                        bodyText:
                                        controller.getInputText().trAmount(),
                                        onPositiveButtonClick: () => {
                                          controller.sendMeasurement(),
                                        }),
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
    final wfa = {
      "en_US": {
        "Severe Underweight": "Severe Underweight",
        "High Risk": "High Risk",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.",
        "Moderate Underweight": "Moderate Underweight",
        "Moderate Risk": "Moderate Risk",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "Your child is moderately underweight according to age, please consult with doctor for evaluation.",
        "Mild Underweight": "Mild Underweight",
        "Low Risk": "Low Risk",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "Your child has mild underweight according to age, please consult doctor for evaluation.",
        "Normal": "Normal",
        "Healthy": "Healthy",
        "Your child is well nourished, please continue balanced diet as usual.":
            "Your child is well nourished, please continue balanced diet as usual.",
        "Overweight": "Overweight",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.",
      },
      "bn_BD": {
        "Severe Underweight": "মারাত্মক কম ওজন",
        "High Risk": "বেশি ঝুঁকি সম্পন্ন",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "আপনার শিশুর  ওজন বয়স অনুযায়ী  অনেক কম, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন।",
        "Moderate Underweight": "মাঝারি কম ওজন",
        "Moderate Risk": "ঝুঁকি সম্পন্ন",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "আপনার শিশুর ওজন বয়স অনুযায়ী স্বাভাবিকের চেয়ে মাঝারি কম।এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Mild Underweight": "স্বল্প কম ওজন",
        "Low Risk": "স্বল্প ঝুঁকি সম্পন্ন",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "আপনার শিশুর ওজন বয়স অনুযায়ী  স্বাভাবিকের চেয়ে কম, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Normal": "স্বাভাবিক",
        "Healthy": "ঝুঁকিমুক্ত",
        "Your child is well nourished, please continue balanced diet as usual.":
            "বয়স অনুযায়ী আপনার শিশু স্বাভাবিক পুষ্টিমাত্রা সম্পন্ন, শিশুকে সুষম খাবার প্রদানের মাধ্যমে এই মাত্রা বজায় রাখুন।",
        "Overweight": "বেশি ওজন",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "বয়স অনুযায়ী আপনার শিশুর ওজন স্বাভাবিকের চেয়ে বেশি। ওজন কমাতে  চিকিৎসক বা পুষ্টিবিদের পরামর্শ নিন । পাশাপাশি অতিরিক্ত তৈলাক্ত ও চর্বিযুক্ত (ফাস্ট ফুড/ভাজা পোড়া) খাবার পরিহার করুন । প্রতিদিন কমপক্ষে এক ঘন্টা নিয়মিত শারীরিক কর্মকান্ড (খেলাধুলা) করুন | অন্যথায় স্থূলতার কারণে ভবিষত আপনার বাচ্চার উচ্চ রক্তচাপ এবং ডায়াবেটিস হতে পারে |",
      },
      "kn_IN": {
        "Severe Underweight": "ತೀವ್ರ ಕಡಿಮೆ ತೂಕ",
        "Moderate Underweight": "ಮಧ್ಯಮ ಕಡಿಮೆ ತೂಕ",
        "Mild Underweight": "ಕಡಿಮೆ ತೂಕ",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Overweight": "ಅಧಿಕ ತೂಕ",
      },
      "hi_IN": {
        "Severe Underweight": "गंभीर कम वजन",
        "High Risk": "उच्च जोखिम",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "आपके बच्चे का वजन उम्र के अनुसार बहुत कम है, कृपया तुरंत डॉक्टर से परामर्श लें या नजदीकी अस्पताल जाएं।",
        "Moderate Underweight": "मध्यम कम वजन",
        "Moderate Risk": "मध्यम जोखिम",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "आपके बच्चे का वजन उम्र के अनुसार मध्यम रूप से कम है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Mild Underweight": "हल्का कम वजन",
        "Low Risk": "कम जोखिम",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "आपके बच्चे का वजन उम्र के अनुसार थोड़ा कम है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Normal": "सामान्य",
        "Healthy": "स्वस्थ",
        "Your child is well nourished, please continue balanced diet as usual.":
            "आपका बच्चा अच्छी तरह से पोषित है, कृपया हमेशा की तरह संतुलित आहार जारी रखें।",
        "Overweight": "अधिक वजन",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "आपके बच्चे का वजन उम्र के अनुसार अधिक है। वजन कम करने के लिए पोषण विशेषज्ञ या डॉक्टर से परामर्श लें। अपने बच्चे को तैलीय और वसायुक्त भोजन (फास्ट फूड या तले हुए खाद्य पदार्थ) देने से बचें। आपके बच्चे को प्रतिदिन कम से कम एक घंटे नियमित शारीरिक गतिविधि (खेलकूद) करनी चाहिए। अन्यथा अधिक वजन के कारण भविष्य में उच्च रक्तचाप, मधुमेह जैसी कई बीमारियां हो सकती हैं।",
      },
      "ta_IN": {
        "Severe Underweight": "கடுமையான குறைந்த எடை",
        "High Risk": "அதிக ஆபத்து",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை மிகவும் குறைவாக உள்ளது, தயவுசெய்து உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
        "Moderate Underweight": "மிதமான குறைந்த எடை",
        "Moderate Risk": "மிதமான ஆபத்து",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை மிதமாக குறைவாக உள்ளது, தயவுசெய்து பரிசோதனைக்காக மருத்துவரை அணுகவும்.",
        "Mild Underweight": "லேசான குறைந்த எடை",
        "Low Risk": "குறைந்த ஆபத்து",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை சற்று குறைவாக உள்ளது, தயவுசெய்து பரிசோதனைக்காக மருத்துவரை அணுகவும்.",
        "Normal": "இயல்பானது",
        "Healthy": "ஆரோக்கியமானது",
        "Your child is well nourished, please continue balanced diet as usual.":
            "உங்கள் குழந்தை நன்கு ஊட்டச்சத்து பெற்றுள்ளது, வழக்கம்போல் சமச்சீர் உணவைத் தொடர்ந்து வழங்குங்கள்.",
        "Overweight": "அதிக எடை",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "உங்கள் குழந்தையின் வயதிற்கு ஏற்ப எடை அதிகமாக உள்ளது. எடையைக் குறைக்க ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும். உங்கள் குழந்தைக்கு எண்ணெய் மற்றும் கொழுப்பு நிறைந்த உணவுகளை (துரித உணவு அல்லது வறுத்த உணவுகள்) வழங்குவதை கட்டுப்படுத்துங்கள். உங்கள் குழந்தை தினமும் குறைந்தது ஒரு மணி நேரம் வழக்கமான உடல் செயல்பாடுகளில் (விளையாட்டு) ஈடுபட வேண்டும். இல்லையெனில் அதிக எடை காரணமாக எதிர்காலத்தில் உயர் இரத்த அழுத்தம், நீரிழிவு போன்ற பல நோய்கள் ஏற்படலாம்.",
      },
      "te_IN": {
        "Severe Underweight": "తీవ్ర తక్కువ బరువు",
        "High Risk": "అధిక ప్రమాదం",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "మీ పిల్లల వయస్సుకు తగిన బరువు కంటే చాలా తక్కువగా ఉంది, దయచేసి వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రిని సందర్శించండి.",
        "Moderate Underweight": "మధ్యస్థ తక్కువ బరువు",
        "Moderate Risk": "మధ్యస్థ ప్రమాదం",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "మీ పిల్లల వయస్సుకు తగిన బరువు కంటే మధ్యస్థంగా తక్కువగా ఉంది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Mild Underweight": "స్వల్ప తక్కువ బరువు",
        "Low Risk": "తక్కువ ప్రమాదం",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "మీ పిల్లల వయస్సుకు తగిన బరువు కంటే కొద్దిగా తక్కువగా ఉంది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Normal": "సాధారణం",
        "Healthy": "ఆరోగ్యకరం",
        "Your child is well nourished, please continue balanced diet as usual.":
            "మీ పిల్లలకు తగినంత పోషకాహారం అందుతోంది, ఎప్పటిలాగే సమతుల్య ఆహారాన్ని కొనసాగించండి.",
        "Overweight": "అధిక బరువు",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "మీ పిల్లల వయస్సుకు తగిన బరువు కంటే ఎక్కువగా ఉంది. బరువు తగ్గించడానికి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి. మీ పిల్లలకు నూనె మరియు కొవ్వు అధికంగా ఉన్న ఆహారాలు (ఫాస్ట్ ఫుడ్ లేదా వేయించిన ఆహార పదార్థాలు) ఇవ్వడాన్ని నియంత్రించండి. మీ పిల్లలు ప్రతిరోజూ కనీసం ఒక గంట క్రమం తప్పకుండా శారీరక కార్యకలాపాల్లో (ఆటలు) పాల్గొనాలి. లేకపోతే అధిక బరువు కారణంగా భవిష్యత్తులో అధిక రక్తపోటు, మధుమేహం వంటి అనేక వ్యాధులు రావచ్చు.",
      },
      "or_IN": {
        "Severe Underweight": "ଗୁରୁତର କମ୍ ଓଜନ",
        "High Risk": "ଅଧିକ ବିପଦ",
        "Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ବହୁତ କମ୍ ଅଛି, ଦୟାକରି ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ଡାକ୍ତରଖାନାକୁ ଯାଆନ୍ତୁ।",
        "Moderate Underweight": "ମଧ୍ୟମ କମ୍ ଓଜନ",
        "Moderate Risk": "ମଧ୍ୟମ ବିପଦ",
        "Your child is moderately underweight according to age, please consult with doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ମଧ୍ୟମ ଭାବରେ କମ୍ ଅଛି, ଦୟାକରି ଯାଞ୍ଚ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Mild Underweight": "ସାମାନ୍ୟ କମ୍ ଓଜନ",
        "Low Risk": "କମ୍ ବିପଦ",
        "Your child has mild underweight according to age, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ସାମାନ୍ୟ କମ୍ ଅଛି, ଦୟାକରି ଯାଞ୍ଚ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Normal": "ସାଧାରଣ",
        "Healthy": "ସୁସ୍ଥ",
        "Your child is well nourished, please continue balanced diet as usual.":
            "ଆପଣଙ୍କ ଶିଶୁ ଭଲ ଭାବରେ ପୁଷ୍ଟି ପାଇଛି, ପୂର୍ବପରି ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଜାରି ରଖନ୍ତୁ।",
        "Overweight": "ଅଧିକ ଓଜନ",
        "You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "ଆପଣଙ୍କ ଶିଶୁର ବୟସ ଅନୁସାରେ ଓଜନ ଅଧିକ ଅଛି। ଓଜନ କମାଇବା ପାଇଁ ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ। ଆପଣଙ୍କ ଶିଶୁକୁ ତେଲିଆ ଏବଂ ଚର୍ବିଯୁକ୍ତ ଖାଦ୍ୟ (ଫାଷ୍ଟ ଫୁଡ୍ କିମ୍ବା ଭଜା ଖାଦ୍ୟ) ଦେବାକୁ ନିୟନ୍ତ୍ରଣ କରନ୍ତୁ। ଆପଣଙ୍କ ଶିଶୁ ପ୍ରତିଦିନ ଅତି କମରେ ଏକ ଘଣ୍ଟା ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ (ଖେଳକୁଦ) କରିବା ଆବଶ୍ୟକ। ଅନ୍ୟଥା ଅଧିକ ଓଜନ ଯୋଗୁଁ ଭବିଷ୍ୟତରେ ଉଚ୍ଚ ରକ୍ତଚାପ, ମଧୁମେହ ଭଳି ଅନେକ ରୋଗ ହୋଇପାରେ।",
      },
    };

    final hfa = {
      "en_US": {
        "Severe Stunting": "Severe Stunting",
        "High Risk": "High Risk",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.",
        "Moderate Stunting": "Moderate Stunting",
        "Moderate Risk": "Moderate Risk",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "Your child is moderately stunted comparing to age, please consult doctor for evaluation.",
        "Mild Stunting": "Mild Stunting",
        "Low Risk": "Low Risk",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "Your child has mild stunting comparing to age, please consult doctor for evaluation.",
        "Normal": "Normal",
        "Healthy": "Healthy",
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
        "Mild Stunting": "স্বল্প খর্ব",
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
        "Your child has mild stunting, please consult doctor for evaluation.":
            "আপনার শিশু বয়সের তুলনায় স্বল্প খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "আপনার শিশু বয়সের তুলনায় স্বাভাবিকের চেয়ে লম্বা। কারণ জানতে চিকিৎসকের পরামর্শ নিন ।",
      },
      "kn_IN": {
        "Severe Stunting": "ತೀವ್ರ ಕುಂಠಿತ",
        "High Risk": "ಹೆಚ್ಚಿನ ಅಪಾಯ",
        "Moderate Stunting": "ಮಧ್ಯಮ ಕುಂಠಿತ",
        "Moderate Risk": "ಮಧ್ಯಮ ಅಪಾಯ",
        "Mild Stunting": "ಸ್ವಲ್ಪ ಕುಂಠಿತ ಬೆಳವಣಿಗೆ",
        "Low Risk": "ಕಡಿಮೆ ಅಪಾಯ",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Healthy": "ಆರೋಗ್ಯಕರ",
        "Tall": "ಎತ್ತರ",
      },
      "hi_IN": {
        "Severe Stunting": "गंभीर अवरुद्ध विकास",
        "High Risk": "उच्च जोखिम",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "आपके बच्चे का विकास उम्र की तुलना में गंभीर रूप से अवरुद्ध है, कृपया तुरंत डॉक्टर से परामर्श लें या नजदीकी अस्पताल जाएं।",
        "Moderate Stunting": "मध्यम अवरुद्ध विकास",
        "Moderate Risk": "मध्यम जोखिम",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "आपके बच्चे का विकास उम्र की तुलना में मध्यम रूप से अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Mild Stunting": "हल्का अवरुद्ध विकास",
        "Low Risk": "कम जोखिम",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "आपके बच्चे का विकास उम्र की तुलना में थोड़ा अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Normal": "सामान्य",
        "Healthy": "स्वस्थ",
        "Normal Height": "सामान्य ऊंचाई",
        "Tall": "लंबा",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "आपका बच्चा उम्र की तुलना में अधिक लंबा है। कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श लें।",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "आपका बच्चा उम्र की तुलना में अधिक लंबा है। कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श लें।",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "आपके बच्चे का विकास गंभीर रूप से अवरुद्ध है, कृपया तुरंत डॉक्टर से परामर्श लें या नजदीकी अस्पताल जाएं।",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "आपके बच्चे का विकास मध्यम रूप से अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "आपके बच्चे का विकास थोड़ा अवरुद्ध है, कृपया जांच के लिए डॉक्टर से परामर्श लें।",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "आपका बच्चा अधिक लंबा है। कृपया वजन कम करने के लिए पोषण विशेषज्ञ या डॉक्टर से परामर्श लें।",
      },
      "ta_IN": {
        "Severe Stunting": "கடுமையான வளர்ச்சி குன்றல்",
        "High Risk": "அதிக ஆபத்து",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "உங்கள் குழந்தையின் வளர்ச்சி வயதுடன் ஒப்பிடும்போது கடுமையாக குன்றியுள்ளது, தயவுசெய்து உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
        "Moderate Stunting": "மிதமான வளர்ச்சி குன்றல்",
        "Moderate Risk": "மிதமான ஆபத்து",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி வயதுடன் ஒப்பிடும்போது மிதமாக குன்றியுள்ளது, தயவுசெய்து பரிசோதனைக்காக மருத்துவரை அணுகவும்.",
        "Mild Stunting": "லேசான வளர்ச்சி குன்றல்",
        "Low Risk": "குறைந்த ஆபத்து",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி வயதுடன் ஒப்பிடும்போது சற்று குன்றியுள்ளது, தயவுசெய்து பரிசோதனைக்காக மருத்துவரை அணுகவும்.",
        "Normal": "இயல்பானது",
        "Healthy": "ஆரோக்கியமானது",
        "Normal Height": "இயல்பான உயரம்",
        "Tall": "உயரம்",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "உங்கள் குழந்தை வயதுடன் ஒப்பிடும்போது மிகவும் உயரமாக உள்ளது. தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "உங்கள் குழந்தை வயதுடன் ஒப்பிடும்போது மிகவும் உயரமாக உள்ளது. தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "உங்கள் குழந்தையின் வளர்ச்சி கடுமையாக குன்றியுள்ளது, தயவுசெய்து உடனடியாக மருத்துவரை அணுகவும் அல்லது அருகிலுள்ள மருத்துவமனைக்குச் செல்லவும்.",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி மிதமாக குன்றியுள்ளது, தயவுசெய்து பரிசோதனைக்காக மருத்துவரை அணுகவும்.",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "உங்கள் குழந்தையின் வளர்ச்சி சற்று குன்றியுள்ளது, தயவுசெய்து பரிசோதனைக்காக மருத்துவரை அணுகவும்.",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "உங்கள் குழந்தை மிகவும் உயரமாக உள்ளது. எடையைக் குறைக்க ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
      },
      "te_IN": {
        "Severe Stunting": "తీవ్ర ఎదుగుదల లోపం",
        "High Risk": "అధిక ప్రమాదం",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "మీ పిల్లల ఎదుగుదల వయస్సుతో పోలిస్తే తీవ్రంగా మందగించింది, దయచేసి వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రిని సందర్శించండి.",
        "Moderate Stunting": "మధ్యస్థ ఎదుగుదల లోపం",
        "Moderate Risk": "మధ్యస్థ ప్రమాదం",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల వయస్సుతో పోలిస్తే మధ్యస్థంగా మందగించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Mild Stunting": "స్వల్ప ఎదుగుదల లోపం",
        "Low Risk": "తక్కువ ప్రమాదం",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల వయస్సుతో పోలిస్తే స్వల్పంగా మందగించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Normal": "సాధారణం",
        "Healthy": "ఆరోగ్యకరం",
        "Normal Height": "సాధారణ ఎత్తు",
        "Tall": "ఎత్తుగా",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "మీ పిల్లలు వయస్సుతో పోలిస్తే ఎక్కువ ఎత్తుగా ఉన్నారు. దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "మీ పిల్లలు వయస్సుతో పోలిస్తే ఎక్కువ ఎత్తుగా ఉన్నారు. దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "మీ పిల్లల ఎదుగుదల తీవ్రంగా మందగించింది, దయచేసి వెంటనే వైద్యుడిని సంప్రదించండి లేదా సమీపంలోని ఆసుపత్రిని సందర్శించండి.",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల మధ్యస్థంగా మందగించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "మీ పిల్లల ఎదుగుదల స్వల్పంగా మందగించింది, దయచేసి పరీక్ష కోసం వైద్యుడిని సంప్రదించండి.",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "మీ పిల్లలు ఎక్కువ ఎత్తుగా ఉన్నారు. బరువు తగ్గించడానికి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
      },
      "or_IN": {
        "Severe Stunting": "ଗୁରୁତର ବିକାଶ ବାଧା",
        "High Risk": "ଅଧିକ ବିପଦ",
        "Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ବୟସ ତୁଳନାରେ ଗୁରୁତର ଭାବରେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ଡାକ୍ତରଖାନାକୁ ଯାଆନ୍ତୁ।",
        "Moderate Stunting": "ମଧ୍ୟମ ବିକାଶ ବାଧା",
        "Moderate Risk": "ମଧ୍ୟମ ବିପଦ",
        "Your child is moderately stunted comparing to age, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ବୟସ ତୁଳନାରେ ମଧ୍ୟମ ଭାବରେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ଯାଞ୍ଚ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Mild Stunting": "ସାମାନ୍ୟ ବିକାଶ ବାଧା",
        "Low Risk": "କମ୍ ବିପଦ",
        "Your child has mild stunting comparing to age, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ବୟସ ତୁଳନାରେ ସାମାନ୍ୟ ଭାବରେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ଯାଞ୍ଚ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Normal": "ସାଧାରଣ",
        "Healthy": "ସୁସ୍ଥ",
        "Normal Height": "ସାଧାରଣ ଉଚ୍ଚତା",
        "Tall": "ଲମ୍ବା",
        "Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":
            "ଆପଣଙ୍କ ଶିଶୁ ବୟସ ତୁଳନାରେ ଅଧିକ ଲମ୍ବା ଅଛି। ଦୟାକରି ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Your child is more tall comparing to age.  Please consult with nutritionist or physician.":
            "ଆପଣଙ୍କ ଶିଶୁ ବୟସ ତୁଳନାରେ ଅଧିକ ଲମ୍ବା ଅଛି। ଦୟାକରି ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ଗୁରୁତର ଭାବରେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ତୁରନ୍ତ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ କିମ୍ବା ନିକଟସ୍ଥ ଡାକ୍ତରଖାନାକୁ ଯାଆନ୍ତୁ।",
        "Your child is moderately stunted, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ମଧ୍ୟମ ଭାବରେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ଯାଞ୍ଚ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Your child has mild stunting, please consult doctor for evaluation.":
            "ଆପଣଙ୍କ ଶିଶୁର ବିକାଶ ସାମାନ୍ୟ ଭାବରେ ବାଧାପ୍ରାପ୍ତ ହୋଇଛି, ଦୟାକରି ଯାଞ୍ଚ ପାଇଁ ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
        "Your child is more tall. Please consult with nutritionist or physician for weight reduction.":
            "ଆପଣଙ୍କ ଶିଶୁ ଅଧିକ ଲମ୍ବା ଅଛି। ଓଜନ କମାଇବା ପାଇଁ ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ।",
      },
    };

    final wfl = {
      "en_US": {
        "Severely Wasted": "Severely Wasted",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":
            "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.",
        "Moderately Wasted": "Moderately Wasted",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":
            "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.",
        "Normal": "Normal",
        "Your child is well nourished compare to height, please continue balanced diet as usual.":
            "Your child is well nourished compare to height, please continue balanced diet as usual.",
        "Overweight": "Overweight",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":
            "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.",
        "Obesity": "Obesity",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":
            "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.",
      },
      "bn_BD": {
        "Severely Wasted": "মারাত্মক তীব্র অপুষ্টি",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":
            "আপনার বাচ্চা উচ্চতা অনুযায়ী মারাত্মক তীব্র অপুষ্টি তে আক্রান্ত। অতি দ্রুত তার চিকিৎসা প্রয়োজন। তাকে যত দ্রুত সম্ভব নিকটস্থ স্বাস্থ্যকেন্দ্রে নিয়ে যান।",
        "Moderately Wasted": "মাঝারি তীব্র অপুষ্টি",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":
            "আপনার বাচ্চা উচ্চতা অনুযায়ী মাঝারি তীব্র অপুষ্টীজনিত রোগে আক্রান্ত। যত দ্রুত সম্ভব তার পুষ্টীর অভাব পুরণের জন্য নিকটস্থ সাস্থ্যকেন্দ্রে নেয়া উত্তম।",
        "Normal": "স্বাভাবিক",
        "Your child is well nourished compare to height, please continue balanced diet as usual.":
            "উচ্চতা অনুযায়ী আপনার শিশু স্বাভাবিক পুষ্টিমাত্রা সম্পন্ন, শিশুকে সুষম খাবার প্রদানের মাধ্যমে এই মাত্রা বজায় রাখুন।",
        "Overweight": "বেশি ওজন",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":
            "আপনার বাচ্চার ওজন, উচ্চতার  তুলনায় বেশি । জটিলতা এড়ানোর জন্য খাদ্যাভ্যাস পরিবর্তন এবং শারিরিক ব্যায়াম প্রয়োজন।",
        "Obesity": "স্থূলতা",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "আপনার শিশুর ওজন উচ্চতার  তুলনায়  অনেক বেশি। ওজন কমাতে দ্রুত চিকিৎসক বা পুষ্টিবিদের পরামর্শ নিন । পাশাপাশি অতিরিক্ত তৈলাক্ত ও চর্বিযুক্ত (ফাস্ট ফুড/ভাজা পোড়া) খাবার পরিহার করুন । প্রতিদিন কমপক্ষে এক ঘন্টা নিয়মিত শারীরিক কর্মকান্ড (খেলাধুলা) করুন | অন্যথায় স্থূলতার কারণে ভবিষত আপনার বাচ্চার উচ্চ রক্তচাপ এবং ডায়াবেটিস হতে পারে |",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":
            "আপনার বাচ্চার ওজন, উচ্চতার  তুলনায় বেশি । জটিলতা এড়ানোর জন্য খাদ্যাভ্যাস পরিবর্তন এবং শারিরিক ব্যায়াম প্রয়োজন।",
      },
      "kn_IN": {
        "Severely Wasted": "ತೀವ್ರವಾಗಿ ವ್ಯರ್ಥವಾಯಿತು",
        "Moderately Wasted": "ಸಾಧಾರಣವಾಗಿ ವ್ಯರ್ಥವಾಗಿದೆ",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Overweight": "ಅಧಿಕ ತೂಕ",
        "Obesity": "ಬೊಜ್ಜು",
      },
      "hi_IN": {
        "Severely Wasted": "गंभीर रूप से क्षीण",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":
            "आपका बच्चा ऊंचाई की तुलना में गंभीर रूप से कुपोषित है। उसे तुरंत चिकित्सा सहायता की आवश्यकता है। अपने बच्चे को जल्द से जल्द निकटतम स्वास्थ्य केंद्र ले जाएं।",
        "Moderately Wasted": "मध्यम रूप से क्षीण",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":
            "आपका बच्चा ऊंचाई की तुलना में मध्यम रूप से कुपोषित है और पोषण संबंधी कमियों से प्रभावित है। उसे जल्द से जल्द निकटतम स्वास्थ्य केंद्र ले जाएं।",
        "Normal": "सामान्य",
        "Your child is well nourished compare to height, please continue balanced diet as usual.":
            "आपका बच्चा ऊंचाई के अनुसार अच्छी तरह से पोषित है, कृपया हमेशा की तरह संतुलित आहार जारी रखें।",
        "Overweight": "अधिक वजन",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":
            "आपके बच्चे का वजन अधिक है। आगे की जटिलताओं को रोकने के लिए आहार में बदलाव और शारीरिक व्यायाम आवश्यक हैं।",
        "Obesity": "मोटापा",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "आपके बच्चे का वजन ऊंचाई की तुलना में बहुत अधिक है। वजन कम करने के लिए पोषण विशेषज्ञ या डॉक्टर से परामर्श लें। अपने बच्चे को तैलीय और वसायुक्त भोजन (फास्ट फूड या तले हुए खाद्य पदार्थ) देने से बचें और आपके बच्चे को प्रतिदिन कम से कम एक घंटे नियमित शारीरिक गतिविधि (खेलकूद) करनी चाहिए। अन्यथा अधिक वजन के कारण भविष्य में उच्च रक्तचाप, मधुमेह जैसी कई बीमारियां हो सकती हैं।",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":
            "आपके बच्चे का वजन ऊंचाई की तुलना में अधिक है। आगे की जटिलताओं को रोकने के लिए आहार में बदलाव और शारीरिक व्यायाम आवश्यक हैं।",
      },
      "ta_IN": {
        "Severely Wasted": "கடுமையான ஊட்டச்சத்து குறைபாடு",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":
            "உங்கள் குழந்தை உயரத்துடன் ஒப்பிடும்போது கடுமையான ஊட்டச்சத்து குறைபாட்டால் பாதிக்கப்பட்டுள்ளது. அவருக்கு உடனடி மருத்துவ கவனிப்பு தேவை. உங்கள் குழந்தையை விரைவில் அருகிலுள்ள சுகாதார மையத்திற்கு அழைத்துச் செல்லுங்கள்.",
        "Moderately Wasted": "மிதமான ஊட்டச்சத்து குறைபாடு",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":
            "உங்கள் குழந்தை உயரத்துடன் ஒப்பிடும்போது மிதமான ஊட்டச்சத்து குறைபாட்டால் பாதிக்கப்பட்டுள்ளது. ஊட்டச்சத்து குறைபாடுகளும் ஏற்பட்டுள்ளன. அவரை விரைவில் அருகிலுள்ள சுகாதார மையத்திற்கு அழைத்துச் செல்லுங்கள்.",
        "Normal": "இயல்பானது",
        "Your child is well nourished compare to height, please continue balanced diet as usual.":
            "உங்கள் குழந்தை உயரத்திற்கு ஏற்ப நன்கு ஊட்டச்சத்து பெற்றுள்ளது, வழக்கம்போல் சமச்சீர் உணவைத் தொடர்ந்து வழங்குங்கள்.",
        "Overweight": "அதிக எடை",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":
            "உங்கள் குழந்தைக்கு அதிக எடை உள்ளது. மேலும் ஏற்படக்கூடிய சிக்கல்களைத் தடுக்க உணவு முறையில் மாற்றங்களும் உடற்பயிற்சியும் அவசியம்.",
        "Obesity": "உடல் பருமன்",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "உங்கள் குழந்தையின் உயரத்துடன் ஒப்பிடும்போது எடை மிகவும் அதிகமாக உள்ளது. எடையைக் குறைக்க ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும். உங்கள் குழந்தைக்கு எண்ணெய் மற்றும் கொழுப்பு நிறைந்த உணவுகளை (துரித உணவு அல்லது வறுத்த உணவுகள்) வழங்குவதை கட்டுப்படுத்துங்கள் மற்றும் உங்கள் குழந்தை தினமும் குறைந்தது ஒரு மணி நேரம் வழக்கமான உடல் செயல்பாடுகளில் (விளையாட்டு) ஈடுபட வேண்டும். இல்லையெனில் அதிக எடை காரணமாக எதிர்காலத்தில் உயர் இரத்த அழுத்தம், நீரிழிவு போன்ற பல நோய்கள் ஏற்படலாம்.",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":
            "உங்கள் குழந்தையின் எடை உயரத்துடன் ஒப்பிடும்போது அதிகமாக உள்ளது. மேலும் ஏற்படக்கூடிய சிக்கல்களைத் தடுக்க உணவு முறையில் மாற்றங்களும் உடற்பயிற்சியும் அவசியம்.",
      },
      "te_IN": {
        "Severely Wasted": "తీవ్ర పోషకాహార లోపం",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":
            "మీ పిల్లలు ఎత్తుతో పోలిస్తే తీవ్రమైన పోషకాహార లోపంతో ఉన్నారు. వారికి తక్షణ వైద్య సహాయం అవసరం. మీ పిల్లలను వీలైనంత త్వరగా సమీపంలోని ఆరోగ్య కేంద్రానికి తీసుకెళ్లండి.",
        "Moderately Wasted": "మధ్యస్థ పోషకాహార లోపం",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":
            "మీ పిల్లలు ఎత్తుతో పోలిస్తే మధ్యస్థ పోషకాహార లోపంతో ఉన్నారు మరియు పోషకాహార లోపాల వల్ల ప్రభావితమయ్యారు. వారిని వీలైనంత త్వరగా సమీపంలోని ఆరోగ్య కేంద్రానికి తీసుకెళ్లండి.",
        "Normal": "సాధారణం",
        "Your child is well nourished compare to height, please continue balanced diet as usual.":
            "మీ పిల్లలు ఎత్తుకు తగిన విధంగా మంచి పోషకాహారం పొందుతున్నారు, ఎప్పటిలాగే సమతుల్య ఆహారాన్ని కొనసాగించండి.",
        "Overweight": "అధిక బరువు",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":
            "మీ పిల్లలకు అధిక బరువు ఉంది. మరిన్ని సమస్యలను నివారించడానికి ఆహారంలో మార్పులు మరియు శారీరక వ్యాయామం అవసరం.",
        "Obesity": "ఊబకాయం",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "మీ పిల్లల బరువు ఎత్తుతో పోలిస్తే చాలా ఎక్కువగా ఉంది. బరువు తగ్గించడానికి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి. మీ పిల్లలకు నూనె మరియు కొవ్వు అధికంగా ఉన్న ఆహారాలు (ఫాస్ట్ ఫుడ్ లేదా వేయించిన ఆహార పదార్థాలు) ఇవ్వడాన్ని నియంత్రించండి మరియు మీ పిల్లలు ప్రతిరోజూ కనీసం ఒక గంట క్రమం తప్పకుండా శారీరక కార్యకలాపాల్లో (ఆటలు) పాల్గొనాలి. లేకపోతే అధిక బరువు కారణంగా భవిష్యత్తులో అధిక రక్తపోటు, మధుమేహం వంటి అనేక వ్యాధులు రావచ్చు.",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":
            "మీ పిల్లల బరువు ఎత్తుతో పోలిస్తే ఎక్కువగా ఉంది. మరిన్ని సమస్యలను నివారించడానికి ఆహారంలో మార్పులు మరియు శారీరక వ్యాయామం అవసరం.",
      },
      "or_IN": {
        "Severely Wasted": "ଗୁରୁତର ପୁଷ୍ଟିହୀନତା",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":
            "ଆପଣଙ୍କ ଶିଶୁ ଉଚ୍ଚତା ତୁଳନାରେ ଗୁରୁତର ପୁଷ୍ଟିହୀନତାରେ ପୀଡ଼ିତ। ତାଙ୍କୁ ତୁରନ୍ତ ଚିକିତ୍ସା ଆବଶ୍ୟକ। ଆପଣଙ୍କ ଶିଶୁକୁ ଯଥାଶୀଘ୍ର ନିକଟସ୍ଥ ସ୍ୱାସ୍ଥ୍ୟକେନ୍ଦ୍ରକୁ ନେଇଯାଆନ୍ତୁ।",
        "Moderately Wasted": "ମଧ୍ୟମ ପୁଷ୍ଟିହୀନତା",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":
            "ଆପଣଙ୍କ ଶିଶୁ ଉଚ୍ଚତା ତୁଳନାରେ ମଧ୍ୟମ ପୁଷ୍ଟିହୀନତାରେ ପୀଡ଼ିତ ଏବଂ ପୁଷ୍ଟିସାର ଅଭାବରେ ପ୍ରଭାବିତ ହୋଇଛି। ତାଙ୍କୁ ଯଥାଶୀଘ୍ର ନିକଟସ୍ଥ ସ୍ୱାସ୍ଥ୍ୟକେନ୍ଦ୍ରକୁ ନେଇଯାଆନ୍ତୁ।",
        "Normal": "ସାଧାରଣ",
        "Your child is well nourished compare to height, please continue balanced diet as usual.":
            "ଆପଣଙ୍କ ଶିଶୁ ଉଚ୍ଚତା ଅନୁସାରେ ଭଲ ଭାବରେ ପୁଷ୍ଟି ପାଇଛି, ପୂର୍ବପରି ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଜାରି ରଖନ୍ତୁ।",
        "Overweight": "ଅଧିକ ଓଜନ",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":
            "ଆପଣଙ୍କ ଶିଶୁର ଓଜନ ଅଧିକ ଅଛି। ପରବର୍ତ୍ତୀ ଜଟିଳତାକୁ ରୋକିବା ପାଇଁ ଖାଦ୍ୟାଭ୍ୟାସରେ ପରିବର୍ତ୍ତନ ଏବଂ ଶାରୀରିକ ବ୍ୟାୟାମ ଆବଶ୍ୟକ।",
        "Obesity": "ସ୍ଥୂଳତା",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":
            "ଆପଣଙ୍କ ଶିଶୁର ଓଜନ ଉଚ୍ଚତା ତୁଳନାରେ ବହୁତ ଅଧିକ। ଓଜନ କମାଇବା ପାଇଁ ପୁଷ୍ଟି ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ପରାମର୍ଶ ନିଅନ୍ତୁ। ଆପଣଙ୍କ ଶିଶୁକୁ ତେଲିଆ ଏବଂ ଚର୍ବିଯୁକ୍ତ ଖାଦ୍ୟ (ଫାଷ୍ଟ ଫୁଡ୍ କିମ୍ବା ଭଜା ଖାଦ୍ୟ) ଦେବାକୁ ନିୟନ୍ତ୍ରଣ କରନ୍ତୁ ଏବଂ ଆପଣଙ୍କ ଶିଶୁ ପ୍ରତିଦିନ ଅତି କମରେ ଏକ ଘଣ୍ଟା ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ (ଖେଳକୁଦ) କରିବା ଆବଶ୍ୟକ। ଅନ୍ୟଥା ଅଧିକ ଓଜନ ଯୋଗୁଁ ଭବିଷ୍ୟତରେ ଉଚ୍ଚ ରକ୍ତଚାପ, ମଧୁମେହ ଭଳି ଅନେକ ରୋଗ ହୋଇପାରେ।",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":
            "ଆପଣଙ୍କ ଶିଶୁର ଓଜନ ଉଚ୍ଚତା ତୁଳନାରେ ଅଧିକ ଅଛି। ପରବର୍ତ୍ତୀ ଜଟିଳତାକୁ ରୋକିବା ପାଇଁ ଖାଦ୍ୟାଭ୍ୟାସରେ ପରିବର୍ତ୍ତନ ଏବଂ ଶାରୀରିକ ବ୍ୟାୟାମ ଆବଶ୍ୟକ।",
      },
    };

    return mergeTranslations(wfa, hfa, wfl);
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {

    Get.put(ScreeningReportRepository());
    Get.put(GmpInputLogic(repository: Get.find<ScreeningReportRepository>(), profileRepository:  Get.find<ProfileRepository>()));
  }

  Map<String, Map<String, String>> mergeTranslations(
      Map<String, Map<String, String>> map1,
      Map<String, Map<String, String>> map2,
      Map<String, Map<String, String>> map3,
      ) {
    final Map<String, Map<String, String>> result = {};

    // Helper local function to deeply merge a single map into the result
    void addMap(Map<String, Map<String, String>> source) {
      source.forEach((langKey, translations) {
        // If the language doesn't exist yet, initialize it with a new map
        result[langKey] ??= {};
        // Merge the inner map without wiping out existing keys
        result[langKey]!.addAll(translations);
      });
    }

    addMap(map1);
    addMap(map2);
    addMap(map3);

    return result;
  }
}
