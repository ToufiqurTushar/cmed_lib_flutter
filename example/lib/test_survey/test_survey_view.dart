import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/tab_page.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'test_survey_logic.dart';




class TestSurveyView extends RapidView<TestSurveyLogic> {
  static String routeName = "/TestSurveyView";

  const TestSurveyView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Survey".tr)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12.0),
          Expanded(
            child: Obx(
              ()=> controller.isLoading.value?
              Center(child: CircularProgressIndicator()):
              SurveyManagerWidget(
                //jsonAssetDirectory: "assets/json/healthydays.json",
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
              // SurveyManagerWidget(
              //   //jsonAssetDirectory: "assets/json/healthydays.json",
              //   surveys: controller.allSurveys,
              //   //showSerialNumber: false,
              //   isTabStyle: true,
              //   tabContents: [
              //     TabPage(id: "t1", title: "GENERAL", listOfQuestionUid: ['as9_1', 'as9_15', 'as9_16', 'as9_17']),
              //     TabPage(id: "t2", title: "SUBSCRIPTION STATUS", listOfQuestionUid: ['as9_2', 'as9_3', 'as9_4', 'as9_5']),//visibleWhen: "showWorkTab:Yes",
              //     TabPage(id: "t3", title: "SOCIAL PROTECTION", listOfQuestionUid: ['as9_6', 'as9_7', 'as9_8', 'as9_9', 'as9_10', 'as9_11', 'as9_12', 'as9_13', 'as9_14']),
              //   ],
              //   selectedSurvey: controller.selectedSurvey.value,
              //   onSelectSurvey: (SurveyDto? selectedSurvey){
              //     controller.selectedSurvey.value = selectedSurvey;
              //   },
              //   onSelectAnswer: (val){
              //
              //   },
              //   onSubmit: (selectedGeoup, formMap){
              //     print('onSubmit');
              //     controller.submitSurvey(selectedGeoup, formMap);
              //   },
              // ),
            ),
          ),
        ]
      ),
    );
  }



  @override
  void loadDependentLogics() {
    Get.put(TestSurveyLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {};
  }
}





