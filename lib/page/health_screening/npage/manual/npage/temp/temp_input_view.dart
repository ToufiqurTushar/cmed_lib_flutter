import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/temp/temp_input_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:themed/themed.dart';

import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';

class TempInputView extends RapidView<TempInputLogic> {
  static String routeName = '/temp_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BasicAppBar('label_body_temperature'.tr),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Form(
              key: controller.screeningReportFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              isShowCurrentDate: true,
                              title:  controller.dateController.text.isEmpty ? null : CustomDateUtils.formatDatePicker(controller.dateController.text),
                              onDateSelect: (DateTime date) {
                                controller.dateController.text = date.millisecondsSinceEpoch.toString();
                              },
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
                                          controller.temperatureUnit.value ==
                                                  TemperatureUnit.FAHRENHEIT.name
                                              ? 'title_measurement_in_f'.tr
                                              : 'title_measurement_in_c'.tr,
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
                                        {controller.toggleTemperatureUnit()},
                                    child:  ChangeColors(
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
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                'input_label_temp'.tr,
                                style: CMEDTextUtils.inputTextLabelStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Obx(() => CMEDTextField(
                                    controller.temperatureUnit.value ==
                                            TemperatureUnit.FAHRENHEIT.name
                                        ? 'input_hint_temp_f'.tr
                                        : 'input_hint_temp_c'.tr,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'))
                                    ],
                                    textEditingController:
                                        controller.temperatureEditTextController,
                                    onSaved: (value) {}, onValidator: (value) {
                                  return controller
                                      .validateTemperatureInput(value!);
                                })),
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
    Get.put(TempInputLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
