import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/api/api_url.dart';
import '../../../common/base/base_logic.dart';
import 'health_assessment_argument.dart';
import 'npage/result/health_assessment_result_argument.dart';
import 'npage/result/health_assessment_result_view.dart';


class HealthAssessmentLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  late HealthAssessmentArgument healthAssessmentArgument;

  @override
  void onInit() {
    super.onInit();
    healthAssessmentArgument = (Get.arguments as HealthAssessmentArgument);
    selectedSurvey.value = healthAssessmentArgument.selectedSurvey;
    fetchSurveyData();
  }

  fetchSurveyData() {
    isLoading.value = true;
    Get.find<HttpProvider>().GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.HEALTH_ASSESSMENT.name)).then((response) {
      if (response.isOk) {
        allSurveys.addAll(SurveyDataResponseDto.fromJson(response.body).content??[]);
        RLog.error(response.body);
      }
    }).catchError((error) {

    }).whenComplete(() {
      isLoading.value = false; // Hide loader after API call
    });
  }

  void submitSurvey(SurveyDto selectedSurveyDto, Map<String, dynamic> formMap) {
    final surveyResultData = SurveyResultItemDto(
        surveyId: selectedSurveyDto.id,
        userId: customer.value.userId,
        surveyName: selectedSurveyDto.name,
        surveyOn: DateTime.now().millisecondsSinceEpoch,
        inputs: formMap
    );
    globalState.showBusy();
    Get.find<HttpProvider>().POST(ApiUrl.postSurveyUrl(), surveyResultData.toJson()).then((response) {
      globalState.hideBusy();
      isLoading.value = false;
      if (response.isOk) {
        SurveyResultItemDto surveyResultItemDto = SurveyResultItemDto.fromJson(response.body);
        RLog.error(response.body);
        RLog.error(selectedSurveyDto.toJson());
        Future.delayed(Duration.zero, () async {
          Get.offNamed(HealthAssessmentResultView.routeName, arguments: HealthAssessmentResultArgument(isFromHistory: false, selectedSurveyResult: surveyResultItemDto, selectedSurvey: selectedSurveyDto));
        });
      }
    });
  }
}