import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/measurement_view_arg.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bmi/bmi_height_input_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto_manual_selection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bmi/bmi_height_weight_input_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:themed/themed.dart';

import 'package:cmed_lib_flutter/common/helper/text_utils.dart';

import '../../../auto/npage/bmi/bmi_device_connection_view.dart';

class BmiHeightInputView extends RapidView<BmiHeightInputLogic> {
  static String routeName = '/bmi_height_input_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controller.isNestedRoute? null: BasicAppBar(
        'label_bmi'.tr,
      ),
      body: SafeArea(
        child: Form(
          key: controller.screeningReportFormKey,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                                                  BmiUnit.FEET_INCH.name
                                              ? 'title_measurement_in_feet_inch'
                                                  .tr
                                              : 'title_measurement_centimeter'
                                                  .tr,
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
                                        {controller.toggleHeightUnit()},
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
                                    BmiUnit.CENTIMETER.name,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Text(
                                        'input_label_input_height_cm'.tr,
                                        style:
                                            CMEDTextUtils.inputTextLabelStyle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    CMEDTextField('input_hint_cm'.tr,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        textEditingController: controller
                                            .heightInCentimeterEditTextController,
                                        onSaved: (value) {},
                                        onValidator: (value) {
                                      return controller
                                          .validateHeightInCentimeter(value!);
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Obx(() => Visibility(
                                visible: controller.heightUnit.value ==
                                    BmiUnit.FEET_INCH.name,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                                'label_input_height_feet'.tr,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                                'label_input_height_inch'.tr,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: CMEDTextField(
                                              'input_label_hint_height_feet'.tr,
                                              keyboardType:
                                                  TextInputType.number,
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
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,2}'))
                                              ],
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
                                          () {
                                            if (controller.isValidInput()){
                                              if(AppUidConfig.isCmedAgentApp || AppUidConfig.isI4WeAgentApp){
                                                Get.toNamed(AutoManualSelectionView.routeName, arguments: {
                                                  "codeId": MeasurementType.BMI.value,
                                                  "heightUnit": controller.heightUnit.value,
                                                  "heightInCm": controller.getHeightInCentimeter(),
                                                  "heightInFeet": controller.heightInFeetEditTextController.text,
                                                  "heightInInch": controller.heightInInchEditTextController.text
                                                },);
                                              } else if(AppUidConfig.isCmedUserApp || AppUidConfig.isI4WeMemberApp) {
                                                bool isAuto = Get.arguments != null? Get.arguments['isAuto']??false: false;
                                                if(isAuto){
                                                  Get.offNamed(BmiDeviceConnectionView.routeName, arguments: MeasurementViewArg(
                                                      isAuto: isAuto,
                                                      heightUnit: controller.heightUnit.value,
                                                      heightInCm: controller.getHeightInCentimeter().toDouble(),
                                                      heightInFeet: controller.heightInFeetEditTextController.text,
                                                      heightInInch: controller.heightInInchEditTextController.text
                                                  ), id: controller.isNestedRoute? 1: null);
                                                } else {
                                                  Get.offNamed(BmiHeightWeightInputView.routeName, arguments:
                                                    MeasurementViewArg(
                                                      isAuto: isAuto,
                                                      heightUnit: controller.heightUnit.value,
                                                      heightInCm: controller.getHeightInCentimeter().toDouble(),
                                                      heightInFeet: controller.heightInFeetEditTextController.text,
                                                      heightInInch: controller.heightInInchEditTextController.text
                                                    ), id: controller.isNestedRoute? 1: null
                                                  );
                                                }
                                                
                                              }
                                            }

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {
      "en_US": {
        "Underweight": "Underweight",
        "At Risk": "At Risk",
        "Your are UNDERWEIGHT, please consult with physician or nutritionist.": "Your are UNDERWEIGHT, please consult with physician or nutritionist.",
        "Normal": "Normal",
        "Healthy": "Healthy",
        "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.": "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.",
        "Overweight": "Overweight",
        "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.",
        "Obesity": "Obesity",
        "High Risk": "High Risk",
        "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.": "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.",
        "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.": "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.",
        "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.": "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.",
        "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.",
        "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.": "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.",
        "Highly Obesity": "Highly Obesity",
        "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.": "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.",
        "Morbid Obesity": "Morbid Obesity",
        "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction.": "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction."
      },
      "bn_BD": {
        "Underweight": "কম ওজন",
        "At Risk": "ঝুঁকি সম্পন্ন",
        "Your are UNDERWEIGHT, please consult with physician or nutritionist.": "বি এম আই অনুযায়ী আপনার ওজন স্বাভাবিকের থেকে কম, অনুগ্রহ পূর্বক চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।",
        "Normal": "স্বাভাবিক",
        "Healthy": "ঝুকিমুক্ত",
        "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.": "বি এম আই অনুযায়ী আপনার ওজন স্বাভাবিক আছে, অর্থাৎ আপনি সুস্থ আছেন। দয়া করে এই স্বাভাবিক মাত্রা বজায় রাখুন ।",
        "Overweight": "বেশি ওজন",
        "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "বি এম আই অনুযায়ী আপনার ওজন স্বাভাবিকের থেকে বেশি। আপনার ওজন কমাতে অনুগ্রহ পূর্বক চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।",
        "Obesity": "স্থুলতা",
        "High Risk": "বেশি ঝুঁকি সম্পন্ন",
        "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.": "বি এম আই অনুযায়ী আপনার ওজন অনেক বেশি। আপনার ওজন কমাতে অনুগ্রহ পূর্বক চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।",
        "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.": "বি এম আই অনুযায়ী আপনার ওজন স্বাভাবিকের থেকে কম, এর ফলে আপনার স্বাস্থ্যগত নানা সমস্যা হতে পারে। অনুগ্রহ পূর্বক চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।",
        "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.": "বি এম আই অনুযায়ী আপনার ওজন স্বাভাবিক আছে। অর্থাৎ আপনি সুস্থ আছেন। দয়া করে এই স্বাভাবিক মাত্রা বজায় রাখুন ।",
        "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "বি এম আই অনুযায়ী আপনার ওজন স্বাভাবিকের থেকে বেশি। আপনার ওজন কমাতে অনুগ্রহ পূর্বক চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।",
        "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.": "বি এম আই অনুযায়ী আপনার ওজন অনেক বেশি। আপনার ওজন কমাতে অনুগ্রহ পূর্বক চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।",
        "Highly Obesity": "অনেক বেশি ওজন",
        "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.": "বি এম আই অনুযায়ী আপনার ওজন স্বাভাবিকের চেয়ে অনেক বেশি। আপনি হৃদরোগ, উচ্চ রক্তচাপ, স্ট্রোক ও ডায়াবেটিসের ঝুঁকিতে আছেন। ওজন কমাতে দ্রুত চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।",
        "Morbid Obesity": "মাত্রাতিরিক্ত ওজন",
        "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction.": "বি এম আই অনুযায়ী আপনার ওজন মাত্রাতিরিক্ত। আপনি হৃদরোগ, উচ্চ রক্তচাপ, স্ট্রোক ও ডায়াবেটিসের ঝুঁকিতে আছেন। ওজন কমাতে দ্রুত চিকিৎসক বা পুষ্টিবিদের পরামশ নিন।"
      },
      "kn_IN": {
        "Underweight": "ಕಡಿಮೆ ತೂಕ",
        "Your are UNDERWEIGHT, please consult with physician or nutritionist.": "ನೀವು ಕಡಿಮೆ ತೂಕ ಹೊಂದಿದ್ದೀರಿ, ದಯವಿಟ್ಟು ವೈದ್ಯರು ಅಥವಾ ಪೌಷ್ಟಿಕತಜ್ಞರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Normal": "ಸಾಮಾನ್ಯ",
        "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.": "ನಿಮ್ಮ BMI ಸಾಮಾನ್ಯದಲ್ಲಿದೆ, ಅಂದರೆ ನೀವು ಆರೋಗ್ಯವಾಗಿದ್ದೀರಿ ಎಂದರ್ಥ. ದಯವಿಟ್ಟು ಈ BMI ಅನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ.",
        "Overweight": "ಅಧಿಕ ತೂಕ",
        "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "ನೀವು ಅಧಿಕ ತೂಕ ಹೊಂದಿದ್ದೀರಿ, ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Obesity": "ಬೊಜ್ಜು",
        "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.": "ನೀವು ಬೊಜ್ಜು ಹೊಂದಿರುವಿರಿ. ಇದು ವಿವಿಧ ಕಾಯಿಲೆಗಳಿಗೆ ಹೆಚ್ಚು ಅಪಾಯಕಾರಿ ಸ್ಥಿತಿಯಾಗಿದೆ, ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.": "ನೀವು ಕಡಿಮೆ ತೂಕ ಹೊಂದಿದ್ದೀರಿ, ಇದು ಹಲವಾರು ಆರೋಗ್ಯ ಸಮಸ್ಯೆಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು. ದಯವಿಟ್ಟು ನಿಮ್ಮ ವೈದ್ಯರು ಅಥವಾ ಪೌಷ್ಟಿಕತಜ್ಞರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.": "ನಿಮ್ಮ BMI ಸಾಮಾನ್ಯ ಮಟ್ಟದಲ್ಲಿದೆ, ಈ ಮಟ್ಟವನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಲು - ನಿಯಮಿತವಾಗಿ ದೈಹಿಕ ಚಟುವಟಿಕೆ ಮಾಡಿ ಮತ್ತು ಸಮತೋಲಿತ ಆಹಾರವನ್ನು ಸೇವಿಸಿ - ಇವೆರಡೂ ನಿಮಗೆ ಉತ್ತಮವಾಗಿ ಕಾಣಲು ಮತ್ತು ಅನುಭವಿಸಲು ಮತ್ತು ತೂಕವನ್ನು ಕಡಿಮೆ ಮಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.",
        "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "ನೀವು ಅಧಿಕ ತೂಕ ಹೊಂದಿದ್ದೀರಿ, ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.": "ನೀವು ಬೊಜ್ಜು. ಬೊಜ್ಜು ಹೊಂದಿರುವ ನಿಮಗೆ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಸಂಬಂಧಿ ಕಾಯಿಲೆ, ಮಧುಮೇಹ ಬರುವ ಅಪಾಯ ಹೆಚ್ಚು. ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ. ನೀವು ... ಕೆಜಿ ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಬೇಕು.",
        "Highly Obesity": "ಅಧಿಕ ಬೊಜ್ಜು",
        "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.": "ನೀವು ತುಂಬಾ ಬೊಜ್ಜು ಹೊಂದಿದ್ದೀರಿ. ನಿಮಗೆ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಸಂಬಂಧಿ ಕಾಯಿಲೆ, ಮಧುಮೇಹ ಬರುವ ಅಪಾಯ ತುಂಬಾ ಹೆಚ್ಚು. ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ.",
        "Morbid Obesity": "ರೋಗಗ್ರಸ್ತ ಬೊಜ್ಜು",
        "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction.": "ನೀವು ಅಸ್ವಸ್ಥ ಬೊಜ್ಜು. ನಿಮಗೆ ಅಧಿಕ ರಕ್ತದೊತ್ತಡ, ಹೃದಯ ಸಂಬಂಧಿ ಕಾಯಿಲೆ, ಮಧುಮೇಹ ಬರುವ ಅಪಾಯ ತುಂಬಾ ಹೆಚ್ಚು, ತೂಕ ಇಳಿಸಿಕೊಳ್ಳಲು ದಯವಿಟ್ಟು ತಕ್ಷಣ ಪೌಷ್ಟಿಕತಜ್ಞರು ಅಥವಾ ವೈದ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ."
      }
    };
  }

  @override
  String getRouteName() {
  return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.lazyPut<BmiHeightInputLogic>(() => BmiHeightInputLogic());
  }
}
