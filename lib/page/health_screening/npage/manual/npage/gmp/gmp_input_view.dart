
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
    final wfa = {"en_US":{"Severe Underweight":"Severe Underweight","High Risk":"High Risk","Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":"Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.","Moderate Underweight":"Moderate Underweight","Moderate Risk":"Moderate Risk","Your child is moderately underweight according to age, please consult with doctor for evaluation.":"Your child is moderately underweight according to age, please consult with doctor for evaluation.","Mild Underweight":"Mild Underweight","Low Risk":"Low Risk","Your child has mild underweight according to age, please consult doctor for evaluation.":"Your child has mild underweight according to age, please consult doctor for evaluation.","Normal":"Normal","Healthy":"Healthy","Your child is well nourished, please continue balanced diet as usual.":"Your child is well nourished, please continue balanced diet as usual.","Overweight":"Overweight","You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":"You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life."},"bn_BD":{"Severe Underweight":"মারাত্মক কম ওজন","High Risk":"বেশি ঝুঁকি সম্পন্ন","Your child is severely underweight according to age, please consult with doctor or visit nearby hospital immediately.":"আপনার শিশুর  ওজন বয়স অনুযায়ী  অনেক কম, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন।","Moderate Underweight":"মাঝারি কম ওজন","Moderate Risk":"ঝুঁকি সম্পন্ন","Your child is moderately underweight according to age, please consult with doctor for evaluation.":"আপনার শিশুর ওজন বয়স অনুযায়ী স্বাভাবিকের চেয়ে মাঝারি কম।এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |","Mild Underweight":"স্বল্প কম ওজন","Low Risk":"স্বল্প ঝুঁকি সম্পন্ন","Your child has mild underweight according to age, please consult doctor for evaluation.":"আপনার শিশুর ওজন বয়স অনুযায়ী  স্বাভাবিকের চেয়ে কম, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |","Normal":"স্বাভাবিক","Healthy":"ঝুঁকিমুক্ত","Your child is well nourished, please continue balanced diet as usual.":"বয়স অনুযায়ী আপনার শিশু স্বাভাবিক পুষ্টিমাত্রা সম্পন্ন, শিশুকে সুষম খাবার প্রদানের মাধ্যমে এই মাত্রা বজায় রাখুন।","Overweight":"বেশি ওজন","You are child is overweight according to age. Please consult with nutritionist or physician for weight reduction. You have to control to give oily & fatty food (fast food or fried food items) to your child. and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":"বয়স অনুযায়ী আপনার শিশুর ওজন স্বাভাবিকের চেয়ে বেশি। ওজন কমাতে  চিকিৎসক বা পুষ্টিবিদের পরামর্শ নিন । পাশাপাশি অতিরিক্ত তৈলাক্ত ও চর্বিযুক্ত (ফাস্ট ফুড/ভাজা পোড়া) খাবার পরিহার করুন । প্রতিদিন কমপক্ষে এক ঘন্টা নিয়মিত শারীরিক কর্মকান্ড (খেলাধুলা) করুন | অন্যথায় স্থূলতার কারণে ভবিষ্যত আপনার বাচ্চার উচ্চ রক্তচাপ এবং ডায়াবেটিস হতে পারে |"},"kn_IN":{"Severe Underweight":"ತೀವ್ರ ಕಡಿಮೆ ತೂಕ","Moderate Underweight":"ಮಧ್ಯಮ ಕಡಿಮೆ ತೂಕ","Mild Underweight":"ಕಡಿಮೆ ತೂಕ","Normal":"ಸಾಮಾನ್ಯ","Overweight":"ಅಧಿಕ ತೂಕ"}};
    final hfa = {"en_US":{"Severe Stunting":"Severe Stunting","High Risk":"High Risk","Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":"Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.","Moderate Stunting":"Moderate Stunting","Moderate Risk":"Moderate Risk","Your child is moderately stunted comparing to age, please consult doctor for evaluation.":"Your child is moderately stunted comparing to age, please consult doctor for evaluation.","Mild Stunting":"Mild Stunting","Low Risk":"Low Risk","Your child has mild stunting comparing to age, please consult doctor for evaluation.":"Your child has mild stunting comparing to age, please consult doctor for evaluation.","Normal":"Normal","Healthy":"Healthy","Normal Height":"Normal Height","Tall":"Tall","Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":"Your child is more  tall comparing to age.  Please consult with nutritionist or physician.","Your child is more tall comparing to age.  Please consult with nutritionist or physician.":"Your child is more tall comparing to age.  Please consult with nutritionist or physician.","Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":"Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.","Your child is moderately stunted, please consult doctor for evaluation.":"Your child is moderately stunted, please consult doctor for evaluation.","Your child has mild stunting, please consult doctor for evaluation.":"Your child has mild stunting, please consult doctor for evaluation.","Your child is more tall. Please consult with nutritionist or physician for weight reduction.":"Your child is more tall. Please consult with nutritionist or physician for weight reduction."},"bn_BD":{"Severe Stunting":"মারাত্মক খর্ব","Your child is severely stunted comparing to age, please consult with doctor or visit nearby hospital immediately.":"আপনার শিশু বয়সের তুলনায় মারাত্মক খর্ব, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন।","Moderate Stunting":"মাঝারি খর্ব","Your child is moderately stunted comparing to age, please consult doctor for evaluation.":"আপনার শিশু বয়সের তুলনায় মাঝারি খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |","Mild Stunting":"স্বল্প খর্ব","Your child has mild stunting comparing to age, please consult doctor for evaluation.":"আপনার শিশু বয়সের তুলনায় স্বল্প খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |","Normal":"স্বাভাবিক","Normal Height":"আপনার শিশুর উচ্চতা স্বাভাবিক |","Tall":"বেশি লম্বা","Your child is more  tall comparing to age.  Please consult with nutritionist or physician.":"আপনার শিশু বয়সের তুলনায় স্বাভাবিকের চেয়ে লম্বা। কারণ জানতে চিকিৎসকের পরামর্শ নিন ।","Your child is more tall comparing to age.  Please consult with nutritionist or physician.":"আপনার শিশু বয়সের তুলনায় স্বাভাবিকের চেয়ে লম্বা। কারণ জানতে চিকিৎসকের পরামর্শ নিন ।","Your child is severely stunted, please consult with doctor or visit nearby hospital immediately.":"আপনার শিশু বয়সের তুলনায় মারাত্মক খর্ব, দ্রুত চিকিৎসকের পরামর্শ নিন বা নিকটস্থ স্বাস্থ্য কেন্দ্রে যোগাযোগ করুন।","Your child is moderately stunted, please consult doctor for evaluation.":"আপনার শিশু বয়সের তুলনায় মাঝারি খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |","Your child has mild stunting, please consult doctor for evaluation.":"আপনার শিশু বয়সের তুলনায় স্বল্প খর্ব, এ ব্যাপারে চিকিৎসকের পরামর্শ নিন |","Your child is more tall. Please consult with nutritionist or physician for weight reduction.":"আপনার শিশু বয়সের তুলনায় স্বাভাবিকের চেয়ে লম্বা। কারণ জানতে চিকিৎসকের পরামর্শ নিন ।"},"kn_IN":{"Severe Stunting":"ತೀವ್ರ ಕುಂಠಿತ","High Risk":"ಹೆಚ್ಚಿನ ಅಪಾಯ","Moderate Stunting":"ಮಧ್ಯಮ ಕುಂಠಿತ","Moderate Risk":"ಮಧ್ಯಮ ಅಪಾಯ","Mild Stunting":"ಸ್ವಲ್ಪ ಕುಂಠಿತ ಬೆಳವಣಿಗೆ","Low Risk":"ಕಡಿಮೆ ಅಪಾಯ","Normal":"ಸಾಮಾನ್ಯ","Healthy":"ಆರೋಗ್ಯಕರ","Tall":"ಎತ್ತರ"}};
    final wfl = {"en_US":{"Severely Wasted":"Severely Wasted","Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":"Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.","Moderately Wasted":"Moderately Wasted","Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":"Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.","Normal":"Normal","Your child is well nourished compare to height, please continue balanced diet as usual.":"Your child is well nourished compare to height, please continue balanced diet as usual.","Overweight":"Overweight","Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":"Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.","Obesity":"Obesity","You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":"You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.","Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":"Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication."},"bn_BD":{"Severely Wasted":"মারাত্মক তীব্র অপুষ্টি","Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.":"আপনার বাচ্চা উচ্চতা অনুযায়ী মারাত্মক তীব্র অপুষ্টি তে আক্রান্ত। অতি দ্রুত তার চিকিৎসা প্রয়োজন। তাকে যত দ্রুত সম্ভব নিকটস্থ স্বাস্থ্যকেন্দ্রে নিয়ে যান।","Moderately Wasted":"মাঝারি তীব্র অপুষ্টি","Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.":"আপনার বাচ্চা উচ্চতা অনুযায়ী মাঝারি তীব্র অপুষ্টীজনিত রোগে আক্রান্ত। যত দ্রুত সম্ভব তার পুষ্টীর অভাব পুরণের জন্য নিকটস্থ সাস্থ্যকেন্দ্রে নেয়া উত্তম।","Normal":"স্বাভাবিক","Your child is well nourished compare to height, please continue balanced diet as usual.":"উচ্চতা অনুযায়ী আপনার শিশু স্বাভাবিক পুষ্টিমাত্রা সম্পন্ন, শিশুকে সুষম খাবার প্রদানের মাধ্যমে এই মাত্রা বজায় রাখুন।","Overweight":"বেশি ওজন","Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.":"আপনার বাচ্চার ওজন, উচ্চতার  তুলনায় বেশি । জটিলতা এড়ানোর জন্য খাদ্যাভ্যাস পরিবর্তন এবং শারিরিক ব্যায়াম প্রয়োজন।","Obesity":"স্থূলতা","You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.":"আপনার শিশুর ওজন উচ্চতার  তুলনায়  অনেক বেশি। ওজন কমাতে দ্রুত চিকিৎসক বা পুষ্টিবিদের পরামর্শ নিন । পাশাপাশি অতিরিক্ত তৈলাক্ত ও চর্বিযুক্ত (ফাস্ট ফুড/ভাজা পোড়া) খাবার পরিহার করুন । প্রতিদিন কমপক্ষে এক ঘন্টা নিয়মিত শারীরিক কর্মকান্ড (খেলাধুলা) করুন | অন্যথায় স্থূলতার কারণে ভবিষ্যত আপনার বাচ্চার উচ্চ রক্তচাপ এবং ডায়াবেটিস হতে পারে |","Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.":"আপনার বাচ্চার ওজন, উচ্চতার  তুলনায় বেশি । জটিলতা এড়ানোর জন্য খাদ্যাভ্যাস পরিবর্তন এবং শারিরিক ব্যায়াম প্রয়োজন।"},"kn_IN":{"Severely Wasted":"ತೀವ್ರವಾಗಿ ವ್ಯರ್ಥವಾಯಿತು","Moderately Wasted":"ಸಾಧಾರಣವಾಗಿ ವ್ಯರ್ಥವಾಗಿದೆ","Normal":"ಸಾಮಾನ್ಯ","Overweight":"ಅಧಿಕ ತೂಕ","Obesity":"ಬೊಜ್ಜು"}};

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
