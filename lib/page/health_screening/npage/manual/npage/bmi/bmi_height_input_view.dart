import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/widget_v2.dart';
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

import '../../../../../../common/widget/cmed_primary_elevated_button.dart';
import '../../../auto/npage/bmi/bmi_device_connection_view.dart';

class BmiHeightInputView extends RapidView<BmiHeightInputLogic> {
  static String routeName = '/bmi_height_input_page';

  @override
  Widget build(BuildContext context) {
    return widgetV(
      v2: GradientWhiteToPrimary(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: controller.isNestedRoute? null: BasicAppBarV2(
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
                                          vertical: 8.0, horizontal: 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CMEDPrimaryElevatedButton(
                                              'label_enter'.tr,
                                              () {
                                                if (controller.isValidInput()){
                                                  bool isAuto = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isAuto??false : false;
                                                  final measurementArg = MeasurementViewArg(
                                                    isAuto: isAuto,
                                                    isNestedRoute: controller.isNestedRoute,
                                                    codeId: MeasurementType.BMI.value,
                                                    heightUnit: controller.heightUnit.value,
                                                    heightInCm: controller.getHeightInCentimeter().toDouble(),
                                                    heightInFeet: controller.heightInFeetEditTextController.text,
                                                    heightInInch: controller.heightInInchEditTextController.text,
                                                  );

                                                  if(AppUidConfig.isCmedAgentApp || AppUidConfig.isI4WeAgentApp){
                                                    Get.toNamed(AutoManualSelectionView.routeName, arguments: measurementArg);
                                                  } else if(AppUidConfig.isCmedUserApp || AppUidConfig.isI4WeMemberApp) {
                                                    if(isAuto){
                                                      Get.offNamed(BmiDeviceConnectionView.routeName, arguments: measurementArg, id: controller.isNestedRoute? 1: null);
                                                    } else {
                                                      Get.offNamed(BmiHeightWeightInputView.routeName, arguments: measurementArg, id: controller.isNestedRoute? 1: null);
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
        ),
      ),
      v1: Scaffold(
        appBar: BasicAppBar(
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
                                            vertical: 8.0, horizontal: 16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CMEDWhiteElevatedButton(
                                                'label_enter'.tr,
                                                    () {
                                                  if (controller.isValidInput()){
                                                    bool isAuto = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isAuto??false : false;
                                                    final measurementArg = MeasurementViewArg(
                                                      isAuto: isAuto,
                                                      isNestedRoute: controller.isNestedRoute,
                                                      codeId: MeasurementType.BMI.value,
                                                      heightUnit: controller.heightUnit.value,
                                                      heightInCm: controller.getHeightInCentimeter().toDouble(),
                                                      heightInFeet: controller.heightInFeetEditTextController.text,
                                                      heightInInch: controller.heightInInchEditTextController.text,
                                                    );

                                                    if(AppUidConfig.isCmedAgentApp || AppUidConfig.isI4WeAgentApp){
                                                      Get.toNamed(AutoManualSelectionView.routeName, arguments: measurementArg);
                                                    } else if(AppUidConfig.isCmedUserApp || AppUidConfig.isI4WeMemberApp) {
                                                      if(isAuto){
                                                        Get.offNamed(BmiDeviceConnectionView.routeName, arguments: measurementArg, id: controller.isNestedRoute? 1: null);
                                                      } else {
                                                        Get.offNamed(BmiHeightWeightInputView.routeName, arguments: measurementArg, id: controller.isNestedRoute? 1: null);
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
      },
      "hi_IN": {
        "Underweight": "कम वजन",
        "Your are UNDERWEIGHT, please consult with physician or nutritionist.": "आपका वजन कम है, कृपया डॉक्टर या पोषण विशेषज्ञ से परामर्श करें।",
        "Normal": "सामान्य",
        "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.": "आपका BMI सामान्य है, इसका मतलब है कि आप स्वस्थ हैं। कृपया इस BMI को बनाए रखें।",
        "Overweight": "अधिक वजन",
        "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "आपका वजन अधिक है, वजन कम करने के लिए कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श करें।",
        "Obesity": "मोटापा",
        "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.": "आप मोटापे से ग्रस्त हैं। यह विभिन्न बीमारियों के लिए उच्च जोखिम वाली स्थिति है। वजन कम करने के लिए कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श करें।",
        "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.": "आपका वजन कम है, इससे कई स्वास्थ्य संबंधी समस्याएं हो सकती हैं। कृपया डॉक्टर या पोषण विशेषज्ञ से परामर्श करें।",
        "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.": "आपका BMI सामान्य स्तर पर है। इस स्तर को बनाए रखने के लिए नियमित शारीरिक गतिविधि करें और संतुलित आहार लें। ये दोनों आपको स्वस्थ महसूस करने और वजन को नियंत्रित रखने में मदद करते हैं।",
        "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "आपका वजन अधिक है, वजन कम करने के लिए कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श करें।",
        "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.": "आप मोटापे से ग्रस्त हैं। मोटापे के कारण आपको उच्च रक्तचाप, हृदय रोग और मधुमेह होने का अधिक जोखिम है। वजन कम करने के लिए कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श करें। आपको .... किग्रा वजन कम करना होगा।",
        "Highly Obesity": "अत्यधिक मोटापा",
        "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.": "आप अत्यधिक मोटापे से ग्रस्त हैं। आपको उच्च रक्तचाप, हृदय रोग और मधुमेह होने का बहुत अधिक जोखिम है। वजन कम करने के लिए कृपया पोषण विशेषज्ञ या डॉक्टर से परामर्श करें।",
        "Morbid Obesity": "रुग्ण मोटापा",
        "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction.": "आप गंभीर मोटापे से ग्रस्त हैं। आपको उच्च रक्तचाप, हृदय रोग और मधुमेह होने का बहुत अधिक जोखिम है। वजन कम करने के लिए कृपया तुरंत पोषण विशेषज्ञ या डॉक्टर से परामर्श करें।"
      },

      "ta_IN": {
        "Underweight": "குறைந்த எடை",
        "Your are UNDERWEIGHT, please consult with physician or nutritionist.": "உங்கள் எடை குறைவாக உள்ளது, தயவுசெய்து மருத்துவர் அல்லது ஊட்டச்சத்து நிபுணரை அணுகவும்.",
        "Normal": "சாதாரணம்",
        "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.": "உங்கள் BMI சாதாரண நிலையில் உள்ளது, அதாவது நீங்கள் ஆரோக்கியமாக இருக்கிறீர்கள். தயவுசெய்து இந்த BMI-ஐ பராமரிக்கவும்.",
        "Overweight": "அதிக எடை",
        "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "உங்கள் எடை அதிகமாக உள்ளது, எடையைக் குறைக்க தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "Obesity": "உடல் பருமன்",
        "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.": "நீங்கள் உடல் பருமனால் பாதிக்கப்பட்டுள்ளீர்கள். இது பல்வேறு நோய்களுக்கு அதிக ஆபத்தான நிலையாகும். எடையைக் குறைக்க தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.": "உங்கள் எடை குறைவாக உள்ளது, இது பல்வேறு உடல்நலப் பிரச்சினைகளை ஏற்படுத்தக்கூடும். தயவுசெய்து மருத்துவர் அல்லது ஊட்டச்சத்து நிபுணரை அணுகவும்.",
        "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.": "உங்கள் BMI சாதாரண நிலையில் உள்ளது. இந்த நிலையைப் பராமரிக்க தொடர்ந்து உடற்பயிற்சி செய்து சமச்சீர் உணவை உட்கொள்ளுங்கள். இவை இரண்டும் நீங்கள் ஆரோக்கியமாக உணரவும், உடல் எடையை கட்டுப்பாட்டில் வைத்திருக்கவும் உதவும்.",
        "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "உங்கள் எடை அதிகமாக உள்ளது, எடையைக் குறைக்க தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.": "நீங்கள் உடல் பருமனால் பாதிக்கப்பட்டுள்ளீர்கள். உடல் பருமன் காரணமாக உயர் இரத்த அழுத்தம், இதய நோய் மற்றும் நீரிழிவு நோய் ஏற்படும் ஆபத்து அதிகமாக உள்ளது. எடையைக் குறைக்க தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும். நீங்கள் .... கிலோ எடையைக் குறைக்க வேண்டும்.",
        "Highly Obesity": "கடுமையான உடல் பருமன்",
        "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.": "நீங்கள் கடுமையான உடல் பருமனால் பாதிக்கப்பட்டுள்ளீர்கள். உயர் இரத்த அழுத்தம், இதய நோய் மற்றும் நீரிழிவு நோய் ஏற்படும் ஆபத்து மிகவும் அதிகமாக உள்ளது. எடையைக் குறைக்க தயவுசெய்து ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்.",
        "Morbid Obesity": "நோய்க்காரணமான உடல் பருமன்",
        "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction.": "நீங்கள் தீவிர உடல் பருமனால் பாதிக்கப்பட்டுள்ளீர்கள். உயர் இரத்த அழுத்தம், இதய நோய் மற்றும் நீரிழிவு நோய் ஏற்படும் ஆபத்து மிகவும் அதிகமாக உள்ளது. எடையைக் குறைக்க தயவுசெய்து உடனடியாக ஊட்டச்சத்து நிபுணர் அல்லது மருத்துவரை அணுகவும்."
      },

      "te_IN": {
        "Underweight": "తక్కువ బరువు",
        "Your are UNDERWEIGHT, please consult with physician or nutritionist.": "మీ బరువు తక్కువగా ఉంది, దయచేసి వైద్యుడిని లేదా పోషకాహార నిపుణుడిని సంప్రదించండి.",
        "Normal": "సాధారణం",
        "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.": "మీ BMI సాధారణ స్థాయిలో ఉంది, అంటే మీరు ఆరోగ్యంగా ఉన్నారని అర్థం. దయచేసి ఈ BMIని కొనసాగించండి.",
        "Overweight": "అధిక బరువు",
        "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "మీ బరువు అధికంగా ఉంది, బరువు తగ్గడానికి దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "Obesity": "ఊబకాయం",
        "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.": "మీకు ఊబకాయం ఉంది. ఇది వివిధ వ్యాధులకు అధిక ప్రమాదకరమైన పరిస్థితి. బరువు తగ్గడానికి దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.": "మీ బరువు తక్కువగా ఉంది, దీనివల్ల అనేక ఆరోగ్య సంబంధిత సమస్యలు రావచ్చు. దయచేసి వైద్యుడిని లేదా పోషకాహార నిపుణుడిని సంప్రదించండి.",
        "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.": "మీ BMI సాధారణ స్థాయిలో ఉంది. ఈ స్థాయిని కొనసాగించడానికి క్రమం తప్పకుండా శారీరక వ్యాయామం చేయండి మరియు సమతుల్య ఆహారం తీసుకోండి. ఇవి రెండూ మీరు ఆరోగ్యంగా ఉండటానికి మరియు బరువును నియంత్రించుకోవడానికి సహాయపడతాయి.",
        "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "మీ బరువు అధికంగా ఉంది, బరువు తగ్గడానికి దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.": "మీకు ఊబకాయం ఉంది. ఊబకాయం కారణంగా అధిక రక్తపోటు, గుండె సంబంధిత వ్యాధులు మరియు మధుమేహం వచ్చే ప్రమాదం ఎక్కువగా ఉంటుంది. బరువు తగ్గడానికి దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి. మీరు .... కిలోల బరువు తగ్గాలి.",
        "Highly Obesity": "తీవ్రమైన ఊబకాయం",
        "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.": "మీకు తీవ్రమైన ఊబకాయం ఉంది. అధిక రక్తపోటు, గుండె సంబంధిత వ్యాధులు మరియు మధుమేహం వచ్చే ప్రమాదం చాలా ఎక్కువగా ఉంది. బరువు తగ్గడానికి దయచేసి పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి.",
        "Morbid Obesity": "తీవ్ర ఊబకాయం",
        "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction.": "మీకు తీవ్రమైన ఊబకాయం ఉంది. అధిక రక్తపోటు, గుండె సంబంధిత వ్యాధులు మరియు మధుమేహం వచ్చే ప్రమాదం చాలా ఎక్కువగా ఉంది. బరువు తగ్గడానికి దయచేసి వెంటనే పోషకాహార నిపుణుడిని లేదా వైద్యుడిని సంప్రదించండి."
      },

      "or_IN": {
        "Underweight": "କମ୍ ଓଜନ",
        "Your are UNDERWEIGHT, please consult with physician or nutritionist.": "ଆପଣଙ୍କ ଓଜନ କମ୍ ଅଛି, ଦୟାକରି ଡାକ୍ତର କିମ୍ବା ପୋଷଣ ବିଶେଷଜ୍ଞଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
        "Normal": "ସାଧାରଣ",
        "Your BMI is in NORMAL,  It means you are healthy. Please maintain this BMI.": "ଆପଣଙ୍କ BMI ସାଧାରଣ ଅଛି, ଏହାର ଅର୍ଥ ଆପଣ ସୁସ୍ଥ ଅଛନ୍ତି। ଦୟାକରି ଏହି BMIକୁ ବଜାୟ ରଖନ୍ତୁ।",
        "Overweight": "ଅଧିକ ଓଜନ",
        "Your are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "ଆପଣଙ୍କ ଓଜନ ଅଧିକ ଅଛି, ଓଜନ କମାଇବା ପାଇଁ ଦୟାକରି ପୋଷଣ ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
        "Obesity": "ମେଦବହୁଳତା",
        "Your are OBESE. It is high risk condition for different diseases, please consult with nutritionist or physician for weight reduction.": "ଆପଣ ମେଦବହୁଳତାରେ ପୀଡ଼ିତ। ଏହା ବିଭିନ୍ନ ରୋଗ ପାଇଁ ଏକ ଅଧିକ ବିପଦପୂର୍ଣ୍ଣ ସ୍ଥିତି। ଓଜନ କମାଇବା ପାଇଁ ଦୟାକରି ପୋଷଣ ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
        "Your are UNDERWEIGHT, this may cause several health related problems. Please consult with physician or nutritionist.": "ଆପଣଙ୍କ ଓଜନ କମ୍ ଅଛି, ଏହା ଅନେକ ସ୍ୱାସ୍ଥ୍ୟ ସମ୍ବନ୍ଧୀୟ ସମସ୍ୟାର କାରଣ ହୋଇପାରେ। ଦୟାକରି ଡାକ୍ତର କିମ୍ବା ପୋଷଣ ବିଶେଷଜ୍ଞଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
        "Your BMI is in NORMAL, to maintain this level - do regular physical activity and eat balanced diet - both of which help you look and feel good and keep weight off.": "ଆପଣଙ୍କ BMI ସାଧାରଣ ସ୍ତରରେ ଅଛି। ଏହି ସ୍ତରକୁ ବଜାୟ ରଖିବା ପାଇଁ ନିୟମିତ ଶାରୀରିକ କାର୍ଯ୍ୟକଳାପ କରନ୍ତୁ ଏବଂ ସନ୍ତୁଳିତ ଖାଦ୍ୟ ଖାଆନ୍ତୁ। ଏହି ଦୁଇଟି ଆପଣଙ୍କୁ ସୁସ୍ଥ ଅନୁଭବ କରିବା ଏବଂ ଓଜନ ନିୟନ୍ତ୍ରଣରେ ରଖିବାରେ ସାହାଯ୍ୟ କରେ।",
        "You are OVERWEIGHT, please consult with nutritionist or physician for weight reduction.": "ଆପଣଙ୍କ ଓଜନ ଅଧିକ ଅଛି, ଓଜନ କମାଇବା ପାଇଁ ଦୟାକରି ପୋଷଣ ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
        "You are OBESE. Being OBESE you are in high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction. You have to loose .... kg.": "ଆପଣ ମେଦବହୁଳତାରେ ପୀଡ଼ିତ। ମେଦବହୁଳତା ଯୋଗୁଁ ଉଚ୍ଚ ରକ୍ତଚାପ, ହୃଦ୍‌ରୋଗ ଏବଂ ମଧୁମେହ ହେବାର ଆଶଙ୍କା ଅଧିକ ଅଛି। ଓଜନ କମାଇବା ପାଇଁ ଦୟାକରି ପୋଷଣ ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ। ଆପଣଙ୍କୁ .... କିଲୋଗ୍ରାମ୍ ଓଜନ କମାଇବାକୁ ପଡ଼ିବ।",
        "Highly Obesity": "ଅତ୍ୟଧିକ ମେଦବହୁଳତା",
        "You are HIGHLY OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes, please consult with nutritionist or physician for weight reduction.": "ଆପଣ ଅତ୍ୟଧିକ ମେଦବହୁଳତାରେ ପୀଡ଼ିତ। ଉଚ୍ଚ ରକ୍ତଚାପ, ହୃଦ୍‌ରୋଗ ଏବଂ ମଧୁମେହ ହେବାର ଆଶଙ୍କା ବହୁତ ଅଧିକ ଅଛି। ଓଜନ କମାଇବା ପାଇଁ ଦୟାକରି ପୋଷଣ ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।",
        "Morbid Obesity": "ରୋଗଗ୍ରସ୍ତ ମେଦବହୁଳତା",
        "You are MORBID OBESE. You are in very high risk to develop hypertension, cardiovascular disease, diabetes,, please consult with a nutritionist or physician immediately for weight reduction.": "ଆପଣ ଗୁରୁତର ମେଦବହୁଳତାରେ ପୀଡ଼ିତ। ଉଚ୍ଚ ରକ୍ତଚାପ, ହୃଦ୍‌ରୋଗ ଏବଂ ମଧୁମେହ ହେବାର ଆଶଙ୍କା ବହୁତ ଅଧିକ ଅଛି। ଓଜନ କମାଇବା ପାଇଁ ଦୟାକରି ତୁରନ୍ତ ପୋଷଣ ବିଶେଷଜ୍ଞ କିମ୍ବା ଡାକ୍ତରଙ୍କ ସହିତ ପରାମର୍ଶ କରନ୍ତୁ।"
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

  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<BmiHeightInputLogic>().isThemeV2) {
      return v2 ?? v1;
    }
    return v1;
  }
}
