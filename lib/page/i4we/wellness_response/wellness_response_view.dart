import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/widget/basic_app_bar.dart';
import 'wellness_response_i18n.dart';
import 'wellness_response_logic.dart';
import 'npage/history/wellness_response_history_list_view.dart';

class WellnessResponseView extends RapidView<WellnessResponseLogic> {
  static String routeName = "/WellnessResponseView";

  const WellnessResponseView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Wellness Response".tr, trailingWidget: InkWell(
          onTap: () {
            Get.toNamed(WellnessResponseHistoryListView.routeName);
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
          )
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12.0),
          Expanded(
            child: Obx(
              ()=> controller.isLoading.value?
              Center(child: CircularProgressIndicator()):
              SurveyManagerWidget(
                //jsonAssetDirectory: "assets/json/WellnessResponse.json",
                surveys: controller.allSurveys,
                showSerialNumber: true,
                selectedSurvey: controller.selectedSurvey.value,
                onSelectSurvey: (SurveyDto? selectedSurvey){
                  controller.selectedSurvey.value = selectedSurvey;
                },
                onSelectAnswer: (String fieldName, val){

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
    Get.put(WellnessResponseLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return WellnessResponseI18N.getTranslations();
  }
}





