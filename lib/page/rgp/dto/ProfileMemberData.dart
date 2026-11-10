import 'ChronicRemovalDto.dart';
import 'HouseholdSurevyMember.dart';
import 'DiseaseMembers.dart';

class ProfileMemberData {
  ProfileMemberData({
    this.householdId,
    this.nidMembers,
    this.bcnMembers,
    this.pregnantMembers,
    this.healthCardMembers,
    this.deadMembers,
    this.diseaseMembers,
    this.chronicRemovals,
    this.doctorVisits,
  });

  ProfileMemberData.fromJson(dynamic json) {
    householdId = json['household_id'];
    if (json['nid_members'] != null) {
      nidMembers = [];
      json['nid_members'].forEach((v) {
        nidMembers?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
    if (json['bcn_members'] != null) {
      bcnMembers = [];
      json['bcn_members'].forEach((v) {
        bcnMembers?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
    if (json['pregnant_members'] != null) {
      pregnantMembers = [];
      json['pregnant_members'].forEach((v) {
        pregnantMembers?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
    if (json['health_card_members'] != null) {
      healthCardMembers = [];
      json['health_card_members'].forEach((v) {
        healthCardMembers?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
    if (json['dead_members'] != null) {
      deadMembers = [];
      json['dead_members'].forEach((v) {
        deadMembers?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
    diseaseMembers = json['disease_members'] != null ? DiseaseMembers.fromJson(json['disease_members']) : null;
    if (json['chronic_removals'] != null) {
      chronicRemovals = [];
      json['chronic_removals'].forEach((v) {
        chronicRemovals?.add(ChronicRemovalDto.fromJson(v));
      });
    }
    if (json['doctor_visits'] != null) {
      doctorVisits = [];
      json['doctor_visits'].forEach((v) {
        doctorVisits?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
  }

  int? householdId;
  List<HouseholdSurevyMember>? nidMembers;
  List<HouseholdSurevyMember>? bcnMembers;
  List<HouseholdSurevyMember>? pregnantMembers;
  List<HouseholdSurevyMember>? healthCardMembers;
  List<HouseholdSurevyMember>? deadMembers;
  DiseaseMembers? diseaseMembers;
  List<ChronicRemovalDto>? chronicRemovals;
  List<HouseholdSurevyMember>? doctorVisits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['household_id'] = householdId;
    if (nidMembers != null) {
      map['nid_members'] = nidMembers?.map((v) => v.toJson()).toList();
    }
    if (bcnMembers != null) {
      map['bcn_members'] = bcnMembers?.map((v) => v.toJson()).toList();
    }
    if (pregnantMembers != null) {
      map['pregnant_members'] = pregnantMembers?.map((v) => v.toJson()).toList();
    }
    if (healthCardMembers != null) {
      map['health_card_members'] = healthCardMembers?.map((v) => v.toJson()).toList();
    }
    if (deadMembers != null) {
      map['dead_members'] = deadMembers?.map((v) => v.toJson()).toList();
    }
    if (diseaseMembers != null) {
      map['disease_members'] = diseaseMembers?.toJson();
    }
    if (chronicRemovals != null) {
      map['chronic_removals'] = chronicRemovals?.map((v) => v.toJson()).toList();
    }
    if (doctorVisits != null) {
      map['doctor_visits'] = doctorVisits?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Map<String, dynamic> toSurveyMap() {
    final map = <String, dynamic>{};
    map['household_id'] = householdId;
    if (nidMembers != null) {
      map['nid_members'] = nidMembers?.map((v) => v.toSurveyMap()).toList();
    }
    if (bcnMembers != null) {
      map['bcn_members'] = bcnMembers?.map((v) => v.toSurveyMap()).toList();
    }
    if (pregnantMembers != null) {
      map['pregnant_members'] = pregnantMembers?.map((v) => v.toSurveyMap()).toList();
    }
    if (healthCardMembers != null) {
      map['health_card_members'] = healthCardMembers?.map((v) => v.toSurveyMap()).toList();
    }
    if (deadMembers != null) {
      map['dead_members'] = deadMembers?.map((v) => v.toSurveyMap()).toList();
    }
    if (diseaseMembers != null) {
      map['disease_members'] = diseaseMembers?.toSurveyMap();
    }
    if (chronicRemovals != null) {
      map['chronic_removals'] = chronicRemovals?.map((v) => v.toJson()).toList();
    }
    if (doctorVisits != null) {
      map['doctor_visits'] = doctorVisits?.map((v) => v.toSurveyMap()).toList();
    }
    return map;
  }
}
