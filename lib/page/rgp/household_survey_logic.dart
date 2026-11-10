import 'dart:convert';

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
  //var selectedSurveyResult = Rxn<SurveyResultDto>();
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
        if (householdSurveyContexDto != null) {
          final defaultInputs = householdSurveyContexDto!.defaultInputs;
          final Map<String, dynamic>? inputsMap =
              (defaultInputs != null && defaultInputs['inputs'] is Map)
                  ? Map<String, dynamic>.from(defaultInputs['inputs'])
                  : defaultInputs;

          final preselected = householdSurveyContexDto!.preselectedProfileMemberData != null
              ? ProfileMemberData.fromJson(
                  householdSurveyContexDto!.preselectedProfileMemberData!.toJson())
              : null;

          allSurveys.first.fields?.forEach((eachField) {
            try {
              if (eachField.name == null) return;

              // 1. Direct field value from inputsMap
              if (inputsMap != null) {
                if (inputsMap.containsKey(eachField.name)) {
                  eachField.defaultValue = inputsMap[eachField.name];
                } else if (householdSurveyCountKeys.contains(eachField.name)) {
                  final fakeKey = fakeHouseholdSurveyCountKeys[
                      householdSurveyCountKeys.indexOf(eachField.name!)];
                  if (inputsMap.containsKey(fakeKey)) {
                    eachField.defaultValue = inputsMap[fakeKey];
                  }
                }
              }

              // 2. Preselected members list from inputsMap (e.g. hs_18_8_nid_members)
              if (inputsMap != null &&
                  inputsMap.containsKey('${eachField.name}_members')) {
                final raw = inputsMap['${eachField.name}_members'];
                if (raw is List) {
                  eachField.preselectedMembers = raw.map((item) {
                    if (item is HouseholdSurevyMember) return item;
                    if (item is Map) return HouseholdSurevyMember.fromJson(item);
                    return HouseholdSurevyMember(display: item.toString());
                  }).toList();
                  if (eachField.preselectedMembers?.isNotEmpty == true) {
                    eachField.defaultValue = "yes";
                  }
                }
              }

              // 3. Preselected profile member data from context
              if (preselected != null &&
                  checkboxHouseholdMemberTypeFieldKey.contains(eachField.name)) {
                final preselectedMembers =
                    _getPreselectedMembersForField(eachField.name!, preselected);
                if (preselectedMembers != null && preselectedMembers.isNotEmpty) {
                  eachField.defaultValue = "yes";
                  eachField.preselectedMembers = preselectedMembers;
                }
              }

              // Safeguard: For checkboxHouseholdMember, defaultValue MUST NEVER be a List!
              if (checkboxHouseholdMemberTypeFieldKey.contains(eachField.name)) {
                if (eachField.defaultValue is List) {
                  final list = eachField.defaultValue as List;
                  eachField.preselectedMembers ??= list.map((item) {
                    if (item is HouseholdSurevyMember) return item;
                    if (item is Map) return HouseholdSurevyMember.fromJson(item);
                    return HouseholdSurevyMember(display: item.toString());
                  }).toList();
                  eachField.defaultValue = (eachField.preselectedMembers?.isNotEmpty == true) ? "yes" : "no";
                }
              }
            } catch (e) {
              RLog.error(e);
            }
          });
        }
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
        selectedSurvey.value!.fields!.add(
          Field(
            label: "Total Patient",
            name: "hs_18_44_total_patient",
            inputType: "number",
            required: false,
            ignore: true,
            defaultValue: null,
          ),
        );
        selectedSurvey.value!.fields!.asMap().forEach((index, field) {
          if(field.inputType == 'switchButton') {
            field.inputType = 'checkboxSingle';
          }
          if(householdSurveyCountKeys.contains(field.name)){
            field.visibilityConditions = null;
            field.min = 0;
            field.ignore = true;
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
                      name: "${field.name}_input_",
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
                        name: "${field.name}_lmp_",
                        inputType: "date",
                        required: true,
                        defaultValue: DateTime.now().millisecondsSinceEpoch,
                    ),
                     Field(
                        label: "EDD",
                        name: "${field.name}_edd_",
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
                        name: "${field.name}_input_",
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

  List<HouseholdSurevyMember>? _getPreselectedMembersForField(
      String fieldName, ProfileMemberData preselected) {
    switch (fieldName) {
      case 'hs_18_8_nid':
        return preselected.nidMembers;
      case 'hs_18_10_bcn':
        return preselected.bcnMembers;
      case 'hs_18_16_pregnant':
        return preselected.pregnantMembers;
      case 'hs_18_18_diabetes':
        return preselected.diseaseMembers?.diabetes;
      case 'hs_18_20_high_bp':
        return preselected.diseaseMembers?.highbp;
      case 'hs_18_30_eye':
        return preselected.diseaseMembers?.eyeproblem;
      case 'hs_18_22_kidney':
        return preselected.diseaseMembers?.kidneyDisease;
      case 'hs_18_24_cancer':
        return preselected.diseaseMembers?.cancer;
      case 'hs_18_26_low_bp':
        return preselected.diseaseMembers?.lowbp;
      case 'hs_18_28_malnutrition_u5':
        return preselected.diseaseMembers?.malnutritionU5;
      case 'hs_18_32_ear':
        return preselected.diseaseMembers?.earproblem;
      case 'hs_18_34_pneumonia':
        return preselected.diseaseMembers?.pneumonia;
      case 'hs_18_36_diarrhea':
        return preselected.diseaseMembers?.diarrhea;
      case 'hs_18_38_hepatitis':
        return preselected.diseaseMembers?.hepatitis;
      case 'hs_18_40_paralysis':
        return preselected.diseaseMembers?.paralysis;
      case 'hs_18_42_other_complicated':
        return preselected.diseaseMembers?.otherComplicated;
      default:
        return null;
    }
  }

  void submitSurvey(SurveyDto selectedSurveyDto, Map<String, dynamic> formMap) {
    //add count key to formMap for submitting(currently dat stored in fake key for showing UI Only)
    for(int i = 0; i < fakeHouseholdSurveyCountKeys.length; i++){
      final fakeKey = fakeHouseholdSurveyCountKeys[i];
      final realKey = householdSurveyCountKeys[i];
      if(formMap[fakeKey] != null && formMap[fakeKey] != ""){
        formMap[realKey] = formMap[fakeKey];
      }
      formMap.remove(fakeKey);
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
          nidMembers: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>?),
          bcnMembers: (formMap["hs_18_10_bcn_members"] as List<HouseholdSurevyMember>?),
          pregnantMembers: (formMap["hs_18_16_pregnant_members"] as List<HouseholdSurevyMember>?),
          //chronicRemovals: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>),
          //deadMembers: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>),
          diseaseMembers: DiseaseMembers(
            diabetes:(formMap["hs_18_18_diabetes_members"] as List<HouseholdSurevyMember>?),
            highbp:(formMap["hs_18_20_high_bp_members"] as List<HouseholdSurevyMember>?),
            eyeproblem:(formMap["hs_18_30_eye_members"] as List<HouseholdSurevyMember>?),
            kidneyDisease:(formMap["hs_18_22_kidney_members"] as List<HouseholdSurevyMember>?),
            cancer:(formMap["hs_18_24_cancer_members"] as List<HouseholdSurevyMember>?),
            lowbp:(formMap["hs_18_26_low_bp_members"] as List<HouseholdSurevyMember>?),
            malnutritionU5:(formMap["hs_18_28_malnutrition_u5_members"] as List<HouseholdSurevyMember>?),
            earproblem:(formMap["hs_18_32_ear_members"] as List<HouseholdSurevyMember>?),
            pneumonia:(formMap["hs_18_34_pneumonia_members"] as List<HouseholdSurevyMember>?),
            diarrhea:(formMap["hs_18_36_diarrhea_members"] as List<HouseholdSurevyMember>?),
            hepatitis:(formMap["hs_18_38_hepatitis_members"] as List<HouseholdSurevyMember>?),
            paralysis:(formMap["hs_18_40_paralysis_members"] as List<HouseholdSurevyMember>?),
            otherComplicated:(formMap["hs_18_42_other_complicated_members"] as List<HouseholdSurevyMember>?),
          )
        )
    );


    // 1. Force a deep clone to make the entire map fully mutable
    final Map<String, dynamic> requestBody = jsonDecode(
      jsonEncode(surveyResultData.toSurveyMap()),
    );

    // 2. Access and clean the inputs map safely
    final surveyMap = requestBody['survey']?['inputs'];
    if (surveyMap is Map<String, dynamic>) {
      surveyMap.removeWhere((key, value) {
        final bool matchesGeneralCriteria = key.endsWith('_members') ||
            fakeHouseholdSurveyCountKeys.contains(key) ||
            key.contains('_input_') ||
            key.contains('_lmp_') ||
            key.contains('_edd_') ||
            key.startsWith('__');

        final bool matchesZeroCount = key.endsWith('_count') &&
            (value == 0 || value == '0' || value == null);

        return matchesGeneralCriteria || matchesZeroCount;
      });
    }


    RLog.error(requestBody);
    //RLog.info(surveyResultData.toJson());
    globalState.showBusy();
    httpProvider.POST(ApiUrl.postHouseholdSurveyUrl(), requestBody).then((response) {
      globalState.hideBusy();
      isLoading.value = false;
      if (response.isOk) {
        // SurveyResultItemDto surveyResultItemDto = SurveyResultItemDto.fromJson(response.body);
        // RLog.error(response.body);
        // RLog.error(selectedSurveyDto.toJson());
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

