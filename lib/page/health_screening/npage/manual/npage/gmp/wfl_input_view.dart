
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/gmp/wfl_input_logic.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';

import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import '../../../../../../common/widget/basic_app_bar.dart';
import '../../../../../../common/widget/cmed_birth_date_picker.dart';
import '../../../../../user_management/repository/profile_repository.dart';

class WflInputView extends RapidView<WflInputLogic> {
  static String routeName = '/wfl_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BasicAppBar('label_wfl'.tr),
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
                            /*Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                'label_select_date'.tr,
                                style: CMEDTextUtils.inputTextLabelStyle,
                              ),
                            ),
                            */
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
        "Severely Wasted": "Severely Wasted",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.": "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.",
        "Moderately Wasted": "Moderately Wasted",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.": "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.",
        "Normal": "Normal",
        "Your child is well nourished compare to height, please continue balanced diet as usual.": "Your child is well nourished compare to height, please continue balanced diet as usual.",
        "Overweight": "Overweight",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.": "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.",
        "Obesity": "Obesity",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.": "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.": "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication."
      },
      "bn_BD": {
        "Severely Wasted": "মারাত্মক তীব্র অপুষ্টি",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.": "আপনার বাচ্চা উচ্চতা অনুযায়ী মারাত্মক তীব্র অপুষ্টি তে আক্রান্ত। অতি দ্রুত তার চিকিৎসা প্রয়োজন। তাকে যত দ্রুত সম্ভব নিকটস্থ স্বাস্থ্যকেন্দ্রে নিয়ে যান।",
        "Moderately Wasted": "মাঝারি তীব্র অপুষ্টি",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.": "আপনার বাচ্চা উচ্চতা অনুযায়ী মাঝারি তীব্র অপুষ্টীজনিত রোগে আক্রান্ত। যত দ্রুত সম্ভব তার পুষ্টীর অভাব পুরণের জন্য নিকটস্থ সাস্থ্যকেন্দ্রে নেয়া উত্তম।",
        "Normal": "স্বাভাবিক",
        "Your child is well nourished compare to height, please continue balanced diet as usual.": "উচ্চতা অনুযায়ী আপনার শিশু স্বাভাবিক পুষ্টিমাত্রা সম্পন্ন, শিশুকে সুষম খাবার প্রদানের মাধ্যমে এই মাত্রা বজায় রাখুন।",
        "Overweight": "অতিরিক্ত ওজন",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.": "আপনার বাচ্চার ওজন, উচ্চতার  তুলনায় বেশি । জটিলতা এড়ানোর জন্য খাদ্যাভ্যাস পরিবর্তন এবং শারিরিক ব্যায়াম প্রয়োজন।",
        "Obesity": "স্থূলতা",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.": "আপনার শিশুর ওজন উচ্চতার  তুলনায়  অনেক বেশি। ওজন কমাতে দ্রুত চিকিৎসক বা পুষ্টিবিদের পরামর্শ নিন । পাশাপাশি অতিরিক্ত তৈলাক্ত ও চর্বিযুক্ত (ফাস্ট ফুড/ভাজা পোড়া) খাবার পরিহার করুন । প্রতিদিন কমপক্ষে এক ঘন্টা নিয়মিত শারীরিক কর্মকান্ড (খেলাধুলা) করুন | অন্যথায় স্থূলতার কারণে ভবিষ্যত আপনার বাচ্চার উচ্চ রক্তচাপ এবং ডায়াবেটিস হতে পারে |",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.": "আপনার বাচ্চার ওজন, উচ্চতার  তুলনায় বেশি । জটিলতা এড়ানোর জন্য খাদ্যাভ্যাস পরিবর্তন এবং শারিরিক ব্যায়াম প্রয়োজন।"
      },
      "kn_IN": {
        "Severely Wasted": "ತೀವ್ರವಾಗಿ ವ್ಯರ್ಥವಾಯಿತು",
        "Your child is severely malnourished compare to height. He/She needs urgent medical attention. Take your child to the nearest health center as soon as possible.": "ನಿಮ್ಮ ಮಗುವಿಗೆ ಎತ್ತರಕ್ಕೆ ಹೋಲಿಸಿದರೆ ತೀವ್ರ ಅಪೌಷ್ಟಿಕತೆ ಇದೆ. ಅವನಿಗೆ/ಆಕೆಗೆ ತುರ್ತು ವೈದ್ಯಕೀಯ ಆರೈಕೆಯ ಅಗತ್ಯವಿದೆ. ಸಾಧ್ಯವಾದಷ್ಟು ಬೇಗ ನಿಮ್ಮ ಮಗುವನ್ನು ಹತ್ತಿರದ ಆರೋಗ್ಯ ಕೇಂದ್ರಕ್ಕೆ ಕರೆದೊಯ್ಯಿರಿ.",
        "Moderately Wasted": "ಮಧ್ಯಮವಾಗಿ ವ್ಯರ್ಥವಾಗಿದೆ",
        "Your child is moderately malnourished compare to height and has been affected by nutritional deficiencies. Take him to the nearest health center as soon as possible.": "ನಿಮ್ಮ ಮಗುವಿನ ಎತ್ತರಕ್ಕೆ ಹೋಲಿಸಿದರೆ ಮಧ್ಯಮ ಅಪೌಷ್ಟಿಕತೆ ಇದೆ ಮತ್ತು ಪೌಷ್ಟಿಕಾಂಶದ ಕೊರತೆಯಿಂದ ಬಳಲುತ್ತಿದೆ. ಸಾಧ್ಯವಾದಷ್ಟು ಬೇಗ ಅವನನ್ನು ಹತ್ತಿರದ ಆರೋಗ್ಯ ಕೇಂದ್ರಕ್ಕೆ ಕರೆದೊಯ್ಯಿರಿ.",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Your child is well nourished compare to height, please continue balanced diet as usual.": "ನಿಮ್ಮ ಮಗುವಿನ ಎತ್ತರಕ್ಕೆ ಹೋಲಿಸಿದರೆ ಉತ್ತಮ ಪೋಷಣೆ ಇದೆ, ದಯವಿಟ್ಟು ಎಂದಿನಂತೆ ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಮುಂದುವರಿಸಿ.",
        "Overweight": "ಅಧಿಕ ತೂಕ",
        "Your child is overweight.Dietary changes and physical exercise are necessary to prevent further complication.": "ನಿಮ್ಮ ಮಗುವು ಅಧಿಕ ತೂಕ ಹೊಂದಿದೆ. ಹೆಚ್ಚಿನ ತೊಡಕುಗಳನ್ನು ತಡೆಗಟ್ಟಲು ಆಹಾರಕ್ರಮದಲ್ಲಿ ಬದಲಾವಣೆಗಳು ಮತ್ತು ದೈಹಿಕ ವ್ಯಾಯಾಮ ಅಗತ್ಯ.",
        "Obesity": "ಬೊಜ್ಜು",
        "You are child is obese compare to height. Please consult with nutritionist or physician for weight reduction.You have to control giving oily & fatty food (fast food or fried food items) to your child and your child need to do regular physical activity (playing) at least one hour daily.  Otherwise excess weight can cause several disease conditions like hypertension, diabetes in future adult life.": "ನಿಮ್ಮ ಮಗು ಎತ್ತರಕ್ಕೆ ಹೋಲಿಸಿದರೆ ಬೊಜ್ಜು ಹೊಂದಿದೆ. ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ. ನಿಮ್ಮ ಮಗುವಿಗೆ ಎಣ್ಣೆಯುಕ್ತ ಮತ್ತು ಕೊಬ್ಬಿನ ಆಹಾರವನ್ನು (ಫಾಸ್ಟ್ ಫುಡ್ ಅಥವಾ ಕರಿದ ಆಹಾರ ಪದಾರ್ಥಗಳು) ನೀಡುವುದನ್ನು ನೀವು ನಿಯಂತ್ರಿಸಬೇಕು ಮತ್ತು ನಿಮ್ಮ ಮಗು ದಿನಕ್ಕೆ ಕನಿಷ್ಠ ಒಂದು ಗಂಟೆಯಾದರೂ ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆ (ಆಟವಾಡುವುದು) ಮಾಡಬೇಕು. ಇಲ್ಲದಿದ್ದರೆ ಅಧಿಕ ತೂಕವು ಭವಿಷ್ಯದಲ್ಲಿ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಮಧುಮೇಹದಂತಹ ಹಲವಾರು ರೋಗಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು.",
        "Your child is overweight compare to height. Dietary changes and physical exercise are necessary to prevent further complication.": "ನಿಮ್ಮ ಮಗುವಿನ ಎತ್ತರಕ್ಕೆ ಹೋಲಿಸಿದರೆ ಅಧಿಕ ತೂಕವಿದೆ. ಹೆಚ್ಚಿನ ತೊಡಕುಗಳನ್ನು ತಡೆಗಟ್ಟಲು ಆಹಾರ ಪದ್ಧತಿಯಲ್ಲಿ ಬದಲಾವಣೆ ಮತ್ತು ದೈಹಿಕ ವ್ಯಾಯಾಮ ಅಗತ್ಯ."
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
    Get.put(WflInputLogic(repository: Get.find<ScreeningReportRepository>(), profileRepository:  Get.find<ProfileRepository>()));
  }
}
