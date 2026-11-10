import 'HouseholdSurevyMember.dart';

class DiseaseMembers {
  DiseaseMembers({
    this.diabetes,
    this.highbp,
    this.kidneyDisease,
    this.cancer,
    this.lowbp,
    this.malnutritionU5,
    this.eyeproblem,
    this.earproblem,
    this.pneumonia,
    this.diarrhea,
    this.hepatitis,
    this.paralysis,
    this.otherComplicated,
  });

  DiseaseMembers.fromJson(dynamic json) {
    if (json == null || json is! Map) return;

    List<HouseholdSurevyMember>? parseList(dynamic rawList) {
      if (rawList == null || rawList is! List) return null;
      return rawList.map((v) {
        if (v is HouseholdSurevyMember) return v;
        return HouseholdSurevyMember.fromJson(v);
      }).toList();
    }

    diabetes = parseList(json['DIABETES'] ?? json['diabetes']);
    highbp = parseList(json['HIGH_BP'] ?? json['high_bp'] ?? json['highbp']);
    kidneyDisease = parseList(json['KIDNEY_DISEASE'] ?? json['kidney_disease'] ?? json['kidney']);
    cancer = parseList(json['CANCER'] ?? json['cancer']);
    lowbp = parseList(json['LOW_BP'] ?? json['low_bp'] ?? json['lowbp']);
    malnutritionU5 = parseList(json['MALNUTRITION_U5'] ?? json['malnutrition_u5']);
    eyeproblem = parseList(json['EYE_PROBLEM'] ?? json['eye_problem'] ?? json['eyeproblem']);
    earproblem = parseList(json['EAR_PROBLEM'] ?? json['ear_problem'] ?? json['earproblem']);
    pneumonia = parseList(json['PNEUMONIA'] ?? json['pneumonia']);
    diarrhea = parseList(json['DIARRHEA'] ?? json['diarrhea']);
    hepatitis = parseList(json['HEPATITIS'] ?? json['hepatitis']);
    paralysis = parseList(json['PARALYSIS'] ?? json['paralysis']);
    otherComplicated = parseList(json['OTHER_COMPLICATED'] ?? json['other_complicated']);
  }

  List<HouseholdSurevyMember>? diabetes;
  List<HouseholdSurevyMember>? highbp;
  List<HouseholdSurevyMember>? kidneyDisease;
  List<HouseholdSurevyMember>? cancer;
  List<HouseholdSurevyMember>? lowbp;
  List<HouseholdSurevyMember>? malnutritionU5;
  List<HouseholdSurevyMember>? eyeproblem;
  List<HouseholdSurevyMember>? earproblem;
  List<HouseholdSurevyMember>? pneumonia;
  List<HouseholdSurevyMember>? diarrhea;
  List<HouseholdSurevyMember>? hepatitis;
  List<HouseholdSurevyMember>? paralysis;
  List<HouseholdSurevyMember>? otherComplicated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (diabetes != null) {
      map['DIABETES'] = diabetes?.map((v) => v.toJson()).toList();
    }
    if (highbp != null) {
      map['HIGH_BP'] = highbp?.map((v) => v.toJson()).toList();
    }
    if (kidneyDisease != null) {
      map['KIDNEY_DISEASE'] = kidneyDisease?.map((v) => v.toJson()).toList();
    }
    if (cancer != null) {
      map['CANCER'] = cancer?.map((v) => v.toJson()).toList();
    }
    if (lowbp != null) {
      map['LOW_BP'] = lowbp?.map((v) => v.toJson()).toList();
    }
    if (malnutritionU5 != null) {
      map['MALNUTRITION_U5'] = malnutritionU5?.map((v) => v.toJson()).toList();
    }
    if (eyeproblem != null) {
      map['EYE_PROBLEM'] = eyeproblem?.map((v) => v.toJson()).toList();
    }
    if (earproblem != null) {
      map['EAR_PROBLEM'] = earproblem?.map((v) => v.toJson()).toList();
    }
    if (pneumonia != null) {
      map['PNEUMONIA'] = pneumonia?.map((v) => v.toJson()).toList();
    }
    if (diarrhea != null) {
      map['DIARRHEA'] = diarrhea?.map((v) => v.toJson()).toList();
    }
    if (hepatitis != null) {
      map['HEPATITIS'] = hepatitis?.map((v) => v.toJson()).toList();
    }
    if (paralysis != null) {
      map['PARALYSIS'] = paralysis?.map((v) => v.toJson()).toList();
    }
    if (otherComplicated != null) {
      map['OTHER_COMPLICATED'] = otherComplicated?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  DiseaseMembers copyWith({
    List<HouseholdSurevyMember>? diabetes,
    List<HouseholdSurevyMember>? highbp,
    List<HouseholdSurevyMember>? kidneyDisease,
    List<HouseholdSurevyMember>? cancer,
    List<HouseholdSurevyMember>? lowbp,
    List<HouseholdSurevyMember>? malnutritionU5,
    List<HouseholdSurevyMember>? eyeproblem,
    List<HouseholdSurevyMember>? earproblem,
    List<HouseholdSurevyMember>? pneumonia,
    List<HouseholdSurevyMember>? diarrhea,
    List<HouseholdSurevyMember>? hepatitis,
    List<HouseholdSurevyMember>? paralysis,
    List<HouseholdSurevyMember>? otherComplicated,
  }) {
    return DiseaseMembers(
      diabetes: diabetes ?? this.diabetes,
      highbp: highbp ?? this.highbp,
      kidneyDisease: kidneyDisease ?? this.kidneyDisease,
      cancer: cancer ?? this.cancer,
      lowbp: lowbp ?? this.lowbp,
      malnutritionU5: malnutritionU5 ?? this.malnutritionU5,
      eyeproblem: eyeproblem ?? this.eyeproblem,
      earproblem: earproblem ?? this.earproblem,
      pneumonia: pneumonia ?? this.pneumonia,
      diarrhea: diarrhea ?? this.diarrhea,
      hepatitis: hepatitis ?? this.hepatitis,
      paralysis: paralysis ?? this.paralysis,
      otherComplicated: otherComplicated ?? this.otherComplicated,
    );
  }
}
