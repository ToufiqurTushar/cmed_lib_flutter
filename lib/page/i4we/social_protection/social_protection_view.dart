import 'package:cmed_lib_flutter/page/i4we/social_protection/social_peotection_i18n.dart';
import 'package:cmed_lib_flutter/page/i4we/social_protection/social_peotection_logic.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/tab_page.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/widget/basic_app_bar.dart';
import '../../../survey/dto/Condition.dart';


class SocialProtectionView extends RapidView<SocialProtectionLogic> {
  static String routeName = "/SocialProtectionView";

  const SocialProtectionView({super.key});

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
                //Icon(Icons.history, color: Theme.of(context).primaryColor, size: 26,),
                //SizedBox(width: 8,),
                //Text('History'.tr)
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
                showSerialNumber: true,
                isTabStyle: true,
                hideTabView: true,
                tabContents: [
                  TabPage(id: "t1", title: "".tr, listOfQuestionUid: ['sp14_1']),
                  TabPage(id: "t2", title: "".tr, listOfQuestionUid: ['sp14_2', 'sp14_3', 'sp14_4', 'sp14_5', 'sp14_6', 'sp14_7', 'sp14_8', 'sp14_9', 'sp14_11', 'sp14_12']),
                ],
                selectedSurvey: controller.selectedSurvey.value,
                onSelectSurvey: (SurveyDto? selectedSurvey){
                  controller.selectedSurvey.value = selectedSurvey;
                },
                onSelectAnswer: (String fieldName, val){
                  print(val);
                },
                beforeNext: (answers) async {
                  final result = await controller.modifyAddSocialProtectionQuestionOptions(answers);
                  return result;
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
    Get.put(SocialProtectionLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return SocialProtectionI18N.getTranslations();
  }
}





