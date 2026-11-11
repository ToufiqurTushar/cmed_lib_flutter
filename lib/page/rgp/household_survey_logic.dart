import 'dart:convert';

import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/page/rgp/dto/ChronicRemovalDto.dart';
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
        // selectedSurvey.value!.fields!.add(
        //   Field(
        //     label: "Total Patient",
        //     name: "hs_18_44_total_patient",
        //     inputType: "number",
        //     required: false,
        //     ignore: true,
        //     defaultValue: null,
        //   ),
        // );
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

          //ignore survey date editing
          if(field.name == 'hs_18_survey_date'){
            field.ignore = true;
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
                  final isNid = field.name == 'hs_18_8_nid';
                  fields = [
                    Field(
                      label: field.label,
                      hint: (field.hint?.isNotEmpty == true)
                          ? field.hint
                          : (isNid
                              ? "NID must be 10, 13, or 17 digits".tr
                              : "Birth Certificate Number must be 10, 13, or 17 digits".tr),
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
                    isHidden: (field.name == 'hs_18_16_pregnant' && (m.gender != 'FEMALE' || m.ageYears! < 9 || m.ageYears! >59))?
                    true:
                    (field.name == 'hs_18_28_malnutrition_u5' && (m.ageYears! > 5))?
                    true:
                    false,
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

  static const Map<String, String> diseaseFieldToChronicCondition = {
    'hs_18_18_diabetes': 'DIABETES',
    'hs_18_20_high_bp': 'HYPERTENSION',
    'hs_18_22_kidney': 'KIDNEY_DISEASE',
    'hs_18_24_cancer': 'CANCER',
  };

  static const Set<String> allowedChronicConditions = {
    'DIABETES',
    'HYPERTENSION',
    'KIDNEY_DISEASE',
    'CANCER',
  };

  bool _memberHadConditionPreviously(
    SurveyMember member,
    String fieldKey,
    String condition,
    ProfileMemberData? preselectedProfile,
  ) {
    final condUpper = condition.toUpperCase();

    // 1. Check member.chronicConditions
    if (member.chronicConditions != null && member.chronicConditions!.isNotEmpty) {
      final match = member.chronicConditions!.any((c) {
        final cUpper = c.toUpperCase();
        if (condUpper == 'HYPERTENSION' && (cUpper == 'HYPERTENSION' || cUpper == 'HIGH_BP')) {
          return true;
        }
        if (condUpper == 'KIDNEY_DISEASE' && (cUpper == 'KIDNEY_DISEASE' || cUpper == 'KIDNEY')) {
          return true;
        }
        return cUpper == condUpper;
      });
      if (match) return true;
    }

    // 2. Check member.activeDiseases
    if (member.activeDiseases != null && member.activeDiseases!.isNotEmpty) {
      final match = member.activeDiseases!.any((c) {
        final cUpper = c.toUpperCase();
        if (condUpper == 'HYPERTENSION' && (cUpper == 'HYPERTENSION' || cUpper == 'HIGH_BP')) {
          return true;
        }
        if (condUpper == 'KIDNEY_DISEASE' && (cUpper == 'KIDNEY_DISEASE' || cUpper == 'KIDNEY')) {
          return true;
        }
        return cUpper == condUpper;
      });
      if (match) return true;
    }

    // 3. Check preselectedProfile from _getPreselectedMembersForField
    if (preselectedProfile != null) {
      final preselectedList = _getPreselectedMembersForField(fieldKey, preselectedProfile);
      if (preselectedList != null && preselectedList.isNotEmpty) {
        final match = preselectedList.any((m) =>
            (m.userId != null && m.userId == member.userId) ||
            (m.memberId != null && m.memberId == member.memberId) ||
            (m.profileId != null && m.profileId == member.profileId));
        if (match) return true;
      }
    }

    // 4. Check diseaseMembers map in context directly
    final diseaseMembersMap = householdSurveyContexDto?.preselectedProfileMemberData?.diseaseMembers;
    if (diseaseMembersMap != null && diseaseMembersMap.isNotEmpty) {
      for (final entry in diseaseMembersMap.entries) {
        final keyUpper = entry.key.toUpperCase();
        bool keyMatches = keyUpper == condUpper;
        if (condUpper == 'HYPERTENSION' && (keyUpper == 'HYPERTENSION' || keyUpper == 'HIGH_BP')) {
          keyMatches = true;
        }
        if (condUpper == 'KIDNEY_DISEASE' && (keyUpper == 'KIDNEY_DISEASE' || keyUpper == 'KIDNEY')) {
          keyMatches = true;
        }
        if (keyMatches) {
          final match = entry.value.any((dm) =>
              (dm.userId != null && dm.userId == member.userId) ||
              (dm.memberId != null && dm.memberId == member.memberId) ||
              (dm.profileId != null && dm.profileId == member.profileId));
          if (match) return true;
        }
      }
    }

    return false;
  }

  bool _memberHasConditionCurrently(
    SurveyMember member,
    String fieldKey,
    Map<String, dynamic> formMap,
  ) {
    final status = formMap[fieldKey];
    if (status != 'yes' && status != true && status != '1' && status != 1) {
      return false;
    }

    final rawList = formMap['${fieldKey}_members'];
    if (rawList is! List || rawList.isEmpty) {
      return false;
    }

    for (final item in rawList) {
      int? uId;
      int? mId;
      int? pId;

      if (item is HouseholdSurevyMember) {
        uId = item.userId;
        mId = item.memberId;
        pId = item.profileId;
      } else if (item is Map) {
        uId = item['user_id'];
        mId = item['member_id'];
        pId = item['profile_id'];
      }

      if ((uId != null && uId == member.userId) ||
          (mId != null && mId == member.memberId) ||
          (pId != null && pId == member.profileId)) {
        return true;
      }
    }

    return false;
  }

  List<ChronicRemovalDto> generateChronicRemovals(Map<String, dynamic> formMap) {
    final List<ChronicRemovalDto> results = [];
    final allMembers = householdSurveyContexDto?.members ?? [];
    if (allMembers.isEmpty) return results;

    final preselectedProfile = householdSurveyContexDto?.preselectedProfileMemberData != null
        ? ProfileMemberData.fromJson(
            householdSurveyContexDto!.preselectedProfileMemberData!.toJson())
        : null;

    final Set<String> processedKeys = {};

    for (final member in allMembers) {
      for (final entry in diseaseFieldToChronicCondition.entries) {
        final fieldKey = entry.key;
        final conditionName = entry.value;

        // Strictly allow only the 4 valid chronic conditions
        if (!allowedChronicConditions.contains(conditionName)) continue;

        final uniqueCheckKey =
            '${member.userId ?? member.memberId ?? member.profileId}_$conditionName';
        if (processedKeys.contains(uniqueCheckKey)) continue;
        processedKeys.add(uniqueCheckKey);

        final wasChecked = _memberHadConditionPreviously(
          member,
          fieldKey,
          conditionName,
          preselectedProfile,
        );

        final isChecked = _memberHasConditionCurrently(
          member,
          fieldKey,
          formMap,
        );

        if (wasChecked && !isChecked) {
          results.add(ChronicRemovalDto(
            userId: member.userId,
            memberId: member.memberId,
            profileId: member.profileId,
            condition: conditionName,
            reason: "RESOLVED",
          ));
        }
      }
    }

    return results;
  }

  List<HouseholdSurevyMember>? _resolveFieldMembers(
    String fieldKey,
    Map<String, dynamic> formMap,
  ) {
    final status = formMap[fieldKey];
    final isYes = status == 'yes' || status == true || status == '1' || status == 1;
    if (!isYes) {
      return null;
    }

    final raw = formMap['${fieldKey}_members'];
    if (raw is List && raw.isNotEmpty) {
      return raw.map((item) {
        if (item is HouseholdSurevyMember) return item;
        if (item is Map) return HouseholdSurevyMember.fromJson(item);
        return HouseholdSurevyMember(display: item.toString());
      }).toList();
    }

    // Fallback: If status is 'yes' but formMap didn't capture members (e.g. not touched),
    // retrieve from field preselectedMembers or context
    final fieldDef = allSurveys.firstOrNull?.fields?.firstWhereOrNull((f) => f.name == fieldKey);
    if (fieldDef?.preselectedMembers != null && fieldDef!.preselectedMembers!.isNotEmpty) {
      return fieldDef!.preselectedMembers;
    }

    final preselected = householdSurveyContexDto?.preselectedProfileMemberData != null
        ? ProfileMemberData.fromJson(
            householdSurveyContexDto!.preselectedProfileMemberData!.toJson())
        : null;
    if (preselected != null) {
      final list = _getPreselectedMembersForField(fieldKey, preselected);
      if (list != null && list.isNotEmpty) {
        return list;
      }
    }

    return null;
  }

  void submitSurvey(SurveyDto selectedSurveyDto, Map<String, dynamic> formMap) {
    // 1. Resolve members for each checkbox field
    final nidMembers = _resolveFieldMembers("hs_18_8_nid", formMap);
    final bcnMembers = _resolveFieldMembers("hs_18_10_bcn", formMap);
    final pregnantMembers = _resolveFieldMembers("hs_18_16_pregnant", formMap);

    final diabetesMembers = _resolveFieldMembers("hs_18_18_diabetes", formMap);
    final highBpMembers = _resolveFieldMembers("hs_18_20_high_bp", formMap);
    final kidneyMembers = _resolveFieldMembers("hs_18_22_kidney", formMap);
    final cancerMembers = _resolveFieldMembers("hs_18_24_cancer", formMap);
    final lowBpMembers = _resolveFieldMembers("hs_18_26_low_bp", formMap);
    final malnutritionMembers = _resolveFieldMembers("hs_18_28_malnutrition_u5", formMap);
    final eyeMembers = _resolveFieldMembers("hs_18_30_eye", formMap);
    final earMembers = _resolveFieldMembers("hs_18_32_ear", formMap);
    final pneumoniaMembers = _resolveFieldMembers("hs_18_34_pneumonia", formMap);
    final diarrheaMembers = _resolveFieldMembers("hs_18_36_diarrhea", formMap);
    final hepatitisMembers = _resolveFieldMembers("hs_18_38_hepatitis", formMap);
    final paralysisMembers = _resolveFieldMembers("hs_18_40_paralysis", formMap);
    final otherComplicatedMembers = _resolveFieldMembers("hs_18_42_other_complicated", formMap);

    // Keep formMap['${fieldKey}_members'] synchronized
    formMap["hs_18_8_nid_members"] = nidMembers;
    formMap["hs_18_10_bcn_members"] = bcnMembers;
    formMap["hs_18_16_pregnant_members"] = pregnantMembers;

    formMap["hs_18_18_diabetes_members"] = diabetesMembers;
    formMap["hs_18_20_high_bp_members"] = highBpMembers;
    formMap["hs_18_22_kidney_members"] = kidneyMembers;
    formMap["hs_18_24_cancer_members"] = cancerMembers;
    formMap["hs_18_26_low_bp_members"] = lowBpMembers;
    formMap["hs_18_28_malnutrition_u5_members"] = malnutritionMembers;
    formMap["hs_18_30_eye_members"] = eyeMembers;
    formMap["hs_18_32_ear_members"] = earMembers;
    formMap["hs_18_34_pneumonia_members"] = pneumoniaMembers;
    formMap["hs_18_36_diarrhea_members"] = diarrheaMembers;
    formMap["hs_18_38_hepatitis_members"] = hepatitisMembers;
    formMap["hs_18_40_paralysis_members"] = paralysisMembers;
    formMap["hs_18_42_other_complicated_members"] = otherComplicatedMembers;

    // 2. Synchronize count fields to strictly match member list size
    final Map<String, int> fieldCounts = {
      'hs_18_9_nid_count': nidMembers?.length ?? 0,
      'hs_18_11_bcn_count': bcnMembers?.length ?? 0,
      'hs_18_17_pregnant_count': pregnantMembers?.length ?? 0,
      'hs_18_19_diabetes_count': diabetesMembers?.length ?? 0,
      'hs_18_21_high_bp_count': highBpMembers?.length ?? 0,
      'hs_18_23_kidney_count': kidneyMembers?.length ?? 0,
      'hs_18_25_cancer_count': cancerMembers?.length ?? 0,
      'hs_18_27_low_bp_count': lowBpMembers?.length ?? 0,
      'hs_18_29_malnutrition_u5_count': malnutritionMembers?.length ?? 0,
      'hs_18_31_eye_count': eyeMembers?.length ?? 0,
      'hs_18_33_ear_count': earMembers?.length ?? 0,
      'hs_18_35_pneumonia_count': pneumoniaMembers?.length ?? 0,
      'hs_18_37_diarrhea_count': diarrheaMembers?.length ?? 0,
      'hs_18_39_hepatitis_count': hepatitisMembers?.length ?? 0,
      'hs_18_41_paralysis_count': paralysisMembers?.length ?? 0,
      'hs_18_43_other_complicated_count': otherComplicatedMembers?.length ?? 0,
    };

    fieldCounts.forEach((realKey, count) {
      if (count > 0) {
        formMap[realKey] = count;
      } else {
        formMap.remove(realKey);
      }
    });

    // Remove any leftover fake count keys
    for (final fakeKey in fakeHouseholdSurveyCountKeys) {
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
          nidMembers: nidMembers,
          bcnMembers: bcnMembers,
          pregnantMembers: pregnantMembers,
          chronicRemovals: generateChronicRemovals(formMap),
          //deadMembers: (formMap["hs_18_8_nid_members"] as List<HouseholdSurevyMember>),
          diseaseMembers: DiseaseMembers(
            diabetes: diabetesMembers,
            highbp: highBpMembers,
            eyeproblem: eyeMembers,
            kidneyDisease: kidneyMembers,
            cancer: cancerMembers,
            lowbp: lowBpMembers,
            malnutritionU5: malnutritionMembers,
            earproblem: earMembers,
            pneumonia: pneumoniaMembers,
            diarrhea: diarrheaMembers,
            hepatitis: hepatitisMembers,
            paralysis: paralysisMembers,
            otherComplicated: otherComplicatedMembers,
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
            (value == 0 || value == '0' || value == null || value == "");

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

