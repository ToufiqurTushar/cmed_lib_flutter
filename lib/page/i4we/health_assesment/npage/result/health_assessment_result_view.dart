import 'package:cmed_lib_flutter/common/helper/utils.dart';
import '../../../../../common/helper/text_utils.dart';
import '../../../../../common/widget/basic_app_bar.dart';
import '../../../../../common/widget/marquee_widget.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../survey/widget/round_image.dart';
import '../../health_assessment_argument.dart';
import '../../health_assessment_view.dart';
import 'health_assessment_result_logic.dart';

class HealthAssessmentResultView extends RapidView<HealthAssessmentResultLogic> {
  static String routeName = '/HealthAssessmentResultView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('Health Assessment'.tr),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Spacer(),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "${'Assessment Date'.tr} ${CustomDateUtils.format(controller.selectedSurveyResult.value.surveyOn).trDate()}",
                                    style: CMEDTextUtils.header1TextStyle,
                                  )),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${controller.selectedSurveyResult.value.surveyName} Assessment Result',
                                        style: CMEDTextUtils.header1TextStyle,
                                      )
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Visibility(
                                    visible: !controller.isHistoryView.isTrue,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${'Reassess ${controller.selectedSurveyResult.value.surveyName} Assessment Result'.tr}", style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                child: IconButton(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      constraints: const BoxConstraints(),
                                                      onPressed: (){
                                                          controller.remeasure();
                                                      },
                                                      icon: const Icon(Icons.refresh, color: Colors.white,)
                                                  )
                                                )
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Container(
                                            width: 116,
                                            height: 116,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(120),
                                                border: Border.all(
                                                    color: controller.selectedSurveyResult.value.result!.colorCode!.toColor(),
                                                    width: 4.0,
                                                    style: BorderStyle.solid)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Spacer(),
                                                Container(
                                                  color: Colors.white,
                                                  child: RoundImage(
                                                    controller.selectedSurveyResult.value.icon??"",
                                                    40,
                                                    defaultImage: "assets/swasti/images/ic_anemia.svg",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: MarqueeWidget(
                                                      child: Text('${controller.selectedSurveyResult.value.result!.status!}'),
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            )),
                                      ),
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              controller.selectedSurveyResult.value.result!.advice ?? "",textAlign: TextAlign.left,
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                              visible: controller.isLoading.isTrue,
                              child: const CircularProgressIndicator()
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !controller.healthAssessmentResultArgument.isFromHistory,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0 ,12, 12),
          child: Container(
            height: 50,
            child: FrElevatedButton(
              onPressed: () {
                Future.delayed(Duration.zero, () async {
                  Get.offNamed(HealthAssessmentView.routeName, arguments: HealthAssessmentArgument());
                });
              },
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor,
                foregroundColor: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              name: 'HEALTH ASSESSMENT MENU'.tr,
            ),
          )
        ),
      ),
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
   return {};
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.put(HealthAssessmentResultLogic());
  }
}
