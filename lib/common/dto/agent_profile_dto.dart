import 'dart:convert';

import 'package:cmed_lib_flutter/common/enum/service_type_enum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/common/helper/utils.dart';

class AgentProfileDto {
  AgentProfileDto({
      this.doctorRating, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.image, 
      this.profileImage, 
      this.name, 
      this.nameBn, 
      this.rootAgentId, 
      this.rootAgentName, 
      this.parentAgentName, 
      this.parentAgentNameBn, 
      this.companyName, 
      this.designation, 
      this.description, 
      this.manufacturerName, 
      this.purchaseCommissionRate, 
      this.serviceRate, 
      this.serviceRateIncentive, 
      this.serviceRateVideo, 
      this.serviceRateIncentiveVideo, 
      this.promoCode, 
      this.transactional, 
      this.prescriptionAttributeEnabled, 
      this.useParentPaymentAcc, 
      this.prescriptionShareType, 
      this.parentId, 
      this.companyId, 
      this.userId, 
      this.parentUserId, 
      this.usersName, 
      this.usersPhoneNumber, 
      this.address, 
      this.agentTypeId, 
      this.agentTypeCode, 
      this.services, 
      this.availableServices, 
      this.operationAreas, 
      this.compactDiscount, 
      this.discount, 
      this.operationAreasInfo, 
      this.agentPath, 
      this.availableStrips, 
      this.facilityName, 
      this.facility, 
      this.address1, 
      this.address2, 
      this.divisionName, 
      this.divisionId, 
      this.districtName, 
      this.districtId, 
      this.upazilaName, 
      this.upazilaId, 
      this.unionName, 
      this.unionId, 
      this.statisticsSummaryEnabled, 
      this.bmdcRegNo, 
      this.degree, 
      this.programStartingYear, 
      this.activeAgents, 
      this.agreementId, 
      this.agreementPhoneNumber, 
      this.speciality, 
      this.specialityName, 
      this.chamberAddress, 
      this.doctorExperience, 
      this.audioRateForUser, 
      this.videoRateForUser, 
      this.telemedicineAllowedStatus, 
      this.telemedicineSearchEnabled, 
      this.serviceRateEnabled, 
      this.servicePackageEnabled,});

  AgentProfileDto.fromJson(dynamic json) {
    doctorRating = json['doctorRating'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    image = json['image'];
    profileImage = json['profile_image'];
    name = json['name'];
    nameBn = json['name_bn'];
    rootAgentId = json['root_agent_id'];
    rootAgentName = json['root_agent_name'];
    parentAgentName = json['parent_agent_name'];
    parentAgentNameBn = json['parent_agent_name_bn'];
    companyName = json['company_name'];
    designation = json['designation'];
    description = json['description'];
    manufacturerName = json['manufacturer_name'];
    purchaseCommissionRate = json['purchase_commission_rate'];
    serviceRate = json['service_rate'];
    serviceRateIncentive = json['service_rate_incentive'];
    serviceRateVideo = json['service_rate_video'];
    serviceRateIncentiveVideo = json['service_rate_incentive_video'];
    promoCode = json['promo_code'];
    transactional = json['transactional'];
    prescriptionAttributeEnabled = json['prescription_attribute_enabled'];
    useParentPaymentAcc = json['use_parent_payment_acc'];
    prescriptionShareType = json['prescription_share_type'];
    parentId = json['parent_id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    parentUserId = json['parent_user_id'];
    usersName = json['users_name'];
    usersPhoneNumber = json['users_phone_number'];
    address = json['address'];
    agentTypeId = json['agent_type_id'];
    agentTypeCode = json['agent_type_code'];
    services = json['services'] != null ? json['services'].cast<int>() : [];
    if (json['available_services'] != null) {
      availableServices = [];
      json['available_services'].forEach((v) {
        availableServices?.add(AvailableService.fromJson(v));
      });
    }
    operationAreas = json['operation_areas'];
    compactDiscount = json['compact_discount'];
    discount = json['discount'];
    operationAreasInfo = json['operation_areas_info'];
    agentPath = json['agent_path'];
    availableStrips = json['available_strips'];
    facilityName = json['facility_name'];
    facility = json['facility'] != null ? Facility.fromJson(json['facility']) : null;
    address1 = json['address_1'];
    address2 = json['address_2'];
    divisionName = json['division_name'];
    divisionId = json['division_id'];
    districtName = json['district_name'];
    districtId = json['district_id'];
    upazilaName = json['upazila_name'];
    upazilaId = json['upazila_id'];
    unionName = json['union_name'];
    unionId = json['union_id'];
    statisticsSummaryEnabled = json['statistics_summary_enabled'];
    bmdcRegNo = json['bmdc_reg_no'];
    degree = json['degree'];
    programStartingYear = json['program_starting_year'];
    activeAgents = json['active_agents'];
    agreementId = json['agreement_id'];
    agreementPhoneNumber = json['agreement_phone_number'];
    speciality = json['speciality'];
    specialityName = json['speciality_name'];
    chamberAddress = json['chamber_address'];
    doctorExperience = json['doctor_experience'];
    audioRateForUser = json['audio_rate_for_user'];
    videoRateForUser = json['video_rate_for_user'];
    telemedicineAllowedStatus = json['telemedicine_allowed_status'];
    telemedicineSearchEnabled = json['telemedicine_search_enabled'];
    serviceRateEnabled = json['service_rate_enabled'];
    servicePackageEnabled = json['service_package_enabled'];
  }
  double? doctorRating;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  String? image;
  String? profileImage;
  String? name;
  String? nameBn;
  int? rootAgentId;
  String? rootAgentName;
  String? parentAgentName;
  String? parentAgentNameBn;
  String? companyName;
  String? designation;
  String? description;
  String? manufacturerName;
  double? purchaseCommissionRate;
  double? serviceRate;
  double? serviceRateIncentive;
  double? serviceRateVideo;
  double? serviceRateIncentiveVideo;
  String? promoCode;
  bool? transactional;
  bool? prescriptionAttributeEnabled;
  bool? useParentPaymentAcc;
  String? prescriptionShareType;
  int? parentId;
  int? companyId;
  int? userId;
  int? parentUserId;
  String? usersName;
  String? usersPhoneNumber;
  String? address;
  int? agentTypeId;
  String? agentTypeCode;
  List<int>? services;
  List<AvailableService>? availableServices;
  dynamic operationAreas;
  double? compactDiscount;
  double? discount;
  dynamic operationAreasInfo;
  String? agentPath;
  int? availableStrips;
  String? facilityName;
  Facility? facility;
  int? address1;
  int? address2;
  String? divisionName;
  int? divisionId;
  String? districtName;
  int? districtId;
  String? upazilaName;
  int? upazilaId;
  String? unionName;
  dynamic unionId;
  bool? statisticsSummaryEnabled;
  String? bmdcRegNo;
  String? degree;
  String? programStartingYear;
  String? activeAgents;
  String? agreementId;
  String? agreementPhoneNumber;
  String? speciality;
  String? specialityName;
  String? chamberAddress;
  String? doctorExperience;
  double? audioRateForUser;
  double? videoRateForUser;
  bool? telemedicineAllowedStatus;
  bool? telemedicineSearchEnabled;
  bool? serviceRateEnabled;
  bool? servicePackageEnabled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['doctorRating'] = doctorRating;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['image'] = image;
    map['profile_image'] = profileImage;
    map['name'] = name;
    map['name_bn'] = nameBn;
    map['root_agent_id'] = rootAgentId;
    map['root_agent_name'] = rootAgentName;
    map['parent_agent_name'] = parentAgentName;
    map['parent_agent_name_bn'] = parentAgentNameBn;
    map['company_name'] = companyName;
    map['designation'] = designation;
    map['description'] = description;
    map['manufacturer_name'] = manufacturerName;
    map['purchase_commission_rate'] = purchaseCommissionRate;
    map['service_rate'] = serviceRate;
    map['service_rate_incentive'] = serviceRateIncentive;
    map['service_rate_video'] = serviceRateVideo;
    map['service_rate_incentive_video'] = serviceRateIncentiveVideo;
    map['promo_code'] = promoCode;
    map['transactional'] = transactional;
    map['prescription_attribute_enabled'] = prescriptionAttributeEnabled;
    map['use_parent_payment_acc'] = useParentPaymentAcc;
    map['prescription_share_type'] = prescriptionShareType;
    map['parent_id'] = parentId;
    map['company_id'] = companyId;
    map['user_id'] = userId;
    map['parent_user_id'] = parentUserId;
    map['users_name'] = usersName;
    map['users_phone_number'] = usersPhoneNumber;
    map['address'] = address;
    map['agent_type_id'] = agentTypeId;
    map['agent_type_code'] = agentTypeCode;
    map['services'] = services;
    if (availableServices != null) {
      map['available_services'] = availableServices?.map((v) => v.toJson()).toList();
    }
    map['operation_areas'] = operationAreas;
    map['compact_discount'] = compactDiscount;
    map['discount'] = discount;
    map['operation_areas_info'] = operationAreasInfo;
    map['agent_path'] = agentPath;
    map['available_strips'] = availableStrips;
    map['facility_name'] = facilityName;
    if (facility != null) {
      map['facility'] = facility?.toJson();
    }
    map['address_1'] = address1;
    map['address_2'] = address2;
    map['division_name'] = divisionName;
    map['division_id'] = divisionId;
    map['district_name'] = districtName;
    map['district_id'] = districtId;
    map['upazila_name'] = upazilaName;
    map['upazila_id'] = upazilaId;
    map['union_name'] = unionName;
    map['union_id'] = unionId;
    map['statistics_summary_enabled'] = statisticsSummaryEnabled;
    map['bmdc_reg_no'] = bmdcRegNo;
    map['degree'] = degree;
    map['program_starting_year'] = programStartingYear;
    map['active_agents'] = activeAgents;
    map['agreement_id'] = agreementId;
    map['agreement_phone_number'] = agreementPhoneNumber;
    map['speciality'] = speciality;
    map['speciality_name'] = specialityName;
    map['chamber_address'] = chamberAddress;
    map['doctor_experience'] = doctorExperience;
    map['audio_rate_for_user'] = audioRateForUser;
    map['video_rate_for_user'] = videoRateForUser;
    map['telemedicine_allowed_status'] = telemedicineAllowedStatus;
    map['telemedicine_search_enabled'] = telemedicineSearchEnabled;
    map['service_rate_enabled'] = serviceRateEnabled;
    map['service_package_enabled'] = servicePackageEnabled;
    return map;
  }



  AvailableService? getAvailableServiceByCodeId(int codeId) {
    return availableServices!.firstWhereOrNull((e)=> e.codeId == codeId);
  }

  getOrderedAvailableService() {
    AvailableService? service;
    List<AvailableService> services = [];
    //bp
    service = getAvailableServiceByCodeId(ServiceTypeEnum.BP.type);
    if(service != null) {
      services.add(service);
    }

    //GLU
    service = getAvailableServiceByCodeId(ServiceTypeEnum.GLU.type);
    if(service != null) {
      services.add(service);
    }

    //SPO2
    service = getAvailableServiceByCodeId(ServiceTypeEnum.SPO2.type);
    if(service != null) {
      services.add(service);
    }

    //TEM
    service = getAvailableServiceByCodeId(ServiceTypeEnum.TEM.type);
    if(service != null) {
      services.add(service);
    }

    //BODY_COMPOSITION
    service = getAvailableServiceByCodeId(ServiceTypeEnum.BODY_COMPOSITION.type);
    if(service != null) {
      services.add(service);
    }

    //BMI
    service = getAvailableServiceByCodeId(ServiceTypeEnum.BMI.type);
    if(service != null) {
      services.add(service);
    }

    //ECG
    service = getAvailableServiceByCodeId(ServiceTypeEnum.ECG.type);
    if(service != null) {
      services.add(service);
    }

    //BREAST_CANCER
    service = getAvailableServiceByCodeId(ServiceTypeEnum.BREAST_CANCER.type);
    if(service != null) {
      services.add(service);
    }


    //EYE_SCREENING
    service = getAvailableServiceByCodeId(ServiceTypeEnum.EYE_SCREENING.type);
    if(service != null) {
      services.add(service);
    }

    //BLOOD_GROUPING
    service = getAvailableServiceByCodeId(ServiceTypeEnum.BLOOD_GROUPING.type);
    if(service != null) {
      services.add(service);
    }
    //WFA
    service = getAvailableServiceByCodeId(ServiceTypeEnum.WFA.type);
    if(service != null) {
      services.add(service);
    }
    //HFA
    service = getAvailableServiceByCodeId(ServiceTypeEnum.HFA.type);
    if(service != null) {
      services.add(service);
    }
    //WFL
    service = getAvailableServiceByCodeId(ServiceTypeEnum.WFL.type);
    if(service != null) {
      services.add(service);
    }

    //MUAC
    service = getAvailableServiceByCodeId(ServiceTypeEnum.MUAC.type);
    if(service != null) {
      services.add(service);
    }
    //PULSE_RATE
    service = getAvailableServiceByCodeId(ServiceTypeEnum.PULSE_RATE.type);
    if(service != null) {
      services.add(service);
    }
    return services;
  }



}

class Facility {
  Facility({
      this.location, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.nameEn, 
      this.nameBn, 
      this.phone, 
      this.email, 
      this.image, 
      this.code, 
      this.facilityTypeId, 
      this.facilityTypeCode, 
      this.primaryAddressId, 
      this.address, 
      this.division, 
      this.district, 
      this.upazila, 
      this.union, 
      this.description, 
      this.contactPersonName, 
      this.contactPersonDesignation, 
      this.noOfCovidBed, 
      this.noOfIcuBed, 
      this.noOfCovidCabin, 
      this.noOfO2Cylinder, 
      this.noOfVentilator, 
      this.available, 
      this.memberBenefits, 
      this.memberBenefitDto,});

  Facility.fromJson(dynamic json) {
    location = json['location'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    nameEn = json['name_en'];
    nameBn = json['name_bn'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    code = json['code'];
    facilityTypeId = json['facility_type_id'];
    facilityTypeCode = json['facility_type_code'];
    primaryAddressId = json['primary_address_id'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    division = json['division'] != null ? Division.fromJson(json['division']) : null;
    district = json['district'] != null ? District.fromJson(json['district']) : null;
    upazila = json['upazila'] != null ? Upazila.fromJson(json['upazila']) : null;
    union = json['union'] != null ? Union.fromJson(json['union']) : null;
    description = json['description'];
    contactPersonName = json['contact_person_name'];
    contactPersonDesignation = json['contact_person_designation'];
    noOfCovidBed = json['no_of_covid_bed'];
    noOfIcuBed = json['no_of_icu_bed'];
    noOfCovidCabin = json['no_of_covid_cabin'];
    noOfO2Cylinder = json['no_of_o2_cylinder'];
    noOfVentilator = json['no_of_ventilator'];
    available = json['available'];
    if (json['member_benefits'] != null) {
      memberBenefits = json['member_benefits'] != null ? json['member_benefits'].cast<String>() : [];
    }
    if (json['member_benefitDto'] != null) {
      memberBenefitDto = [];
      json['member_benefitDto'].forEach((v) {
        //memberBenefitDto?.add(Dynamic.fromJson(v));
      });
    }
  }
  String? location;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  String? nameEn;
  String? nameBn;
  String? phone;
  String? email;
  String? image;
  String? code;
  int? facilityTypeId;
  String? facilityTypeCode;
  int? primaryAddressId;
  Address? address;
  Division? division;
  District? district;
  Upazila? upazila;
  Union? union;
  String? description;
  String? contactPersonName;
  String? contactPersonDesignation;
  int? noOfCovidBed;
  int? noOfIcuBed;
  int? noOfCovidCabin;
  int? noOfO2Cylinder;
  int? noOfVentilator;
  bool? available;
  List<String>? memberBenefits;
  List<dynamic>? memberBenefitDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location'] = location;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['name_en'] = nameEn;
    map['name_bn'] = nameBn;
    map['phone'] = phone;
    map['email'] = email;
    map['image'] = image;
    map['code'] = code;
    map['facility_type_id'] = facilityTypeId;
    map['facility_type_code'] = facilityTypeCode;
    map['primary_address_id'] = primaryAddressId;
    if (address != null) {
      map['address'] = address?.toJson();
    }
    if (division != null) {
      map['division'] = division?.toJson();
    }
    if (district != null) {
      map['district'] = district?.toJson();
    }
    if (upazila != null) {
      map['upazila'] = upazila?.toJson();
    }
    if (union != null) {
      map['union'] = union?.toJson();
    }
    map['description'] = description;
    map['contact_person_name'] = contactPersonName;
    map['contact_person_designation'] = contactPersonDesignation;
    map['no_of_covid_bed'] = noOfCovidBed;
    map['no_of_icu_bed'] = noOfIcuBed;
    map['no_of_covid_cabin'] = noOfCovidCabin;
    map['no_of_o2_cylinder'] = noOfO2Cylinder;
    map['no_of_ventilator'] = noOfVentilator;
    map['available'] = available;
    map['member_benefits'] = memberBenefits;

    if (memberBenefitDto != null) {
      map['member_benefitDto'] = memberBenefitDto?.map((v) => v).toList();
    }
    return map;
  }

}

class Union {
  Union({
      this.weight, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.nameEn, 
      this.nameBn, 
      this.upazilaId, 
      this.municipalityId, 
      this.bbsCode,});

  Union.fromJson(dynamic json) {
    weight = json['weight'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    nameEn = json['name_en'];
    nameBn = json['name_bn'];
    upazilaId = json['upazila_id'];
    municipalityId = json['municipality_id'];
    bbsCode = json['bbs_code'];
  }
  int? weight;
  int? id;
  String? uuid;
  dynamic createdAt;
  dynamic lastUpdated;
  int? createdById;
  int? updatedById;
  String? nameEn;
  String? nameBn;
  int? upazilaId;
  int? municipalityId;
  int? bbsCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['weight'] = weight;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['name_en'] = nameEn;
    map['name_bn'] = nameBn;
    map['upazila_id'] = upazilaId;
    map['municipality_id'] = municipalityId;
    map['bbs_code'] = bbsCode;
    return map;
  }
  static fromJsonList(list) => List<Union>.from(list.map((x) => Union.fromJson(x)));
}

class Upazila {
  Upazila({
      this.weight, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.nameEn, 
      this.nameBn, 
      this.districtId, 
      this.cityCorporationId, 
      this.bbsCode,});

  Upazila.fromJson(dynamic json) {
    weight = json['weight'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    nameEn = json['name_en'];
    nameBn = json['name_bn'];
    districtId = json['district_id'];
    cityCorporationId = json['city_corporation_id'];
    bbsCode = json['bbs_code'];
  }
  int? weight;
  int? id;
  String? uuid;
  dynamic createdAt;
  dynamic lastUpdated;
  int? createdById;
  int? updatedById;
  String? nameEn;
  String? nameBn;
  int? districtId;
  int? cityCorporationId;
  int? bbsCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['weight'] = weight;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['name_en'] = nameEn;
    map['name_bn'] = nameBn;
    map['district_id'] = districtId;
    map['city_corporation_id'] = cityCorporationId;
    map['bbs_code'] = bbsCode;
    return map;
  }
  static fromJsonList(list) => List<Upazila>.from(list.map((x) => Upazila.fromJson(x)));
}

class District {
  District({
      this.weight, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.nameEn, 
      this.nameBn, 
      this.divisionId, 
      this.bbsCode, 
      this.divisionBbsCode,});

  District.fromJson(dynamic json) {
    weight = json['weight'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    nameEn = json['name_en'];
    nameBn = json['name_bn'];
    divisionId = json['division_id'];
    bbsCode = json['bbs_code'];
    divisionBbsCode = json['division_bbs_code'];
  }
  int? weight;
  int? id;
  String? uuid;
  dynamic createdAt;
  dynamic lastUpdated;
  int? createdById;
  int? updatedById;
  String? nameEn;
  String? nameBn;
  int? divisionId;
  int? bbsCode;
  int? divisionBbsCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['weight'] = weight;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['name_en'] = nameEn;
    map['name_bn'] = nameBn;
    map['division_id'] = divisionId;
    map['bbs_code'] = bbsCode;
    map['division_bbs_code'] = divisionBbsCode;
    return map;
  }
  static fromJsonList(list) => List<District>.from(list.map((x) => District.fromJson(x)));

}

class Division {
  Division({
      this.weight, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.nameEn, 
      this.nameBn, 
      this.bbsCode, 
      this.countryId,});

  Division.fromJson(dynamic json) {
    weight = json['weight'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    nameEn = json['name_en'];
    nameBn = json['name_bn'];
    bbsCode = json['bbs_code'];
    countryId = json['country_id'];
  }
  int? weight;
  int? id;
  String? uuid;
  dynamic createdAt;
  dynamic lastUpdated;
  int? createdById;
  int? updatedById;
  String? nameEn;
  String? nameBn;
  int? bbsCode;
  int? countryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['weight'] = weight;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['name_en'] = nameEn;
    map['name_bn'] = nameBn;
    map['bbs_code'] = bbsCode;
    map['country_id'] = countryId;
    return map;
  }
  static fromJsonList(list) => List<Division>.from(list.map((x) => Division.fromJson(x)));
}

class Address {
  Address({
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.address, 
      this.addressDetails, 
      this.divisionId, 
      this.districtId, 
      this.upazilaId, 
      this.unionId, 
      this.villageId, 
      this.lat, 
      this.lng, 
      this.pinCode,
      this.location,});

  Address.fromJson(dynamic json) {
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    address = json['address'];
    addressDetails = json['address_details'] != null ? AddressDetails.fromJson(json['address_details']) : null;
    divisionId = json['division_id'];
    districtId = json['district_id'];
    upazilaId = json['upazila_id'];
    unionId = json['union_id'];
    villageId = json['village_id'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
    pinCode = json['pin_code'];
  }
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  String? address;
  AddressDetails? addressDetails;
  int? divisionId;
  int? districtId;
  int? upazilaId;
  int? unionId;
  int? villageId;
  int? pinCode;
 // String? lat;
 // String? lng;
 // int? location;
   int? lat;
   int? lng;
   String? location;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['address'] = address;
    if (addressDetails != null) {
      map['address_details'] = addressDetails?.toJson();
    }
    map['division_id'] = divisionId;
    map['district_id'] = districtId;
    map['upazila_id'] = upazilaId;
    map['union_id'] = unionId;
    map['village_id'] = villageId;
    map['lat'] = lat;
    map['lng'] = lng;
    map['location'] = location;
    map['pin_code'] = pinCode;
    return map;
  }

  String? getShowAbleLocation() {
    if(location !=null) {
      return "$location, ${addressDetails!.getShowAbleAddress()??""}";
    } else {
      return addressDetails?.getShowAbleAddress()??"";
    }
  }

}

class AddressDetails {
  AddressDetails({
      this.division, 
      this.district, 
      this.upazila, 
      this.union, 
      this.village,
      this.pinCode,});

  AddressDetails.fromJson(dynamic json) {
    division = json['division'] != null ? Division.fromJson(json['division']) : null;
    district = json['district'] != null ? District.fromJson(json['district']) : null;
    upazila = json['upazila'] != null ? Upazila.fromJson(json['upazila']) : null;
    union = json['union'] != null ? Union.fromJson(json['union']) : null;
    village = json['village'];
    pinCode = json['pin_code'];
  }
  Division? division;
  District? district;
  Upazila? upazila;
  Union? union;
  String? village;
  String? pinCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (division != null) {
      map['division'] = division?.toJson();
    }
    if (district != null) {
      map['district'] = district?.toJson();
    }
    if (upazila != null) {
      map['upazila'] = upazila?.toJson();
    }
    if (union != null) {
      map['union'] = union?.toJson();
    }
    map['village'] = village;
    map['pin_code'] = pinCode;
    return map;
  }


  String getShowAbleAddress() {
    String? unionName = '${Utils.isLocaleBn() ? union?.nameBn : union?.nameEn}';
    String? thanaName = '${Utils.isLocaleBn() ? upazila?.nameBn : upazila?.nameEn}';
    String? districtName = '${Utils.isLocaleBn() ? district?.nameBn : district?.nameEn}';
    String? divisionName = '${Utils.isLocaleBn() ? division?.nameBn : division?.nameEn}';

    final parts = [
      pinCode?.toString(),
      unionName,
      thanaName,
      districtName,
      divisionName,
    ];

    // Remove null or empty strings
    final nonEmptyParts = parts.where((e) => e != null && e.trim().isNotEmpty).toList();

    return nonEmptyParts.join(', ');
  }

}

class AvailableService {
  AvailableService({
      this.name, 
      this.code, 
      this.description, 
      this.image, 
      this.tags, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.nameBn, 
      this.codeId, 
      this.serviceRate, 
      this.isUnavailable,
      this.discount,
      this.discountPercentage, 
      this.serviceRateDiscounted, 
      this.attributes,
      this.unavailableReason,
      this.measuredStatus,});

  AvailableService.fromJson(dynamic json) {
    name = json['name'];
    code = json['code'];
    description = json['description'];
    image = json['image'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    nameBn = json['name_bn'];
    codeId = json['code_id'];
    serviceRate = json['service_rate'];
    discount = json['discount'];
    discountPercentage = json['discount_percentage'];
    serviceRateDiscounted = json['service_rate_discounted'];
    unavailableReason = json['unavailableReason'];
    isUnavailable = json['isUnavailable'];
    if (json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((v) {
        attributes?.add(Attributes.fromJson(v));
      });
    }
    measuredStatus = json['measured_status'];
  }
  String? name;
  String? code;
  String? description;
  String? image;
  List<String>? tags;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  String? nameBn;
  String? unavailableReason;
  bool? isUnavailable;
  int? codeId;
  double? serviceRate;
  double? discount;
  bool? discountPercentage;
  double? serviceRateDiscounted;
  List<Attributes>? attributes;
  String? measuredStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['code'] = code;
    map['description'] = description;
    map['image'] = image;
    map['tags'] = tags;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['name_bn'] = nameBn;
    map['code_id'] = codeId;
    map['service_rate'] = serviceRate;
    map['isUnavailable'] = isUnavailable;
    map['discount'] = discount;
    map['discount_percentage'] = discountPercentage;
    map['service_rate_discounted'] = serviceRateDiscounted;
    map['unavailableReason'] = unavailableReason;
    if (attributes != null) {
      map['attributes'] = attributes?.map((v) => v.toJson()).toList();
    }
    map['measured_status'] = measuredStatus;
    return map;
  }

  static fromJsonList(list) => List<AvailableService>.from(list.map((x) => AvailableService.fromJson(x)));

  static Future<List<AvailableService>> getAllServices() async {
    final String jsonString = await rootBundle.loadString('assets/json/available_services.json');
    final List<AvailableService>? allServices = AvailableService.fromJsonList(jsonDecode(jsonString));
    return Future.value(allServices!);
  }

  String getStringServiceRate() {
    if(serviceRateDiscounted == null) {
      return "label_free".tr;
    }
    return "${serviceRateDiscounted} ${'label_bdt'.tr}";
  }

}

class Attributes {
  Attributes({
      this.name, 
      this.unit, 
      this.code, 
      this.order, 
      this.id, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById, 
      this.updatedById, 
      this.measurementTypeId,});

  Attributes.fromJson(dynamic json) {
    name = json['name'];
    unit = json['unit'];
    code = json['code'];
    order = json['order'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    measurementTypeId = json['measurement_type_id'];
  }
  String? name;
  String? unit;
  String? code;
  int? order;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  int? measurementTypeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['unit'] = unit;
    map['code'] = code;
    map['order'] = order;
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['measurement_type_id'] = measurementTypeId;
    return map;
  }
}