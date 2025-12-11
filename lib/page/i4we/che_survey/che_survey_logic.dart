import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/api/api_url.dart';
import '../../../common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import '../../../common/widget/app_dialog.dart';
import 'che_survey_argument.dart';


class CheSurveyLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  late CheSurveyArgument cheSurveyArgument;

  @override
  void onInit() {
    super.onInit();
    cheSurveyArgument = (Get.arguments as CheSurveyArgument);
    selectedSurvey.value = cheSurveyArgument.selectedSurvey;
    fetchSurveyData();
  }

  fetchSurveyData() {
    isLoading.value = true;
    Get.find<HttpProvider>().GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.AGENT_SUBSCRIPTION.name)).then((response) {
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
        AppDialogs.showSingleButtonDialog(centerImageUrl: 'assets/images/ic_success.svg', 'Survey Completed successfully', positiveButtonText: 'OK', cancelable: false,onButtonClick:(){
          if(cheSurveyArgument.redirectToServiceSelectionView??false) {
            globalState.currentUser.value = customer;
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
        //   Get.offNamed(CheSurveyResultView.routeName, arguments: CheSurveyResultArgument(isFromHistory: false, selectedSurveyResult: surveyResultItemDto, selectedSurvey: selectedSurveyDto, customer: customer));
        // });
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    });
  }
}