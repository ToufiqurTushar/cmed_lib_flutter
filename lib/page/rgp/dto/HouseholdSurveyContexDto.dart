import 'dart:convert';

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
  final String? lmpDate;
  final String? eddDate;

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
  final String? lmpDate;
  final String? eddDate;
  final List<String>? activeDiseases;
  final List<String>? chronicConditions;

  SurveyMember({
    this.userId,
    this.memberId,
    this.profileId,
    this.displayName,
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

  factory SurveyMember.fromJson(Map<String, dynamic> json) {
    return SurveyMember(
      userId: json['user_id'],
      memberId: json['member_id'],
      profileId: json['profile_id'],
      displayName: json['display_name'],
      gender: json['gender'],
      ageYears: json['age_years'],
      householdHead: json['household_head'],
      dead: json['dead'],
      hasNid: json['has_nid'],
      nationalId: json['national_id'],
      hasBcn: json['has_bcn'],
      birthCertificateNumber: json['birth_certificate_number'],
      hasHealthCard: json['has_health_card'],
      healthCardIssueDate: json['health_card_issue_date'],
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