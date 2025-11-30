import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:cmed_lib_flutter_example/app_http.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

class TestSurveyLogic extends RapidStartLogic {
  var isLoading = false.obs;
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  var userId = 4216884;

  @override
  void onInit() {
    super.onInit();

    fetchSurveyData();
  }

  fetchSurveyData() {
    isLoading.value = true;
    Get.find<Http>().GET('api/v1/survey/rules?type=${SurveyTypeEnum.HEALTHY_DAYS.name}&page=0&size=100').then((response) {
      if (response.isOk) {
        allSurveys.addAll(SurveyDataResponseDto.fromJson(response.body).content??[]);
        selectedSurvey.value = allSurveys.first;
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
        userId: userId,
        surveyName: selectedSurveyDto.name,
        surveyOn: DateTime.now().millisecondsSinceEpoch,
        inputs: formMap
    );
    globalState.showBusy();
    Get.find<Http>().POST('api/v1/survey/submit', surveyResultData.toJson()).then((response) {
      globalState.hideBusy();
      isLoading.value = false;
      if (response.isOk) {
        SurveyResultItemDto surveyResultItemDto = SurveyResultItemDto.fromJson(response.body);
        RLog.error(response.body);
        RLog.error(surveyResultItemDto.toJson());
      } else {
        ShowToast.error('');
      }
    });
  }
}