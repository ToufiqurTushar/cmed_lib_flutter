import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/widget/item_survey_result.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'household_survey_history_list_logic.dart';

class HouseholdSurveyHistoryListView extends RapidView<HouseholdSurveyListLogic> {
  static const routeName = '/HouseholdSurveyHistoryListView';
  final bool showAppTitle;
  HouseholdSurveyHistoryListView({super.key, this.showAppTitle = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Household Survey".tr, showTitleBar: showAppTitle),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(
              () => buildListContainer(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListContainer(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: controller.surveyHistoryList.isNotEmpty
                ? controller.surveyHistoryList.length
                : controller.surveyResultList.length,
            itemBuilder: (context, index) {
              var surveyDto = controller.surveyHistoryList.isNotEmpty
                  ? (controller.surveyHistoryList[index].survey ?? SurveyResultItemDto())
                  : controller.surveyResultList[index];
              var title = (surveyDto.surveyName != null && surveyDto.surveyName!.isNotEmpty)
                  ? surveyDto.surveyName!.tr
                  : "Household Survey".tr;
              var subtitle = (surveyDto.result?.status != null && surveyDto.result!.status!.isNotEmpty)
                  ? surveyDto.result!.status!.tr
                  : "";
              var date = CustomDateUtils.format(
                surveyDto.surveyOn ?? DateTime.now().millisecondsSinceEpoch,
                format: CustomDateUtils.HH_MM_A_DD_MMM_YYYY,
              ).trDigit();
              var color = (surveyDto.result?.colorCode != null && surveyDto.result!.colorCode!.isNotEmpty)
                  ? surveyDto.result!.colorCode!.toColor()
                  : Theme.of(context).primaryColor;

              return SurveyResultItemWidget(
                context: context,
                title: title,
                subtitle: subtitle,
                color: color,
                serverImage: surveyDto.icon ?? "",
                defaultImage: "assets/swasti/images/ic_social_protection.svg",
                date: date,
                onTap: () {
                  controller.openSurveyHistoryDetails(index);
                },
              );
            },
          ),
        ),
        Visibility(
          visible: !controller.globalState.isSystemBusy.value &&
              controller.surveyHistoryList.isEmpty &&
              controller.surveyResultList.isEmpty,
          child: Align(
            alignment: Alignment.center,
            child: Text('Empty'.tr),
          ),
        ),
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
    Get.lazyPut<HouseholdSurveyListLogic>(
      () => HouseholdSurveyListLogic(),
    );
  }
}

