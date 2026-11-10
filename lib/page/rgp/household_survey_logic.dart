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
import 'dto/DiseaseMembers.dart';
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

  List<String> get checkboxHouseholdMemberTypeFieldKey => [
    "hs_18_8_nid",
    "hs_18_10_bcn",
    "hs_18_16_pregnant",
    "hs_18_18_diabetes",
    "hs_18_20_high_bp",
    "hs_18_30_eye",
    "hs_18_22_kidney",
    "hs_18_24_cancer",
    "hs_18_26_low_bp",
    "hs_18_28_malnutrition_u5",
    "hs_18_32_ear",
    "hs_18_34_pneumonia",
    "hs_18_36_diarrhea",
    "hs_18_38_hepatitis",
    "hs_18_40_paralysis",
    "hs_18_42_other_complicated",
  ];
  List<String> get householdSurveyCountKeys => [
    'hs_18_9_nid_count',
    'hs_18_11_bcn_count',
    'hs_18_17_pregnant_count',
    'hs_18_19_diabetes_count',
    'hs_18_21_high_bp_count',
    'hs_18_23_kidney_count',
    'hs_18_25_cancer_count',
    'hs_18_27_low_bp_count',
    'hs_18_29_malnutrition_u5_count',
    'hs_18_31_eye_count',
    'hs_18_33_ear_count',
    'hs_18_35_pneumonia_count',
    'hs_18_37_diarrhea_count',
    'hs_18_39_hepatitis_count',
    'hs_18_41_paralysis_count',
    'hs_18_43_other_complicated_count'
  ];
  List<String> get fakeHouseholdSurveyCountKeys => [
    'hs_18_8_nid_count',
    'hs_18_10_bcn_count',
    'hs_18_16_pregnant_count',
    'hs_18_15_diabetes_count',
    'hs_18_20_high_bp_count',
    'hs_18_22_kidney_count',
    'hs_18_24_cancer_count',
    'hs_18_26_low_bp_count',
    'hs_18_25_malnutrition_u5_count',
    'hs_18_30_eye_count',
    'hs_18_32_ear_count',
    'hs_18_34_pneumonia_count',
    'hs_18_36_diarrhea_count',
    'hs_18_38_hepatitis_count',
    'hs_18_40_paralysis_count',
    'hs_18_42_other_complicated_count'
  ];

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
        //add fake_key_count for view(health information)
        // for(int i = 0; i < fakeHouseholdSurveyCountKeys.length; i++){
        //   final fakeKey = fakeHouseholdSurveyCountKeys[i];
        //   final realKey = householdSurveyCountKeys[i];
        //   selectedSurvey.value!.fields?.forEach((){
        //
        //   });
        // }
        // modify visibility condition
        selectedSurvey.value!.fields!.removeWhere((Field field)=> field.visibilityConditions?.first.sourceField == "__rgp_extended_enabled__");
        selectedSurvey.value!.fields!.asMap().forEach((index, field) {
          if(field.inputType == 'switchButton') {
            field.inputType = 'checkboxSingle';
          }
          if(field.name!.contains("_count")){
            field.visibilityConditions = null;
            field.readOnly = true;
            field.min = 0;
            //add fake_key_count for view(health information)
            field.name = fakeHouseholdSurveyCountKeys[householdSurveyCountKeys.indexWhere((key)=>key  == field.name!)];
          }

          if(checkboxHouseholdMemberTypeFieldKey.contains(field.name)) {
            field.inputType = 'checkboxHouseholdMember';
            if (field.members == null || field.members!.isEmpty) {
              field.members = householdSurveyContexDto?.members?.map<HouseholdSurevyMember>((m) {
                final displayName = (Get.locale?.languageCode == 'en'
                        ? (m.displayName?.isNotEmpty == true ? m.displayName : m.displayName)
                        : (m.displayName?.isNotEmpty == true ? m.displayName : m.displayName)) ??'N/A';
                List<Field> fields = [];
                if(
                field.name == 'hs_18_8_nid' ||
                field.name == 'hs_18_10_bcn'
                ) {
                  fields = [
                    Field(
                      label: field.label,
                      hint: field.hint,
                      name: "${field.name}_input",
                      inputType: "text",
                      required: true,
                      defaultValue: "",
                    )
                  ];
                }
                else if(field.name == 'hs_18_16_pregnant') {
                  fields = [
                    Field(
                        label: "LMP",
                        name: "${field.name}_lmp",
                        inputType: "date",
                        required: true,
                        defaultValue: DateTime.now().millisecondsSinceEpoch,
                    ),
                     Field(
                        label: "EDD",
                        name: "${field.name}_edd",
                        inputType: "date",
                        required: true,
                        defaultValue: (DateTime.now().add(const Duration(days: 280))).millisecondsSinceEpoch,
                    )
                  ];
                }

                else {
                  fields = [
                    Field(
                        label: field.label,
                        hint: field.hint,
                        name: "${field.name}_input",
                        inputType: "text",
                        required: false,
                        defaultValue: "",
                        isHidden: true
                    )
                  ];
                }
                return HouseholdSurevyMember(
                    userId: m.userId,
                    memberId: m.memberId,
                    profileId: m.profileId,
                    display: displayName,
                    fields: fields,
                    isHidden: (field.name == 'hs_18_16_pregnant' && (m.gender != 'FEMALE' || m.ageYears! < 9 || m.ageYears! >59))? true: false,
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
    //add count key to formMap for submitting(currently dat stored in fake key for showing UI Only)
    for(int i = 0; i < fakeHouseholdSurveyCountKeys.length; i++){
      final fakeKey = fakeHouseholdSurveyCountKeys[i];
      final realKey = householdSurveyCountKeys[i];
      if(formMap[fakeKey] == null || formMap[fakeKey] == ""){
        formMap[realKey] = formMap[fakeKey];
      }
    }

    //other filed modification like profile data
    final surveyResultData = HouseholdSurveyRequestDto(
        surveyId: selectedSurveyDto.id,
        userId: customer.value.userId,
        surveyName: selectedSurveyDto.name,
        surveyOn: DateTime.now().millisecondsSinceEpoch,
        inputs: formMap,
        profileMemberData: ProfileMemberData(
          householdId: customer.value.householdId!,
          nidMembers: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>),
          bcnMembers: (formMap["hs_18_10_bcn_members"] as List<HouseholdSurevyMember>),
          pregnantMembers: (formMap["hs_18_16_pregnant"] as List<HouseholdSurevyMember>),
          //chronicRemovals: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>),
          //deadMembers: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>),
          diseaseMembers: DiseaseMembers(
            diabetes:(formMap["hs_18_18_diabetes_members"] as List<HouseholdSurevyMember>),
            highbp:(formMap["hs_18_20_high_bp_members"] as List<HouseholdSurevyMember>),
            eyeproblem:(formMap["hs_18_30_eye_members"] as List<HouseholdSurevyMember>),
            kidneyDisease:(formMap["hs_18_22_kidney_members"] as List<HouseholdSurevyMember>),
            cancer:(formMap["hs_18_24_cancer"] as List<HouseholdSurevyMember>),
            lowbp:(formMap["hs_18_26_low_bp_members"] as List<HouseholdSurevyMember>),
            malnutritionU5:(formMap["hs_18_28_malnutrition_u5_members"] as List<HouseholdSurevyMember>),
            earproblem:(formMap["hs_18_32_ear_members"] as List<HouseholdSurevyMember>),
            pneumonia:(formMap["hs_18_34_pneumonia_members"] as List<HouseholdSurevyMember>),
            diarrhea:(formMap["hs_18_36_diarrhea_members"] as List<HouseholdSurevyMember>),
            hepatitis:(formMap["hs_18_38_hepatitis_members"] as List<HouseholdSurevyMember>),
            paralysis:(formMap["hs_18_40_paralysis_members"] as List<HouseholdSurevyMember>),
            otherComplicated:(formMap["hs_18_42_other_complicated_members"] as List<HouseholdSurevyMember>),
          )
        )
    );
    globalState.showBusy();
    final requestBody = surveyResultData.toJson();
    //requestBody['inputs'].remove("hs_18_8_nid_members");
    //requestBody['inputs'].remove("hs_18_10_bcn_members");
    RLog.info(requestBody);
    //RLog.info(surveyResultData.toJson());
    httpProvider.POST(ApiUrl.postHouseholdSurveyUrl(), requestBody).then((response) {
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

