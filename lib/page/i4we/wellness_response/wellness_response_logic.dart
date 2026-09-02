import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/base/base_logic.dart';
import 'wellness_response_argument.dart';
import 'npage/result/wellness_response_result_argument.dart';
import 'npage/result/wellness_response_result_view.dart';
import '../../../common/widget/app_dialog.dart';

class WellnessResponseLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  var  wellnessResponseArgument = WellnessResponseArgument();

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
      wellnessResponseArgument = (Get.arguments as WellnessResponseArgument);
      selectedSurvey.value = wellnessResponseArgument.selectedSurvey;
    }
    fetchSurveyData();
    RLog.error(wellnessResponseArgument.isFromHistory??false);
  }

  fetchSurveyData() {
    isLoading.value = true;
    httpProvider.GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.WELLNESS_RESPONSE.name)).then((response) {
      if (response.isOk) {
        allSurveys.addAll(SurveyDataResponseDto.fromJson(response.body).content??[]);
        selectedSurvey.value = allSurveys.first;
        RLog.error(response.body);
        //set default value if exist
        final selectedSurveyResult = wellnessResponseArgument.surveyResultItemDto;
        if(selectedSurveyResult != null){
          RLog.error(selectedSurveyResult.toJson());
          allSurveys.first.fields!.forEach((eachField){
            try{
              eachField.defaultValue = selectedSurveyResult!.inputs[eachField.name];
            } catch (e){
              RLog.error(e);
            }
          });
        }
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
        AppDialogs.showSingleButtonDialog(centerImageUrl: 'assets/images/ic_wellness_response.svg', 'Survey Completed Successfully'.tr, positiveButtonText: 'OK'.tr, cancelable: false,onButtonClick:(){
          if(wellnessResponseArgument.redirectToServiceSelectionView??false) {
            Get.offNamedUntil(
              '/ServiceSelectionView',
              ModalRoute.withName('/ServiceView'),
              arguments: customer,
            );
          } else{
            Get.back();
          }
        });
        // Future.delayed(Duration.zero, () async {
        //   Get.offNamed(WellnessResponseResultView.routeName, arguments: WellnessResponseResultArgument(isFromHistory: false, selectedSurveyResult: surveyResultItemDto, selectedSurvey: selectedSurveyDto));
        // });
      } else if(response.statusCode == 400){
        ShowToast.error(response.body);
      }
    });
  }
}