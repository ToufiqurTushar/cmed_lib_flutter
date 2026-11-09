import 'HouseholdSurevyMember.dart';

class DiseaseMembers {
  DiseaseMembers({
      this.diabetes, 
      this.highbp, 
      this.eyeproblem,});

  DiseaseMembers.fromJson(dynamic json) {
    if (json['DIABETES'] != null) {
      diabetes = [];
      json['DIABETES'].forEach((v) {
        diabetes?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
    if (json['HIGH_BP'] != null) {
      highbp = [];
      json['HIGH_BP'].forEach((v) {
        highbp?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
    if (json['EYE_PROBLEM'] != null) {
      eyeproblem = [];
      json['EYE_PROBLEM'].forEach((v) {
        eyeproblem?.add(HouseholdSurevyMember.fromJson(v));
      });
    }
  }
  List<HouseholdSurevyMember>? diabetes;
  List<HouseholdSurevyMember>? highbp;
  List<HouseholdSurevyMember>? eyeproblem;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (diabetes != null) {
      map['DIABETES'] = diabetes?.map((v) => v.toJson()).toList();
    }
    if (highbp != null) {
      map['HIGH_BP'] = highbp?.map((v) => v.toJson()).toList();
    }
    if (eyeproblem != null) {
      map['EYE_PROBLEM'] = eyeproblem?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}