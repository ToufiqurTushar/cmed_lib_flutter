import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/survey/widget/item_survey_result.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../common/widget/basic_app_bar.dart';
import '../result/healthy_days_result_argument.dart';
import '../result/healthy_days_result_view.dart';
import 'healthy_days_history_list_logic.dart';


class HealthyDaysHistoryListView extends RapidView<HealthyDaysListLogic> {
  static const routeName = '/HealthyDaysHistoryListView';
  final bool showAppTitle;
  HealthyDaysHistoryListView({super.key, this.showAppTitle = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showAppTitle?BasicAppBar("Healthy Days".tr): null,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                ()=> builListContainer(context),
              ),
            ),
          ]
      ),

    );
  }

  builListContainer(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount:controller.surveyResultList.length,
              itemBuilder: (context, index) {
                var surveyDto = controller.surveyResultList[index];
                var title = surveyDto.surveyName!;
                var subtitle = surveyDto.result!.status!;
                var date = CustomDateUtils.format(surveyDto.surveyOn??DateTime.now().millisecondsSinceEpoch, format:CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDigit();
                // return Text('1');
                return SurveyResultItemWidget(
                    context: context,
                    title: title,
                    subtitle: subtitle,
                    color: surveyDto.result!.colorCode!.toColor(),
                    icon: surveyDto.icon??"",
                    date: date ,
                    onTap:(){
                      Get.toNamed(HealthyDaysResultView.routeName, arguments: HealthyDaysResultArgument(isFromHistory: true, selectedSurveyResult: surveyDto));
                    }
                );
              }
          ),
        ),
        Visibility(
          visible: !controller.globalState.isSystemBusy.value && controller.surveyResultList.isEmpty,
          child: Align(
            alignment: Alignment.center,
            child: Text('Empty'.tr),
          ),
        )
      ],
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
    Get.lazyPut<HealthyDaysListLogic>(() => HealthyDaysListLogic(),);
  }
}
