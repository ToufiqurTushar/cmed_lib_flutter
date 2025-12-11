import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/survey_manager_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/widget/basic_app_bar.dart';
import 'healthy_days_i18n.dart';
import 'healthy_days_logic.dart';


class HealthyDaysView extends RapidView<HealthyDaysLogic> {
  static String routeName = "/HealthyDaysView";

  const HealthyDaysView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Healthy Days".tr),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Obx(
          //   ()=> LayoutCustomerHeader(
          //     item: controller.selectedCustomerDto.value,
          //     // buttonBesideName: InkWell(
          //     //   onTap: (){
          //     //     Get.toNamed(HealthyDaysHistoryListView.routeName, arguments: controller.customer);
          //     //   },
          //     //   child: const Visibility(
          //     //     visible: true,
          //     //     child: Padding(
          //     //       padding: EdgeInsets.only(right: 8.0),
          //     //       child: Row(
          //     //         children: [
          //     //           Icon(Icons.history, color: AppColor.primaryColor, size: 26,),
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
    Get.put(HealthyDaysLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return HealthyDaysI18N.getTranslations();
  }
}





