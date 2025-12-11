import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/base/base_logic.dart';
import 'healthy_days_argument.dart';
import 'npage/result/healthy_days_result_argument.dart';
import 'npage/result/healthy_days_result_view.dart';


class HealthyDaysLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  late HealthyDaysArgument healthyDaysArgument;

  @override
  void onInit() {
    super.onInit();
    healthyDaysArgument = (Get.arguments as HealthyDaysArgument);
    selectedSurvey.value = healthyDaysArgument.selectedSurvey;
    fetchSurveyData();
  }

  fetchSurveyData() {
    isLoading.value = true;
    Get.find<HttpProvider>().GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.HEALTHY_DAYS.name)).then((response) {
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
          Get.offNamed(HealthyDaysResultView.routeName, arguments: HealthyDaysResultArgument(isFromHistory: false, selectedSurveyResult: surveyResultItemDto, selectedSurvey: selectedSurveyDto));
        });
      } else if(response.statusCode == 400){
        ShowToast.error(response.body);
      }
    });
  }
}