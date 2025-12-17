import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_contrast_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../../../common/widget/basic_app_bar.dart';

class EyeScreeningContrastView extends RapidView<EyeScreeningContrastLogic> {
  static String routeName = '/eye_screening_contrast_view';
  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> Scaffold(
        appBar: BasicAppBar('label_color_contrast_test'.tr),
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
                            Expanded(
                              child: SingleChildScrollView(
                                child: GridView.count(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 30.0,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: List.generate(controller.screeningQuestions.length, (index) {
                                      return InkWell(
                                        onTap: (){
                                          controller.nextScreening(result:controller.screeningQuestions[index]);
                                        },
                                        child: Center(
                                          child: Text(controller.getLabel(index), style: TextStyle(color: controller.getColor(index), fontSize: 46, fontWeight: FontWeight.bold)),
                                        ),
                                      );}
                                    )
                                ),
                                // child: Column(
                                //   children: [
                                //     Visibility(
                                //       visible: controller.startScreening.isTrue,
                                //       child: Text(controller.getLabel(), style: TextStyle(fontSize: controller.getFontSize())),
                                //     ),
                                //   ],
                                // ),
                              ),
                            ),
                            // InkWell(
                            //     onTap: (){
                            //       Get.toNamed(controller.nextScreening());
                            //     },
                            //     child: Image.asset(controller.getImageAsset())
                            // ),

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
    Get.put(EyeScreeningContrastLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
