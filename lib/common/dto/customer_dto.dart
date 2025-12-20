import 'dart:convert';
import 'package:age_calculator/age_calculator.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/helper/CalanderUtil.dart';
import '../enum/sample_collection_type.dart';
import 'additional_information.dart';
import 'base_entity_dto.dart';
import 'lab_technitian_investigations_dto.dart';
import 'member_dto.dart';

class CustomerDTO extends BaseEntity {
  String? localId;
  int? pinCode;
  int? serverId;
  String? firstNameBn;
  String? firstName;
  String? lastNameBn;
  String? lastName;
  int? agentId;
  int? birthDate;
  int? bloodGroup;
  String? bloodGroupString;
  String? companyEmployeeId;
  int? companyId;
  String? companyName;
  String? designation;
  bool? isGovtOfficial;
  bool? isPoor;
  bool? isFreedomFighter;
  String? email;
  int? gender;
  double? heightCentimeter;
  int? heightFeet;
  double? heightInch;
  int? homeAddressId;
  String? addressUUID;
  String? addressString;
  bool? isDiabetic;
  bool? isHypertensive;
  bool? hasAsthma;
  bool? hasCOPD;
  bool? hasKidneyDisease;
  bool? hasHeartDisease;
  bool? hasStroke;
  bool? hasCancer;
  bool? hasDisability;
  String? imageUrl;
  String? contactNumber;
  int? userId;
  String? userUuid;
  int? memberId;
  String? username;
  String? nidNumber;
  double? weight;
  int? pulse;
  bool? isCorporate;
  String? householdUuid;
  int? householdId;
  bool? isFromRemote;
  List<dynamic>? measurementBundle;
  List<MemberDTO>? familyMembers;
  bool isExpanded;
  bool isFamilyMember;
  bool? hasSubscribeToAnyHealthPackage;
  String? dateRange;
  int? measuredAt;
  int? age;
  String? itemType;
  int? occupiedServiceId;
  int? occupiedTrackingStateId;
  int? parentUserId;
  String? parentUserPhone;
  String? parentUsername;
  final SampleCollectionLocationType visitType;
  String? sampleType;
  String? status;
  List<LabTechnitianInvestigationDto>? labTechnitianInvestigations;
  int? referralId;
  String? sampleCollectionPlace;
  String? referTo;
  int? referredOn;
  String? reason;
  String? investigationStatus;

  String? divisionNameEn;
  String? divisionNameBn;
  String? districtNameEn;
  String? districtNameBn;
  String? upazilaNameEn;
  String? upazilaNameBn;
  String? unionNameEn;
  String? unionNameBn;
  String? userAddress;
  String? pageTitle;
  String? religion;
  String? religionBranch;
  String? education;
  String? occupation;
  double? income;
  AdditionalInformation? additionalInformation;
  String? maritalStatus;
  String? fromWhere;
  bool isHouseholdHead = true;

  CustomerDTO({
    this.pinCode,
    this.serverId,
    this.firstNameBn,
    this.firstName,
    this.lastNameBn,
    this.lastName,
    this.agentId,
    this.birthDate,
    this.bloodGroup,
    this.bloodGroupString,
    this.companyEmployeeId,
    this.companyId,
    this.companyName,
    this.designation,
    this.isGovtOfficial,
    this.isPoor,
    this.isFreedomFighter,
    this.email,
    this.gender,
    this.heightCentimeter,
    this.heightFeet,
    this.heightInch,
    this.homeAddressId,
    this.addressUUID,
    this.addressString,
    this.isDiabetic,
    this.isHypertensive,
    this.hasAsthma,
    this.hasCOPD,
    this.hasKidneyDisease,
    this.hasHeartDisease,
    this.hasStroke,
    this.hasCancer,
    this.hasDisability,
    this.imageUrl,
    this.contactNumber,
    this.userId,
    this.memberId,
    this.username,
    this.nidNumber,
    this.weight,
    this.pulse,
    this.isCorporate,
    this.householdUuid,
    this.householdId,
    this.isFromRemote = false,
    this.measurementBundle,
    this.familyMembers,
    this.hasSubscribeToAnyHealthPackage,
    this.isExpanded = false,
    this.isFamilyMember = false,
    this.dateRange,
    this.measuredAt,
    this.age = 0,
    this.itemType,
    this.occupiedServiceId,
    this.occupiedTrackingStateId,
    this.parentUserId,
    this.parentUserPhone,
    this.parentUsername,
    this.visitType = SampleCollectionLocationType.HOME_SAMPLE,
    this.sampleType,
    this.status,
    this.labTechnitianInvestigations,
    this.referralId,
    this.sampleCollectionPlace,
    this.referTo,
    this.referredOn,
    this.reason,
    this.investigationStatus,
    this.divisionNameEn,
    this.divisionNameBn,
    this.districtNameEn,
    this.districtNameBn,
    this.upazilaNameEn,
    this.upazilaNameBn,
    this.unionNameEn,
    this.unionNameBn,
    this.userAddress,
    this.pageTitle,
    this.religion,
    this.religionBranch,
    this.education,
    this.occupation,
    this.income,
    this.maritalStatus,
    this.additionalInformation,
    this.fromWhere,
    this.isHouseholdHead = true,

  });

  factory CustomerDTO.fromJson(Map<String, dynamic> json) {
    var familyMembersFromJson = json['familyMembers'] as List?;
    List<MemberDTO> familyMembersList = familyMembersFromJson != null
        ? familyMembersFromJson
            .map((member) => MemberDTO.fromJson(member))
            .toList()
        : [];

    List<LabTechnitianInvestigationDto> labTests = [];
    if(json['investigations'] != null){
      json['investigations'].forEach((v) {
        labTests.add(LabTechnitianInvestigationDto.fromJson(v));
      });
    }


    return CustomerDTO(
      pinCode: json['pin_code'],
      serverId: json['serverId'],
      firstNameBn: json['first_name_bn'],
      firstName: json['first_name_en'],
      lastNameBn: json['last_name_bn'],
      lastName: json['last_name_en'],
      agentId: json['agent_id'],
      birthDate: json['birthday'],
      bloodGroup: json['blood_group'],
      bloodGroupString: json['blood_group_string'],
      companyEmployeeId: json['company_employee_id'],
      companyId: json['company_id'],
      companyName: json['company_name'],
      designation: json['designation'],
      isGovtOfficial: json['is_govt_official'],
      isPoor: json['is_poor'],
      isFreedomFighter: json['freedom_fighter'],
      email: json['email'],
      gender: json['gender'],
      heightCentimeter: json['height'],
      heightFeet: json['height_feet'],
      heightInch: json['height_inch'],
      homeAddressId: json['home_address_id'],
      addressUUID: json['home_address_uuid'],
      addressString: json['address_string'],
      isDiabetic: json['diabetic'],
      isHypertensive: json['hypertensive'],
      hasAsthma: json['has_asthma'],
      hasCOPD: json['copd'],
      hasKidneyDisease: json['ckd'],
      hasHeartDisease: json['heart_disease'],
      hasStroke: json['stroke'],
      hasCancer: json['cancer'],
      hasDisability: json['disable'],
      imageUrl: json['image'],
      contactNumber: json['phone'],
      userId: json['user_id'],
      memberId: json['member_id'],
      username: json['username'],
      nidNumber: json['nid_number'],
      weight: json['weight'],
      pulse: json['pulse'],
      isCorporate: json['is_corporate'],
      occupiedServiceId: json['occupied_service_id'],
      occupiedTrackingStateId: json['occupied_tracking_state_id'],
      householdUuid: json['household_uuid'],
      householdId: json['household_id'],
      isFromRemote: json['is_from_remote'] ?? false,
      hasSubscribeToAnyHealthPackage: json['has_subscribe_to_any_health_package'] ?? false,
      measurementBundle: json['measurementBundle'] ?? [],
      familyMembers: familyMembersList,
      measuredAt: json['measuredAt'],
      itemType: json['item_type'],
      parentUserId: json['parent_user_id'],
      visitType: json['visit_type'] != null
          ? SampleCollectionLocationType.values.firstWhere(
            (e) => e.toString().split('.').last == json['visit_type'],
        orElse: () => SampleCollectionLocationType.HOME_SAMPLE,
      )
          : SampleCollectionLocationType.HOME_SAMPLE,

        sampleType: json['Sample_type'],
        status: json['status'],
        labTechnitianInvestigations: labTests,
      referralId: json['referral_id'],
      sampleCollectionPlace: json['sample_collection_place'],
      referTo: json['refer_to'],
      referredOn: json['referred_on'],
      reason: json['reason'],
      investigationStatus: json['investigation_status'],

      divisionNameEn: json['division_name_en'],
      divisionNameBn: json['division_name_bn'],
      districtNameEn: json['district_name_en'],
      districtNameBn: json['district_name_bn'],
      upazilaNameEn: json['upazila_name_en'],
      upazilaNameBn: json['upazila_name_bn'],
      unionNameEn: json['union_name_en'],
      unionNameBn: json['union_name_bn'],
      userAddress: json['user_address'],
      parentUserPhone: json['parent_user_phone'],
      parentUsername: json['parent_username'],
      pageTitle: json['pageTitle'],
      religion: json['religion'],
      education: json['education'],
      occupation: json['occupation'],
      maritalStatus: json['marital_status'],
      religionBranch: json['religion_branch'],
      income: json['income'],
      isHouseholdHead: json['isHouseholdHead']??true,
      additionalInformation: json['additional_information'] != null ? AdditionalInformation.fromJson(json['additional_information']) : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': localId,
      'pin_code': pinCode,
      'serverId': serverId,
      'first_name_bn': firstNameBn,
      'first_name_en': firstName,
      'last_name_bn': lastNameBn,
      'last_name_en': lastName,
      'agent_id': agentId,
      'birthday': birthDate,
      'blood_group': bloodGroup,
      'blood_group_string': bloodGroupString,
      'company_employee_id': companyEmployeeId,
      'company_id': companyId,
      'company_name': companyName,
      'designation': designation,
      'is_govt_official': isGovtOfficial,
      'occupied_service_id': occupiedServiceId,
      'occupied_tracking_state_id': occupiedTrackingStateId,
      'is_poor': isPoor,
      'freedom_fighter': isFreedomFighter,
      'email': email,
      'gender': gender,
      'height': heightCentimeter,
      'height_feet': heightFeet,
      'height_inch': heightInch,
      'home_address_id': homeAddressId,
      'home_address_uuid': addressUUID,
      'address_string': addressString,
      'diabetic': isDiabetic,
      'hypertensive': isHypertensive,
      'has_asthma': hasAsthma,
      'copd': hasCOPD,
      'ckd': hasKidneyDisease,
      'heart_disease': hasHeartDisease,
      'stroke': hasStroke,
      'cancer': hasCancer,
      'disable': hasDisability,
      'image': imageUrl,
      'phone': contactNumber,
      'user_id': userId,
      'user_uuid': userUuid,
      'member_id': memberId,
      'parent_user_id': parentUserId,
      'username': username,
      'nid_number': nidNumber,
      'weight': weight,
      'pulse': pulse,
      'is_corporate': isCorporate,
      'has_subscribe_to_any_health_package': hasSubscribeToAnyHealthPackage,
      'household_uuid': householdUuid,
      'household_id': householdId,
      'is_from_remote': isFromRemote,
      'measurementBundle': measurementBundle,
      'familyMembers': familyMembers?.map((e) => e.toJson()).toList(),
      'measuredAt': measuredAt,
      'age': age,
      'item_type': itemType,
      'visit_type': visitType.toString().split('.').last,
      'Sample_type': sampleType,
      'status': status,
      'investigations': labTechnitianInvestigations != null? labTechnitianInvestigations?.map((LabTechnitianInvestigationDto v) => v.toJson()).toList(): [],
      'referral_id': referralId,
      'sample_collection_place': sampleCollectionPlace,
      'refer_to': referTo,
      'referred_on': referredOn,
      'reason': reason,
      'investigation_status': investigationStatus,

      'division_name_en': divisionNameEn,
      'division_name_bn': divisionNameBn,
      'district_name_en': districtNameEn,
      'district_name_bn': districtNameBn,
      'upazila_name_en': upazilaNameEn,
      'upazila_name_bn': upazilaNameBn,
      'union_name_bn': unionNameEn,
      'user_address': userAddress,
      'parent_username': parentUsername,
      'pageTitle': pageTitle,
      'religion': religion,
      'occupation': occupation,
      'education': education,
      'marital_status': maritalStatus,
      'income': income,
      'religion_branch': religionBranch,
      'isHouseholdHead': isHouseholdHead,
      'additional_information': additionalInformation?.toJson(),
    };
  }

  String getUserAddress() {
    final parts = [
      userAddress,
      pinCode?.toString()??"",
      unionNameEn,
      upazilaNameEn,
      districtNameEn,
      divisionNameEn,
    ];

    // Remove null or empty strings
    final nonEmptyParts = parts.where((e) => e != null && e.trim().isNotEmpty).toList();

    return nonEmptyParts.join(', ');
  }


  int getAgeInYear() {
    if(birthDate != null) {
      var ageCalculator = AgeCalculator.age(DateTime.fromMillisecondsSinceEpoch(birthDate!));
      return ageCalculator.years;
    }
    return 0;
  }

  int getAgeInMonth() {
    if(birthDate != null) {
      var ageCalculator = AgeCalculator.age(DateTime.fromMillisecondsSinceEpoch(birthDate!));
      return ageCalculator.years*12 + ageCalculator.months;
    }
    return 0;
  }

  int getAgeInDay() {
    if(birthDate != null) {
      var ageCalculator = AgeCalculator.age(DateTime.fromMillisecondsSinceEpoch(birthDate!));
      return  ageCalculator.years*12*365 + ageCalculator.months*30 + ageCalculator.days;
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
    return gender == 1? 'Male' : gender == 2 ? 'Female': 'Others';
  }


  String getFullName() {
    final firstEn = (firstName?.isEmpty ?? true) ? "" : firstName!;
    final lastEn = (lastName?.isEmpty ?? true) ? "" : lastName!;
    final nameEn = "$firstEn $lastEn";

    final firstBn = (firstNameBn?.isEmpty ?? true) ? "" : firstNameBn!;
    final lastBn = (lastNameBn?.isEmpty ?? true) ? "" : lastNameBn!;
    final nameBn = "$firstBn $lastBn";

    if (Language.isEnglishSelected && nameEn.trim().isNotEmpty) {
      return nameEn.trim();
    } else if (!Language.isEnglishSelected && nameBn.trim().isNotEmpty) {
      return nameBn.trim();
    } else {
      return nameEn.trim();
    }
  }

  int getCustomerAge() {
    return CalendarUtil.instance.getAgeFromTimeInMillis(birthDate);
  }

  int getCustomerAgeMonth() {
    return CalendarUtil.instance.getAgeFromTimeInMillisInMonth(birthDate);
  }

  String getAgeString() {
    if (birthDate != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(birthDate!);
      String age = "(${CalendarUtil.instance.getFullAgeString(dateTime)})";
      return age;
    } else {
      return "Birthdate is not available";
    }
  }



  String getComorbidityString(bool? value) {
    return value == true ? 'Yes' : 'No'; // Replace with string resource
  }

  String getPhoneNumber() {
    final phoneNumber = contactNumber ?? "";

    return phoneNumber;
  }

  String getNIDString() {
    return Language.isEnglishSelected
        ? (nidNumber ?? "")
        : LanguageUtil.getDigitBanglaFromEnglish(nidNumber ?? "");
  }

  String getMeasuredAtAsString() {
    return CalendarUtil.instance.getDateFromTimeInMillis(
        measuredAt ?? DateTime.now().millisecondsSinceEpoch);
  }

  String getMeasuredDate() {
    return CalendarUtil.instance.getDateFromTimeInMillis(
        measuredAt ?? DateTime.now().millisecondsSinceEpoch);
  }

  bool isSpecialCustomer() {
    return (isGovtOfficial ?? false) ||
        (isFreedomFighter ?? false) ||
        (isPoor ?? false);
  }

  bool hasAnyUnsyncedMeasurement() {
    return measurementBundle
            ?.any((measurement) => measurement.measurementServerId == null) ??
        false;
  }

  String getIconBasedOnItemType() {
    if(itemType == "CONSULTATION_SERVICE")
      return 'assets/images/ic_consltation.svg';
    else if(itemType == "POCD_SERVICE")
      return 'assets/images/ic_heart_screening_pocd.svg';
    else if(itemType == "OTHER")
      return '';

    RLog.error(itemType);
    return '';
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  getParentUserId() {
    return parentUserId??userId;
  }

  getParentUserPhone() {
    return parentUserPhone??contactNumber;
  }

  UserVEDoc toVedUser() {
    return UserVEDoc(
      contactNumber: contactNumber,
      name: getFullName(),
      dateOfBirth: birthDate,
      gender: gender,
      age: age,
      heightFeet: heightFeet,
      heightInch: heightInch,
      heightCentimeter: heightCentimeter,
      weight: weight,
    );
  }
}

class Language {
  static bool isEnglishSelected = true;
}

class LanguageUtil {
  static String getDigitBanglaFromEnglish(String input) {
    // Conversion logic here
    return input;
  }
}

class UserVEDoc {
  String? contactNumber;
  String? name;
  int? dateOfBirth;
  int? gender;
  int? age;
  int? heightFeet;
  double? heightInch;
  double? heightCentimeter;
  double? weight;

  UserVEDoc({
    this.contactNumber,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.age,
    this.heightFeet,
    this.heightInch,
    this.heightCentimeter,
    this.weight,
  });
}
