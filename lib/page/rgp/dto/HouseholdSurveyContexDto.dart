import 'dart:convert';
import '../../../common/helper/digit_converter.dart';
import '../../../common/helper/utils.dart';

class HouseholdSurveyContexDto {
  final int? householdId;
  final String? householdNumber;
  final SurveyStatus? status;
  final SurveyGroup? surveyGroup;
  final Map<String, dynamic>? defaultInputs;
  final PreselectedProfileMemberData? preselectedProfileMemberData;
  final List<SurveyMember>? members;

  HouseholdSurveyContexDto({
    this.householdId,
    this.householdNumber,
    this.status,
    this.surveyGroup,
    this.defaultInputs,
    this.preselectedProfileMemberData,
    this.members,
  });

  factory HouseholdSurveyContexDto.fromJson(Map<String, dynamic> json) {
    return HouseholdSurveyContexDto(
      householdId: json['household_id'],
      householdNumber: json['household_number']?.toString(),
      status: json['status'] != null ? SurveyStatus.fromJson(json['status']) : null,
      surveyGroup: json['survey_group'] != null ? SurveyGroup.fromJson(json['survey_group']) : null,
      defaultInputs: json['default_inputs'] != null ? Map<String, dynamic>.from(json['default_inputs']) : null,
      preselectedProfileMemberData: json['preselected_profile_member_data'] != null
          ? PreselectedProfileMemberData.fromJson(json['preselected_profile_member_data'])
          : null,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => SurveyMember.fromJson(e))
          .toList(),
    );
  }

  factory HouseholdSurveyContexDto.fromHistoryItem(
    Map<String, dynamic> json, {
    List<SurveyMember>? members,
    PreselectedProfileMemberData? livePreselected,
  }) {
    final survey = json['survey'] is Map ? json['survey'] as Map<String, dynamic> : null;
    final Map<String, dynamic> profileData = json['profile_member_data'] is Map
        ? Map<String, dynamic>.from(json['profile_member_data'])
        : <String, dynamic>{};

    final Map<String, dynamic> inputs = (survey?['inputs'] is Map)
        ? Map<String, dynamic>.from(survey!['inputs'])
        : <String, dynamic>{};

    // 1. Synchronize real count keys with fake count keys for Tab 2
    const countKeyPairs = [
      ['hs_18_9_nid_count', 'hs_18_8_nid_count'],
      ['hs_18_11_bcn_count', 'hs_18_10_bcn_count'],
      ['hs_18_17_pregnant_count', 'hs_18_16_pregnant_count'],
      ['hs_18_19_diabetes_count', 'hs_18_18_diabetes_count'],
      ['hs_18_21_high_bp_count', 'hs_18_20_high_bp_count'],
      ['hs_18_23_kidney_count', 'hs_18_22_kidney_count'],
      ['hs_18_25_cancer_count', 'hs_18_24_cancer_count'],
      ['hs_18_27_low_bp_count', 'hs_18_26_low_bp_count'],
      ['hs_18_29_malnutrition_u5_count', 'hs_18_28_malnutrition_u5_count'],
      ['hs_18_31_eye_count', 'hs_18_30_eye_count'],
      ['hs_18_33_ear_count', 'hs_18_32_ear_count'],
      ['hs_18_35_pneumonia_count', 'hs_18_34_pneumonia_count'],
      ['hs_18_37_diarrhea_count', 'hs_18_36_diarrhea_count'],
      ['hs_18_39_hepatitis_count', 'hs_18_38_hepatitis_count'],
      ['hs_18_41_paralysis_count', 'hs_18_40_paralysis_count'],
      ['hs_18_43_other_complicated_count', 'hs_18_42_other_complicated_count'],
    ];

    for (final pair in countKeyPairs) {
      final realKey = pair[0];
      final fakeKey = pair[1];
      if (inputs.containsKey(realKey) && inputs[realKey] != null) {
        inputs[fakeKey] = inputs[realKey];
      } else if (inputs.containsKey(fakeKey) && inputs[fakeKey] != null) {
        inputs[realKey] = inputs[fakeKey];
      }
    }

    SurveyMember? findSurveyMember(dynamic idOrKey) {
      if (idOrKey == null || members == null) return null;
      final str = idOrKey.toString();
      for (final m in members) {
        if (m.userId?.toString() == str ||
            m.memberId?.toString() == str ||
            m.profileId?.toString() == str ||
            m.displayName == str) {
          return m;
        }
      }
      return null;
    }

    // 2. NID members:
    List<dynamic> nidMembers = [];
    if (profileData['nid_members'] is List && (profileData['nid_members'] as List).isNotEmpty) {
      nidMembers = (profileData['nid_members'] as List).map((item) {
        final map = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{'user_id': item};
        final sm = findSurveyMember(map['user_id'] ?? map['member_id'] ?? map['profile_id']);
        if (sm != null) {
          map['display'] ??= sm.displayName;
          map['value'] ??= sm.nationalId;
          map['user_id'] ??= sm.userId;
          map['member_id'] ??= sm.memberId;
          map['profile_id'] ??= sm.profileId;
        }
        return map;
      }).toList();
    } else if (inputs['hs_18_8_nid'] == 'yes' && members != null && members.isNotEmpty) {
      final nidCandidates = members.where((m) => (m.nationalId != null && m.nationalId!.isNotEmpty) || m.hasNid == true).toList();
      final count = int.tryParse(inputs['hs_18_9_nid_count']?.toString() ?? '') ??
                    int.tryParse(inputs['hs_18_8_nid_count']?.toString() ?? '') ??
                    nidCandidates.length;
      final listToTake = (nidCandidates.isNotEmpty ? nidCandidates : members).take(count > 0 ? count : 1);
      nidMembers = listToTake.map((m) => {
        'user_id': m.userId,
        'member_id': m.memberId,
        'profile_id': m.profileId,
        'display': m.displayName,
        'value': m.nationalId ?? '',
      }).toList();
    } else if (livePreselected?.nidMembers != null && inputs['hs_18_8_nid'] == 'yes') {
      nidMembers = List<dynamic>.from(livePreselected!.nidMembers!);
    }

    if (nidMembers.isNotEmpty) {
      profileData['nid_members'] = nidMembers;
      inputs['hs_18_8_nid_members'] = nidMembers;
      inputs['hs_18_8_nid'] = 'yes';
      for (final m in nidMembers) {
        final uId = m['user_id'] ?? m['member_id'] ?? m['profile_id'];
        if (uId != null && m['value'] != null) {
          inputs['hs_18_8_nid_input_$uId'] = m['value'];
        }
      }
    }

    // 3. BCN members:
    List<dynamic> bcnMembers = [];
    if (profileData['bcn_members'] is List && (profileData['bcn_members'] as List).isNotEmpty) {
      bcnMembers = (profileData['bcn_members'] as List).map((item) {
        final map = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{'user_id': item};
        final sm = findSurveyMember(map['user_id'] ?? map['member_id'] ?? map['profile_id']);
        if (sm != null) {
          map['display'] ??= sm.displayName;
          map['value'] ??= sm.birthCertificateNumber;
          map['user_id'] ??= sm.userId;
          map['member_id'] ??= sm.memberId;
          map['profile_id'] ??= sm.profileId;
        }
        return map;
      }).toList();
    } else if (inputs['hs_18_10_bcn'] == 'yes' && members != null && members.isNotEmpty) {
      final bcnCandidates = members.where((m) => (m.birthCertificateNumber != null && m.birthCertificateNumber!.isNotEmpty) || m.hasBcn == true).toList();
      final count = int.tryParse(inputs['hs_18_11_bcn_count']?.toString() ?? '') ??
                    int.tryParse(inputs['hs_18_10_bcn_count']?.toString() ?? '') ??
                    bcnCandidates.length;
      final listToTake = (bcnCandidates.isNotEmpty ? bcnCandidates : members).take(count > 0 ? count : 1);
      bcnMembers = listToTake.map((m) => {
        'user_id': m.userId,
        'member_id': m.memberId,
        'profile_id': m.profileId,
        'display': m.displayName,
        'value': m.birthCertificateNumber ?? '',
      }).toList();
    } else if (livePreselected?.bcnMembers != null && inputs['hs_18_10_bcn'] == 'yes') {
      bcnMembers = List<dynamic>.from(livePreselected!.bcnMembers!);
    }

    if (bcnMembers.isNotEmpty) {
      profileData['bcn_members'] = bcnMembers;
      inputs['hs_18_10_bcn_members'] = bcnMembers;
      inputs['hs_18_10_bcn'] = 'yes';
      for (final m in bcnMembers) {
        final uId = m['user_id'] ?? m['member_id'] ?? m['profile_id'];
        if (uId != null && m['value'] != null) {
          inputs['hs_18_10_bcn_input_$uId'] = m['value'];
        }
      }
    }

    // 4. Pregnant members:
    List<dynamic> pregnantMembers = [];
    if (profileData['pregnant_members'] is List && (profileData['pregnant_members'] as List).isNotEmpty) {
      pregnantMembers = (profileData['pregnant_members'] as List).map((item) {
        final map = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{'user_id': item};
        final sm = findSurveyMember(map['user_id'] ?? map['member_id'] ?? map['profile_id']);
        if (sm != null) {
          map['display'] ??= sm.displayName;
          map['lmp_date'] ??= sm.lmpDate;
          map['edd_date'] ??= sm.eddDate;
          map['user_id'] ??= sm.userId;
          map['member_id'] ??= sm.memberId;
          map['profile_id'] ??= sm.profileId;
        }
        return map;
      }).toList();
    } else if (inputs['hs_18_16_pregnant'] == 'yes' && members != null && members.isNotEmpty) {
      final pregCandidates = members.where((m) => m.pregnant == true || (m.gender == 'FEMALE' && (m.ageYears ?? 0) >= 9 && (m.ageYears ?? 0) <= 59 && m.lmpDate != null)).toList();
      final count = int.tryParse(inputs['hs_18_17_pregnant_count']?.toString() ?? '') ??
                    int.tryParse(inputs['hs_18_16_pregnant_count']?.toString() ?? '') ??
                    pregCandidates.length;
      final listToTake = (pregCandidates.isNotEmpty ? pregCandidates : members.where((m) => m.gender == 'FEMALE')).take(count > 0 ? count : 1);
      pregnantMembers = listToTake.map((m) => {
        'user_id': m.userId,
        'member_id': m.memberId,
        'profile_id': m.profileId,
        'display': m.displayName,
        'lmp_date': m.lmpDate,
        'edd_date': m.eddDate,
      }).toList();
    } else if (livePreselected?.pregnantMembers != null && inputs['hs_18_16_pregnant'] == 'yes') {
      pregnantMembers = List<dynamic>.from(livePreselected!.pregnantMembers!);
    }

    if (pregnantMembers.isNotEmpty) {
      profileData['pregnant_members'] = pregnantMembers;
      inputs['hs_18_16_pregnant_members'] = pregnantMembers;
      inputs['hs_18_16_pregnant'] = 'yes';
      for (final m in pregnantMembers) {
        final uId = m['user_id'] ?? m['member_id'] ?? m['profile_id'];
        if (uId != null) {
          if (m['lmp_date'] != null) inputs['hs_18_16_pregnant_lmp_$uId'] = m['lmp_date'];
          if (m['edd_date'] != null) inputs['hs_18_16_pregnant_edd_$uId'] = m['edd_date'];
        }
      }
    }

    // 5. Disease members:
    final Map<String, dynamic> rawDiseaseMembers = (profileData['disease_members'] is Map)
        ? Map<String, dynamic>.from(profileData['disease_members'])
        : <String, dynamic>{};

    const conditionToFieldMap = {
      'DIABETES': 'hs_18_18_diabetes',
      'HIGH_BP': 'hs_18_20_high_bp',
      'HYPERTENSION': 'hs_18_20_high_bp',
      'KIDNEY_DISEASE': 'hs_18_22_kidney',
      'CANCER': 'hs_18_24_cancer',
      'LOW_BP': 'hs_18_26_low_bp',
      'MALNUTRITION_U5': 'hs_18_28_malnutrition_u5',
      'EYE_PROBLEM': 'hs_18_30_eye',
      'EAR_PROBLEM': 'hs_18_32_ear',
      'PNEUMONIA': 'hs_18_34_pneumonia',
      'DIARRHEA': 'hs_18_36_diarrhea',
      'HEPATITIS': 'hs_18_38_hepatitis',
      'PARALYSIS': 'hs_18_40_paralysis',
      'OTHER_COMPLICATED': 'hs_18_42_other_complicated',
    };

    conditionToFieldMap.forEach((condition, fieldKey) {
      final isYes = inputs[fieldKey] == 'yes' || inputs[fieldKey] == true;
      if (!isYes) {
        rawDiseaseMembers.remove(condition);
        return;
      }

      List<dynamic> list = [];
      if (rawDiseaseMembers[condition] is List && (rawDiseaseMembers[condition] as List).isNotEmpty) {
        list = (rawDiseaseMembers[condition] as List).map((item) {
          final map = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{'user_id': item};
          final sm = findSurveyMember(map['user_id'] ?? map['member_id'] ?? map['profile_id']);
          if (sm != null) {
            map['display'] ??= sm.displayName;
            map['gender'] ??= sm.gender;
            map['age_years'] ??= sm.ageYears;
            map['user_id'] ??= sm.userId;
            map['member_id'] ??= sm.memberId;
            map['profile_id'] ??= sm.profileId;
          }
          return map;
        }).toList();
      } else if (members != null && members.isNotEmpty) {
        final matching = members.where((m) {
          final act = m.activeDiseases ?? [];
          final chr = m.chronicConditions ?? [];
          return act.contains(condition) || chr.contains(condition);
        }).toList();
        if (matching.isNotEmpty) {
          list = matching.map((m) => {
            'user_id': m.userId,
            'member_id': m.memberId,
            'profile_id': m.profileId,
            'display': m.displayName,
            'gender': m.gender,
            'age_years': m.ageYears,
          }).toList();
        }
      }

      if (list.isNotEmpty) {
        rawDiseaseMembers[condition] = list;
        inputs['${fieldKey}_members'] = list;
      }
    });

    profileData['disease_members'] = rawDiseaseMembers;

    final preselected = PreselectedProfileMemberData.fromJson(profileData);

    final rawHId = profileData['household_id'] ?? survey?['household_id'];
    final householdId = rawHId is int ? rawHId : int.tryParse(rawHId?.toString() ?? '');

    return HouseholdSurveyContexDto(
      householdId: householdId,
      defaultInputs: {'inputs': inputs},
      preselectedProfileMemberData: preselected,
      members: members,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'household_id': householdId,
      'household_number': householdNumber,
      'status': status?.toJson(),
      'survey_group': surveyGroup?.toJson(),
      'default_inputs': defaultInputs,
      'preselected_profile_member_data': preselectedProfileMemberData?.toJson(),
      'members': members?.map((e) => e.toJson()).toList(),
    };
  }
}

class SurveyStatus {
  final int? householdId;
  final String? householdNumber;
  final int? surveyYear;
  final int? surveyMonth;
  final bool? completedForCurrentMonth;
  final int? currentMonthSurveyId;
  final int? latestSurveyId;
  final int? latestSurveyOn;

  SurveyStatus({
    this.householdId,
    this.householdNumber,
    this.surveyYear,
    this.surveyMonth,
    this.completedForCurrentMonth,
    this.currentMonthSurveyId,
    this.latestSurveyId,
    this.latestSurveyOn,
  });

  factory SurveyStatus.fromJson(Map<String, dynamic> json) {
    return SurveyStatus(
      householdId: json['household_id'],
      householdNumber: json['household_number']?.toString(),
      surveyYear: json['survey_year'],
      surveyMonth: json['survey_month'],
      completedForCurrentMonth: json['completed_for_current_month'],
      currentMonthSurveyId: json['current_month_survey_id'],
      latestSurveyId: json['latest_survey_id'],
      latestSurveyOn: json['latest_survey_on'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'household_id': householdId,
      'household_number': householdNumber,
      'survey_year': surveyYear,
      'survey_month': surveyMonth,
      'completed_for_current_month': completedForCurrentMonth,
      'current_month_survey_id': currentMonthSurveyId,
      'latest_survey_id': latestSurveyId,
      'latest_survey_on': latestSurveyOn,
    };
  }
}

class SurveyGroup {
  final String? name;
  final String? icon;
  final List<SurveyField>? fields;

  SurveyGroup({
    this.name,
    this.icon,
    this.fields,
  });

  factory SurveyGroup.fromJson(Map<String, dynamic> json) {
    return SurveyGroup(
      name: json['name'],
      icon: json['icon'],
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => SurveyField.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'fields': fields?.map((e) => e.toJson()).toList(),
    };
  }
}

class SurveyField {
  final bool? required;
  final String? label;
  final List<dynamic>? images;
  final String? description;
  final String? inputType;
  final bool? readOnly;
  final String? name;
  final List<SurveyOption>? options;
  final dynamic defaultValue;
  final String? icon;
  final String? hint;
  final dynamic min;
  final dynamic max;
  final List<dynamic>? visibilityConditions;
  final String? domain;

  SurveyField({
    this.required,
    this.label,
    this.images,
    this.description,
    this.inputType,
    this.readOnly,
    this.name,
    this.options,
    this.defaultValue,
    this.icon,
    this.hint,
    this.min,
    this.max,
    this.visibilityConditions,
    this.domain,
  });

  factory SurveyField.fromJson(Map<String, dynamic> json) {
    return SurveyField(
      required: json['required'],
      label: json['label'],
      images: json['images'],
      description: json['description'],
      inputType: json['input_type'],
      readOnly: json['read_only'],
      name: json['name'],
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => SurveyOption.fromJson(e))
          .toList(),
      defaultValue: json['default_value'],
      icon: json['icon'],
      hint: json['hint'],
      min: json['min'],
      max: json['max'],
      visibilityConditions: json['visibility_conditions'],
      domain: json['domain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'label': label,
      'images': images,
      'description': description,
      'input_type': inputType,
      'read_only': readOnly,
      'name': name,
      'options': options?.map((e) => e.toJson()).toList(),
      'default_value': defaultValue,
      'icon': icon,
      'hint': hint,
      'min': min,
      'max': max,
      'visibility_conditions': visibilityConditions,
      'domain': domain,
    };
  }
}

class SurveyOption {
  final String? name;
  final String? value;
  final int? weight;
  final String? icon;
  final String? type;
  final String? title;

  SurveyOption({
    this.name,
    this.value,
    this.weight,
    this.icon,
    this.type,
    this.title,
  });

  factory SurveyOption.fromJson(Map<String, dynamic> json) {
    return SurveyOption(
      name: json['name'],
      value: json['value'],
      weight: json['weight'],
      icon: json['icon'],
      type: json['type'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'weight': weight,
      'icon': icon,
      'type': type,
      'title': title,
    };
  }
}

class PreselectedProfileMemberData {
  final int? householdId;
  final List<dynamic>? nidMembers;
  final List<dynamic>? bcnMembers;
  final List<dynamic>? pregnantMembers;
  final Map<String, List<DiseaseMember>>? diseaseMembers;
  final List<dynamic>? chronicRemovals;
  final List<dynamic>? healthCardMembers;
  final List<dynamic>? deadMembers;
  final List<dynamic>? doctorVisits;

  PreselectedProfileMemberData({
    this.householdId,
    this.nidMembers,
    this.bcnMembers,
    this.pregnantMembers,
    this.diseaseMembers,
    this.chronicRemovals,
    this.healthCardMembers,
    this.deadMembers,
    this.doctorVisits,
  });

  factory PreselectedProfileMemberData.fromJson(Map<String, dynamic> json) {
    Map<String, List<DiseaseMember>>? parsedDiseases;
    if (json['disease_members'] != null && json['disease_members'] is Map) {
      parsedDiseases = {};
      (json['disease_members'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          parsedDiseases![key] =
              value.map((e) => DiseaseMember.fromJson(e)).toList();
        }
      });
    }

    return PreselectedProfileMemberData(
      householdId: json['household_id'],
      nidMembers: json['nid_members'],
      bcnMembers: json['bcn_members'],
      pregnantMembers: json['pregnant_members'],
      diseaseMembers: parsedDiseases,
      chronicRemovals: json['chronic_removals'],
      healthCardMembers: json['health_card_members'],
      deadMembers: json['dead_members'],
      doctorVisits: json['doctor_visits'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? diseasesJson;
    if (diseaseMembers != null) {
      diseasesJson = {};
      diseaseMembers!.forEach((key, value) {
        diseasesJson![key] = value.map((e) => e.toJson()).toList();
      });
    }

    return {
      'household_id': householdId,
      'nid_members': nidMembers,
      'bcn_members': bcnMembers,
      'pregnant_members': pregnantMembers,
      'disease_members': diseasesJson,
      'chronic_removals': chronicRemovals,
      'health_card_members': healthCardMembers,
      'dead_members': deadMembers,
      'doctor_visits': doctorVisits,
    };
  }
}

class DiseaseMember {
  final int? userId;
  final int? memberId;
  final int? profileId;
  final String? display;
  final dynamic value;
  final bool? dead;
  final String? dateOfDeath;
  final String? healthCardNumber;
  final dynamic healthCardCost;
  final String? healthCardIssueDate;
  final String? healthCardExpireDate;
  final int? lmpDate;
  final int? eddDate;

  DiseaseMember({
    this.userId,
    this.memberId,
    this.profileId,
    this.display,
    this.value,
    this.dead,
    this.dateOfDeath,
    this.healthCardNumber,
    this.healthCardCost,
    this.healthCardIssueDate,
    this.healthCardExpireDate,
    this.lmpDate,
    this.eddDate,
  });

  factory DiseaseMember.fromJson(Map<String, dynamic> json) {
    return DiseaseMember(
      userId: json['user_id'],
      memberId: json['member_id'],
      profileId: json['profile_id'],
      display: json['display'],
      value: json['value'],
      dead: json['dead'],
      dateOfDeath: json['date_of_death'],
      healthCardNumber: json['health_card_number'],
      healthCardCost: json['health_card_cost'],
      healthCardIssueDate: json['health_card_issue_date'],
      healthCardExpireDate: json['health_card_expire_date'],
      lmpDate: json['lmp_date'],
      eddDate: json['edd_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'member_id': memberId,
      'profile_id': profileId,
      'display': display,
      'value': value,
      'dead': dead,
      'date_of_death': dateOfDeath,
      'health_card_number': healthCardNumber,
      'health_card_cost': healthCardCost,
      'health_card_issue_date': healthCardIssueDate,
      'health_card_expire_date': healthCardExpireDate,
      'lmp_date': lmpDate,
      'edd_date': eddDate,
    };
  }
}

class SurveyMember {
  final int? userId;
  final int? memberId;
  final int? profileId;
  final String? displayName;
  final String? displayNameBn;
  final String? gender;
  final int? ageYears;
  final bool? householdHead;
  final bool? dead;
  final bool? hasNid;
  final String? nationalId;
  final bool? hasBcn;
  final String? birthCertificateNumber;
  final bool? hasHealthCard;
  final String? healthCardIssueDate;
  final bool? pregnant;
  final bool? pregnancyEligible;
  final int? lmpDate;
  final int? eddDate;
  final List<String>? activeDiseases;
  final List<String>? chronicConditions;

  SurveyMember({
    this.userId,
    this.memberId,
    this.profileId,
    this.displayName,
    this.displayNameBn,
    this.gender,
    this.ageYears,
    this.householdHead,
    this.dead,
    this.hasNid,
    this.nationalId,
    this.hasBcn,
    this.birthCertificateNumber,
    this.hasHealthCard,
    this.healthCardIssueDate,
    this.pregnant,
    this.pregnancyEligible,
    this.lmpDate,
    this.eddDate,
    this.activeDiseases,
    this.chronicConditions,
  });

  String getDisplayName() {
    if (Utils.isLocaleBn()) {
      if (displayNameBn != null && displayNameBn!.isNotEmpty) {
        return DigitConverter.convertToLocalizedNumbers(displayNameBn!);
      }
      if (displayName != null) {
        String d = DigitConverter.convertToLocalizedNumbers(displayName!);
        d = d.replaceAll('Y)', ' বছর)').replaceAll('Y', ' বছর').replaceAll('M)', ' মাস)').replaceAll('D)', ' দিন)');
        return d;
      }
    }
    return displayName ?? '';
  }

  factory SurveyMember.fromJson(Map<String, dynamic> json) {
    return SurveyMember(
      userId: json['user_id'],
      memberId: json['member_id'],
      profileId: json['profile_id'],
      displayName: json['display_name'],
      displayNameBn: json['display_name_bn'] ?? json['name_bn'] ?? json['first_name_bn'],
      gender: json['gender'],
      ageYears: json['age_years'],
      householdHead: json['household_head'],
      dead: json['dead'],
      hasNid: json['has_nid'],
      nationalId: json['national_id'],
      hasBcn: json['has_bcn'],
      birthCertificateNumber: json['birth_certificate_number'],
      hasHealthCard: json['has_health_card'],
      //disable as no need
      //healthCardIssueDate: json['health_card_issue_date'],
      pregnant: json['pregnant'],
      pregnancyEligible: json['pregnancy_eligible'],
      lmpDate: json['lmp_date'],
      eddDate: json['edd_date'],
      activeDiseases: (json['active_diseases'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      chronicConditions: (json['chronic_conditions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'member_id': memberId,
      'profile_id': profileId,
      'display_name': displayName,
      'gender': gender,
      'age_years': ageYears,
      'household_head': householdHead,
      'dead': dead,
      'has_nid': hasNid,
      'national_id': nationalId,
      'has_bcn': hasBcn,
      'birth_certificate_number': birthCertificateNumber,
      'has_health_card': hasHealthCard,
      'health_card_issue_date': healthCardIssueDate,
      'pregnant': pregnant,
      'pregnancy_eligible': pregnancyEligible,
      'lmp_date': lmpDate,
      'edd_date': eddDate,
      'active_diseases': activeDiseases,
      'chronic_conditions': chronicConditions,
    };
  }
}