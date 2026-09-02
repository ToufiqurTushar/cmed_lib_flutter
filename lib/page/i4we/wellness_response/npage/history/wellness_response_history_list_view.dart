import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/survey/widget/item_survey_result.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../common/widget/basic_app_bar.dart';

import 'wellness_response_history_list_logic.dart';
import '../../wellness_response_view.dart';
import '../../wellness_response_argument.dart';


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
                var subtitle = surveyDto.result?.status??"";
                var date = CustomDateUtils.format(surveyDto.surveyOn??DateTime.now().millisecondsSinceEpoch, format:CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDigit();
                return SurveyResultItemWidget(
                    context: context,
                    title: title,
                    subtitle: subtitle,
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
    Get.lazyPut<WellnessResponseHistoryListLogic>(() => WellnessResponseHistoryListLogic(),);
  }
}


