import 'package:cmed_lib_flutter/common/dto/service_type_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../dto/agent_profile_dto.dart'; // If you're using SVG images
//
// enum ServiceTypeEnum {
//   PULSE_RATE(5),
//   BP(1),
//   SPO2(8),
//   BMI(3),
//   TEM(2),
//   GLU(4),
//   RESPIRATION_RATE(6),
//   WHR(14),
//   WC(13),
//   BREAST_CANCER(15),
//   BODY_COMPOSITION(20),
//   BLOOD_GROUPING(22),
//   EYE_SCREENING(21),
//   MUAC(10),
//   ECG(7),
//   WFA(17),
//   HFA(16),
//   WFL(23),
//   HEMOGLOBIN(26),
//   CORONA_COVID19(11),
//   CORONA_COVID19_V2(12);
//
//   final int type;
//
//   const ServiceTypeEnum(this.type);
// }

String populateDrawable(int? typeId) {
  switch (typeId) {
    case 5:
      return 'assets/images/ic_pulse.svg';
    case 1:
      return 'assets/images/ic_bp.svg';
    case 8:
      return 'assets/images/ic_noborder_spo2.svg';
    case 3:
      return 'assets/images/ic_bmi.svg';
    case 2:
      return 'assets/images/ic_temp.svg';
    case 4:
      return 'assets/images/ic_glucose.svg';
    case 14:
      return 'assets/images/ic_whr.svg';
    case 13:
      return 'assets/images/ic_wc.svg';
    case 10:
      return 'assets/images/ic_muac.svg';
    case 15:
      return 'assets/images/ic_breast_cancer.svg';
    case 20:
      return 'assets/images/ic_fat_scale.svg';
    case 21:
      return 'assets/images/ic_eye.svg';
    case 22:
      return 'assets/images/ic_blood_grouping.svg';
    case 7:
      return 'assets/images/ic_ecg.svg';
    case 16:
    case 17:
    case 23:
      return 'assets/images/ic_gmp.svg';
    case 11:
    case 12:
      return 'assets/images/virus.svg'; // Use the same image for both cases
    case 26:
      return 'assets/images/ic_hemoglobin.svg';
    case 9000:
      return 'assets/images/ic_healthy_days.svg';
    default:
      return 'assets/images/ic_glucose.svg'; // Default drawable
  }
}

String populateTitle(int? typeId) {
  // Determine language based on current locale
  String language = Get.locale?.languageCode ?? 'en'; // Defaults to 'en' if locale is null

  switch (typeId) {
    case 5:
      return language == 'bn' ? 'পাল্‌স' : 'Pulse Rate';
    case 1:
      return language == 'bn' ? 'রক্তচাপ' : 'BP';
    case 8:
      return language == 'bn' ? 'অক্সিজেন স্যাচুরেশন' : 'SpO2';
    case 3:
      return language == 'bn' ? 'বিএমআই' : 'BMI';
    case 2:
      return language == 'bn' ? 'তাপমাত্রা' : 'Temperature';
    case 4:
      return language == 'bn' ? 'গ্লুকোজ' : 'Glucose';
    case 14:
      return language == 'bn' ? 'WHR' : 'WHR';
    case 13:
      return language == 'bn' ? 'WC' : 'WC';
    case 10:
      return language == 'bn' ? 'মুয়াক' : 'MUAC';
    case 7:
      return language == 'bn' ? 'ইসিজি' : 'ECG';
    case 23:
      return language == 'bn' ? 'ডব্লিউ এফ এল' : 'WFL';
    case 16:
      return language == 'bn' ? 'এইচ এফ এ' : 'HFA';
    case 17:
      return language == 'bn' ? 'ডব্লিউ এফ এ' : 'WFA';//জি এম পি//
    case 15:
      return language == 'bn' ? 'স্তন ক্যান্সার' : 'Breast Cancer';
    case 20:
      return language == 'bn' ? 'বডি কম্পোজিশন' : 'Body Composition';
    case 22:
      return language == 'bn' ? 'রক্তের গ্রুপ' : 'Blood Grouping';
    case 21:
      return language == 'bn' ? 'চোখের স্ক্রিনিং' : 'Eye Screening';
    case 11:
    case 12:
      return language == 'bn' ? 'কোভিড-১৯' : 'Covid-19';
    default:
      return language == 'bn' ? 'শিরোনাম' : 'Title';
  }
}

ServiceType toServiceTypeDto(AvailableService service) {
  int? id = service.codeId;
  return ServiceType(
    image: populateDrawable(id),
    result: "label_not_measured_yet".tr,
    serviceName: service.code,
    serviceNameLarge: Get.locale?.languageCode == 'bn'
        ? service.nameBn ?? service.name
        : service.name ?? service.nameBn,
    serviceNameBn: service.nameBn,
    codeId: service.codeId,
    serviceTypeId: service.codeId,
    serviceRateDiscounted: service.serviceRateDiscounted,
    unavailableReason: service.unavailableReason,
    isUnavailable: service.isUnavailable,
  );
}

