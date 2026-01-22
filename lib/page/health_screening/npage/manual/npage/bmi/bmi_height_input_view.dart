import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
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

class BmiHeightInputView extends RapidView<BmiHeightInputLogic> {
  static String routeName = '/bmi_height_input_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      vertical: 8.0, horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CMEDWhiteElevatedButton(
                                          'label_enter'.tr,
                                          () => {
                                            if (controller.isValidInput()){
                                              if(AppUidConfig.isCmedAgentApp || AppUidConfig.isI4WeAgentApp){
                                                Get.toNamed(AutoManualSelectionView.routeName, arguments: {
                                                  "codeId": MeasurementType.BMI.value,
                                                  "heightUnit": controller.heightUnit.value,
                                                  "heightInCm": controller.getHeightInCentimeter(),
                                                  "heightInFeet": controller.heightInFeetEditTextController.text,
                                                  "heightInInch": controller.heightInInchEditTextController.text
                                                },)
                                              } else if(AppUidConfig.isCmedUserApp || AppUidConfig.isI4WeMemberApp) {
                                                Get.toNamed(BmiHeightWeightInputView.routeName, arguments: [
                                                  {
                                                    "codeId": MeasurementType.BMI.value,
                                                    "heightUnit": controller.heightUnit.value,
                                                    "heightInCm": controller.getHeightInCentimeter(),
                                                    "heightInFeet": controller.heightInFeetEditTextController.text,
                                                    "heightInInch": controller.heightInInchEditTextController.text
                                                  }
                                                ])
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
    return HealthScreeningHomeI18N.getTranslations();
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
