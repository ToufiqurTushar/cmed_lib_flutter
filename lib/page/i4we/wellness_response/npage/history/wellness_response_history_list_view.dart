import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/survey/widget/item_survey_result.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../common/widget/basic_app_bar.dart';

import 'wellness_response_history_list_logic.dart';
import '../../wellness_response_view.dart';
import '../../wellness_response_argument.dart';
import 'package:age_calculator/age_calculator.dart';


class WellnessResponseHistoryListView extends RapidView<WellnessResponseHistoryListLogic> {
  static const routeName = '/WellnessResponseHistoryListView';
  final bool showAppTitle;
  WellnessResponseHistoryListView({super.key, this.showAppTitle = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Wellness Response".tr, showTitleBar:showAppTitle),
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
                var date = CustomDateUtils.format(surveyDto.surveyOn??DateTime.now().millisecondsSinceEpoch, format:CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDigit();
                var daysAgo = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(surveyDto.surveyOn!)).inDays;
                var subtitle = "${daysAgo} days ago";
                if(daysAgo == 0){
                  subtitle = "Today".tr;
                } else if(daysAgo == 2){
                  subtitle = "Yesterday".tr;
                } else {
                  subtitle = formatAgeAgo(DateTime.fromMillisecondsSinceEpoch(DateTime.now().subtract(Duration(days: 200)).millisecondsSinceEpoch));
                }
                return SurveyResultItemWidget(
                    context: context,
                    title: title,
                    subtitle: subtitle.toString(),
                    color: Theme.of(context).primaryColor,
                    serverImage: "",
                    defaultImage: 'assets/images/ic_wellness_response.svg',
                    date: date ,
                    onTap:(){
                      Get.toNamed(WellnessResponseView.routeName, arguments: WellnessResponseArgument(isFromHistory: true, surveyResultItemDto: surveyDto));
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

  String formatAgeAgo(DateTime date) {
    DateDuration age = AgeCalculator.age(date);
    if(age.years == 0 && age.months == 0) {
      return 'day_ago'.trParams({
        'days': age.days.toString(),
      });
    } else if(age.years == 0) {
      return 'month_day_ago'.trParams({
        'months': age.months.toString(),
        'days': age.days.toString(),
      });
    }
    return 'year_month_day_ago'.trParams({
      'years': age.years.toString(),
      'months': age.months.toString(),
      'days': age.days.toString(),
    });
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {
      'en': {
        'year_month_day_ago': '@years years @months months and @days days ago',
        'month_day_ago': '@months months and @days days ago',
        'day_ago': '@days days ago',
      },
      'bn': {
        'year_month_day_ago': '@years বছর @months মাস এবং @days দিন আগে',
        'month_day_ago': '@months মাস এবং @days দিন আগে',
        'day_ago': '@days দিন আগে',
      }
    };
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.lazyPut<WellnessResponseHistoryListLogic>(() => WellnessResponseHistoryListLogic(),);
  }
}


