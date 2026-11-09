import 'package:cmed_lib_flutter/page/rgp/npage/result/household_survey_result_argument.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../common/base/base_logic.dart';

class HouseholdSurveyResultLogic extends BaseLogic {
  final isHistoryView = false.obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  late HouseholdSurveyResultArgument householdSurveyResultArgument;

  @override
  void onInit() {
    super.onInit();
    householdSurveyResultArgument = (Get.arguments as HouseholdSurveyResultArgument);
    isHistoryView.value = householdSurveyResultArgument.isFromHistory;
    selectedSurveyResult.value = householdSurveyResultArgument.selectedSurveyResult;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void remeasure() {
    //Get.offNamed(HouseholdSurveyView.routeName, arguments: HouseholdSurveyArg(selectedSurvey: householdSurveyResultArgument.selectedSurvey, customer: customer.value));
  }
}

