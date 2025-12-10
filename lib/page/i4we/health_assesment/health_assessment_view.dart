import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/widget/basic_app_bar.dart';
import 'health_assessment_i18n.dart';
import 'health_assessment_logic.dart';
import 'npage/history/health_assessment_history_list_view.dart';


class HealthAssessmentView extends RapidView<HealthAssessmentLogic> {
  static String routeName = "/HealthAssessmentView";

  const HealthAssessmentView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Health Assessment".tr, trailingWidget: InkWell(
        onTap: () {
          Get.toNamed(HealthAssessmentHistoryListView.routeName);
        },
        child: Visibility(
          visible: controller.selectedSurvey.value == null,
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Icon(Icons.history, color: Theme.of(context).primaryColor, size: 26,),
                SizedBox(width: 8,),
                Text('History')
              ],
            ),
          ),
        ),
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(
              ()=> controller.isLoading.value?
              Center(child: CircularProgressIndicator()):
              SurveyManagerWidget(
                //jsonAssetDirectory: "assets/json/healthassessment.json",
                surveys: controller.allSurveys,
                selectedSurvey: controller.selectedSurvey.value,
                onSelectSurvey: (SurveyDto? selectedSurvey){
                  controller.selectedSurvey.value = selectedSurvey;
                },
                onSelectAnswer: (val){

                },
                onSubmit: (selectedGeoup, formMap){
                  print('onSubmit');
                  controller.submitSurvey(selectedGeoup, formMap);
                },
              ),
            ),
          ),
        ]
      ),
    );
  }



  @override
  void loadDependentLogics() {
    Get.put(HealthAssessmentLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return HealthAssesmentI18N.getTranslations();
  }
}





