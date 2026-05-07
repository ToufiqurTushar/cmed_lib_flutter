import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/widget/app_dialog.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/muac/muac_input_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:themed/themed.dart';



class MuacInputView extends RapidView<MuacInputLogic> {
  static String routeName = '/muac_input_page';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BasicAppBar('label_muac'.tr),
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
                                          controller.muacUnit.value ==
                                              GmpUnit.CENTIMETER.name
                                              ? 'title_measurement_in_inch'.tr
                                              : 'title_measurement_centimeter'.tr,
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
                                    onTap: () => {controller.toggleMuacUnit()},
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
                              height: 8,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Obx(
                                    ()=> Text(
                                  controller.muacUnit.value == MuacUnit.CENTIMETER.name
                                      ? 'input_label_muac_cm'.tr
                                      : 'input_label_muac_inch'.tr,
                                  style: CMEDTextUtils.inputTextLabelStyle,
                                ),
                              ),
                            ),
                            Obx(
                                  ()=> CMEDTextField(
                                  controller.muacUnit.value == MuacUnit.CENTIMETER.name
                                      ? 'input_label_muac_cm'.tr
                                      : 'input_label_muac_inch'.tr,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                  textEditingController: controller.muacController,
                                  onSaved: (value) {}, onValidator: (value) {
                                return controller.validateMuac(value!);
                              }),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
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
                                    AppDialogs.showDoubleButtonDialog(
                                        'label_measurement_store_warning'.tr,
                                        bodyText: controller.getInputText(),
                                        onPositiveButtonClick: () => {
                                          controller.sendMeasurement(),
                                        }),
                                },
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          if (controller.isSuccess.value) {
                            controller.isSuccess.value = false;
                            Future.delayed(Duration.zero, () async {
                              Get.offNamed('/screening_report_result_details',
                                  arguments: [
                                    {
                                      "screeningReport":
                                      controller.screeningReport.value
                                    }
                                  ]);
                            });
                          }
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
    return {
      "en_US": {
        "Severe Acute Malnutrition": "Severe Acute Malnutrition",
        "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.": "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.",
        "Moderate Acute Malnutrition": "Moderate Acute Malnutrition",
        "Malnourished child , please consult with doctor/nutritionist for further evaluation and advice.": "Malnourished child , please consult with doctor/nutritionist for further evaluation and advice.",
        "Normal": "Normal",
        "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet.": "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet."
      },
      "bn_BD": {
        "Severe Acute Malnutrition": "তীব্র মারাত্মক অপুষ্টি",
        "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.": "মারাত্মক তীব্র অপুষ্টি",
        "Moderate Acute Malnutrition": "মাঝারি তীব্র অপুষ্টি",
        "Malnourished child , please consult with doctor/nutritionist for further evaluation and advice.": "মাঝারি তীব্র অপুষ্টি",
        "Normal": "স্বাভাবিক",
        "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet.": "স্বাভাবিক"
      },
      "kn_IN": {
        "Severe Acute Malnutrition": "ತೀಬ್ರ ಮಾರಾತಮಕ್ ಅಪುಷ್ಟಿ",
        "Severely malnourished child. Please don't panic and consult a doctor or go to the nearest hospital right away.": "ಅಪನಾರ್ ಶಿಶು ತೀಬ್ರ ಮಾರಾತಮಕ್ ಅಪುಷ್ಟಿ.  ಆತುರ ನಾ ಹಯೇ ಶಿಶುರ ಪಡತಿ ಯತ್ನ, ದನ ಚಿಕಿತ್ಸಾಲಯ, ರಾಮನಗರ ಸ್ಬಾಸ್ತ್ಯ ಕೆಂದ್ರೆ ಯೋಗಾಯೋಗ ಕರುಣ್. ",
        "Moderate Acute Malnutrition": "ಮಾಜಾರಿ ತೀಬ್ರ ಅಪುಷ್ಟಿ",
        "Malnourished child , please consult with doctor/nutritionist for further evaluation and advice.": "ಆಪನಾರ ಶಿವರು ಪುಷ್ಟಿಮಾತ್ರಾ ಸ್ಬಾವೈರಿಗಳು ಚೆಯ್ ಕಾಮ್, ಎ ಬ್ಯಾಪಾರೆ ದ್ರುತ್ ನಿಶ್ಚಿತ್ ಹೋದ್ ಪ್ರಯೋಜನ್. ಚಿಕಿಸಾ ಎಬನ್ ಪರಮಾರ್ಶೆರ್ ಜನ್ಯ ಚಿಕಿಯಸಕ್/ಪುಷ್ಟಿಬಿದಿರೆ ಪರಮೇಶ್ವರ್ ನಿನ್ |",
        "Normal": "ಸ್ವಭಾವ",
        "Congratulations! Well nourished child. Please maintain this level by providing your child with proper regular balanced diet.": "ಅಭಿನಂದನ್! ಶಿಶುರ ಪುಷ್ಟಿಮಾತ್ರಾ ಸ್ಬಾಬಿಕ್ । ಶಿಶುಕೆ ಪ್ರತಿದಿನ ಸುಷಮ್ ಖಬಾರ್ ಪುರದರೈತರು ಈ ಮಾತ್ರಾ ಬಜಾಯ ರಾಖುನ್."
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
    Get.put(MuacInputLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
