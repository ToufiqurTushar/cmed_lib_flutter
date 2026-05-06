
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
    Get.put(WfaInputLogic(repository: Get.find<ScreeningReportRepository>(), profileRepository:  Get.find<ProfileRepository>()));
  }
}
