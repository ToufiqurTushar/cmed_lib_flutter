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
                surveys: controller.allSurveys,
                showSerialNumber: false,
                isTabStyle: false,
                hideTabView: true,
                selectedSurvey: controller.selectedSurvey.value,
                onSelectSurvey: (SurveyDto? selectedSurvey){
                  controller.selectedSurvey.value = selectedSurvey;
                },
                onSelectAnswer: (String fieldName, val){
                  print(val);
                },
                beforeNext: (answers) async {
                  final result = await controller.modifyAddHouseholdSurveyQuestionOptions(answers);
                  return result;
                },
                onSubmit: (selectedGroup, formMap){
                  print('onSubmit');
                  controller.submitSurvey(selectedGroup, formMap);
                }
              ),
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

