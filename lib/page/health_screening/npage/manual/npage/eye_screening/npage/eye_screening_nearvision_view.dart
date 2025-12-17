import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_nearvision_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../../../common/widget/basic_app_bar.dart';

class EyeScreeningNearvisionView extends RapidView<EyeScreeningNearvisionLogic> {
  static String routeName = '/eye_screening_nearvision_view';
  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> Scaffold(
        appBar: BasicAppBar('label_near_vision_both_eye_test'.tr),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Visibility(
                              visible: controller.startScreening.isFalse,
                              child: Column(
                                children: [
                                  Text('info_near_vision1'.tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 16),),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap:(){
                                            controller.startScreening.value = true;
                                          },
                                          child: Container(
                                            height:65,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(24)),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            child: Center(child: Text('label_start_measurement_by_opening_two_eyes'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16,color: Colors.white),)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: controller.startScreening.isTrue,
                              child: Text(controller.getName(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: controller.startScreening.isTrue,
                                      child: Text(controller.getLabel(), style: TextStyle(fontSize: controller.getFontSize()+5)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12,),
                            Visibility(
                              visible: controller.startScreening.isTrue,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CMEDPrimaryElevatedButton(
                                      'label_clear'.tr,
                                      buttonBgColor: Theme.of(context).primaryColor,
                                          () => {
                                        controller.nextScreening(clear: true),
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12,),
                            Visibility(
                              visible: controller.startScreening.isTrue,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CMEDPrimaryElevatedButton(
                                      'label_unclear'.tr,
                                      buttonBgColor: Colors.red,
                                          () => {
                                        controller.nextScreening(clear: false),
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
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
    Get.put(EyeScreeningNearvisionLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
