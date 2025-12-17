
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
    return HealthScreeningHomeI18N.getTranslations();
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
