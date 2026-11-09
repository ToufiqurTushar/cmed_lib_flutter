import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/page/rgp/household_survey_argument.dart';
import 'package:cmed_lib_flutter/survey/dto/field_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../common/api/api_url.dart';
import '../../common/base/base_logic.dart';
import '../../common/widget/app_dialog.dart';
import '../../survey/dto/Condition.dart';
import 'dto/HouseholdSurveyRequestDto.dart';
import 'dto/ProfileMemberData.dart';
import 'dto/SurveyResultResponse.dart';

class HouseholdSurveyLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  var selectedSurveyResult = Rxn<SurveyResultDto>();
  late HouseholdSurveyArg householdSurveyArg;

  @override
  void onInit() {
    super.onInit();
    householdSurveyArg = (Get.arguments as HouseholdSurveyArg);
    selectedSurvey.value = householdSurveyArg.selectedSurvey;
    fetchSurveyData();
  }

  fetchSurveyData() async {
    isLoading.value = true;
    await httpProvider.GET(ApiUrl.getLastHouseholdSurveyUrl(householdId: customer.value.householdId!, userId: customer.value.userId!)).then((response) {
      if (response.isOk && response.statusCode == 200) {
        final results = SurveyResultResponseDto.fromJson(response.body).content;
        if(results?.isNotEmpty??false){
          selectedSurveyResult.value = results!.first;
        }
        //RLog.error(response.body);
      }
    });
    httpProvider.GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.HOUSEHOLD_SURVEY.name)).then((response) {
      if (response.isOk) {
        allSurveys.value = SurveyDataResponseDto.fromJson(response.body).content!;
        //set default value if exist
        if(selectedSurveyResult.value != null){
          allSurveys.first.fields!.forEach((eachField){
            try{
              eachField.defaultValue = selectedSurveyResult.value!.inputs[eachField.name];
            } catch (e){
              RLog.error(e);
            }
          });
        }
        selectedSurvey.value = allSurveys.first;
        // modify visibility condition
        selectedSurvey.value!.fields!.forEach((field) {
          FieldCondition(hide: true, operator: FBConditionType.isHidden.name);
        });
        RLog.info(selectedSurvey.value!.toJson());
      }
    }).catchError((error) {

    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  void submitSurvey(SurveyDto selectedSurveyDto, Map<String, dynamic> formMap) {
    final surveyResultData = HouseholdSurveyRequestDto(
        surveyId: selectedSurveyDto.id,
        userId: customer.value.userId,
        surveyName: selectedSurveyDto.name,
        surveyOn: DateTime.now().millisecondsSinceEpoch,
        inputs: formMap,
        profileMemberData: ProfileMemberData(
          householdId: customer.value.householdId!
        )
    );
    globalState.showBusy();
    RLog.info(surveyResultData.toJson());
    httpProvider.POST(ApiUrl.postHouseholdSurveyUrl(), surveyResultData.toJson()).then((response) {
      globalState.hideBusy();
      isLoading.value = false;
      if (response.isOk) {
        SurveyResultItemDto surveyResultItemDto = SurveyResultItemDto.fromJson(response.body);
        RLog.error(response.body);
        RLog.error(selectedSurveyDto.toJson());
        AppDialogs.showSingleButtonDialog(centerImageUrl: 'assets/images/ic_success.svg', 'Survey Completed Successfully'.tr, positiveButtonText: 'OK'.tr, cancelable: false,onButtonClick:(){
          Get.back();
        });
      } else {
        ShowToast.error(response.body.toString());
      }
    });
  }

  Future<bool> modifyAddHouseholdSurveyQuestionOptions(Map<String, dynamic> answers) async {
    return true;
  }
}

