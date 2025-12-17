import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'blood_glucose_input_logic.dart';


class BloodGlucoseInputView extends RapidView<BloodGlucoseInputLogic> {
  static String routeName = '/blood_glucose_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BasicAppBar('label_blood_glucose'.tr),
        body: SafeArea(
          child: Form(
            key: controller.screeningReportFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
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

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              'input_label_glucose'.tr,
                              style: CMEDTextUtils.inputTextLabelStyle,
                            ),
                          ),
                          CMEDTextField(AppUidConfig.getGlucoseLabelHint('input_hint_glucose'.tr),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, ),
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                              textEditingController:
                                  controller.bloodGlucoseEditTextController,
                              onSaved: (value) {}, onValidator: (value) {
                            return controller.validateGlucoseInput(value!);
                          }),
                          const SizedBox(
                            height: 4,
                          ),
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
                                  //     bodyText: controller.getInputText(),
                                  //     onPositiveButtonClick: () => {
                                  //           controller.sendMeasurement(),
                                  //         }),
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
    Get.put(BloodGlucoseInputLogic(
        repository: Get.find<ScreeningReportRepository>()));
  }
}
