import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/page/i4we/social_protection/social_protection_argument.dart';
import 'package:cmed_lib_flutter/survey/dto/field_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../common/api/api_url.dart';
import '../../../common/base/base_logic.dart';
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
    httpProvider.GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.SOCIAL_PROTECTION.name)).then((response) {
      if (response.isOk) {
        allSurveys.addAll(SurveyDataResponseDto.fromJson(response.body).content??[]);
        //set default value if exist
        if(selectedSurveyResult.value != null){
          allSurveys.first.fields!.forEach((eachField){
            try{
              //eachField.defaultValue = selectedSurveyResult.value!.inputs[eachField.name];
            } catch (e){
              RLog.error(e);
            }
          });
        }
        selectedSurvey.value = allSurveys.first;
        // modify visibility condition
        // selectedSurvey.value!.fields!.firstWhere((field)=>field.name == 'sp14_2').visibilityConditions = [
        //   FieldCondition(sourceField: "sp14_1", expectedValue: ['sp14_1_ration_card'])
        // ];
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
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    });
  }

  void checkEligibilityForFields(Map<String, dynamic> answers) {
    globalState.showBusy();
    httpProvider.GET(ApiUrl.socialProtectionEligibility(civicIds: answers['sp14_1'], userId: customer.value.userId!)).then((response) {
      globalState.hideBusy();
      isLoading.value = false;
      if (response.isOk) {
        List<FieldOption> eligibleOptions = FieldOption.fromJsonList(response.body);
        RLog.info(eligibleOptions.length);
        selectedSurvey.value!.fields!.firstWhere((m)=>m.name == 'sp14_3').options = eligibleOptions.map((e) => FieldOption(title:e.title, name: e.name, value: e.value)).toList();
        // selectedSurvey.value!.fields!.forEach((field){
        //   field.visibilityConditions = field.visibilityConditions??[];
        //   field.visibilityConditions!.add(
        //     //FieldCondition(hide: eligibleFillds.where((element) => element.name == field.name).isEmpty, sourceField: 'sp14_1', operator: FBConditionType.isHidden.name)
        //     FieldCondition(hide: false, operator: FBConditionType.isHidden.name)
        //   );
        // });
        // selectedSurvey.value!.fields!.firstWhere((field)=>field.name == 'sp14_2').visibilityConditions = [
        //  FieldCondition(sourceField: "sp14_1", expectedValue: ['sp14_1_ration_card'], operator: FBConditionType.equal.name)
        // ];
        selectedSurvey.refresh();
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    });
  }
}