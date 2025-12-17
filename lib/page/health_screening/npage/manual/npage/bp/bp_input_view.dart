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
   return HealthScreeningHomeI18N.getTranslations();
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
