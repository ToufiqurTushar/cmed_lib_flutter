import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../common/base/base_logic.dart';
import '../../anemia_survey_argument.dart';
import '../../anemia_survey_view.dart';
import 'anemia_survey_result_argument.dart';


class AnemiaSurveyResultLogic extends BaseLogic {
  final isHistoryView = false.obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  late AnemiaSurveyResultArgument anemiaSurveyResultArgument;

  @override
  void onInit() {
    super.onInit();
    anemiaSurveyResultArgument = (Get.arguments as AnemiaSurveyResultArgument);
    isHistoryView.value = anemiaSurveyResultArgument.isFromHistory;
    selectedSurveyResult.value = anemiaSurveyResultArgument.selectedSurveyResult;
  }



  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
  }

  void remeasure() {
    Get.offNamed(AnemiaSurveyView.routeName, arguments: AnemiaSurveyArgument(selectedSurvey: anemiaSurveyResultArgument.selectedSurvey, customer: customer.value));
  }
}
