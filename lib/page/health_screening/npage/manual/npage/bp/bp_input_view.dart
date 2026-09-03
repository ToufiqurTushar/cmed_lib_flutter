import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bp/bp_input_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';

import '../../../../../../common/widget/basic_app_bar.dart';
import '../../../../../../common/widget/cmed_primary_elevated_button.dart';
import '../../../../../../common/widget/widget_v2.dart';


class BpInputView extends RapidView<BpInputLogic> {
  static String routeName = '/bp_input_page';

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
            appBar: controller.isNestedRoute? null: BasicAppBarV2('label_blood_pressure'.tr),
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
                                    'input_label_systolic_bp'.tr,
                                    style: CMEDTextUtils.inputTextLabelStyle,
                                  ),
                                ),
                                CMEDTextField('input_hint_systolic_bp'.tr,
                                    keyboardType: TextInputType.number,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    textEditingController:
                                    controller.systolicController,
                                    onSaved: (value) {}, onValidator: (value) {
                                      return controller.validateSystolic(value!);
                                    }),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('input_label_diastolic_bp'.tr,
                                    style: CMEDTextUtils.inputTextLabelStyle),
                                CMEDTextField(
                                  'input_hint_systolic_bp'.tr,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textEditingController:
                                  controller.diastolicController,
                                  onSaved: (value) {},
                                  onValidator: (value) {
                                    return controller.validateDiastolic(value!);
                                  },
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'input_label_pulse_rate'.tr,
                                  style: CMEDTextUtils.inputTextLabelStyle,
                                ),
                                CMEDTextField('input_hint_bpm'.tr,
                                    keyboardType: TextInputType.number,
                                    textEditingController: controller.pulseController,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    onSaved: (value) {}, onValidator: (value) {
                                      return controller.validatePulse(value!);
                                    }),
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
                                  child: CMEDPrimaryElevatedButton(
                                    'label_enter'.tr,
                                        () => {
                                      if (controller.isValidInput())
                                        controller
                                            .sendBpAndPulseMeasurement(),
                                      // CMEDDialogs.showDoubleButtonDialog(
                                      //     'label_measurement_store_warning'.tr,
                                      //     bodyText: controller.getInputText(),
                                      //     onPositiveButtonClick: () => {
                                      //           controller
                                      //               .sendBpAndPulseMeasurement(),
                                      //         }),
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
        ),
        v1: Scaffold(
            appBar: BasicAppBar('label_blood_pressure'.tr),
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
                                    'input_label_systolic_bp'.tr,
                                    style: CMEDTextUtils.inputTextLabelStyle,
                                  ),
                                ),
                                CMEDTextField('input_hint_systolic_bp'.tr,
                                    keyboardType: TextInputType.number,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    textEditingController:
                                        controller.systolicController,
                                    onSaved: (value) {}, onValidator: (value) {
                                  return controller.validateSystolic(value!);
                                }),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('input_label_diastolic_bp'.tr,
                                    style: CMEDTextUtils.inputTextLabelStyle),
                                CMEDTextField(
                                  'input_hint_systolic_bp'.tr,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textEditingController:
                                      controller.diastolicController,
                                  onSaved: (value) {},
                                  onValidator: (value) {
                                    return controller.validateDiastolic(value!);
                                  },
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'input_label_pulse_rate'.tr,
                                  style: CMEDTextUtils.inputTextLabelStyle,
                                ),
                                CMEDTextField('input_hint_bpm'.tr,
                                    keyboardType: TextInputType.number,
                                    textEditingController: controller.pulseController,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    onSaved: (value) {}, onValidator: (value) {
                                  return controller.validatePulse(value!);
                                }),
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
                                        controller
                                            .sendBpAndPulseMeasurement(),
                                        // CMEDDialogs.showDoubleButtonDialog(
                                        //     'label_measurement_store_warning'.tr,
                                        //     bodyText: controller.getInputText(),
                                        //     onPositiveButtonClick: () => {
                                        //           controller
                                        //               .sendBpAndPulseMeasurement(),
                                        //         }),
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
      ),
      
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
   return {
     "en_US": {
       "Normal": "Normal",
       "Healthy": "Healthy",
       "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.": "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.",
       "Low": "Low",
       "High Risk": "High Risk",
       "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.",
       "High": "High",
       "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.": "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.",
       "High Normal": "High Normal",
       "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.",
       "Mild High": "Mild High",
       "Moderate High": "Moderate High",
       "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.",
       "Severe High": "Severe High",
       "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.",
       "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.": "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.",
       "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.": "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.",
       "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.",
       "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.",
       "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.": "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.",
       "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.": "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.",
       "NORMAL rate.": "NORMAL rate.",
       "LOW pulse rate. Monitor regularly.": "LOW pulse rate. Monitor regularly.",
       "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.": "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.",
       "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.": "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.",
     },
     "bn_BD": {
       "Normal": "স্বাভাবিক",
       "Healthy": "ঝুকিমুক্ত",
       "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.": "অভিনন্দন! আপনার রক্তচাপ স্বাভাবিক। নিয়মিত দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে স্বাভাবিক রক্তচাপ বজায় রাখুন। নিজে সুস্থ থাকুন এবং পরিবারকে নিরাপদ রাখুন।",
       "Low": "নিম্ন",
       "High Risk": "বেশি ঝুঁকি সম্পন্ন",
       "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "আপনার রক্তচাপ স্বাভাবিকের চেয়ে কম, যা পরবর্তীতে আপনার জন্য বিপজ্জনক হতে পারে। রক্তচাপ স্বাভাবিক রাখতে নিয়মিত রক্তচাপ পর্যবেক্ষন, শারীরিক পরিশ্রম ও সুষম খাবার গ্রহণ করুন। প্রয়োজনে চিকিৎসকের পরামর্শ নিন।",
       "High": "উচ্চ",
       "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.": "আপনার উচ্চ রক্তচাপ দেখাচ্ছে যা পরবর্তীতে আপনার উচ্চরক্তচাপ, হৃদরোগ, স্ট্রোক ও ডায়াবেটিস রোগের ঝুঁকি অনেক বাড়িয়ে দেয়। পুরোপুরি উচ্চ রক্তচাপে উন্নীত হওয়ার পূর্বেই নিয়মিত রক্তচাপ পর্যবেক্ষন, শারীরিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে স্বাভাবিক অবস্থায় আনুন। প্রয়োজনে চিকিৎসকের পরামর্শ নিন।",
       "High Normal": "উচ্চ স্বাভাবিক",
       "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "আপনার রক্তচাপ উচ্চ স্বাভাবিক দেখাচ্ছে, যা স্বাভাবিক রক্তের চাপের তুলনায় কিছুটা বেশি। রক্তচাপ স্বাভাবিক রাখতে নিয়মিত রক্তচাপ পর্যবেক্ষন, শারীরিক পরিশ্রম ও সুষম খাবার গ্রহণ করুন। প্রয়োজনে চিকিৎসকের পরামর্শ নিন।",
       "Mild High": "মৃদু উচ্চ",
       "Moderate High": "মাঝারি উচ্চ",
       "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "আপনার উচ্চ রক্তচাপ দেখাচ্ছে যা পরবর্তীতে আপনার উচ্চরক্তচাপ, হৃদরোগ, স্ট্রোক ও ডায়াবেটিস রোগের ঝুঁকি অনেক বাড়িয়ে দেয়। পুরোপুরি উচ্চ রক্তচাপে উন্নীত হওয়ার পূর্বেই নিয়মিত রক্তচাপ পর্যবেক্ষন, শারীরিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে স্বাভাবিক অবস্থায় আনুন। প্রয়োজনে চিকিৎসকের পরামর্শ নিন।",
       "Severe High": "মাত্রাতিরিক্ত",
       "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "আপনার রক্তচাপ অনেক বেশী। যা পরবর্তীতে আপনার উচ্চরক্তচাপ, হৃদরোগ, স্ট্রোক ও ডায়াবেটিস রোগের ঝুঁকি অনেক বাড়িয়ে দেয়। পুরোপুরি উচ্চ রক্তচাপে উন্নীত হওয়ার পূর্বেই নিয়মিত রক্তচাপ পর্যবেক্ষন, শারীরিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে স্বাভাবিক অবস্থায় আনুন। অনুগ্রহপূর্বক অতিসত্বর চিকিৎসকের পরামর্শ নিন এবং উচ্চ রক্তচাপ নিশ্চিত করুন। নিয়মিত রক্তচাপ পরিমাপ করুন এবং চিকিৎসকের সাথে যোগাযোগ রাখুন।",
       "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.": "আপনার রক্তচাপ স্বাভাবিক সীমার চেয়ে কম। আপনাকে ঘন ঘন খাবার খেতে হবে। প্রতিদিন আপনার রক্তচাপ মাপুন এবং তা লিখে রাখুন। যদি রক্তচাপ আরও কমে যায়, তাহলে আপনি পূর্বে যেসব উচ্চ রক্তচাপ নিয়ন্ত্রক ওষুধ খাচ্ছিলেন তা বন্ধ করুন এবং আপনার ডাক্তারের পরামর্শ নিন।",
       "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.": "আপনার রক্তচাপ স্বাভাবিক রক্তচাপের চেয়ে সামান্য বেশি। পরবর্তী এক সপ্তাহ প্রতিদিন আপনার রক্তচাপ মাপুন এবং তা লিখে রাখুন। যদি রক্তচাপ বাড়তে থাকে, তাহলে আপনার ডাক্তারের পরামর্শ নিন। আপনাকে পুষ্টিকর খাবার খেতে হবে এবং নিয়মিত ২০ মিনিট ব্যায়াম করতে হবে। যদি আপনি চিকিৎসা নিতে দেরি করেন, এটি গুরুতর রক্তচাপের সমস্যায় পরিণত হতে পারে।",
       "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "আপনার উচ্চ রক্তচাপ দেখা যাচ্ছে। উচ্চ রক্তচাপ নিয়ন্ত্রক ওষুধ শুরু করা বা আপনার চলমান ওষুধে কিছু পরিবর্তন করা প্রয়োজন, পাশাপাশি নিয়মিত ব্যায়াম ,শারীরিক পরিশ্রম এবং স্বাস্থ্যকর খাবার খাওয়া জরুরি। পরবর্তী এক সপ্তাহ প্রতিদিন রক্তচাপ মাপুন এবং লিখে রাখুন। পুরোপুরি উচ্চ রক্তচাপে উন্নীত হওয়ার পূর্বেই , ডাক্তারের পরামর্শ নিন, না হলে এটি আরও বেশি বাড়তে পারে।",
       "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "আপনার উচ্চ রক্তচাপ দেখা যাচ্ছে। উচ্চ রক্তচাপ নিয়ন্ত্রক ওষুধ শুরু করা বা আপনার চলমান ওষুধে কিছু পরিবর্তন করা প্রয়োজন, পাশাপাশি নিয়মিত ব্যায়াম ,শারীরিক পরিশ্রম এবং স্বাস্থ্যকর খাবার খাওয়া জরুরি। পরবর্তী এক সপ্তাহ প্রতিদিন রক্তচাপ মাপুন এবং লিখে রাখুন। পুরোপুরি উচ্চ রক্তচাপে উন্নীত হওয়ার পূর্বেই , ডাক্তারের পরামর্শ নিন, না হলে এটি আরও বেশি বাড়তে পারে।",
       "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.": "আপনার রক্তচাপ অনেক বেশি। অবিলম্বে আপনার চিকিৎসকের সঙ্গে পরামর্শ করুন। আপনাকে উচ্চ রক্তচাপ নিয়ন্ত্রনের ওষুধ শুরু করতে হবে বা আপনার পূর্ববর্তী ওষুধে প্রয়োজনীয় পরিবর্তন করতে হবে। পুষ্টিকর খাবার খাওয়া, শারিরীক পরিশ্রম এবং প্রতিদিন ব্যায়াম করা জরুরি। আপনাকে প্রতিদিন রক্তচাপ মাপতে হবে এবং তা সংরক্ষণ করতে হবে। যদি চিকিৎসা নিতে দেরি করেন, তবে এটি হৃদরোগ, স্ট্রোক বা কিডনি রোগের কারণ হতে পারে।",
       "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.": "আপনার রক্তচাপ স্বাভাবিক। যদি আপনি কোনো উচ্চ রক্তচাপ নিয়ন্ত্রক ওষুধ খেতে থাকেন, তাহলে তা চলমান রাখতে হবে। আপনাকে প্রতি সপ্তাহে রক্তচাপ মাপতে হবে। স্বাস্থ্যকর খাবার খেতে হবে এবং নিয়মিত ব্যায়াম করতে হবে।",
       "NORMAL rate.": "পালস রেট স্বাভাবিক।",
       "LOW pulse rate. Monitor regularly.": "পালস রেট কম, নিয়মিত মনিটর করুন ও প্রয়োজন হলে চিকিৎসকের পরামর্শ নিন। ",
       "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.": "পালস রেট বেশি। এটি ঝুঁকি সম্পন্ন, নিয়মিত মনিটর করুন ও প্রয়োজন হলে চিকিৎসকের পরামর্শ নিন ও নিশ্চিত হন। ",
       "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.": "পালস রেট স্বাভাবিক। নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে এই মাত্রা বজায় রাখুন।",
     },
     "kn_IN": {
       "Normal": "ಸಾಮಾನ್ಯ",
       "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ.",
       "Low": "ಕಡಿಮೆ ",
       "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ.",
       "High": "ಹೆಚ್ಚು ",
       "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಮಾಪನ ಕಡಿಮೆಯಾಗಿದೆ, ಇದು ನಿಮಗೆ ಅಪಾಯಕಾರಿಯಾಗಬಹುದು. ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ಸಾಮಾನ್ಯ ಮಿತಿಯಲ್ಲಿಡಲು, ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ. ಅಗತ್ಯವಿದ್ದರೆ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
       "High Normal": "ಹೆಚ್ಚು ಸಾಮಾನ್ಯ ",
       "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ.",
       "Mild High": "ಮೈಲ್ಡಾಗಿ ಹೆಚ್ಚಾಗಿದೆ ",
       "Moderate High": "ಮಾಡರೇಟಾಗಿ ಹೆಚ್ಚು ",
       "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಮಾಪನ ಕಡಿಮೆಯಾಗಿದೆ, ಇದು ನಿಮಗೆ ಅಪಾಯಕಾರಿಯಾಗಬಹುದು. ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ಸಾಮಾನ್ಯ ಮಿತಿಯಲ್ಲಿಡಲು, ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ. ಅಗತ್ಯವಿದ್ದರೆ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
       "Severe High": "ತೀವ್ರವಾಗಿ ಹೆಚ್ಚು",
       "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ.",
       "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಮಾಪನ ಕಡಿಮೆಯಾಗಿದೆ, ಇದು ನಿಮಗೆ ಅಪಾಯಕಾರಿಯಾಗಬಹುದು. ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ಸಾಮಾನ್ಯ ಮಿತಿಯಲ್ಲಿಡಲು, ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ. ಅಗತ್ಯವಿದ್ದರೆ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
       "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ.",
       "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮಾಡಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ.",
       "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಿ. ಹೆಚ್ಚಿನ ನಿರ್ವಹಣೆಗಾಗಿ ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ತಕ್ಷಣದ ಕ್ರಮಗಳನ್ನು ತೆಗೆದುಕೊಳ್ಳಿ.",
       "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.": "ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡ ತೀವ್ರವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಕಾಯಿಲೆ, ಪಾರ್ಶ್ವವಾಯು ಮತ್ತು ಮಧುಮೇಹ ಸೇರಿದಂತೆ ಕೆಲವು ಗಂಭೀರ ಕಾಯಿಲೆಗಳು ಬರುವ ಅಪಾಯ ಗಮನಾರ್ಹವಾಗಿ ಹೆಚ್ಚಾಗಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆರೋಗ್ಯ ಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಜಾಗರೂಕರಾಗಿರಿ, ನಿಯಮಿತವಾಗಿ ರಕ್ತದೊತ್ತಡವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ, ನಿಯಮಿತ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಿ. ಹೆಚ್ಚಿನ ನಿರ್ವಹಣೆಗಾಗಿ ದಯವಿಟ್ಟು ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ ಮತ್ತು ನಿಮ್ಮ ರಕ್ತದೊತ್ತಡವನ್ನು ನಿಯಂತ್ರಿಸಲು ತಕ್ಷಣದ ಕ್ರಮಗಳನ್ನು ತೆಗೆದುಕೊಳ್ಳಿ.",
       "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.": "ಅಭಿನಂದನೆಗಳು! ನಿಮಗೆ ಸಾಮಾನ್ಯ ರಕ್ತದೊತ್ತಡವಿದೆ. ದಯವಿಟ್ಟು ನಿಯಮಿತ ದೈಹಿಕ ವ್ಯಾಯಾಮ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸುವ ಮೂಲಕ ಈ ಒತ್ತಡವನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ. ನಿಮ್ಮನ್ನು ಮತ್ತು ನಿಮ್ಮ ಕುಟುಂಬವನ್ನು ಆರೋಗ್ಯವಾಗಿಡಿ.",
       "Healthy": "ಆರೋಗ್ಯಕರ",
       "High Risk": "ಹೆಚ್ಚಿನ ಅಪಾಯ",
       "NORMAL rate.": "ಸಾಮಾನ್ಯ ದರ.",
       "LOW pulse rate. Monitor regularly.": "ಕಡಿಮೆ ನಾಡಿಮಿಡಿತ. ನಿಯಮಿತವಾಗಿ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ.",
       "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.": "ಹೆಚ್ಚಿನ ನಾಡಿಮಿಡಿತ, ಇದು ಅಪಾಯಕಾರಿ. ಈ ಸ್ಥಿತಿ ಮುಂದುವರಿದರೆ ದಯವಿಟ್ಟು ಮೌಲ್ಯಮಾಪನ ಮಾಡಿ.",
       "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.": "ಸಾಮಾನ್ಯ ದರ. ದಯವಿಟ್ಟು ನಿಯಮಿತ ದೈಹಿಕ ಚಟುವಟಿಕೆ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರದ ಮೂಲಕ ಈ ದರವನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ."
     },
    "hi_IN": {
      "Normal": "सामान्य",
      "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.": "बधाई हो! आपका रक्तचाप सामान्य है। कृपया नियमित शारीरिक व्यायाम और संतुलित आहार लेकर इस रक्तचाप को बनाए रखें। अपने और अपने परिवार को स्वस्थ रखें।",
      "Low": "कम",
      "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "आपका रक्तचाप कम है, जो आपके लिए जोखिम हो सकता है। अपने रक्तचाप को सामान्य सीमा में रखने के लिए नियमित रूप से रक्तचाप की निगरानी करें, नियमित व्यायाम करें और संतुलित आहार लें। आवश्यकता होने पर डॉक्टर से परामर्श करें।",
      "High": "उच्च",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.": "आपका रक्तचाप अधिक है। भविष्य में उच्च रक्तचाप, हृदय रोग, स्ट्रोक और मधुमेह सहित कुछ गंभीर बीमारियों के विकसित होने का आपका जोखिम काफी बढ़ गया है। कृपया अपनी स्वास्थ्य स्थिति के प्रति सावधान रहें, नियमित रूप से BP की निगरानी करें, नियमित शारीरिक व्यायाम करें और अपने BP को नियंत्रित करने के लिए संतुलित आहार लें।",
      "High Normal": "उच्च सामान्य",
      "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "आपका रक्तचाप उच्च सामान्य है, जो सामान्य रक्तचाप की ऊपरी सीमा से अधिक है। अपने रक्तचाप को सामान्य सीमा में रखने के लिए नियमित रूप से रक्तचाप की निगरानी करें, नियमित व्यायाम करें और संतुलित आहार लें। आवश्यकता होने पर डॉक्टर से परामर्श करें।",
      "Mild High": "हल्का उच्च",
      "Moderate High": "मध्यम उच्च",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "आपका रक्तचाप अधिक है। भविष्य में उच्च रक्तचाप, हृदय रोग, स्ट्रोक और मधुमेह सहित कुछ गंभीर बीमारियों के विकसित होने का आपका जोखिम काफी बढ़ गया है। कृपया अपनी स्वास्थ्य स्थिति के प्रति सावधान रहें, नियमित रूप से BP की निगरानी करें, नियमित शारीरिक व्यायाम करें और अपने BP को नियंत्रित करने के लिए संतुलित आहार लें। आगे के प्रबंधन के लिए कृपया डॉक्टर से परामर्श करें और अपने रक्तचाप को नियंत्रित करने के लिए तुरंत कदम उठाएं।",
      "Severe High": "गंभीर रूप से उच्च",
      "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "आपका रक्तचाप बहुत अधिक है। भविष्य में उच्च रक्तचाप, हृदय रोग, स्ट्रोक और मधुमेह सहित कुछ गंभीर बीमारियों के विकसित होने का आपका जोखिम काफी बढ़ गया है। कृपया अपनी स्वास्थ्य स्थिति के प्रति सावधान रहें, नियमित रूप से BP की निगरानी करें, नियमित शारीरिक व्यायाम करें और अपने BP को नियंत्रित करने के लिए संतुलित आहार लें। आगे के प्रबंधन के लिए कृपया डॉक्टर से परामर्श करें और अपने रक्तचाप को नियंत्रित करने के लिए तुरंत कदम उठाएं।",
      "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.": "आपका रक्तचाप सामान्य सीमा से कम है। आपको बार-बार भोजन करना चाहिए। कृपया अपने रक्तचाप की प्रतिदिन निगरानी करें और उसे लिखकर रखें। यदि रक्तचाप गिरता है, तो अपनी पिछली उच्च रक्तचाप की दवा बंद करें और अपने डॉक्टर से परामर्श करें।",
      "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.": "आपका रक्तचाप उच्च सामान्य है। यह सामान्य रक्तचाप से थोड़ा अधिक है। कृपया अगले एक सप्ताह तक प्रतिदिन अपने रक्तचाप की निगरानी करें और उसे लिखकर रखें। यदि आपका रक्तचाप बढ़ता है, तो अपने डॉक्टर से परामर्श करें। आपको पौष्टिक भोजन लेना चाहिए और नियमित रूप से 20 मिनट व्यायाम करना चाहिए। यदि आप देरी करते हैं, तो इससे गंभीर उच्च रक्तचाप हो सकता है।",
      "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "आपका रक्तचाप हल्का अधिक है। उच्च रक्तचाप की दवा शुरू करना या अपनी चल रही दवा को समायोजित करना और नियमित व्यायाम, स्वस्थ आहार और शारीरिक गतिविधि जैसे जीवनशैली में बदलाव करना महत्वपूर्ण है। कृपया अगले एक सप्ताह तक प्रतिदिन अपने रक्तचाप की निगरानी करें और उसे सुरक्षित रखें। यदि रक्तचाप बढ़ता है, तो आपको डॉक्टर से परामर्श करना चाहिए, अन्यथा यह गंभीर उच्च रक्तचाप का कारण बन सकता है।",
      "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "आपका रक्तचाप मध्यम रूप से अधिक है। उच्च रक्तचाप की दवा शुरू करना या अपनी चल रही दवा को समायोजित करना और नियमित व्यायाम, स्वस्थ आहार और शारीरिक गतिविधि जैसे जीवनशैली में बदलाव करना महत्वपूर्ण है। कृपया अगले एक सप्ताह तक प्रतिदिन अपने रक्तचाप की निगरानी करें और उसे सुरक्षित रखें। यदि रक्तचाप बढ़ता है, तो आपको डॉक्टर से परामर्श करना चाहिए, अन्यथा यह गंभीर उच्च रक्तचाप का कारण बन सकता है।",
      "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.": "आपका रक्तचाप बहुत अधिक है। आपको तुरंत अपने डॉक्टर से परामर्श करना चाहिए। आपको उच्च रक्तचाप की दवा शुरू करने या अपनी पिछली दवा को समायोजित करने की आवश्यकता है। कृपया स्वस्थ आहार लें और प्रतिदिन शारीरिक गतिविधि एवं व्यायाम करें। आपको प्रतिदिन अपने रक्तचाप की निगरानी करनी चाहिए और उसे लिखकर रखना चाहिए। यदि आप उपचार में देरी करते हैं, तो इससे हृदय विफलता, स्ट्रोक और गुर्दे की बीमारी हो सकती है।",
      "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.": "आपका रक्तचाप सामान्य है। यदि आप कोई उच्च रक्तचाप की दवा लेते हैं, तो आपको अपनी चल रही दवा जारी रखनी चाहिए। आपको साप्ताहिक रूप से अपने रक्तचाप की निगरानी करनी चाहिए। आपको पौष्टिक भोजन लेना चाहिए, शारीरिक गतिविधि करनी चाहिए और नियमित रूप से व्यायाम करना चाहिए।",
      "Healthy": "स्वस्थ",
      "High Risk": "उच्च जोखिम",
      "NORMAL rate.": "सामान्य दर।",
      "LOW pulse rate. Monitor regularly.": "कम नाड़ी दर। नियमित रूप से निगरानी करें।",
      "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.": "उच्च नाड़ी दर, यह खतरनाक हो सकती है। यदि यह स्थिति बनी रहती है तो कृपया जांच करवाएं।",
      "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.": "सामान्य दर। कृपया नियमित शारीरिक गतिविधि और संतुलित आहार के माध्यम से इस दर को बनाए रखें।"
    },
    "ta_IN": {
      "Normal": "சாதாரணம்",
      "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.": "வாழ்த்துக்கள்! உங்கள் இரத்த அழுத்தம் சாதாரணமாக உள்ளது. வழக்கமான உடற்பயிற்சி மற்றும் சமச்சீர் உணவை உட்கொள்வதன் மூலம் இந்த இரத்த அழுத்தத்தை பராமரிக்கவும். உங்களையும் உங்கள் குடும்பத்தினரையும் ஆரோக்கியமாக வைத்திருங்கள்.",
      "Low": "குறைவு",
      "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "உங்கள் இரத்த அழுத்த அளவு குறைவாக உள்ளது, இது உங்களுக்கு ஆபத்தாக இருக்கலாம். உங்கள் இரத்த அழுத்தத்தை இயல்பான வரம்பிற்குள் வைத்திருக்க, இரத்த அழுத்தத்தை தொடர்ந்து கண்காணிக்கவும், வழக்கமான உடற்பயிற்சி செய்யவும் மற்றும் சமச்சீர் உணவை உட்கொள்ளவும். தேவைப்பட்டால் மருத்துவரை அணுகவும்.",
      "High": "அதிகம்",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.": "உங்கள் இரத்த அழுத்தம் அதிகமாக உள்ளது. எதிர்காலத்தில் உயர் இரத்த அழுத்தம், இதய நோய், பக்கவாதம் மற்றும் நீரிழிவு உள்ளிட்ட சில தீவிர நோய்கள் ஏற்படும் அபாயம் கணிசமாக அதிகரித்துள்ளது. உங்கள் உடல்நிலை குறித்து கவனமாக இருங்கள், BP-ஐ தொடர்ந்து கண்காணிக்கவும், வழக்கமான உடற்பயிற்சி செய்யவும் மற்றும் உங்கள் BP-ஐ கட்டுப்படுத்த சமச்சீர் உணவை உட்கொள்ளவும்.",
      "High Normal": "உயர் சாதாரணம்",
      "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "உங்கள் இரத்த அழுத்த அளவு உயர் சாதாரண நிலையில் உள்ளது, இது சாதாரண இரத்த அழுத்தத்தின் மேல் வரம்பை விட அதிகமாகும். உங்கள் இரத்த அழுத்தத்தை இயல்பான வரம்பிற்குள் வைத்திருக்க, இரத்த அழுத்தத்தை தொடர்ந்து கண்காணிக்கவும், வழக்கமான உடற்பயிற்சி செய்யவும் மற்றும் சமச்சீர் உணவை உட்கொள்ளவும். தேவைப்பட்டால் மருத்துவரை அணுகவும்.",
      "Mild High": "லேசான அதிகம்",
      "Moderate High": "மிதமான அதிகம்",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "உங்கள் இரத்த அழுத்தம் அதிகமாக உள்ளது. எதிர்காலத்தில் உயர் இரத்த அழுத்தம், இதய நோய், பக்கவாதம் மற்றும் நீரிழிவு உள்ளிட்ட சில தீவிர நோய்கள் ஏற்படும் அபாயம் கணிசமாக அதிகரித்துள்ளது. உங்கள் உடல்நிலை குறித்து கவனமாக இருங்கள், BP-ஐ தொடர்ந்து கண்காணிக்கவும், வழக்கமான உடற்பயிற்சி செய்யவும் மற்றும் உங்கள் BP-ஐ கட்டுப்படுத்த சமச்சீர் உணவை உட்கொள்ளவும். மேலதிக சிகிச்சைக்காக மருத்துவரை அணுகி, உங்கள் இரத்த அழுத்தத்தைக் கட்டுப்படுத்த உடனடி நடவடிக்கைகளை எடுக்கவும்.",
      "Severe High": "மிகவும் அதிகம்",
      "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "உங்கள் இரத்த அழுத்தம் மிகவும் அதிகமாக உள்ளது. எதிர்காலத்தில் உயர் இரத்த அழுத்தம், இதய நோய், பக்கவாதம் மற்றும் நீரிழிவு உள்ளிட்ட சில தீவிர நோய்கள் ஏற்படும் அபாயம் கணிசமாக அதிகரித்துள்ளது. உங்கள் உடல்நிலை குறித்து கவனமாக இருங்கள், BP-ஐ தொடர்ந்து கண்காணிக்கவும், வழக்கமான உடற்பயிற்சி செய்யவும் மற்றும் உங்கள் BP-ஐ கட்டுப்படுத்த சமச்சீர் உணவை உட்கொள்ளவும். மேலதிக சிகிச்சைக்காக மருத்துவரை அணுகி, உங்கள் இரத்த அழுத்தத்தைக் கட்டுப்படுத்த உடனடி நடவடிக்கைகளை எடுக்கவும்.",
      "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.": "உங்கள் இரத்த அழுத்தம் இயல்பான வரம்பை விட குறைவாக உள்ளது. நீங்கள் அடிக்கடி உணவு உட்கொள்ள வேண்டும். உங்கள் இரத்த அழுத்தத்தை தினமும் கண்காணித்து பதிவு செய்யவும். இரத்த அழுத்தம் குறைந்தால், நீங்கள் முன்பு எடுத்த உயர் இரத்த அழுத்த மருந்தை நிறுத்திவிட்டு உங்கள் மருத்துவரை அணுக வேண்டும்.",
      "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.": "உங்கள் இரத்த அழுத்தம் உயர் சாதாரண நிலையில் உள்ளது. இது வழக்கமான சாதாரண அழுத்தத்தை விட சற்று அதிகமாகும். அடுத்த ஒரு வாரத்திற்கு தினமும் உங்கள் இரத்த அழுத்தத்தை கண்காணித்து பதிவு செய்யவும். உங்கள் இரத்த அழுத்தம் அதிகரித்தால், மருத்துவரை அணுகவும். சத்தான உணவை உட்கொண்டு தினமும் 20 நிமிடங்கள் தொடர்ந்து உடற்பயிற்சி செய்ய வேண்டும். நீங்கள் தாமதித்தால், இது கடுமையான உயர் இரத்த அழுத்தத்திற்கு வழிவகுக்கலாம்.",
      "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "உங்கள் இரத்த அழுத்தம் லேசாக அதிகமாக உள்ளது. உயர் இரத்த அழுத்த மருந்தைத் தொடங்குவது அல்லது நீங்கள் தொடர்ந்து எடுத்துக்கொண்டிருக்கும் மருந்தைச் சரிசெய்வது மற்றும் வழக்கமான உடற்பயிற்சி, ஆரோக்கியமான உணவு, உடல் உழைப்பு போன்ற வாழ்க்கை முறை மாற்றங்களைச் செய்வது முக்கியம். அடுத்த ஒரு வாரத்திற்கு தினமும் உங்கள் இரத்த அழுத்தத்தை கண்காணித்து பதிவு செய்யவும். இரத்த அழுத்தம் அதிகரித்தால் மருத்துவரை அணுக வேண்டும்; இல்லையெனில் இது கடுமையான உயர் இரத்த அழுத்தத்திற்கு வழிவகுக்கலாம்.",
      "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "உங்கள் இரத்த அழுத்தம் மிதமாக அதிகமாக உள்ளது. உயர் இரத்த அழுத்த மருந்தைத் தொடங்குவது அல்லது நீங்கள் தொடர்ந்து எடுத்துக்கொண்டிருக்கும் மருந்தைச் சரிசெய்வது மற்றும் வழக்கமான உடற்பயிற்சி, ஆரோக்கியமான உணவு, உடல் உழைப்பு போன்ற வாழ்க்கை முறை மாற்றங்களைச் செய்வது முக்கியம். அடுத்த ஒரு வாரத்திற்கு தினமும் உங்கள் இரத்த அழுத்தத்தை கண்காணித்து பதிவு செய்யவும். இரத்த அழுத்தம் அதிகரித்தால் மருத்துவரை அணுக வேண்டும்; இல்லையெனில் இது கடுமையான உயர் இரத்த அழுத்தத்திற்கு வழிவகுக்கலாம்.",
      "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.": "உங்கள் இரத்த அழுத்தம் மிகவும் அதிகமாக உள்ளது. உடனடியாக உங்கள் மருத்துவரை அணுக வேண்டும். உயர் இரத்த அழுத்த மருந்தைத் தொடங்க வேண்டும் அல்லது உங்கள் முந்தைய மருந்தைச் சரிசெய்ய வேண்டும். ஆரோக்கியமான உணவைப் பராமரித்து, தினமும் உடல் உழைப்பு மற்றும் உடற்பயிற்சி செய்யவும். தினமும் உங்கள் இரத்த அழுத்தத்தை கண்காணித்து பதிவு செய்யவும். சிகிச்சையைத் தாமதித்தால் இதய செயலிழப்பு, பக்கவாதம் மற்றும் சிறுநீரக நோய் ஏற்படலாம்.",
      "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.": "உங்கள் இரத்த அழுத்தம் சாதாரணமாக உள்ளது. நீங்கள் ஏதேனும் உயர் இரத்த அழுத்த மருந்தை எடுத்துக்கொண்டிருந்தால், தொடர்ந்து அந்த மருந்தை எடுத்துக்கொள்ள வேண்டும். வாரந்தோறும் உங்கள் இரத்த அழுத்தத்தை கண்காணிக்கவும். சத்தான உணவை உட்கொண்டு, உடல் உழைப்பு மற்றும் உடற்பயிற்சியை தொடர்ந்து செய்யவும்.",
      "Healthy": "ஆரோக்கியமான",
      "High Risk": "அதிக ஆபத்து",
      "NORMAL rate.": "சாதாரண விகிதம்.",
      "LOW pulse rate. Monitor regularly.": "குறைந்த நாடித்துடிப்பு. தொடர்ந்து கண்காணிக்கவும்.",
      "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.": "அதிக நாடித்துடிப்பு, இது ஆபத்தானதாக இருக்கலாம். இந்த நிலை தொடர்ந்தால் தயவுசெய்து பரிசோதனை செய்யவும்.",
      "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.": "சாதாரண விகிதம். வழக்கமான உடல் செயல்பாடு மற்றும் சமச்சீர் உணவு மூலம் இந்த விகிதத்தை பராமரிக்கவும்."
    },
    "te_IN": {
      "Normal": "సాధారణం",
      "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.": "అభినందనలు! మీ రక్తపోటు సాధారణంగా ఉంది. క్రమం తప్పకుండా శారీరక వ్యాయామం చేయడం మరియు సమతుల్య ఆహారం తీసుకోవడం ద్వారా ఈ రక్తపోటును కొనసాగించండి. మిమ్మల్ని మరియు మీ కుటుంబాన్ని ఆరోగ్యంగా ఉంచుకోండి.",
      "Low": "తక్కువ",
      "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "మీ రక్తపోటు తక్కువగా ఉంది, ఇది మీకు ప్రమాదకరంగా ఉండవచ్చు. మీ రక్తపోటును సాధారణ పరిమితుల్లో ఉంచడానికి, క్రమం తప్పకుండా రక్తపోటును పర్యవేక్షించండి, క్రమం తప్పకుండా వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి. అవసరమైతే వైద్యుడిని సంప్రదించండి.",
      "High": "అధికం",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.": "మీ రక్తపోటు అధికంగా ఉంది. భవిష్యత్తులో అధిక రక్తపోటు, గుండె జబ్బులు, స్ట్రోక్ మరియు మధుమేహం వంటి కొన్ని తీవ్రమైన వ్యాధులు వచ్చే ప్రమాదం గణనీయంగా పెరిగింది. దయచేసి మీ ఆరోగ్య పరిస్థితి పట్ల జాగ్రత్తగా ఉండండి, BPని క్రమం తప్పకుండా పర్యవేక్షించండి, క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు BPని నియంత్రించడానికి సమతుల్య ఆహారం తీసుకోండి.",
      "High Normal": "అధిక సాధారణం",
      "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "మీ రక్తపోటు అధిక సాధారణ స్థాయిలో ఉంది, ఇది సాధారణ రక్తపోటు యొక్క గరిష్ఠ పరిమితి కంటే ఎక్కువగా ఉంది. మీ రక్తపోటును సాధారణ పరిమితుల్లో ఉంచడానికి, క్రమం తప్పకుండా రక్తపోటును పర్యవేక్షించండి, క్రమం తప్పకుండా వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి. అవసరమైతే వైద్యుడిని సంప్రదించండి.",
      "Mild High": "స్వల్పంగా అధికం",
      "Moderate High": "మధ్యస్థంగా అధికం",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "మీ రక్తపోటు అధికంగా ఉంది. భవిష్యత్తులో అధిక రక్తపోటు, గుండె జబ్బులు, స్ట్రోక్ మరియు మధుమేహం వంటి కొన్ని తీవ్రమైన వ్యాధులు వచ్చే ప్రమాదం గణనీయంగా పెరిగింది. దయచేసి మీ ఆరోగ్య పరిస్థితి పట్ల జాగ్రత్తగా ఉండండి, BPని క్రమం తప్పకుండా పర్యవేక్షించండి, క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు BPని నియంత్రించడానికి సమతుల్య ఆహారం తీసుకోండి. తదుపరి నిర్వహణ కోసం దయచేసి వైద్యుడిని సంప్రదించి, మీ రక్తపోటును నియంత్రించడానికి వెంటనే చర్యలు తీసుకోండి.",
      "Severe High": "తీవ్రంగా అధికం",
      "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "మీ రక్తపోటు చాలా ఎక్కువగా ఉంది. భవిష్యత్తులో అధిక రక్తపోటు, గుండె జబ్బులు, స్ట్రోక్ మరియు మధుమేహం వంటి కొన్ని తీవ్రమైన వ్యాధులు వచ్చే ప్రమాదం గణనీయంగా పెరిగింది. దయచేసి మీ ఆరోగ్య పరిస్థితి పట్ల జాగ్రత్తగా ఉండండి, BPని క్రమం తప్పకుండా పర్యవేక్షించండి, క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు BPని నియంత్రించడానికి సమతుల్య ఆహారం తీసుకోండి. తదుపరి నిర్వహణ కోసం దయచేసి వైద్యుడిని సంప్రదించి, మీ రక్తపోటును నియంత్రించడానికి వెంటనే చర్యలు తీసుకోండి.",
      "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.": "మీ రక్తపోటు సాధారణ పరిమితి కంటే తక్కువగా ఉంది. మీరు తరచుగా భోజనం చేయాలి. దయచేసి మీ రక్తపోటును ప్రతిరోజూ పర్యవేక్షించి నమోదు చేసుకోండి. రక్తపోటు తగ్గితే, మీరు గతంలో తీసుకుంటున్న రక్తపోటు మందును ఆపి, మీ వైద్యుడిని సంప్రదించాలి.",
      "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.": "మీ రక్తపోటు అధిక సాధారణ స్థాయిలో ఉంది. ఇది సాధారణ రక్తపోటు కంటే కొద్దిగా ఎక్కువగా ఉంది. వచ్చే ఒక వారం పాటు ప్రతిరోజూ మీ రక్తపోటును పర్యవేక్షించి నమోదు చేసుకోండి. మీ రక్తపోటు పెరిగితే, మీ వైద్యుడిని సంప్రదించండి. పోషకాహారం తీసుకుని, క్రమం తప్పకుండా 20 నిమిషాలు వ్యాయామం చేయాలి. మీరు ఆలస్యం చేస్తే, ఇది తీవ్రమైన అధిక రక్తపోటుకు దారితీయవచ్చు.",
      "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "మీ రక్తపోటు స్వల్పంగా అధికంగా ఉంది. రక్తపోటు మందును ప్రారంభించడం లేదా మీరు ప్రస్తుతం తీసుకుంటున్న మందును సర్దుబాటు చేయడం మరియు క్రమం తప్పకుండా వ్యాయామం, ఆరోగ్యకరమైన ఆహారం, శారీరక శ్రమ వంటి జీవనశైలి మార్పులు చేయడం ముఖ్యం. వచ్చే ఒక వారం పాటు ప్రతిరోజూ మీ రక్తపోటును పర్యవేక్షించి నమోదు చేసుకోండి. రక్తపోటు పెరిగితే, మీరు వైద్యుడిని సంప్రదించాలి, లేకపోతే ఇది తీవ్రమైన అధిక రక్తపోటుకు దారితీయవచ్చు.",
      "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "మీ రక్తపోటు మధ్యస్థంగా అధికంగా ఉంది. రక్తపోటు మందును ప్రారంభించడం లేదా మీరు ప్రస్తుతం తీసుకుంటున్న మందును సర్దుబాటు చేయడం మరియు క్రమం తప్పకుండా వ్యాయామం, ఆరోగ్యకరమైన ఆహారం, శారీరక శ్రమ వంటి జీవనశైలి మార్పులు చేయడం ముఖ్యం. వచ్చే ఒక వారం పాటు ప్రతిరోజూ మీ రక్తపోటును పర్యవేక్షించి నమోదు చేసుకోండి. రక్తపోటు పెరిగితే, మీరు వైద్యుడిని సంప్రదించాలి, లేకపోతే ఇది తీవ్రమైన అధిక రక్తపోటుకు దారితీయవచ్చు.",
      "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.": "మీ రక్తపోటు తీవ్రంగా అధికంగా ఉంది. వెంటనే మీ వైద్యుడిని సంప్రదించాలి. మీరు రక్తపోటు తగ్గించే మందును ప్రారంభించాలి లేదా మీ మునుపటి మందును సర్దుబాటు చేయాలి. ఆరోగ్యకరమైన ఆహారం తీసుకుంటూ ప్రతిరోజూ శారీరక శ్రమ మరియు వ్యాయామం చేయండి. మీరు ప్రతిరోజూ మీ రక్తపోటును పర్యవేక్షించి నమోదు చేసుకోవాలి. చికిత్సలో ఆలస్యం చేస్తే, ఇది గుండె వైఫల్యం, స్ట్రోక్ మరియు మూత్రపిండాల వ్యాధికి దారితీయవచ్చు.",
      "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.": "మీ రక్తపోటు సాధారణంగా ఉంది. మీరు ఏదైనా రక్తపోటు మందు తీసుకుంటుంటే, కొనసాగుతున్న మందులను కొనసాగించాలి. మీరు వారానికి ఒకసారి మీ రక్తపోటును పర్యవేక్షించాలి. పోషకాహారం తీసుకుని, శారీరక శ్రమ మరియు వ్యాయామం క్రమం తప్పకుండా చేయాలి.",
      "Healthy": "ఆరోగ్యకరమైన",
      "High Risk": "అధిక ప్రమాదం",
      "NORMAL rate.": "సాధారణ రేటు.",
      "LOW pulse rate. Monitor regularly.": "తక్కువ నాడి రేటు. క్రమం తప్పకుండా పర్యవేక్షించండి.",
      "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.": "అధిక నాడి రేటు, ఇది ప్రమాదకరంగా ఉండవచ్చు. ఈ పరిస్థితి కొనసాగితే దయచేసి పరీక్ష చేయించుకోండి.",
      "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.": "సాధారణ రేటు. క్రమం తప్పకుండా శారీరక కార్యకలాపాలు మరియు సమతుల్య ఆహారం ద్వారా ఈ రేటును కొనసాగించండి."
    },
    "or_IN": {
      "Normal": "ସାଧାରଣ",
      "Congratulations! You have NORMAL Blood Pressure. Please maintain this pressure by regular physical exercise, and eating a balanced diet. Keep yourself and your family healthy.": "ଅଭିନନ୍ଦନ! ଆପଣଙ୍କ ରକ୍ତଚାପ ସାଧାରଣ ଅଛି। ନିୟମିତ ଶାରୀରିକ ବ୍ୟାୟାମ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଇ ଏହି ରକ୍ତଚାପକୁ ବଜାୟ ରଖନ୍ତୁ। ନିଜକୁ ଏବଂ ଆପଣଙ୍କ ପରିବାରକୁ ସୁସ୍ଥ ରଖନ୍ତୁ।",
      "Low": "କମ୍",
      "Your blood pressure measurement is LOW, which may be a risk for you. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "ଆପଣଙ୍କ ରକ୍ତଚାପ କମ୍ ଅଛି, ଯାହା ଆପଣଙ୍କ ପାଇଁ ବିପଦ ହୋଇପାରେ। ଆପଣଙ୍କ ରକ୍ତଚାପକୁ ସାଧାରଣ ସୀମା ମଧ୍ୟରେ ରଖିବା ପାଇଁ ନିୟମିତ ଭାବେ ରକ୍ତଚାପ ମାପନ୍ତୁ, ନିୟମିତ ବ୍ୟାୟାମ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ। ଆବଶ୍ୟକ ହେଲେ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
      "High": "ଅଧିକ",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke, and Diabetes in the future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise, and balanced diet to control your BP.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ଅଧିକ ଅଛି। ଭବିଷ୍ୟତରେ ଉଚ୍ଚ ରକ୍ତଚାପ, ହୃଦ୍‌ରୋଗ, ଷ୍ଟ୍ରୋକ୍ ଏବଂ ମଧୁମେହ ସମେତ କିଛି ଗୁରୁତର ରୋଗ ହେବାର ଆପଣଙ୍କ ବିପଦ ଯଥେଷ୍ଟ ବଢ଼ିଛି। ଦୟାକରି ନିଜ ସ୍ୱାସ୍ଥ୍ୟ ପ୍ରତି ସଚେତନ ରୁହନ୍ତୁ, ନିୟମିତ ଭାବେ BP ମାପନ୍ତୁ, ନିୟମିତ ଶାରୀରିକ ବ୍ୟାୟାମ କରନ୍ତୁ ଏବଂ BP ନିୟନ୍ତ୍ରଣ ପାଇଁ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ।",
      "High Normal": "ଅଧିକ ସାଧାରଣ",
      "Your blood pressure measurement is HIGH NORMAL, which is above the higher limit of normal blood pressure. To keep your blood pressure within normal limits, monitor your blood pressure regularly, do regular exercise and eat a balanced diet. Consult with a doctor, if necessary.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ଅଧିକ ସାଧାରଣ ସ୍ତରରେ ଅଛି, ଯାହା ସାଧାରଣ ରକ୍ତଚାପର ଉଚ୍ଚ ସୀମାଠାରୁ ଅଧିକ। ଆପଣଙ୍କ ରକ୍ତଚାପକୁ ସାଧାରଣ ସୀମା ମଧ୍ୟରେ ରଖିବା ପାଇଁ ନିୟମିତ ଭାବେ ରକ୍ତଚାପ ମାପନ୍ତୁ, ନିୟମିତ ବ୍ୟାୟାମ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ। ଆବଶ୍ୟକ ହେଲେ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
      "Mild High": "ସାମାନ୍ୟ ଅଧିକ",
      "Moderate High": "ମଧ୍ୟମ ଅଧିକ",
      "Your blood pressure is HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ଅଧିକ ଅଛି। ଭବିଷ୍ୟତରେ ଉଚ୍ଚ ରକ୍ତଚାପ, ହୃଦ୍‌ରୋଗ, ଷ୍ଟ୍ରୋକ୍ ଏବଂ ମଧୁମେହ ସମେତ କିଛି ଗୁରୁତର ରୋଗ ହେବାର ଆପଣଙ୍କ ବିପଦ ଯଥେଷ୍ଟ ବଢ଼ିଛି। ଦୟାକରି ନିଜ ସ୍ୱାସ୍ଥ୍ୟ ପ୍ରତି ସଚେତନ ରୁହନ୍ତୁ, ନିୟମିତ ଭାବେ BP ମାପନ୍ତୁ, ନିୟମିତ ଶାରୀରିକ ବ୍ୟାୟାମ କରନ୍ତୁ ଏବଂ BP ନିୟନ୍ତ୍ରଣ ପାଇଁ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ। ଅଧିକ ଚିକିତ୍ସା ପରିଚାଳନା ପାଇଁ ଦୟାକରି ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ ଏବଂ ଆପଣଙ୍କ ରକ୍ତଚାପ ନିୟନ୍ତ୍ରଣ ପାଇଁ ତୁରନ୍ତ ପଦକ୍ଷେପ ନିଅନ୍ତୁ।",
      "Severe High": "ଅତ୍ୟଧିକ ଅଧିକ",
      "Your blood pressure is SEVERELY HIGH. You have a Substantially Increased Risk of developing some serious diseases including Hypertension, Heart Disease, Stroke and Diabetes in future. Please be cautious about your health condition, monitor BP regularly, do regular physical exercise and balanced diet to control your BP. Please consult a doctor for further management and take immidiate steps to control your blood pressure.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ଅତ୍ୟଧିକ ଅଧିକ ଅଛି। ଭବିଷ୍ୟତରେ ଉଚ୍ଚ ରକ୍ତଚାପ, ହୃଦ୍‌ରୋଗ, ଷ୍ଟ୍ରୋକ୍ ଏବଂ ମଧୁମେହ ସମେତ କିଛି ଗୁରୁତର ରୋଗ ହେବାର ଆପଣଙ୍କ ବିପଦ ଯଥେଷ୍ଟ ବଢ଼ିଛି। ଦୟାକରି ନିଜ ସ୍ୱାସ୍ଥ୍ୟ ପ୍ରତି ସଚେତନ ରୁହନ୍ତୁ, ନିୟମିତ ଭାବେ BP ମାପନ୍ତୁ, ନିୟମିତ ଶାରୀରିକ ବ୍ୟାୟାମ କରନ୍ତୁ ଏବଂ BP ନିୟନ୍ତ୍ରଣ ପାଇଁ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ। ଅଧିକ ଚିକିତ୍ସା ପରିଚାଳନା ପାଇଁ ଦୟାକରି ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ ଏବଂ ଆପଣଙ୍କ ରକ୍ତଚାପ ନିୟନ୍ତ୍ରଣ ପାଇଁ ତୁରନ୍ତ ପଦକ୍ଷେପ ନିଅନ୍ତୁ।",
      "Your blood pressure is lower than normal limit. You should take meal frequently. Please monitor your pressure daily & write it down. If pressure falls, you should stop your previous antihypertensive drug & consult with your doctor.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ସାଧାରଣ ସୀମାଠାରୁ କମ୍ ଅଛି। ଆପଣ ବାରମ୍ବାର ଖାଦ୍ୟ ଖାଇବା ଉଚିତ। ଦୟାକରି ପ୍ରତିଦିନ ଆପଣଙ୍କ ରକ୍ତଚାପ ମାପି ଲେଖି ରଖନ୍ତୁ। ଯଦି ରକ୍ତଚାପ କମିଯାଏ, ତେବେ ଆପଣ ପୂର୍ବରୁ ନେଉଥିବା ଉଚ୍ଚ ରକ୍ତଚାପର ଔଷଧ ବନ୍ଦ କରି ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରିବା ଉଚିତ।",
      "Your blood pressure is high normal. It is slightly higher than usual normal pressure. Please monitor your pressure daily for next one week & write it down. If your pressure rises,consult your doctor. You should take nutritious food & do exercise for 20 minutes regularly. If you delay, it may lead to severe blood pressure.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ଅଧିକ ସାଧାରଣ ସ୍ତରରେ ଅଛି। ଏହା ସାଧାରଣ ରକ୍ତଚାପଠାରୁ ସାମାନ୍ୟ ଅଧିକ। ଦୟାକରି ପରବର୍ତ୍ତୀ ଏକ ସପ୍ତାହ ପାଇଁ ପ୍ରତିଦିନ ଆପଣଙ୍କ ରକ୍ତଚାପ ମାପି ଲେଖି ରଖନ୍ତୁ। ଯଦି ଆପଣଙ୍କ ରକ୍ତଚାପ ବଢ଼େ, ତେବେ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ଆପଣ ପୌଷ୍ଟିକ ଖାଦ୍ୟ ଖାଇବା ସହିତ ନିୟମିତ ଭାବେ ୨୦ ମିନିଟ୍ ବ୍ୟାୟାମ କରିବା ଉଚିତ। ଯଦି ଆପଣ ବିଳମ୍ବ କରନ୍ତି, ତେବେ ଏହା ଗୁରୁତର ଉଚ୍ଚ ରକ୍ତଚାପକୁ ନେଇଯାଇପାରେ।",
      "Your blood pressure is mild high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ସାମାନ୍ୟ ଅଧିକ ଅଛି। ଉଚ୍ଚ ରକ୍ତଚାପର ଔଷଧ ଆରମ୍ଭ କରିବା କିମ୍ବା ଆପଣଙ୍କ ଚାଲୁଥିବା ଔଷଧକୁ ସମଯୋଜନ କରିବା ଏବଂ ନିୟମିତ ବ୍ୟାୟାମ, ସ୍ୱାସ୍ଥ୍ୟକର ଖାଦ୍ୟ ଓ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ ଭଳି ଜୀବନଶୈଳୀରେ ପରିବର୍ତ୍ତନ କରିବା ଗୁରୁତ୍ୱପୂର୍ଣ୍ଣ। ପରବର୍ତ୍ତୀ ଏକ ସପ୍ତାହ ପାଇଁ ପ୍ରତିଦିନ ଆପଣଙ୍କ ରକ୍ତଚାପ ମାପି ସଂରକ୍ଷଣ କରନ୍ତୁ। ଯଦି ରକ୍ତଚାପ ବଢ଼େ, ତେବେ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ, ନଚେତ ଏହା ଗୁରୁତର ଉଚ୍ଚ ରକ୍ତଚାପକୁ ନେଇଯାଇପାରେ।",
      "Your blood pressure is moderately high. It is important to start antihypertensive drug/ adjust your ongoing medication and make lifestyle changes like regular exercise, healthy diet, physical work. Please monitor your pressure next one week daily & store it. If pressure rises, you should consult with a doctor, otherwise it may lead to severe high pressure.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ମଧ୍ୟମ ଭାବରେ ଅଧିକ ଅଛି। ଉଚ୍ଚ ରକ୍ତଚାପର ଔଷଧ ଆରମ୍ଭ କରିବା କିମ୍ବା ଆପଣଙ୍କ ଚାଲୁଥିବା ଔଷଧକୁ ସମଯୋଜନ କରିବା ଏବଂ ନିୟମିତ ବ୍ୟାୟାମ, ସ୍ୱାସ୍ଥ୍ୟକର ଖାଦ୍ୟ ଓ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ ଭଳି ଜୀବନଶୈଳୀରେ ପରିବର୍ତ୍ତନ କରିବା ଗୁରୁତ୍ୱପୂର୍ଣ୍ଣ। ପରବର୍ତ୍ତୀ ଏକ ସପ୍ତାହ ପାଇଁ ପ୍ରତିଦିନ ଆପଣଙ୍କ ରକ୍ତଚାପ ମାପି ସଂରକ୍ଷଣ କରନ୍ତୁ। ଯଦି ରକ୍ତଚାପ ବଢ଼େ, ତେବେ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ, ନଚେତ ଏହା ଗୁରୁତର ଉଚ୍ଚ ରକ୍ତଚାପକୁ ନେଇଯାଇପାରେ।",
      "Your blood pressure is severely high. Immediately you should consult with your physician. You need to start anti hypertensive dru or adjust your previous medication. Please maintain a healthy diet & do physical work & exercise daily. You should monitor your pressure daily & write it down. If you delay your treatment, it may lead to heart failure, stroke, kidney disease.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ଅତ୍ୟଧିକ ଅଧିକ ଅଛି। ତୁରନ୍ତ ଆପଣଙ୍କ ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ଆପଣଙ୍କୁ ଉଚ୍ଚ ରକ୍ତଚାପର ଔଷଧ ଆରମ୍ଭ କରିବା କିମ୍ବା ପୂର୍ବରୁ ନେଉଥିବା ଔଷଧକୁ ସମଯୋଜନ କରିବା ଆବଶ୍ୟକ। ସ୍ୱାସ୍ଥ୍ୟକର ଖାଦ୍ୟ ଖାଆନ୍ତୁ ଏବଂ ପ୍ରତିଦିନ ଶାରୀରିକ କାର୍ଯ୍ୟ ଓ ବ୍ୟାୟାମ କରନ୍ତୁ। ଆପଣ ପ୍ରତିଦିନ ରକ୍ତଚାପ ମାପି ଲେଖି ରଖିବା ଉଚିତ। ଚିକିତ୍ସାରେ ବିଳମ୍ବ କଲେ ଏହା ହୃଦ୍‌ପିଣ୍ଡ ବିଫଳତା, ଷ୍ଟ୍ରୋକ୍ ଏବଂ ବୃକ୍କ ରୋଗର କାରଣ ହୋଇପାରେ।",
      "Your blood pressure is normal. You should continue your ongoing medication if you took any antihypertensive.You should monitor your pressure weekly.You should eat nutritious food, do physical work & exercise reguarly.": "ଆପଣଙ୍କ ରକ୍ତଚାପ ସାଧାରଣ ଅଛି। ଯଦି ଆପଣ କୌଣସି ଉଚ୍ଚ ରକ୍ତଚାପର ଔଷଧ ନେଉଥିଲେ, ତେବେ ଚାଲୁଥିବା ଔଷଧ ଜାରି ରଖନ୍ତୁ। ଆପଣ ସାପ୍ତାହିକ ଭାବେ ରକ୍ତଚାପ ମାପିବା ଉଚିତ। ପୌଷ୍ଟିକ ଖାଦ୍ୟ ଖାଆନ୍ତୁ, ଶାରୀରିକ କାର୍ଯ୍ୟ କରନ୍ତୁ ଏବଂ ନିୟମିତ ଭାବେ ବ୍ୟାୟାମ କରନ୍ତୁ।",
      "Healthy": "ସୁସ୍ଥ",
      "High Risk": "ଅଧିକ ବିପଦ",
      "NORMAL rate.": "ସାଧାରଣ ହାର।",
      "LOW pulse rate. Monitor regularly.": "କମ୍ ନାଡ଼ି ହାର। ନିୟମିତ ଭାବେ ନିରୀକ୍ଷଣ କରନ୍ତୁ।",
      "HIGH pulse rate, it can be dangerous. Please evaluate if this condition continue.": "ଅଧିକ ନାଡ଼ି ହାର, ଏହା ବିପଦଜନକ ହୋଇପାରେ। ଯଦି ଏହି ସ୍ଥିତି ଜାରି ରହେ, ଦୟାକରି ପରୀକ୍ଷା କରାନ୍ତୁ।",
      "NORMAL rate. Please maintain this rate by regular physical activity and balanced diet.": "ସାଧାରଣ ହାର। ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ମାଧ୍ୟମରେ ଏହି ହାରକୁ ବଜାୟ ରଖନ୍ତୁ।"
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
    Get.put(BpInputLogic(repository: Get.find<ScreeningReportRepository>()));
  }
  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<BpInputLogic>().isThemeV2) {
      return v2 ?? v1;
    }
    return v1;
  }

}
