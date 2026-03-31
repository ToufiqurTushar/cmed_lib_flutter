import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/tab_page.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/widget/basic_app_bar.dart';
import 'che_survey_i18n.dart';
import 'che_survey_logic.dart';


class CheSocialProtectionView extends RapidView<CheSocialProtectionLogic> {
  static String routeName = "/CheSocialProtectionView";

  const CheSocialProtectionView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Social Protection".tr, trailingWidget: InkWell(
        onTap: () {
          //Get.toNamed(HealthAssessmentHistoryListView.routeName);
        },
        child: Visibility(
          visible: controller.selectedSurvey.value == null,
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Icon(Icons.history, color: Theme.of(context).primaryColor, size: 26,),
                SizedBox(width: 8,),
                Text('History'.tr)
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
                //jsonAssetDirectory: "assets/json/healthydays.json",
                surveys: controller.allSurveys,
                //showSerialNumber: false,
                isTabStyle: true,
                tabContents: [
                  TabPage(id: "t1", title: "GENERAL".tr, listOfQuestionUid: controller.customer.value.isFamilyMember? ['as9_1', 'as9_15']: ['as9_1', 'as9_15', 'as9_16', 'as9_17']),
                  TabPage(id: "t2", title: "SUBSCRIPTION STATUS".tr, listOfQuestionUid: ['as9_18','as9_2', 'as9_3', 'as9_4', 'as9_5'], isTabVisible: !controller.customer.value.isFamilyMember),
                  TabPage(id: "t3", title: "SOCIAL PROTECTION".tr, listOfQuestionUid: ['as9_6', 'as9_7','as9_7.1','as9_7.2', 'as9_8', 'as9_9', 'as9_10', 'as9_11', 'as9_12', 'as9_13', 'as9_14'],),
                ],
                selectedSurvey: controller.selectedSurvey.value,
                onSelectSurvey: (SurveyDto? selectedSurvey){
                  controller.selectedSurvey.value = selectedSurvey;
                },
                onSelectAnswer: (val){

                },
                onSubmit: (selectedGeoup, formMap){
                  print('onSubmit');
                  controller.submitSurvey(selectedGeoup, formMap);
                }
              ),
            ),
          ),
        ]
      ),
    );
  }



  @override
  void loadDependentLogics() {
    Get.put(CheSocialProtectionLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return CheSocialProtectionI18N.getTranslations();
  }
}





