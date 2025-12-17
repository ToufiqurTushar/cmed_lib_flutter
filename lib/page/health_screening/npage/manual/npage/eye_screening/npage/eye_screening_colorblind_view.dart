import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_colorblind_logic.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

class EyeScreeningColorblindView extends RapidView<EyeScreeningColorblindLogic> {
  static String routeName = '/eye_screening_colorblind_view';
  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> Scaffold(
        appBar: BasicAppBar('label_color_blind_test'.tr),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8,8,8,0),
                    child: Card(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Image.asset(controller.getImageAsset(), width: 200,)),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Column(
                        children: [
                          Form(
                            key: controller.formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: CMEDTextField(
                              'label_type_number_in_screen'.tr,
                              textEditingController: controller.textEditingController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                              bottomMargin: 8,
                              onValidator: (value) {
                                return controller.validateNumber(value!);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CMEDPrimaryElevatedButton(
                                  'label_dont_see_anything'.tr,
                                  fontSize: 14,
                                  buttonBgColor: Colors.red,
                                      () => {
                                    controller.screeningComplete(),
                                  },
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Expanded(
                                child: CMEDPrimaryElevatedButton(
                                  'label_submit'.tr,
                                  fontSize: 14,
                                  buttonBgColor: Theme.of(context).primaryColor,
                                      () => {
                                    controller.nextScreening(),
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12,),
                          const Row(
                            children: [

                            ],
                          ),
                          const SizedBox(height: 8,),
                        ],
                      ),
                    ),
                  ),
                ],),
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return EyeScreeningHomeI18N.getTranslations();
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {

    Get.put(ScreeningReportRepository());
    Get.put(EyeScreeningColorblindLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
