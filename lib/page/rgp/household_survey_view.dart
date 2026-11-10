import 'package:cmed_lib_flutter/page/rgp/household_survey_i18n.dart';
import 'package:cmed_lib_flutter/page/rgp/household_survey_logic.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/tab_page.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../common/widget/basic_app_bar.dart';
import '../../survey/dto/Condition.dart';

class HouseholdSurveyView extends RapidView<HouseholdSurveyLogic> {
  static String routeName = "/HouseholdSurveyView";

  const HouseholdSurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Household Survey".tr, trailingWidget: InkWell(
        onTap: () {
          //Get.toNamed(HouseholdSurveyHistoryListView.routeName);
        },
        child: Visibility(
          visible: controller.selectedSurvey.value == null,
          child: const Padding(
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
              const Center(child: CircularProgressIndicator()):
              SurveyManagerWidget(
                //jsonAssetDirectory: "assets/json/healthydays.json",
                  surveys: controller.allSurveys,
                  showSerialNumber: true,
                  isTabStyle: true,
                  hideTabView: false,
                  tabContents: [
                    TabPage(id: "t1", title: "Survey".tr, listOfQuestionUid: ['hs_18_survey_date', 'hs_18_1_safe_water', 'hs_18_2_sanitary_latrine', 'hs_18_3_bondhu_chula', 'hs_18_4_solar_panel', 'hs_18_5_electricity', 'hs_18_6_backyard_vegetables', 'hs_18_7_iodized_salt', 'hs_18_8_nid', 'hs_18_10_bcn', 'hs_18_12_health_card', 'hs_18_13_health_card_issue_date', 'hs_18_14_monthly_income', 'hs_18_15_monthly_health_expense', 'hs_18_16_pregnant', 'hs_18_18_diabetes', 'hs_18_20_high_bp', 'hs_18_22_kidney', 'hs_18_24_cancer', 'hs_18_26_low_bp', 'hs_18_28_malnutrition_u5', 'hs_18_30_eye', 'hs_18_32_ear', 'hs_18_34_pneumonia', 'hs_18_36_diarrhea', 'hs_18_38_hepatitis', 'hs_18_40_paralysis', 'hs_18_42_other_complicated', 'hs_18_44_total_patient']),
                    TabPage(id: "t2", title: "Health Information".tr, listOfQuestionUid: controller.householdSurveyCountKeys),
                  ],
                  selectedSurvey: controller.selectedSurvey.value,
                  onSelectSurvey: (SurveyDto? selectedSurvey){
                    controller.selectedSurvey.value = selectedSurvey;
                  },
                  onSelectAnswer: (String fieldName, val){
                    print("fieldName $fieldName: $val");
                  },
                  // beforeNext: (answers) async {
                  //   final result = await controller.modifyAddSocialProtectionQuestionOptions(answers);
                  //   return result;
                  // },
                  onSubmit: (selectedGeoup, formMap){
                    print('onSubmit');
                    controller.submitSurvey(selectedGeoup, formMap);
                  }
              ),
              // SurveyManagerWidget(
              //   surveys: controller.allSurveys,
              //   showSerialNumber: true,
              //   isTabStyle: false,
              //   hideTabView: true,
              //   selectedSurvey: controller.selectedSurvey.value,
              //   onSelectSurvey: (SurveyDto? selectedSurvey){
              //     controller.selectedSurvey.value = selectedSurvey;
              //   },
              //   onSelectAnswer: (String fieldName, val){
              //     print("fieldName $fieldName: $val");
              //   },
              //   // beforeNext: (answers) async {
              //   //   final result = await controller.modifyAddHouseholdSurveyQuestionOptions(answers);
              //   //   return result;
              //   // },
              //   onSubmit: (selectedGroup, formMap){
              //     print('onSubmit');
              //     controller.submitSurvey(selectedGroup, formMap);
              //   }
              // ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void loadDependentLogics() {
    Get.put(HouseholdSurveyLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return HouseholdSurveyI18N.getTranslations();
  }
}

