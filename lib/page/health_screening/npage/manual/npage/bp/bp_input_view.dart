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


class BpInputView extends RapidView<BpInputLogic> {
  static String routeName = '/bp_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
}
