import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/page/rgp/household_survey_argument.dart';
import 'package:cmed_lib_flutter/survey/dto/field_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:cmed_lib_flutter/survey/enum/enum.dart';
import 'package:logger/logger.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../common/api/api_url.dart';
import '../../common/base/base_logic.dart';
import '../../common/widget/app_dialog.dart';
import '../../survey/dto/Condition.dart';
import 'dto/HouseholdSurveyContexDto.dart';
import 'dto/HouseholdSurveyRequestDto.dart';
import 'dto/HouseholdSurevyMember.dart';
import 'dto/ProfileMemberData.dart';
import 'dto/SurveyResultResponse.dart';

class HouseholdSurveyLogic extends BaseLogic {
  var allSurveys = <SurveyDto>[].obs;
  var selectedSurvey = Rxn<SurveyDto>();
  var selectedSurveyResult = Rxn<SurveyResultDto>();
  late HouseholdSurveyArg householdSurveyArg;
  HouseholdSurveyContexDto? householdSurveyContexDto;

  @override
  void onInit() {
    super.onInit();
    householdSurveyArg = (Get.arguments as HouseholdSurveyArg);
    selectedSurvey.value = householdSurveyArg.selectedSurvey;
    fetchSurveyData();
  }

  fetchSurveyData() async {
    isLoading.value = true;
    await httpProvider.GET(ApiUrl.getHouseholdSurveyContextUrl(householdId: customer.value.householdId!, userId: customer.value.userId!)).then((response) {
      RLog.error(response.body);
      if (response.isOk && response.statusCode == 200) {
        householdSurveyContexDto = HouseholdSurveyContexDto.fromJson(response.body);
      }
    });
    httpProvider.GET(ApiUrl.getSurveyRulesUrl(surveyType:SurveyTypeEnum.HOUSEHOLD_SURVEY.name)).then((response) {
      if (response.isOk) {
        allSurveys.value = SurveyDataResponseDto.fromJson(response.body).content!;
        //set default value if exist
        // if(selectedSurveyResult.value != null){
        //   allSurveys.first.fields!.forEach((eachField){
        //     try{
        //       eachField.defaultValue = selectedSurveyResult.value!.inputs[eachField.name];
        //     } catch (e){
        //       RLog.error(e);
        //     }
        //   });
        // }
        selectedSurvey.value = allSurveys.first;
        // modify visibility condition
        selectedSurvey.value!.fields!.removeWhere((Field field)=> field.visibilityConditions?.first.sourceField == "__rgp_extended_enabled__");
        selectedSurvey.value!.fields!.forEach((field) {
          if(field.inputType == 'switchButton') {
            field.inputType = 'checkboxSingle';
          }
          if(field.name!.contains("_count")){
            field.visibilityConditions = [FieldCondition(hide: false, operator: FBConditionType.isHidden.name)];
            field.readOnly = true;
            field.min = 0;
          }
          final  checkboxHouseholdMemberTypeFieldKey = ['hs_18_8_nid',  'hs_18_11_bcn', 'hs_18_17_pregnant', 'hs_18_19_diabetes', 'hs_18_21_high_bp', 'hs_18_23_kidney', 'hs_18_25_cancer', 'hs_18_27_low_bp', 'hs_18_29_malnutrition_u5', 'hs_18_31_eye', 'hs_18_33_ear', 'hs_18_35_pneumonia', 'hs_18_37_diarrhea', 'hs_18_39_hepatitis', 'hs_18_40_paralysis', 'hs_18_43_other_complicated'];
          if(checkboxHouseholdMemberTypeFieldKey.contains(field.name)) {
            field.inputType = 'checkboxHouseholdMember';
            if (field.members == null || field.members!.isEmpty) {
              field.members = householdSurveyContexDto?.members?.map<HouseholdSurevyMember>((m) {
                final displayName = (Get.locale?.languageCode == 'en'
                        ? (m.displayName?.isNotEmpty == true ? m.displayName : m.displayName)
                        : (m.displayName?.isNotEmpty == true ? m.displayName : m.displayName)) ??'N/A';
                return HouseholdSurevyMember(
                  userId: m.userId,
                  memberId: m.memberId!,
                  profileId: m.profileId,
                  display: displayName,
                );
              }).toList();
            }
          }
        });
        Logger().w(selectedSurvey.value!.toJson());
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
          householdId: customer.value.householdId!,
          nidMembers: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>)
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

