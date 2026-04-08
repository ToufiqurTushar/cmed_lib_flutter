import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/page/i4we/social_protection/social_protection_argument.dart';
import 'package:cmed_lib_flutter/survey/dto/field_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/api/api_url.dart';
import '../../../common/base/base_logic.dart';
import '../../../common/widget/app_dialog.dart';
import '../../../survey/dto/Condition.dart';
import 'dto/SurveyResultResponse.dart';


class SocialProtectionLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  var selectedSurveyResult = Rxn<SurveyResultDto>();
  late SocialProtectionArg socialProtectionArg;

  @override
  void onInit() {
    super.onInit();
    socialProtectionArg = (Get.arguments as SocialProtectionArg);
    selectedSurvey.value = socialProtectionArg.selectedSurvey;
    fetchSurveyData();
  }

  fetchSurveyData() async {
    isLoading.value = true;
    await httpProvider.GET(ApiUrl.getAgentSocialProtectionRulesByUserIdUrl(customer.value.userId!)).then((response) {
      if (response.isOk) {
        final results = SurveyResultResponseDto.fromJson(response.body).content;
        if(results?.isNotEmpty??false){
          selectedSurveyResult.value = results!.first;
        }
        RLog.error(response.body);
      }
    });
    httpProvider.GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.SOCIAL_PROTECTION.name)).then((response) {
      if (response.isOk) {
        allSurveys.addAll(SurveyDataResponseDto.fromJson(response.body).content??[]);
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
    final surveyResultData = SurveyResultItemDto(
        surveyId: selectedSurveyDto.id,
        userId: customer.value.userId,
        surveyName: selectedSurveyDto.name,
        surveyOn: DateTime.now().millisecondsSinceEpoch,
        inputs: formMap
    );
    globalState.showBusy();
    httpProvider.POST(ApiUrl.postSurveyUrl(), surveyResultData.toJson()).then((response) {
      globalState.hideBusy();
      isLoading.value = false;
      if (response.isOk) {
        SurveyResultItemDto surveyResultItemDto = SurveyResultItemDto.fromJson(response.body);
        RLog.error(response.body);
        RLog.error(selectedSurveyDto.toJson());
        // Future.delayed(Duration.zero, () async {
        //   Get.offNamed(CheSurveyResultView.routeName, arguments: CheSurveyResultArgument(isFromHistory: false, selectedSurveyResult: surveyResultItemDto, selectedSurvey: selectedSurveyDto, customer: customer));
        // });
        AppDialogs.showSingleButtonDialog(centerImageUrl: 'assets/images/ic_success.svg', 'Survey Completed successfully', positiveButtonText: 'OK', cancelable: false,onButtonClick:(){
          Get.back();
        });
      } else {
        ShowToast.error(response.body.toString());
      }
    });
  }


  Future<bool> modifyAddSocialProtectionQuestionOptions(Map<String, dynamic> answers) async {
    globalState.showBusy();
    final civicIdsFieldName = 'sp14_1';
    final socialProtectionFieldName = 'sp14_3';
    final socialProtectionField = selectedSurvey.value!.fields!.firstWhere((m) => m.name == socialProtectionFieldName);
    socialProtectionField.visibilityConditions = socialProtectionField.visibilityConditions??[];


      final response = await httpProvider.GET(
        ApiUrl.socialProtectionEligibility(
          civicIds: answers[civicIdsFieldName]??[],
          userId: customer.value.userId!,
        ),
      );
      globalState.hideBusy();

      if (response.isOk) {
        List<FieldOption> eligibleOptions = FieldOption.fromJsonList(response.body);
        if(eligibleOptions.isEmpty){
          socialProtectionField.required = false;
          socialProtectionField.defaultValue = null;
          socialProtectionField.options = [];
        } else {
          socialProtectionField.required = true;
          if(!eligibleOptions.map((e)=>e.value).contains(socialProtectionField.defaultValue)){
            socialProtectionField.defaultValue = null;
          }
          socialProtectionField.options = eligibleOptions.map((e) => FieldOption(title: e.title, name: e.name, value: e.value.toString())).toList();
        }
        selectedSurvey.refresh();
        RLog.error('modifyFieldOptions: true');
        return true;
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
        return false;
      }

  }
}