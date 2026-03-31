import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../common/base/base_logic.dart';
import 'health_assessment_result_argument.dart';


class CheSocialProtectionResultLogic extends BaseLogic {
  final isHistoryView = false.obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  late HealthAssessmentResultArgument healthAssessmentResultArgument;

  @override
  void onInit() {
    super.onInit();
    healthAssessmentResultArgument = (Get.arguments as HealthAssessmentResultArgument);
    isHistoryView.value = healthAssessmentResultArgument.isFromHistory;
    selectedSurveyResult.value = healthAssessmentResultArgument.selectedSurveyResult;
  }



  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
  }

  void remeasure() {
    //Get.offNamed(HealthAssessmentView.routeName, arguments: HealthAssessmentArgument(selectedSurvey: healthAssessmentResultArgument.selectedSurvey));
  }
}
