import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/tab_page.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/widget/basic_app_bar.dart';
import 'anemia_survey_i18n.dart';
import 'anemia_survey_logic.dart';
import 'npage/history/anemia_survey_history_list_view.dart';


class AnemiaSurveyView extends RapidView<AnemiaSurveyLogic> {
  static String routeName = "/AnemiaSurveyView";

  const AnemiaSurveyView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Anemia".tr, trailingWidget: InkWell(
        onTap: () {
          Get.toNamed(AnemiaSurveyHistoryListView.routeName);
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
          // Obx(
          //   ()=> LayoutCustomerHeader(
          //     item: controller.selectedCustomerDto.value,
          //     // buttonBesideName: InkWell(
          //     //   onTap: (){
          //     //     Get.toNamed(AnemiaSurveyHistoryListView.routeName, arguments: controller.customer);
          //     //   },
          //     //   child: const Visibility(
          //     //     visible: true,
          //     //     child: Padding(
          //     //       padding: EdgeInsets.only(right: 8.0),
          //     //       child: Row(
          //     //         children: [
          //     //           Icon(Icons.history, color: Theme.of(context).primaryColor, size: 26,),
          //     //           SizedBox(width: 8,),
          //     //           Text('History')
          //     //         ],
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //     showFamilyIcon: false, // Pass false to hide the family icon
          //   ),
          // ),
          // const SizedBox(height: 12.0),
          Expanded(
            child: Obx(
              ()=> controller.isLoading.value?
              Center(child: CircularProgressIndicator()):
              SurveyManagerWidget(
                //jsonAssetDirectory: "assets/json/healthydays.json",
                surveys: controller.allSurveys,
                showSerialNumber: false,
                isTabStyle: true,
                tabContents: [
                  TabPage(id: "t1", title: "High-Risk Group Flags".tr, listOfQuestionUid: controller.customer.value.gender == 2 && controller.customer.value.getAgeInYear() >= 9 && controller.customer.value.getAgeInYear() < 50? ['aa1_1', 'aa1_2', 'aa1_3']: ['aa1_3'], isTabVisible: true),
                  TabPage(id: "t2", title: "Symptom Screening".tr, listOfQuestionUid: ['aa2_1','aa2_2', 'aa2_3', 'aa2_4', 'aa2_5'], isTabVisible: true),
                  TabPage(id: "t3", title: "Dietary Risk".tr, listOfQuestionUid: ['aa3_1','aa3_2'], isTabVisible: true),
                ],
                selectedSurvey: controller.selectedSurvey.value,
                onSelectSurvey: (SurveyDto? selectedSurvey){
                  controller.selectedSurvey.value = selectedSurvey;
                },
                onSelectAnswer: (String fieldName, val){

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
    Get.put(AnemiaSurveyLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return AnemiaSurveyI18N.getTranslations();
  }
}








