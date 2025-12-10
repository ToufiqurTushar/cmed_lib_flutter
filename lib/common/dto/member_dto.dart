import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/helper/CalanderUtil.dart';
import 'additional_information.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class MemberDTO {
  String? localId;
  int? parentUserId;
  String? parentUserPhone;
  String? parentUsername;
  int? serverId;
  int? userId;
  int? createdById;
  String? userUuid;
  String? nidNumber;
  String? householdLocalId;
  int? householdServerId;
  int? gender;
  bool isHouseholdHead;
  bool isFamilyMember;
  String? email;
  int? birthday;
  String? memberId;
  String? firstName;
  String? firstNameEnglish;
  String? lastNameBn;
  String? lastName;
  int? relationWithHouseHolder;
  String? relationTitleBn;
  String? relationTitleEn;
  int? primaryOccupation;
  String? phoneNumber;
  bool? isGovtOfficial;
  bool? isPoor;
  bool? isFreedomFighter;
  bool? hasHighBloodPressure;
  bool? isDiabetic;
  bool? hasAsthma;
  bool? hasCOPD;
  bool? hasKidneyDisease;
  bool? hasHeartDisease;
  bool? hasStroke;
  bool? hasCancer;
  bool? hasDisability;
  int? bloodGroup;
  String? bloodGroupString;
  int? educationQualification;
  int? companyId;
  int? age;
  RelationWithHouseholdHeadObj? relationWithHouseholdHeadObj;
  String? religion;
  String? religionBranch;
  String? education;
  String? occupation;
  double? income;
  AdditionalInformation? additionalInformation;
  String? maritalStatus;


  MemberDTO({
    this.localId,
    this.parentUserId,
    this.parentUserPhone,
    this.parentUsername,
    this.companyId,
    this.serverId,
    this.userId,
    this.createdById,
    this.userUuid,
    this.nidNumber,
    this.householdLocalId,
    this.householdServerId,
    this.gender,
    this.isHouseholdHead = false,
    this.isFamilyMember = false,
    this.email,
    this.birthday,
    this.memberId,
    this.firstName,
    this.firstNameEnglish,
    this.lastNameBn,
    this.lastName,
    this.relationWithHouseHolder,
    this.relationTitleBn,
    this.relationTitleEn,
    this.primaryOccupation,
    this.phoneNumber,
    this.isGovtOfficial,
    this.isPoor,
    this.isFreedomFighter,
    this.hasHighBloodPressure,
    this.isDiabetic,
    this.hasAsthma,
    this.hasCOPD,
    this.hasKidneyDisease,
    this.hasHeartDisease,
    this.hasStroke,
    this.hasCancer,
    this.hasDisability,
    this.bloodGroup,
    this.bloodGroupString,
    this.educationQualification,
    this.relationWithHouseholdHeadObj,
    this.religion,
    this.religionBranch,
    this.education,
    this.occupation,
    this.income,
    this.maritalStatus,
    this.additionalInformation,
  });

  // Generate a random UUID
  // static String _generateUUID() {
  //   return Uuid().v4();
  // }

  // Convert JSON to Member
  factory MemberDTO.fromJson(Map<String, dynamic> json) {
    return MemberDTO(
      localId: json['uuid'],
      parentUserId: json['parent_user_id'],
      parentUserPhone: json['parent_user_phone'],
      parentUsername: json['parent_username'],
      companyId: json['company_id'],
      serverId: json['id'],
      userId: json['user_id'],
      createdById: json['created_by_id'],
      userUuid: json['user_uuid'] ,
      nidNumber: json['nid_number'],
      householdLocalId: json['household_uuid'],
      householdServerId: json['household_id'],
      gender: json['gender'],
      isHouseholdHead: json['household_head'] ?? false,
      isFamilyMember: json['is_family_member'] ?? false,
      email: json['email'],
      birthday: json['birthday'],
      memberId: json['member_id'],
      firstName: json['first_name_bn'],
      firstNameEnglish: json['first_name_en'],
      lastNameBn: json['last_name_bn'],
      lastName: json['last_name_en'],
      relationWithHouseHolder: json['relation_with_household_head'],
      relationTitleBn: json['relation_title_bn'],
      relationTitleEn: json['relation_title_en'],
      primaryOccupation: json['primary_occupation'] ?? 1,
      phoneNumber: json['phone'],
      isGovtOfficial: json['is_govt_official'],
      isPoor: json['is_poor'],
      isFreedomFighter: json['freedom_fighter'],
      hasHighBloodPressure: json['hypertensive'],
      isDiabetic: json['diabetic'],
      hasAsthma: json['has_asthma'],
      hasCOPD: json['has_copd'],
      hasKidneyDisease: json['has_kidney_disease'],
      hasHeartDisease: json['has_cardiovascular_disease'],
      hasStroke: json['had_stroke'],
      hasCancer: json['has_cancer'],
      hasDisability: json['disable'],
      bloodGroup: json['blood_group'],
      bloodGroupString: null, // Assuming you will set this separately
      educationQualification: json['educational_qualification'] ?? 1,
      relationWithHouseholdHeadObj: json['relation_with_household_head_obj'] != null
          ? RelationWithHouseholdHeadObj.fromJson(json['relation_with_household_head_obj'])
          : null,
      religion: json['religion'],
      education: json['education'],
      occupation: json['occupation'],
      maritalStatus: json['marital_status'],
      religionBranch: json['religion_branch'],
      additionalInformation: json['additional_information'] != null ? AdditionalInformation.fromJson(json['additional_information']) : null,
      income: json['income'],
    );
  }

  // Convert Member to JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': localId,
      'parent_user_id': parentUserId,
      'parent_user_phone': parentUserPhone,
      'parent_username': parentUsername,
      'company_id': companyId,
      'id': serverId,
      'user_id': userId,
      'created_by_id': createdById,
      'user_uuid': userUuid,
      'nid_number': nidNumber,
      'household_uuid': householdLocalId,
      'household_id': householdServerId,
      'gender': gender,
      'household_head': isHouseholdHead,
      'is_family_member': isFamilyMember,
      'email': email,
      'birthday': birthday,
      'member_id': memberId,
      'first_name_bn': firstName,
      'first_name_en': firstNameEnglish,
      'last_name_bn': lastNameBn,
      'last_name_en': lastName,
      'relation_with_household_head': relationWithHouseHolder,
      'relation_title_bn': relationTitleBn,
      'relation_title_en': relationTitleEn,
      'primary_occupation': primaryOccupation,
      'phone': phoneNumber,
      'is_govt_official': isGovtOfficial,
      'is_poor': isPoor,
      'freedom_fighter': isFreedomFighter,
      'hypertensive': hasHighBloodPressure,
      'diabetic': isDiabetic,
      'has_asthma': hasAsthma,
      'has_copd': hasCOPD,
      'has_kidney_disease': hasKidneyDisease,
      'has_cardiovascular_disease': hasHeartDisease,
      'had_stroke': hasStroke,
      'has_cancer': hasCancer,
      'disable': hasDisability,
      'blood_group': bloodGroup,
      'educational_qualification': educationQualification,
      'relation_with_household_head_obj': relationWithHouseholdHeadObj?.toJson(),
      'religion': religion,
      'occupation': occupation,
      'education': education,
      'marital_status': maritalStatus,
      'income': income,
      'religion_branch': religionBranch,
      'additional_information': additionalInformation?.toJson(),
    };
  }



  CustomerDTO toCustomer() {
    RLog.info(email);
    return CustomerDTO(
      userId: userId,
      firstName: firstNameEnglish,
      firstNameBn: firstName,
      lastName: lastName,
      lastNameBn: lastNameBn,
      gender: gender,
      bloodGroup: bloodGroup,
      birthDate: birthday,
      age: age,
      isDiabetic: isDiabetic,
      isHypertensive: hasHighBloodPressure,
      hasAsthma: hasAsthma,
      hasCOPD: hasCOPD,
      hasKidneyDisease: hasKidneyDisease,
      hasHeartDisease: hasHeartDisease,
      hasStroke: hasStroke,
      hasCancer: hasCancer,
      hasDisability: hasDisability,
      contactNumber: phoneNumber,
      // TODO: ADD IT LATER.:
      //   agentId : pref.agentServerId().get()?.toInt(),
      //   companyId : pref.companyId().get(),
      memberId: serverId,
      isFreedomFighter: isFreedomFighter,
      isPoor: isPoor,
      isGovtOfficial: isGovtOfficial,
      isFamilyMember: isHouseholdHead == false,
      householdId: householdServerId,
      householdUuid: householdLocalId,
      companyId: companyId,
      parentUserId: parentUserId,
      parentUserPhone: parentUserPhone,
      parentUsername: parentUsername,
      religion: religion,
      occupation: occupation,
      education: education,
      maritalStatus: maritalStatus,
      income: income,
      religionBranch: religionBranch,
      additionalInformation: additionalInformation,
      email: email,
      isHouseholdHead: isHouseholdHead,
    );
  }

  String getFullName() {
    String nameEn = "${firstNameEnglish ?? ""} ${lastName ?? ""}";
    String nameBn = "${firstName ?? ""} ${lastNameBn ?? ""}";

    return nameEn.trim().isNotEmpty ? nameEn.trim() : nameBn.trim();
  }

  String getAgeString() {
    if (birthday != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(birthday!);
      String age = "(${CalendarUtil.instance.getFullAgeString(dateTime)})";
      return age;
    } else {
      return "Birthdate is not available";
    }
  }

  String getPhoneNumber() {
    final phone = phoneNumber ?? "";

    return Language.isEnglishSelected
        ? phone
        : LanguageUtil.getDigitBanglaFromEnglish(phone);
  }

  String getGenderString() {
    switch (gender) {
      case 1:
        return 'Male'; // Replace with localized string
      case 2:
        return 'Female'; // Replace with localized string
      default:
        return 'Other'; // Replace with localized string
    }
  }
}



class RelationWithHouseholdHeadObj {
   String? labelBn;
  String? labelEn;
  int? type;
  int? id;

  RelationWithHouseholdHeadObj({
    required this.labelBn,
    required this.labelEn,
    required this.type,
    required this.id,
  });

  factory RelationWithHouseholdHeadObj.fromJson(Map<String, dynamic> json) {
    return RelationWithHouseholdHeadObj(
      labelBn: json['labelBn'] ?? '',
      labelEn: json['labelEn'] ?? '',
      type: json['type'] ?? 0,
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labelBn': labelBn,
      'labelEn': labelEn,
      'type': type,
      'id': id,
    };
  }
}
