import 'dart:convert';

import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/api/api_url.dart';
import '../../../common/base/base_logic.dart';


class UserManagementLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchSurveyData();
  }

  fetchSurveyData() async {
    showLoader();
    final String jsonStr = await rootBundle.loadString("assets/json/usermanagement.json");
    RLog.warning(jsonStr);
    final dynamic jsonData = json.decode(jsonStr);
    allSurveys.addAll(SurveyDataResponseDto.fromJson(jsonData).content??[]);
    selectedSurvey.value = allSurveys.first;
    hideLoader();
  }

  void submitSurvey(SurveyDto selectedSurveyDto, Map<String, dynamic> formMap) {
    final surveyResultData = SurveyResultItemDto(
        surveyId: selectedSurveyDto.id,
        userId: customer.value.userId,
        surveyName: selectedSurveyDto.name,
        surveyOn: DateTime.now().millisecondsSinceEpoch,
        inputs: formMap
    );
    showLoader();
    httpProvider.POST(ApiUrl.getCustomProfileByUserIdUrl(customer.value.userId), surveyResultData.toJson()).then((response) {
      hideLoader();
      if (response.isOk) {
        RLog.error(response.body);
        RLog.error(selectedSurveyDto.toJson());
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    });
  }
}