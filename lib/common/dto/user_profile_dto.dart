import 'package:age_calculator/age_calculator.dart';
import 'package:cmed_lib_flutter/common/dto/additional_information.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';

import 'customer_dto.dart';

class UserProfile {
  String? additionalNote;
  String? birthCertificateNumber;
  String? birthPlace;
  int? birthday;
  MasterDataDTO? bloodGroupDTO;
  int? bloodGroup;
  String? companyEmployeeId;
  String? companyJobTitle;
  bool? coronaAffectedStatus;
  int? dateOfConception;
  int? dateOfDeath;
  bool? dead;
  bool? deadDueToCorona;
  bool? diabetic;
  List<DisabilitiesDTO>? disabilities;
  bool? disable;
  bool? doesGoToProsperitySchool;
  int? eddDate;
  int? educationInstitute;
  int? educationQualification;
  String? email;
  bool? familyDiabetes;
  bool? familyHyperTension;
  String? fatherName;
  String? fatherNameBn;
  String? firstName;
  String? firstNameBn;
  bool? freedomFighter;
  int? gender;
  MasterDataDTO? genderDTO;
  bool? govtOfficial;
  bool? hadStroke;
  bool? hasAsthma;
  bool? hasCancer;
  bool? hasCardiovascularDisease;
  bool? hasCopd;
  bool? hasElectricity;
  bool? hasHealthCard;
  bool? hasKidneyDisease;
  double? healthCardCost;
  String? healthCardIssueDate;
  String? healthCardNumber;
  double? height;
  bool? hypertensive;
  int? id;
  bool? isDeadDueToCorona;
  bool? isGovtOfficial;
  bool? isPoor;
  String? lastName;
  String? lastNameBn;
  int? lmpDate;
  MasterDataDTO? maritalStatusDTO;
  String? motherName;
  String? motherNameBn;
  String? nameBn;
  String? nationalId;
  String? nationality;
  int? numberOfTeeth;
  bool? oldAgePension;
  String? organizationName;
  String? passportNumber;
  int? permanentAddressId;
  String? phone;
  String? photo;
  bool? poor;
  int? pregnancyIdentificationDate;
  int? presentAddressId;
  int? primaryOccupation;
  String? prosperitySchoolCenterNumber;
  MasterDataDTO? relationWithHouseholdHeadObj;
  int? relationWithHouseholdHead;
  bool? schoolGoingChildren;
  int? secondaryOccupation;
  List<SymptomsAfterTakenVaccineDTO>? symptomsAfterTakenVaccine;
  int? userId;
  String? uuid;
  List<VaccinationHistory>? vaccinationHistory;
  bool? vaccineTakenStatus;
  double? weight;

  PatientAllergicHistory? patientAllergicHistory;
  GynaecologicalObstetrical? gynaecologicalObstetrical;
  PatientPersonalHistory? patientPersonalHistory;
  List<DrugHistory>? drugHistoryList;
  List<ComorbidityList>? comorbidityList;
  List<Injury>? injuries;
  List<Surgery>? surgeries;
  num? audioServiceRate;
  num? videoServiceRate;
  String? agreementId;
  String? payerReference;
  String? customerMsisdn;
  String? userUuid;
  String? religion;
  String? religionBranch;
  String? education;
  String? occupation;
  double? income;
  AdditionalInformation? additionalInformation;
  String? maritalStatus;
  int? i4weAgentSubscriptionDate;
  bool? i4weSocialProtectionStatus;
  int? i4weSocialProtectionExpiryDate;
  int? i4weAgentSubscriptionExpiryDate;
  String? onboardedByAgentContactNumber;
  String? onboardedByAgentName;

  UserProfile({
    this.additionalNote,
    this.relationWithHouseholdHead,
    this.birthCertificateNumber,
    this.birthPlace,
    this.birthday,
    this.bloodGroupDTO,
    this.bloodGroup,
    this.companyEmployeeId,
    this.companyJobTitle,
    this.coronaAffectedStatus,
    this.dateOfConception,
    this.dateOfDeath,
    this.dead,
    this.deadDueToCorona,
    this.diabetic,
    this.disabilities,
    this.disable,
    this.doesGoToProsperitySchool,
    this.eddDate,
    this.educationInstitute,
    this.educationQualification,
    this.email,
    this.familyDiabetes,
    this.familyHyperTension,
    this.fatherName,
    this.fatherNameBn,
    this.firstName,
    this.firstNameBn,
    this.freedomFighter,
    this.gender,
    this.genderDTO,
    this.govtOfficial,
    this.hadStroke,
    this.hasAsthma,
    this.hasCancer,
    this.hasCardiovascularDisease,
    this.hasCopd,
    this.hasElectricity,
    this.hasHealthCard,
    this.hasKidneyDisease,
    this.healthCardCost,
    this.healthCardIssueDate,
    this.healthCardNumber,
    this.height,
    this.hypertensive,
    this.id,
    this.userUuid,
    this.isDeadDueToCorona,
    this.isGovtOfficial,
    this.isPoor,
    this.lastName,
    this.lastNameBn,
    this.lmpDate,
    this.maritalStatusDTO,
    this.motherName,
    this.motherNameBn,
    this.nameBn,
    this.nationalId,
    this.nationality,
    this.numberOfTeeth,
    this.oldAgePension,
    this.organizationName,
    this.passportNumber,
    this.permanentAddressId,
    this.phone,
    this.photo,
    this.poor,
    this.pregnancyIdentificationDate,
    this.presentAddressId,
    this.primaryOccupation,
    this.prosperitySchoolCenterNumber,
    this.relationWithHouseholdHeadObj,
    this.schoolGoingChildren,
    this.secondaryOccupation,
    this.symptomsAfterTakenVaccine,
    this.userId,
    this.uuid,
    this.vaccineTakenStatus,
    this.weight,
    this.gynaecologicalObstetrical,
    this.patientAllergicHistory,
    this.patientPersonalHistory,
    this.drugHistoryList,
    this.comorbidityList,
    this.injuries,
    this.surgeries,
    this.agreementId,
    this.audioServiceRate,
    this.videoServiceRate,
    this.payerReference,
    this.customerMsisdn,
    this.religion,
    this.religionBranch,
    this.education,
    this.occupation,
    this.income,
    this.maritalStatus,
    this.additionalInformation,
    this.vaccinationHistory,
    this.i4weAgentSubscriptionDate,
    this.i4weSocialProtectionStatus,
    this.i4weSocialProtectionExpiryDate,
    this.i4weAgentSubscriptionExpiryDate,
    this.onboardedByAgentContactNumber,
    this.onboardedByAgentName,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    additionalNote = json['additional_note'];
    userUuid = json['user_uuid'];
    birthCertificateNumber = json['birth_certificate_number'];
    birthPlace = json['birth_place'];
    birthday = json['birthday'];
    bloodGroup = json['blood_group'];
    bloodGroupDTO = json['blood_group_obj'] != null ? MasterDataDTO.fromJson(json['blood_group_obj']) : null;
    companyEmployeeId = json['company_employee_id'];
    companyJobTitle = json['company_job_title'];
    coronaAffectedStatus = json['corona_affected_status'];
    dateOfConception = json['date_of_conception'];
    dateOfDeath = json['date_of_death'];
    dead = json['dead'];
    deadDueToCorona = json['deadDueToCorona'];
    diabetic = json['diabetic'];
    if (json['disabilities'] != null) {
      disabilities = <DisabilitiesDTO>[];
      json['disabilities'].forEach((v) {
        disabilities!.add(DisabilitiesDTO.fromJson(v));
      });
    }
    disable = json['disable'];
    doesGoToProsperitySchool = json['does_go_to_prosperity_school'];
    eddDate = json['edd_date'];
    educationInstitute = json['education_institute'];
    educationQualification = json['education_qualification'];
    email = json['email']?.trim() == "" ? null : json['email'];
    familyDiabetes = json['family_diabetes'];
    familyHyperTension = json['family_hyper_tension'];
    fatherName = json['father_name'];
    fatherNameBn = json['father_name_bn'];
    firstName = json['first_name'];
    firstNameBn = json['first_name_bn'];
    freedomFighter = json['freedom_fighter'];
    gender = json['gender'];
    genderDTO = json['genderObj'] != null ? MasterDataDTO.fromJson(json['genderObj']) : null;
    govtOfficial = json['govtOfficial'];
    hadStroke = json['had_stroke'];
    hasAsthma = json['has_asthma'];
    hasCancer = json['has_cancer'];
    hasCardiovascularDisease = json['has_cardiovascular_disease'];
    hasCopd = json['has_copd'];
    hasElectricity = json['has_electricity'];
    hasHealthCard = json['has_health_card'];
    hasKidneyDisease = json['has_kidney_disease'];
    healthCardCost = json['health_card_cost'];
    healthCardIssueDate = json['health_card_issue_date'];
    healthCardNumber = json['health_card_number'];
    height = json['height'];
    hypertensive = json['hypertensive'];
    id = json['id'];
    isDeadDueToCorona = json['is_dead_due_to_corona'];
    isGovtOfficial = json['is_govt_official'];
    isPoor = json['is_poor'];
    lastName = json['last_name'];
    lastNameBn = json['last_name_bn'];
    lmpDate = json['lmp_date'];
    maritalStatusDTO = json['maritalStatusObj'] != null ? MasterDataDTO.fromJson(json['maritalStatusObj']) : null;
    maritalStatus = json['marital_status'];

    motherName = json['mother_name'];
    motherNameBn = json['mother_name_bn'];
    nameBn = json['name_bn'];
    nationalId = json['national_id'];
    nationality = json['nationality'];
    numberOfTeeth = json['number_of_teeth'];
    oldAgePension = json['old_age_pension'];
    organizationName = json['organization_name'];
    passportNumber = json['passport_number'];
    permanentAddressId = json['permanent_address_id'];
    phone = json['phone'];
    photo = json['photo'];
    poor = json['poor'];
    pregnancyIdentificationDate = json['pregnancy_identification_date'];
    presentAddressId = json['present_address_id'];
    primaryOccupation = json['primary_occupation'];
    prosperitySchoolCenterNumber = json['prosperity_school_center_number'];
    relationWithHouseholdHead = json['relation_with_household_head'];
    relationWithHouseholdHeadObj = json['relation_with_household_head_obj'] != null
        ? MasterDataDTO.fromJson(json['relation_with_household_head_obj'])
        : null;
    religion = json['religion'];
    schoolGoingChildren = json['school_going_children'];
    secondaryOccupation = json['secondary_occupation'];
    if (json['symptoms_after_taken_vaccine'] != null) {
      symptomsAfterTakenVaccine = <SymptomsAfterTakenVaccineDTO>[];
      json['symptoms_after_taken_vaccine'].forEach((v) {
        symptomsAfterTakenVaccine!.add(SymptomsAfterTakenVaccineDTO.fromJson(v));
      });
    }
    if (json['vaccinationHistory'] != null) {
      vaccinationHistory = <VaccinationHistory>[];
      json['vaccinationHistory'].forEach((v) {
        vaccinationHistory!.add(VaccinationHistory.fromJson(v));
      });
    }
    userId = json['user_id'];
    uuid = json['uuid'];
    vaccineTakenStatus = json['vaccine_taken_status'];
    weight = json['weight'];

    patientAllergicHistory = json['patientAllergicHistory'] != null
        ? PatientAllergicHistory.fromJson(json['patientAllergicHistory'])
        : null;
    patientPersonalHistory = json['patientPersonalHistory'] != null
        ? PatientPersonalHistory.fromJson(json['patientPersonalHistory'])
        : null;
    gynaecologicalObstetrical = json['gynaecologicalObstetrical'] != null
        ? GynaecologicalObstetrical.fromJson(json['gynaecologicalObstetrical'])
        : null;
    if (json['drugHistoryList'] != null) {
      drugHistoryList = [];
      json['drugHistoryList'].forEach((v) {
        drugHistoryList?.add(DrugHistory.fromJson(v));
      });
    }
    if (json['comorbidityList'] != null) {
      comorbidityList = [];
      json['comorbidityList'].forEach((v) {
        comorbidityList?.add(ComorbidityList.fromJson(v));
      });
    }
    if (json['injuries'] != null) {
      injuries = [];
      json['injuries'].forEach((v) {
        injuries?.add(Injury.fromJson(v));
      });
    }
    if (json['surgeries'] != null) {
      surgeries = [];
      json['surgeries'].forEach((v) {
        surgeries?.add(Surgery.fromJson(v));
      });
    }
    audioServiceRate = json['audio_service_rate'];
    videoServiceRate = json['video_service_rate'];
    agreementId = json['agreement_id'];
    payerReference = json['payer_reference'];
    customerMsisdn = json['customer_msisdn'];

    religion = json['religion'];
    education = json['education'];
    occupation = json['occupation'];
    maritalStatus = json['marital_status'];
    religionBranch = json['religion_branch'];
    additionalInformation = json['additional_information'] != null
        ? AdditionalInformation.fromJson(json['additional_information'])
        : null;
    income = json['income'];
    if (json['vaccinationHistory'] != null) {
      // vaccinationHistory = [];
      json['vaccinationHistory'].forEach((v) {
        vaccinationHistory!.add(VaccinationHistory.fromJson(v));
      });
    }
    onboardedByAgentName = json['onboarded_by_agent_name'];
    onboardedByAgentContactNumber = json['onboarded_by_agent_contact_number'];
    i4weAgentSubscriptionExpiryDate = json['i4we_agent_subscription_expiry_date'];
    i4weAgentSubscriptionDate = json['i4we_agent_subscription_date'];
    i4weSocialProtectionStatus = json['i4we_social_protection_status'];
    i4weSocialProtectionExpiryDate = json['social_protection_expiry_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['additional_note'] = additionalNote;
    data['birth_certificate_number'] = birthCertificateNumber;
    data['birth_place'] = birthPlace;
    data['birthday'] = birthday;
    if (bloodGroupDTO != null) {
      data['bloodGroupObj'] = bloodGroupDTO!.toJson();
    }
    data['blood_group'] = bloodGroup;
    if (bloodGroupDTO != null) {
      data['blood_group_obj'] = bloodGroupDTO!.toJson();
    }
    data['company_employee_id'] = companyEmployeeId;
    data['company_job_title'] = companyJobTitle;
    data['corona_affected_status'] = coronaAffectedStatus;
    data['date_of_conception'] = dateOfConception;
    data['date_of_death'] = dateOfDeath;
    data['dead'] = dead;
    data['deadDueToCorona'] = deadDueToCorona;
    data['diabetic'] = diabetic;
    if (disabilities != null) {
      data['disabilities'] = disabilities!.map((v) => v.toJson()).toList();
    }
    data['disable'] = disable;
    data['relation_with_household_head'] = relationWithHouseholdHead;
    data['does_go_to_prosperity_school'] = doesGoToProsperitySchool;
    data['edd_date'] = eddDate;
    data['education_institute'] = educationInstitute;
    data['education_qualification'] = educationQualification;
    data['email'] = email?.trim() == "" ? null : email;
    data['family_diabetes'] = familyDiabetes;
    data['family_hyper_tension'] = familyHyperTension;
    data['father_name'] = fatherName;
    data['father_name_bn'] = fatherNameBn;
    data['first_name'] = firstName;
    data['first_name_bn'] = firstNameBn;
    data['freedom_fighter'] = freedomFighter;
    data['gender'] = gender;
    if (genderDTO != null) {
      data['genderObj'] = genderDTO!.toJson();
    }
    if (genderDTO != null) {
      data['gender_obj'] = genderDTO!.toJson();
    }
    data['govtOfficial'] = govtOfficial;
    data['had_stroke'] = hadStroke;
    data['has_asthma'] = hasAsthma;
    data['has_cancer'] = hasCancer;
    data['has_cardiovascular_disease'] = hasCardiovascularDisease;
    data['has_copd'] = hasCopd;
    data['has_electricity'] = hasElectricity;
    data['has_health_card'] = hasHealthCard;
    data['has_kidney_disease'] = hasKidneyDisease;
    data['health_card_cost'] = healthCardCost;
    data['health_card_issue_date'] = healthCardIssueDate;
    data['health_card_number'] = healthCardNumber;
    data['height'] = height;
    data['hypertensive'] = hypertensive;
    data['id'] = id;
    data['user_uuid'] = userUuid;
    data['is_dead_due_to_corona'] = isDeadDueToCorona;
    data['is_govt_official'] = isGovtOfficial;
    data['is_poor'] = isPoor;
    data['last_name'] = lastName;
    data['last_name_bn'] = lastNameBn;
    data['lmp_date'] = lmpDate;
    if (maritalStatusDTO != null) {
      data['maritalStatusObj'] = maritalStatusDTO!.toJson();
    }

    data['mother_name'] = motherName;
    data['mother_name_bn'] = motherNameBn;
    data['name_bn'] = nameBn;
    data['national_id'] = nationalId;
    data['nationality'] = nationality;
    data['number_of_teeth'] = numberOfTeeth;
    data['old_age_pension'] = oldAgePension;
    data['organization_name'] = organizationName;
    data['passport_number'] = passportNumber;
    data['permanent_address_id'] = permanentAddressId;
    data['phone'] = phone;
    data['photo'] = photo;
    data['poor'] = poor;
    data['pregnancy_identification_date'] = pregnancyIdentificationDate;
    data['present_address_id'] = presentAddressId;
    data['primary_occupation'] = primaryOccupation;
    data['prosperity_school_center_number'] = prosperitySchoolCenterNumber;
    if (relationWithHouseholdHeadObj != null) {
      data['relation_with_household_head_obj'] = relationWithHouseholdHeadObj!.toJson();
    }

    data['school_going_children'] = schoolGoingChildren;
    data['secondary_occupation'] = secondaryOccupation;
    if (symptomsAfterTakenVaccine != null) {
      data['symptoms_after_taken_vaccine'] = symptomsAfterTakenVaccine!.map((v) => v.toJson()).toList();
    }
    data['user_id'] = userId;
    data['uuid'] = uuid;
    data['vaccine_taken_status'] = vaccineTakenStatus;
    data['weight'] = weight;

    if (patientAllergicHistory != null) {
      data['patientAllergicHistory'] = patientAllergicHistory?.toJson();
    }
    if (patientPersonalHistory != null) {
      data['patientPersonalHistory'] = patientPersonalHistory?.toJson();
    }

    if (gynaecologicalObstetrical != null) {
      data['gynaecologicalObstetrical'] = gynaecologicalObstetrical?.toJson();
    }

    if (drugHistoryList != null) {
      data['drugHistoryList'] = drugHistoryList?.map((v) => v.toJson()).toList();
    }
    if (comorbidityList != null) {
      data['comorbidityList'] = comorbidityList?.map((v) => v.toJson()).toList();
    }
    if (injuries != null) {
      data['injuries'] = injuries?.map((v) => v.toJson()).toList();
    }
    if (surgeries != null) {
      data['surgeries'] = surgeries?.map((v) => v.toJson()).toList();
    }

    data['audio_service_rate'] = audioServiceRate;
    data['video_service_rate'] = videoServiceRate;
    data['agreement_id'] = agreementId;
    data['payer_reference'] = payerReference;
    data['customer_msisdn'] = customerMsisdn;

    data['religion'] = religion;
    data['occupation'] = occupation;
    data['education'] = education;
    data['marital_status'] = maritalStatus;
    data['income'] = income;
    data['religion_branch'] = religionBranch;
    data['additional_information'] = additionalInformation?.toJson();
    if (vaccinationHistory != null) {
      data['vaccinationHistory'] = vaccinationHistory!.map((v) => v.toJson()).toList();
    }
    // 'vaccinationHistory': vaccinationHistoryToJson(vaccinationHistory),
    data['onboarded_by_agent_name'] = onboardedByAgentName;
    data['onboarded_by_agent_contact_number'] = onboardedByAgentContactNumber;
    data['i4we_agent_subscription_expiry_date'] = i4weAgentSubscriptionExpiryDate;
    data['i4we_agent_subscription_date'] = i4weAgentSubscriptionDate;
    data['i4we_social_protection_status'] = i4weSocialProtectionStatus;
    data['social_protection_expiry_date'] = i4weSocialProtectionExpiryDate;
    return data;
  }

  String getProfilePhotoUrl() {
    return photo ?? '';
    // return "${appEnvConfig.baseUrl}$photo";
    // return "https://ask-mortgage-question.sarojroy.com/files/questions/image-picker-96af9434-ee13-4f50-81bb-2a4521cbd754-46982-00003ca5dcc6c835-630c46872c28b610610174.jpg";
  }

  String getNationalId() {
    return (nationalId != null && nationalId!.trim().isNotEmpty) ? nationalId! : "N/A";
  }

  String getLastName() {
    return (lastName != null && lastName!.trim().isNotEmpty) ? lastName! : "N/A";
  }

  int getAgeInYear() {
    if (birthday != null) {
      var ageCalculator = AgeCalculator.age(DateTime.fromMillisecondsSinceEpoch(birthday!));
      return ageCalculator.years;
    }
    return 0;
  }

  int getAgeInMonth() {
    if (birthday != null) {
      var ageCalculator = AgeCalculator.age(DateTime.fromMillisecondsSinceEpoch(birthday!));
      return ageCalculator.years * 12 + ageCalculator.months;
    }
    return 0;
  }

  int getAgeInDay() {
    if (birthday != null) {
      var ageCalculator = AgeCalculator.age(DateTime.fromMillisecondsSinceEpoch(birthday!));
      return ageCalculator.years * 12 * 365 + ageCalculator.months * 30 + ageCalculator.days;
    }
    return 0;
  }

  bool getIsGenderMale() {
    return gender == 1;
  }

  bool getIsGenderFeMale() {
    return gender == 2;
  }

  String getGenderString() {
    return gender == 1
        ? 'Male'
        : gender == 2
        ? 'Female'
        : 'Others';
  }

  CustomerDTO toCustomer() {
    return CustomerDTO(
      userId: userId,
      firstName: firstName,
      firstNameBn: firstNameBn,
      lastName: lastName,
      lastNameBn: lastNameBn,
      gender: gender,
      imageUrl: photo,
      bloodGroup: bloodGroup,
      birthDate: birthday,
      hasAsthma: hasAsthma,
      hasKidneyDisease: hasKidneyDisease,
      hasCancer: hasCancer,
      contactNumber: phone,
      isPoor: isPoor,
      isGovtOfficial: isGovtOfficial,
      religion: religion,
      occupation: occupation,
      education: education,
      maritalStatus: maritalStatus,
      income: income,
      religionBranch: religionBranch,
      additionalInformation: additionalInformation,
      email: email,
    );
  }
}

class VaccinationHistory {
  int? id;
  int? profileId;
  String? status;
  int? userId;
  String? uuid;
  String? vaccineDate;
  String? vaccineName;

  VaccinationHistory({
    this.id,
    this.profileId,
    this.status,
    this.userId,
    this.uuid,
    this.vaccineDate,
    this.vaccineName,
  });

  factory VaccinationHistory.fromJson(Map<String, dynamic> json) {
    return VaccinationHistory(
      id: json['id'],
      profileId: json['profile_id'],
      status: json['status'],
      userId: json['user_id'],
      uuid: json['uuid'],
      vaccineDate: json['vaccine_date'],
      vaccineName: json['vaccine_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'status': status,
      'user_id': userId,
      'uuid': uuid,
      'vaccine_date': vaccineDate,
      'vaccine_name': vaccineName,
    };
  }
}

class DisabilitiesDTO {
  String? name;

  DisabilitiesDTO({this.name});

  DisabilitiesDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class SymptomsAfterTakenVaccineDTO {
  String? description;
  String? name;

  SymptomsAfterTakenVaccineDTO({this.description, this.name});

  SymptomsAfterTakenVaccineDTO.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['name'] = name;
    return data;
  }
}

class ComorbidityList {
  ComorbidityList({this.existIn, this.comorbidity});

  ComorbidityList.fromJson(dynamic json) {
    existIn = json['existIn'];
    comorbidity = json['comorbidity'] != null ? Comorbidity.fromJson(json['comorbidity']) : null;
  }
  int? existIn;
  Comorbidity? comorbidity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['existIn'] = existIn;
    if (comorbidity != null) {
      map['comorbidity'] = comorbidity?.toJson();
    }
    return map;
  }
}

class Comorbidity {
  Comorbidity({this.name, this.verified, this.id, this.uuid, this.createdAt, this.lastUpdated});

  Comorbidity.fromJson(dynamic json) {
    name = json['name'];
    verified = json['verified'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
  }
  String? name;
  bool? verified;
  num? id;
  String? uuid;
  num? createdAt;
  num? lastUpdated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['verified'] = verified;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    return map;
  }
}

class DrugHistory {
  DrugHistory({
    this.medicineName,
    this.strength,
    this.type,
    this.dar,
    this.dosage,
    this.durationTime,
    this.durationUnit,
    this.description,
  });

  DrugHistory.fromJson(dynamic json) {
    medicineName = json['medicineName'];
    strength = json['strength'];
    type = json['type'];
    dar = json['dar'];
    dosage = json['dosage'];
    durationTime = json['durationTime'];
    durationUnit = json['durationUnit'];
    description = json['description'];
  }
  String? medicineName;
  String? strength;
  String? type;
  String? dar;
  String? dosage;
  int? durationTime;
  String? durationUnit;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['medicineName'] = medicineName;
    map['strength'] = strength;
    map['type'] = type;
    map['dar'] = dar;
    map['dosage'] = dosage;
    map['durationTime'] = durationTime;
    map['durationUnit'] = durationUnit;
    map['description'] = description;
    return map;
  }
}

class Injury {
  Injury({this.previousInjury, this.description, this.injuryDate, this.injuryTypes});

  Injury.fromJson(dynamic json) {
    previousInjury = json['previousInjury'];
    description = json['description'];
    injuryDate = json['injuryDate'];
    injuryTypes = json['injuryTypes'];
  }
  bool? previousInjury;
  String? description;
  int? injuryDate;
  String? injuryTypes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['previousInjury'] = previousInjury;
    map['description'] = description;
    map['injuryDate'] = injuryDate;
    map['injuryTypes'] = injuryTypes;
    return map;
  }
}

class PatientAllergicHistory {
  PatientAllergicHistory({
    this.food,
    this.foodTypeNames,
    this.medicine,
    this.medicineTypeNames,
    this.pollen,
    this.dust,
    this.mites,
    this.other,
    this.userId,
  });

  PatientAllergicHistory.fromJson(dynamic json) {
    food = json['food'];
    foodTypeNames = json['foodTypeNames'];
    medicine = json['medicine'];
    medicineTypeNames = json['medicineTypeNames'];
    pollen = json['pollen'];
    dust = json['dust'];
    mites = json['mites'];
    other = json['other'];
    userId = json['userId'];
  }
  bool? food;
  String? foodTypeNames;
  bool? medicine;
  String? medicineTypeNames;
  bool? pollen;
  bool? dust;
  bool? mites;
  String? other;
  num? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['food'] = food;
    map['foodTypeNames'] = foodTypeNames;
    map['medicine'] = medicine;
    map['medicineTypeNames'] = medicineTypeNames;
    map['pollen'] = pollen;
    map['dust'] = dust;
    map['mites'] = mites;
    map['other'] = other;
    map['userId'] = userId;
    return map;
  }
}

class PatientPersonalHistory {
  PatientPersonalHistory({
    this.activityLevel,
    this.alcohol,
    this.alcoholDescriptions,
    this.alcoholDurationTime,
    this.alcoholDurationUnit,
    this.foodPreference,
    this.other,
    this.userId,
    this.smoking,
    this.smokingDescriptions,
    this.smokingDurationTime,
    this.smokingDurationUnit,
  });

  PatientPersonalHistory.fromJson(dynamic json) {
    activityLevel = json['activityLevel'];
    alcohol = json['alcohol'];
    alcoholDescriptions = json['alcoholDescriptions'];
    alcoholDurationTime = json['alcoholDurationTime'];
    alcoholDurationUnit = json['alcoholDurationUnit'];
    foodPreference = json['foodPreference'];
    other = json['other'];
    userId = json['userId'];
    smoking = json['smoking'];
    smokingDescriptions = json['smokingDescriptions'];
    smokingDurationTime = json['smokingDurationTime'];
    smokingDurationUnit = json['smokingDurationUnit'];
  }
  String? activityLevel;
  bool? alcohol;
  String? alcoholDescriptions;
  int? alcoholDurationTime;
  String? alcoholDurationUnit;
  String? foodPreference;
  String? other;
  int? userId;
  bool? smoking;
  String? smokingDescriptions;
  int? smokingDurationTime;
  String? smokingDurationUnit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['activityLevel'] = activityLevel;
    map['alcohol'] = alcohol;
    map['alcoholDescriptions'] = alcoholDescriptions;
    map['alcoholDurationTime'] = alcoholDurationTime;
    map['alcoholDurationUnit'] = alcoholDurationUnit;
    map['foodPreference'] = foodPreference;
    map['other'] = other;
    map['userId'] = userId;
    map['smoking'] = smoking;
    map['smokingDescriptions'] = smokingDescriptions;
    map['smokingDurationTime'] = smokingDurationTime;
    map['smokingDurationUnit'] = smokingDurationUnit;
    return map;
  }
}

class Surgery {
  Surgery({this.previousSurgery, this.surgeryDate, this.surgeryName});

  Surgery.fromJson(dynamic json) {
    previousSurgery = json['previousSurgery'];
    surgeryDate = json['surgeryDate'];
    surgeryName = json['surgeryName'];
  }
  bool? previousSurgery;
  int? surgeryDate;
  String? surgeryName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['previousSurgery'] = previousSurgery;
    map['surgeryDate'] = surgeryDate;
    map['surgeryName'] = surgeryName;
    return map;
  }
}

class GynaecologicalObstetrical {
  GynaecologicalObstetrical({
    this.ageOfMenarche,
    this.menstruationCycle,
    this.menstruationCyclePeriod,
    this.menstruationFlow,
    this.menstruationPeriod,
    this.menstruationLmpDate,
    this.obsLmp,
    this.obsEdd,
    this.obsPara,
    this.obsGravida,
    this.obsAlc,
    this.obsDeliveryType,
    this.obsPvExam,
    this.pregnant,
    this.obsContraceptiveType,
    this.id,
    this.uuid,
    this.createdAt,
    this.lastUpdated,
    this.createdById,
    this.updatedById,
  });

  GynaecologicalObstetrical.fromJson(dynamic json) {
    ageOfMenarche = json['ageOfMenarche'];
    menstruationCycle = json['menstruationCycle'];
    menstruationCyclePeriod = json['menstruationCyclePeriod']?.trim() == ""
        ? null
        : json['menstruationCyclePeriod']?.trim();
    menstruationFlow = json['menstruationFlow'];
    menstruationPeriod = json['menstruationPeriod'];
    menstruationLmpDate = json['menstruationLmpDate'];
    obsLmp = json['obsLmp'];
    obsEdd = json['obsEdd'];
    obsPara = json['obsPara'];
    obsGravida = json['obsGravida'];
    obsAlc = json['obsAlc'];
    obsDeliveryType = json['obsDeliveryType'];
    obsPvExam = json['obsPvExam'];
    pregnant = json['pregnant'];
    obsContraceptiveType = json['obsContraceptiveType'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
  }
  int? ageOfMenarche;
  String? menstruationCycle;
  String? menstruationCyclePeriod;
  String? menstruationFlow;
  String? menstruationPeriod;
  int? menstruationLmpDate;
  int? obsLmp;
  int? obsEdd;
  String? obsPara;
  String? obsGravida;
  String? obsAlc;
  String? obsDeliveryType;
  String? obsPvExam;
  bool? pregnant;
  String? obsContraceptiveType;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ageOfMenarche'] = ageOfMenarche;
    map['menstruationCycle'] = menstruationCycle;
    map['menstruationCyclePeriod'] = menstruationCyclePeriod;
    map['menstruationFlow'] = menstruationFlow;
    map['menstruationPeriod'] = menstruationPeriod;
    map['menstruationLmpDate'] = menstruationLmpDate;
    map['obsLmp'] = obsLmp;
    map['obsEdd'] = obsEdd;
    map['obsPara'] = obsPara;
    map['obsGravida'] = obsGravida;
    map['obsAlc'] = obsAlc;
    map['obsDeliveryType'] = obsDeliveryType;
    map['obsPvExam'] = obsPvExam;
    map['pregnant'] = pregnant;
    map['obsContraceptiveType'] = obsContraceptiveType;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    return map;
  }
}
