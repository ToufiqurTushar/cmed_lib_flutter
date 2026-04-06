import 'package:cmed_lib_flutter/page/i4we/social_protection/npage/result/social_peotection_result_argument.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../common/base/base_logic.dart';



class SocialProtectionResultLogic extends BaseLogic {
  final isHistoryView = false.obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  late SocialProtectionResultArgument socialProtectionResultArgument;

  @override
  void onInit() {
    super.onInit();
    socialProtectionResultArgument = (Get.arguments as SocialProtectionResultArgument);
    isHistoryView.value = socialProtectionResultArgument.isFromHistory;
    selectedSurveyResult.value = socialProtectionResultArgument.selectedSurveyResult;
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
