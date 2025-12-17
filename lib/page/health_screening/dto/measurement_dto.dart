import 'dart:convert';

import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/enum/service_type_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/hemoglobin/hemoglobin_input_view.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/blood_glucose/blood_glucose_auto_select_time_period_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/fat/dto/fat_scale_data_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bmi/bmi_height_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/bp/bp_device_connection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/ecg/ecg_device_connection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/oxygen_saturation/oxygen_saturation_device_connection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/blood_glucose/blood_glucose_select_time_period_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bmi/bmi_height_weight_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bp/bp_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bscan/bscan_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/gmp/gmp_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/muac/muac_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/oxygen_saturation/oxygen_saturation_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/temp/temp_input_view.dart';
//import 'package:alzheimer_lib_flutter/alzheimer/dto/mesurement/location.dart';

import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import '../npage/auto/npage/fat/fat_height_input_view.dart';
import '../npage/manual/npage/blood_grouping/blood_grouping_view.dart';
import '../npage/manual/npage/eye_screening/enum/eye_screening_type_enum.dart';

class MeasurementDTO {
  Map<String, dynamic>? inputs;
  List<Ecgsymps>? ecgsymps;
  BodyComposition? bodyComposition;
  List<EyeScreening>? eyeScreening;
  int? outcome;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  int? memberId;
  int? appId;
  int? clientId;
  int? userId;
  String? userUuid;
  String? userFullName;
  String? userFullNameBn;
  String? userPhoneNumber;
  int? userDateOfBirth;
  MasterDataDTO? userBloodGroup;
  int? gender;
  String? userEmail;
  String? userNid;
  int? measurementTypeCodeId;
  String? measurementTypeName;
  String? measurementTypeCode;
  int? bundleId;
  ResultDTO? result;
  int? measuredAt;
  String? ecgGraphValue;
  String? tag;
  Location? location;
  bool? offline;
  String? createdByUuid;
  int? companyId;

  MeasurementDTO(
      {this.inputs,
        this.ecgsymps,
        this.bodyComposition,
        this.eyeScreening,
        this.outcome,
        this.id,
        this.uuid,
        this.createdAt,
        this.lastUpdated,
        this.createdById,
        this.updatedById,
        this.memberId,
        this.appId,
        this.clientId,
        this.userId,
        this.userUuid,
        this.userFullName,
        this.userFullNameBn,
        this.userPhoneNumber,
        this.userDateOfBirth,
        this.userBloodGroup,
        this.gender,
        this.userEmail,
        this.userNid,
        this.measurementTypeCodeId,
        this.measurementTypeName,
        this.measurementTypeCode,
        this.bundleId,
        this.result,
        this.measuredAt,
        this.ecgGraphValue,
        this.tag,
        this.location,
        this.offline,
        this.createdByUuid,
        this.companyId});

  static List<MeasurementDTO> fromJsonList(list) =>
      List<MeasurementDTO>.from(list.map((x) => MeasurementDTO.fromJson(x)));

  MeasurementDTO.fromJson(Map<String, dynamic> json) {
    inputs = json['inputs'];
    if (json['ecgsymps'] != null) {
      ecgsymps = <Ecgsymps>[];
      json['ecgsymps'].forEach((v) {
        ecgsymps!.add(Ecgsymps.fromJson(v));
      });
    }

    bodyComposition = json['body_composition'] != null ? BodyComposition.fromJson(jsonDecode(json['body_composition'])) : null;
    try{
      eyeScreening = json['eye_screening'] != null ? EyeScreening.listFromJson(jsonDecode(json['eye_screening'])) : null;
    }
    catch(e){}
    outcome = json['outcome'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    memberId = json['member_id'];
    appId = json['app_id'];
    clientId = json['client_id'];
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    userFullName = json['user_full_name'];
    userFullNameBn = json['user_full_name_bn'];
    userPhoneNumber = json['user_phone_number'];
    userDateOfBirth = json['user_date_of_birth'];
    userBloodGroup = json['user_blood_group'] != null
        ? MasterDataDTO.fromJson(json['user_blood_group'])
        : null;
    gender = json['gender'];
    userEmail = json['user_email'];
    userNid = json['user_nid'];
    measurementTypeCodeId = json['measurement_type_code_id'];
    measurementTypeName = json['measurement_type_name'];
    measurementTypeCode = json['measurement_type_code'];
    bundleId = json['bundle_id'];
    result = json['result'] != null ? ResultDTO.fromJson(json['result']) : null;
    measuredAt = json['measured_at'];
    ecgGraphValue = json['ecg_graph_value'];
    tag = json['tag'];
    location =
    json['location'] != null ? Location.fromJson(json['location']) : null;
    offline = json['offline'];
    createdByUuid = json['created_by_uuid'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inputs != null) {
      data['inputs'] = inputs;
    }
    if (ecgsymps != null) {
      data['ecgsymps'] = ecgsymps!.map((v) => v.toJson()).toList();
    }
    if (bodyComposition != null) {
      data['body_composition'] = jsonEncode(bodyComposition);//string
      //data['body_composition'] = bodyComposition!.toJson();//map
    }

    if (eyeScreening != null) {
      data['eye_screening'] = jsonEncode(eyeScreening);
    }
    data['outcome'] = outcome;
    data['id'] = id;
    data['uuid'] = uuid;
    data['created_at'] = createdAt;
    data['last_updated'] = lastUpdated;
    data['created_by_id'] = createdById;
    data['updated_by_id'] = updatedById;
    data['member_id'] = memberId;
    data['app_id'] = appId;
    data['client_id'] = clientId;
    data['user_id'] = userId;
    data['user_uuid'] = userUuid;
    data['user_full_name'] = userFullName;
    data['user_full_name_bn'] = userFullNameBn;
    data['user_phone_number'] = userPhoneNumber;
    data['user_date_of_birth'] = userDateOfBirth;
    if (userBloodGroup != null) {
      data['user_blood_group'] = userBloodGroup!.toJson();
    }
    data['gender'] = gender;
    data['user_email'] = userEmail;
    data['user_nid'] = userNid;
    data['measurement_type_code_id'] = measurementTypeCodeId;
    data['measurement_type_name'] = measurementTypeName;
    data['measurement_type_code'] = measurementTypeCode;
    data['bundle_id'] = bundleId;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['measured_at'] = measuredAt;

    data['ecg_graph_value'] = ecgGraphValue;
    data['tag'] = tag;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['offline'] = offline;
    data['created_by_uuid'] = createdByUuid;
    data['company_id'] = companyId;
    return data;
  }

  static List<MeasurementDTO> listFromJson(list) =>
      List<MeasurementDTO>.from(list.map((x) => MeasurementDTO.fromJson(x)));

  FatScaleDataDto getBmiFatScaleData() {
    return  FatScaleDataDto(
        value: bodyComposition?.cBmi,
        colors: ['#ADD8E6', '#00C853', '#FFD100', '#F13546'],
        results: ['Underweight', 'Normal', 'Overweight', 'Obese'],
        resultsBn: ['কম ওজন', 'স্বাভাবিক ওজন', 'বেশি ওজন', 'স্থুলতা'],
        maxRanges: [0, 18.4, 24.9, 29.9]
    );
  }
  getStatus({bool isLocaleBn = false}) {
    if(measurementTypeCodeId == MeasurementType.BODY_COMPOSITION.value) {
      try{
        FatScaleDataDto fatScaleItem = getBmiFatScaleData();
        var indexLength = fatScaleItem.maxRanges!.length-1;
        for(var i = 0; i <= indexLength; i++) {
          if(i == indexLength) {
            if(isLocaleBn) {
              return fatScaleItem.resultsBn![i];
            } else {
              return fatScaleItem.results![i];
            }
          }

          if(fatScaleItem.value >= fatScaleItem.maxRanges![i] && fatScaleItem.value < fatScaleItem.maxRanges![i+1]) {
            if(isLocaleBn) {
              return fatScaleItem.resultsBn![i];
            } else {
              return fatScaleItem.results![i];
            }
          }
        }
      } catch(e){
        print(e.toString());
        return "";
      }
    }

    if(Utils.isLocaleBn()) {
      return result?.statusBn??result?.status;
    } else {
      return result?.status;
    }
  }

  getHashColorCode() {
    if(measurementTypeCodeId == MeasurementType.BODY_COMPOSITION.value) {
      try{
        FatScaleDataDto fatScaleItem = getBmiFatScaleData();
        var indexLength = fatScaleItem.maxRanges!.length-1;
        for(var i = 0; i <= indexLength; i++) {
          if(i == indexLength) {
            return fatScaleItem.colors![indexLength];
          }

          if(fatScaleItem.value >= fatScaleItem.maxRanges![i] && fatScaleItem.value < fatScaleItem.maxRanges![i+1]) {
            return fatScaleItem.colors![i];
          }
        }
      } catch(e){
        print(e.toString());
        return "#000000";
      }
    }
    return "#000000";
  }


  int getIntColor() {
    if(measurementTypeCodeId == MeasurementType.BODY_COMPOSITION.value) {
      var hashColorCode = getHashColorCode();
      try{
        return int.parse(hashColorCode!.replaceAll('#', '0xff'));
      } catch(e){
      }
    }
    return int.parse(result?.colorCode?.replaceAll('#', '0xff') ?? Colors.black54.value.toString());
  }

  String getMeasurementValueWithUnitString() {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value =
          '${inputs![BPAttribute.SYSTOLIC.name]}/${inputs![BPAttribute.DIASTOLIC.name]} mmHg'
              .replaceAll(".0", "");
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = '${result?.value?.toStringAsFixed(result?.value?.truncateToDouble() == result?.value ? 0 : 2) ?? ""} kg/m\u00B2';
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      value = '${inputs![BloodGlucoseAttribute.SUGAR.name]} ${AppUidConfig.getGlucoseLabelHint('input_hint_glucose'.tr)}';
    }  else if (measurementTypeCodeId == MeasurementType.BLOOD_GROUPING.value) {
      value = '${result?.status ?? ""}';
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      value = '${inputs![TemperatureAttribute.TEMP.name]}\u2109';
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      value = '${inputs![PulseAttribute.PULSE_RATE.name]} bpm';
    } else if (measurementTypeCodeId == MeasurementType.RESPIRATION_RATE.value) {
      value = '${inputs!["RESPIRATION_RATE"]}'.replaceAll(".0", "");
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
      value = '${result?.status ?? ""}';
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = '${inputs![SPO2Attribute.SPO2.name]}%';
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = '${inputs![MuacAttribute.MUAC.name] } cm';
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      value = inputs![GmpAttribute.HFA_HEIGHT.name]?.toStringAsFixed(
          inputs![GmpAttribute.HFA_HEIGHT.name]?.truncateToDouble() == inputs![GmpAttribute.HFA_HEIGHT.name] ? 0 : 2
      ) ?? "";
      value = '$value cm';
    } else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      value = inputs![GmpAttribute.WFA_WEIGHT.name]?.toStringAsFixed(
          inputs![GmpAttribute.WFA_WEIGHT.name]?.truncateToDouble() == inputs![GmpAttribute.WFA_WEIGHT.name] ? 0 : 2
      ) ?? "";
      value = '$value kg';
    } else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      value = inputs![GmpAttribute.WFL_WEIGHT.name]?.toStringAsFixed(
          inputs![GmpAttribute.WFL_WEIGHT.name]?.truncateToDouble() == inputs![GmpAttribute.WFL_WEIGHT.name] ? 0 : 2
      ) ?? "";
      value = '$value kg';
    } else if (measurementTypeCodeId == MeasurementType.CORONA_COVID19_V2.value || measurementTypeCodeId == MeasurementType.COVID19.value) {
    } else if (measurementTypeCodeId == MeasurementType.WAVE_COUNT.value) {
    } else if (measurementTypeCodeId == MeasurementType.BREAST_CANCER.value) {
      value = '${result?.status ?? ""}';
    } else if (measurementTypeCodeId == MeasurementType.BODY_COMPOSITION.value) {
      value = inputs![BodyCompositionAttribute.BODY_COMPOSITION.name]?.toStringAsFixed(
          inputs![BodyCompositionAttribute.BODY_COMPOSITION.name]?.truncateToDouble() == inputs![BodyCompositionAttribute.BODY_COMPOSITION.name] ? 0 : 2
      ) ?? "";
      value = '$value kg/m²';//⁻ ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹
    } else if (measurementTypeCodeId == MeasurementType.HEMOGLOBIN.value) {
      value ='${inputs![HemoglobinAttribute.HEMOGLOBIN_LEVEL.name]} g/dL';
    }

    return value;
  }

  String getMeasurementValueWithUnitStringBn() {
    String value = getMeasurementValueWithUnitString();
    if (measurementTypeCodeId == MeasurementType.BREAST_CANCER.value) {
      value = '${result?.statusBn ?? ""}';
    }
    else if (measurementTypeCodeId == MeasurementType.BLOOD_GROUPING.value) {
      value = '${result?.statusBn ?? ""}';
    }
    else if (measurementTypeCodeId == MeasurementType.ECG.value) {
      value = '${result?.statusBn ?? ""}';
    }
    return value;
  }

  String getMeasurementNameString({bool showGMPAsGroup = false}) {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = 'label_blood_pressure'.tr;
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = 'label_bmi'.tr;
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      value = 'label_blood_glucose'.tr;
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      value = 'label_temperature'.tr;
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      value = 'label_pulse_rate'.tr;
    } else if (measurementTypeCodeId == MeasurementType.RESPIRATION_RATE.value) {
      value = 'label_respiration_rate'.tr;
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
      value = 'label_ecg'.tr;
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = 'label_oxygen_saturation'.tr;
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = 'label_muac'.tr;
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      value = showGMPAsGroup == true ? 'label_gmp'.tr: 'label_hfa'.tr;
    } else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      value = showGMPAsGroup == true ? 'label_gmp'.tr: 'label_wfa'.tr;
    } else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      value = showGMPAsGroup == true ? 'label_gmp'.tr: 'label_wfl'.tr;
    } else if (measurementTypeCodeId == MeasurementType.CORONA_COVID19_V2.value || measurementTypeCodeId == MeasurementType.COVID19.value) {
      value = 'label_covid'.tr;
    } else if (measurementTypeCodeId == MeasurementType.BREAST_CANCER.value) {
      value = 'label_breast_cancer_screening'.tr;
    } else if (measurementTypeCodeId == MeasurementType.BODY_COMPOSITION.value) {
      value = 'label_body_fat_composition'.tr;
    } else if (measurementTypeCodeId == MeasurementType.EYE_SCREENING.value) {
      value = 'label_eye_screening'.tr;
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_GROUPING.value) {
      value = 'label_blood_grouping_and_rh_typing'.tr;
    } else if (measurementTypeCodeId == MeasurementType.HEMOGLOBIN.value) {
      value = 'Hemoglobin'.tr;
    } else {
      value = measurementTypeName ?? "";
    }
    return value;
  }

  String getMeasurementRouteNameString(bool isAuto) {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = isAuto ? BpDeviceConnectionView.routeName : BpInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = isAuto ? BmiHeightInputView.routeName : BmiHeightInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.BODY_COMPOSITION.value) {
      value = isAuto ? FatHeightInputView.routeName : "";
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      value = isAuto ? BloodGlucoseAutoSelectTimePeriodView.routeName : BloodGlucoseSelectTimePeriodView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      value = TempInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      value = "";
    } else if (measurementTypeCodeId == MeasurementType.RESPIRATION_RATE.value) {
      value = "";
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
      value = EcgDeviceConnectionView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = isAuto ? OxygenSaturationDeviceConnectionView.routeName : OxygenSaturationInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = MuacInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      value = GmpInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      value = GmpInputView.routeName;
    }  else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      value = GmpInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.CORONA_COVID19_V2.value || measurementTypeCodeId == MeasurementType.COVID19.value) {
      value = "";
    } else if (measurementTypeCodeId == MeasurementType.BREAST_CANCER.value) {
      value = BScanInputView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_GROUPING.value) {
      value = BloodGroupingView.routeName;
    } else if (measurementTypeCodeId == MeasurementType.HEMOGLOBIN.value) {
      value = HemoglobinInputView.routeName;
    }
    return value;
  }

  String getMeasurementValueString() {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value =
          '${inputs![BPAttribute.SYSTOLIC.name]}/${inputs![BPAttribute.DIASTOLIC.name]}'
              .replaceAll(".0", "");
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = result?.value?.toStringAsFixed(
          result?.value?.truncateToDouble() == result?.value ? 0 : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      value = '${inputs![BloodGlucoseAttribute.SUGAR.name]}';
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      value = '${inputs![TemperatureAttribute.TEMP.name]}';
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      value = '${inputs![PulseAttribute.PULSE_RATE.name]}';
    } else if (measurementTypeCodeId ==
        MeasurementType.RESPIRATION_RATE.value) {
      value = '${inputs!["RESPIRATION_RATE"]}'.replaceAll(".0", "");
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = '${inputs![SPO2Attribute.SPO2.name]}';
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = '${result?.value ?? ""}';
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      value = '${result?.value ?? ""}';
    } else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      value = '${result?.value ?? ""}';
    } else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      value = '${result?.value ?? ""}';
    } else if (measurementTypeCodeId ==
        MeasurementType.CORONA_COVID19_V2.value ||
        measurementTypeCodeId == MeasurementType.COVID19.value) {
    }
    else if (measurementTypeCodeId == MeasurementType.WAVE_COUNT.value) {}
    else if (measurementTypeCodeId == MeasurementType.BREAST_CANCER.value) {
      value = '${result?.value ?? ""}';
    }else if (measurementTypeCodeId == MeasurementType.BLOOD_GROUPING.value) {
      value = '${result?.status ?? ""}';
    }
    return value;
  }

  String getMeasurementUnitString() {
    String unit = "";
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      unit = 'mmHg';
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      unit = 'kg/m²';
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      unit = AppUidConfig.getGlucoseLabelHint('input_hint_glucose'.tr);
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      unit = 'Fahrenheit';
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      unit = 'bpm';
    } else if (measurementTypeCodeId ==
        MeasurementType.RESPIRATION_RATE.value) {
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      unit = '%';
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      unit = 'cm';
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      unit = 'cm';
    }  else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      unit = 'cm';
    } else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      unit = 'kg';
    } else if (measurementTypeCodeId ==
        MeasurementType.CORONA_COVID19_V2.value ||
        measurementTypeCodeId == MeasurementType.COVID19.value) {
    } else if (measurementTypeCodeId == MeasurementType.WAVE_COUNT.value) {}
    return unit;
  }

  String? getValue1Title() {
    String? value;
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = BPAttribute.getDisplayName(BPAttribute.SYSTOLIC);
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = BmiAttribute.getDisplayName(BmiAttribute.HEIGHT);
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value ||
        measurementTypeCodeId == MeasurementType.SpO2.value ||
        measurementTypeCodeId == MeasurementType.PULSE_RATE.value ||
        measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value ||
        measurementTypeCodeId == MeasurementType.HFA.value ||
        measurementTypeCodeId == MeasurementType.WFL.value ||
        measurementTypeCodeId == MeasurementType.WFA.value
    ) {
      value = getMeasurementNameString();
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = 'input_label_muac_cm'.tr;
    } else if (measurementTypeCodeId == MeasurementType.HEMOGLOBIN.value) {
      value = 'Hemoglobin'.tr;
    }
    return value;
  }

  String getShortName() {
    String value = '';
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = "BP";
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = "BMI";
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      value = "GLU";
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
      value = "Stress";
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      value = "TEM";
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      value = "PUL";
    } else if (measurementTypeCodeId == MeasurementType.COVID19.value || measurementTypeCodeId == MeasurementType.CORONA_COVID19_V2.value) {
      value = "COV";
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = SPO2Attribute.SPO2.name;
    } else if (measurementTypeCodeId == MeasurementType.RESPIRATION_RATE.value) {
      value = "RSP";
    }  else if (measurementTypeCodeId == MeasurementType.BREAST_CANCER.value) {
      value = "BC";
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      value = GmpAttribute.HFA_HEIGHT.displayNameEn;
    } else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      value = GmpAttribute.WFA_WEIGHT.displayNameEn;
    } else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      value = GmpAttribute.WFA_WEIGHT.displayNameEn;
    }
    return value;
  }

  String getShortMyHealthName() {
    String value = '';
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = "BP";
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = "BMI";
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      value = "CBG";
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
      value = "ECG";
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      value = "Temp";
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      value = "PUL";
    } else if (measurementTypeCodeId == MeasurementType.COVID19.value ||
        measurementTypeCodeId == MeasurementType.CORONA_COVID19_V2.value) {
      value = "COV";
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = SPO2Attribute.SPO2.name;
    } else if (measurementTypeCodeId ==
        MeasurementType.RESPIRATION_RATE.value) {
      value = "RSP";
    }
    return value;
  }

  String getValue2Title() {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = BPAttribute.getDisplayName(BPAttribute.DIASTOLIC);
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = 'label_bmi'.tr;
    }
    else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = 'input_label_muac_inch'.tr;
    }else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = BPAttribute.getDisplayName(BPAttribute.PULSE);
    }
    return value;
  }

  String? getValue3Title() {
    String? value;
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = BPAttribute.getDisplayName(BPAttribute.PULSE);
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = BmiAttribute.getDisplayName(BmiAttribute.WEIGHT);
    }
    return value;
  }

  String? getValue1() {
    String? value;
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = inputs![BPAttribute.SYSTOLIC.name]?.toStringAsFixed(
          inputs![BPAttribute.SYSTOLIC.name]?.truncateToDouble() ==
              inputs![BPAttribute.SYSTOLIC.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value =
          "${Utils.getFeetFromCentimeter(inputs![BmiAttribute.HEIGHT.name])}' ${Utils.getInchFromCentimeter(inputs![BmiAttribute.HEIGHT.name]).toStringAsFixed(1)}''"
              .replaceAll(".00", "")
              .replaceAll(".0", "");
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = inputs![SPO2Attribute.SPO2.name]?.toStringAsFixed(
          inputs![SPO2Attribute.SPO2.name]?.truncateToDouble() ==
              inputs![SPO2Attribute.SPO2.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.PULSE_RATE.value) {
      value = inputs![PulseAttribute.PULSE_RATE.name]?.toStringAsFixed(
          inputs![PulseAttribute.PULSE_RATE.name]?.truncateToDouble() ==
              inputs![PulseAttribute.PULSE_RATE.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.TEMP.value) {
      value =
      "${inputs![TemperatureAttribute.TEMP.name]?.toStringAsFixed(inputs![TemperatureAttribute.TEMP.name]?.truncateToDouble() == inputs![TemperatureAttribute.TEMP.name] ? 0 : 2) ?? ""}";
    } else if (measurementTypeCodeId == MeasurementType.BLOOD_SUGAR.value) {
      value = inputs![BloodGlucoseAttribute.SUGAR.name]?.toStringAsFixed(
          inputs![BloodGlucoseAttribute.SUGAR.name]?.truncateToDouble() ==
              inputs![BloodGlucoseAttribute.SUGAR.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.BMI.value ||
        measurementTypeCodeId == MeasurementType.TEMP.value) {
      value = result?.value?.toStringAsFixed(
          result?.value?.truncateToDouble() == result?.value ? 0 : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = inputs![MuacAttribute.MUAC.name]?.toStringAsFixed(
          inputs![MuacAttribute.MUAC.name]?.truncateToDouble() ==
              inputs![MuacAttribute.MUAC.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      value = inputs![GmpAttribute.HFA_HEIGHT.name]?.toStringAsFixed(
          inputs![GmpAttribute.HFA_HEIGHT.name]?.truncateToDouble() ==
              inputs![GmpAttribute.HFA_HEIGHT.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      value = inputs![GmpAttribute.WFA_WEIGHT.name]?.toStringAsFixed(
          inputs![GmpAttribute.WFA_WEIGHT.name]?.truncateToDouble() ==
              inputs![GmpAttribute.WFA_WEIGHT.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      value = inputs![GmpAttribute.WFL_WEIGHT.name]?.toStringAsFixed(
          inputs![GmpAttribute.WFL_WEIGHT.name]?.truncateToDouble() ==
              inputs![GmpAttribute.WFL_WEIGHT.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.HEMOGLOBIN.value) {
      value = result?.value?.toStringAsFixed(
          result?.value?.truncateToDouble() == result?.value ? 0 : 2) ??
          "";
    }
    return value;
  }

  String? getValue2() {
    String? value;
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = inputs![BPAttribute.DIASTOLIC.name]?.toStringAsFixed(
          inputs![BPAttribute.DIASTOLIC.name]?.truncateToDouble() ==
              inputs![BPAttribute.DIASTOLIC.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = result?.value?.toStringAsFixed(
          result?.value?.truncateToDouble() == result?.value ? 0 : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = inputs![PulseAttribute.PULSE_RATE.name]?.toStringAsFixed(
          inputs![PulseAttribute.PULSE_RATE.name]?.truncateToDouble() ==
              inputs![PulseAttribute.PULSE_RATE.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = inputs![MuacAttribute.MUAC.name]?.toStringAsFixed(
          inputs![MuacAttribute.MUAC.name]?.truncateToDouble() ==
              inputs![MuacAttribute.MUAC.name]
              ? 0
              : 2) ??
          "";
      if(value!.isNotEmpty) {
        var inch = Utils.getInchFromCentimeter(double.parse(value));
        value = inch.toStringAsFixed(inch.truncateToDouble() == inch ? 0 : 2);
      }
    }
    return value;
  }

  double getValueY1() {
    double value = 0.0;
    if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = result?.value ?? 0.0;
    } else if (measurementTypeCodeId == MeasurementType.ECG.value) {
      value = inputs?['pressure']?? 0.0;
    } else if (measurementTypeCodeId == MeasurementType.BREAST_CANCER.value) {
      value = result?.value ?? 0.0;
    } else if (measurementTypeCodeId == MeasurementType.WFA.value) {
      value = inputs![GmpAttribute.WFA_WEIGHT.name];
    } else if (measurementTypeCodeId == MeasurementType.WFL.value) {
      value = inputs![GmpAttribute.WFL_LENGTH.name];
    } else if (measurementTypeCodeId == MeasurementType.HFA.value) {
      value = inputs![GmpAttribute.HFA_HEIGHT.name];
    }  else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = inputs![MuacAttribute.MUAC.name];
    } else {
      value = double.parse(getValue1() ?? "0");
    }
    return value;
  }

  double getValueY2() {
    return double.parse(getValue2() ?? "0");
  }

  String? getValue3() {
    String? value;
    if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = inputs![BPAttribute.PULSE.name]?.toStringAsFixed(
          inputs![BPAttribute.PULSE.name]?.truncateToDouble() ==
              inputs![BPAttribute.PULSE.name]
              ? 0
              : 2) ??
          "";
    } else if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = inputs![BmiAttribute.WEIGHT.name]?.toStringAsFixed(
          inputs![BmiAttribute.WEIGHT.name]?.truncateToDouble() ==
              inputs![BmiAttribute.WEIGHT.name]
              ? 0
              : 2) ??
          "";
    }
    return value;
  }

  String getValue1Unit() {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = "Ft In".trUnit();
    } else if (measurementTypeCodeId == MeasurementType.HEMOGLOBIN.value) {
      value = "g/dL.".trUnit();
    } else {
      value = getMeasurementUnitString();
    }
    return value;
  }

  String getValue2Unit() {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.SpO2.value) {
      value = "bpm";
    } else if (measurementTypeCodeId == MeasurementType.MUAC.value) {
      value = "inch";
    } else {
      value = getMeasurementUnitString();
    }
    return value;
  }

  String getValue3Unit() {
    String value = "";
    if (measurementTypeCodeId == MeasurementType.BMI.value) {
      value = "Kg";
    } else if (measurementTypeCodeId == MeasurementType.BP.value) {
      value = "bpm";
    } else {
      value = getMeasurementValueWithUnitString();
    }
    return value;
  }





  String getStatusAssetPath() {
    var path = "";
    if (result?.status?.toUpperCase() == "NORMAL") {
      path = "assets/images/healthrecord/ic_check.svg";
    } else {
      path = "assets/images/healthrecord/ic_exclamatory.svg";
    }
    return path;
  }

  String getAssetPath() {
    return populateDrawable(measurementTypeCodeId);
  }

  getAdviceAndSuggestion() {
    return "${getAdvice()}\n${getSuggestion()}";
  }

  bool isNotEmptyAdviceAndSuggestion() {
    if(Utils.notNullOrEmpty(getAdvice())){
      return false;
    }
    if(Utils.notNullOrEmpty(getSuggestion())) {
      return false;
    }
    return true;
  }
  getAdvice() {
    
    if (Utils.isLocaleBn()) {
      if(measurementTypeCodeId == MeasurementType.BLOOD_GROUPING.value) {
        return "আপনার রক্তের গ্রুপ ${getStatus()}";
      }
      return result?.bnAdvice ?? "";
    } else {
      if(measurementTypeCodeId == MeasurementType.BLOOD_GROUPING.value) {
        return "Your Blood group is ${getStatus()}";
      }
      return result?.engAdvice ?? "";
    }
  }

  getSuggestion() {
    if (Utils.isLocaleBn()) {
      return result?.suggestionBn?? getSuggestionEn(result?.suggestion ?? "");
    } else {
      return getSuggestionEn(result?.suggestion ?? "");
    }
  }

  getSuggestionEn(String suggestion) {
    if (suggestion.contains("ওজন বাড়াতে হবে")) {
      return (suggestion
          .replaceAll("আপনাকে কমপক্ষে", "You have to increase ")
          .replaceAll("আপনাকে", "You have to increase ")
          .replaceAll("ওজন বাড়াতে হবে", " weight.")
          .replaceAll("kg", " kg")
          .replaceAll("।", ""))
          .trim();
    } else if (suggestion.contains("ওজন কমাতে হবে")) {
      return (suggestion
          .replaceAll("আপনাকে কমপক্ষে", "You have to reduce ")
          .replaceAll("আপনাকে", "You have to reduce ")
          .replaceAll("ওজন কমাতে হবে", " weight.")
          .replaceAll("kg", " kg"))
          .trim();
    } else {
      return suggestion;
    }
  }
}

class Location {
  Location({
    this.latitude,
    this.longitude,
    this.altitude,});

  Location.fromJson(dynamic json) {
    latitude = json['latitude'] != null ? json['latitude'].cast<String>() : [];
    longitude = json['longitude'] != null ? json['longitude'].cast<String>() : [];
    altitude = json['altitude'] != null ? json['altitude'].cast<String>() : [];
  }
  List<String>? latitude;
  List<String>? longitude;
  List<String>? altitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['altitude'] = altitude;
    return map;
  }

}

class ResultDTO {
  double? value;
  String? status;
  String? severity;
  String? remarks;
  String? suggestion;
  String? suggestionBn;
  String? engAdvice;
  String? bnAdvice;
  String? colorCode;
  String? statusBn;

  ResultDTO(
      {this.value,
        this.status,
        this.severity,
        this.remarks,
        this.suggestion,
        this.suggestionBn,
        this.engAdvice,
        this.bnAdvice,
        this.colorCode,
        this.statusBn});

  ResultDTO.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    status = json['status'];
    severity = json['severity'];
    remarks = json['remarks'];
    suggestion = json['suggestion'];
    suggestionBn = json['suggestion_bn'];
    engAdvice = json['eng_advice'];
    bnAdvice = json['bn_advice'];
    colorCode = json['color_code'];
    statusBn = json['status_bn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['status'] = status;
    data['severity'] = severity;
    data['remarks'] = remarks;
    data['suggestion'] = suggestion;
    data['suggestion_bn'] = suggestionBn;
    data['eng_advice'] = engAdvice;
    data['bn_advice'] = bnAdvice;
    data['color_code'] = colorCode;
    data['status_bn'] = statusBn;
    return data;
  }

  getStatus(){
    if(Utils.isLocaleBn()){
      return statusBn??status;
    }
    return status;
  }

  static List<ResultDTO> listFromJson(list) =>
      List<ResultDTO>.from(list.map((x) => ResultDTO.fromJson(x)));
}

enum MeasurementType {
  BP(1),
  TEMP(2),
  BMI(3),
  BLOOD_SUGAR(4),
  PULSE_RATE(5),
  RESPIRATION_RATE(6),
  WAVE_COUNT(9),
  ECG(7),
  SpO2(8),
  MUAC(10),
  COVID19(11),
  CORONA_COVID19_V2(12),

  BREAST_CANCER(15),
  HFA(16),
  WFA(17),
  BODY_COMPOSITION(20),
  EYE_SCREENING(21),
  BLOOD_GROUPING(22),
  HEMOGLOBIN(26),
  WFL(23);

  const MeasurementType(this.value);

  final int value;
}

enum BPAttribute {
  SYSTOLIC("Systolic", "সিস্টোলিক"),
  DIASTOLIC("Diastolic", "ডায়াস্টলিক"),
  PULSE("Pulse", "পালস্‌");

  const BPAttribute(this.displayNameEn, this.displayNameBn);

  final String displayNameEn;
  final String displayNameBn;

  static getDisplayName(BPAttribute attribute) {
    if (Utils.isLocaleBn()) {
      return attribute.displayNameBn;
    } else {
      return attribute.displayNameEn;
    }
  }
}

enum PulseAttribute {
  PULSE_RATE;
}

enum SPO2Attribute {
  SPO2;
}

enum TemperatureAttribute {
  TEMP;
}
enum MuacAttribute {
  MUAC;
}
enum HemoglobinAttribute {
  HEMOGLOBIN_LEVEL;
}
enum EyeScreeningAttribute {
  EYE_SCREENING;
}

enum BmiAttribute {
  HEIGHT("Height", "উচ্চতা"),
  WEIGHT("Weight", "ওজন");

  const BmiAttribute(this.displayNameEn, this.displayNameBn);

  final String displayNameEn;
  final String displayNameBn;

  static getDisplayName(BmiAttribute attribute) {
    if (Utils.isLocaleBn()) {
      return attribute.displayNameBn;
    } else {
      return attribute.displayNameEn;

    }
  }
}

enum BodyCompositionAttribute {
  BODY_COMPOSITION;
}
enum GmpAttribute {
  HFA_HEIGHT("Height", "উচ্চতা"),
  WFA_WEIGHT("Weight", "ওজন"),
  WFL_LENGTH("Height", "উচ্চতা"),
  WFL_WEIGHT("Weight", "ওজন");

  const GmpAttribute(this.displayNameEn, this.displayNameBn);

  final String displayNameEn;
  final String displayNameBn;

  static getDisplayName(BmiAttribute attribute) {
    if (Utils.isLocaleBn()) {
      return attribute.displayNameBn;
    } else {
      return attribute.displayNameEn;

    }
  }
}

enum BmiUnit {
  CENTIMETER,
  FEET_INCH,
  KG,
  LB;
}

enum GmpUnit {
  CENTIMETER,
  FEET_INCH,
  KG,
  LB;
}
enum MuacUnit {
  CENTIMETER,
  INCH;
}


enum TemperatureUnit {
  FAHRENHEIT,
  CELSIUS;
}

enum BloodGlucoseAttribute {
  SUGAR;
}

enum BloodGroupingAttribute {
  BLOOD_GROUPING;
}


enum GlucoseTag {
  RANDOM(9),
  FASTING(10),
  OGTT(11),
  TWO_HR_AFB(12);

  const GlucoseTag(this.tagId);

  final int tagId;
}

class ECG {
  List<Ecgsymps>? ecgsymps;
  Ecgval? ecgval;
  ECGInput? ecgInput;

  ECG({this.ecgsymps, this.ecgval, this.ecgInput});

  ECG.fromJson(Map<String, dynamic> json) {
    if (json['ecgsymps'] != null) {
      ecgsymps = <Ecgsymps>[];
      json['ecgsymps'].forEach((v) {
        ecgsymps!.add(Ecgsymps.fromJson(v));
      });
    }
    ecgval = json['ecgval'] != null ? Ecgval.fromJson(json['ecgval']) : null;
    ecgInput = json['input'] != null ? ECGInput.fromJson(json['input']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ecgsymps != null) {
      data['ecgsymps'] = ecgsymps!.map((v) => v.toJson()).toList();
    }
    if (ecgval != null) {
      data['ecgval'] = ecgval!.toJson();
    }
    if (ecgInput != null) {
      data['input'] = ecgInput?.toJson();
    }
    return data;
  }
}

class Ecgval {
  int? breath;
  int? heartage;
  int? hrmax;
  int? hrmean;
  int? hrmin;
  int? hrv;
  String? mood;
  int? pbcnt;
  String? pns;
  String? pr;
  int? pressure;
  String? qrs;
  String? qt;
  String? qtc;
  String? sns;
  String? suspectedflag;

  Ecgval(
      {this.breath,
        this.heartage,
        this.hrmax,
        this.hrmean,
        this.hrmin,
        this.hrv,
        this.mood,
        this.pbcnt,
        this.pns,
        this.pr,
        this.pressure,
        this.qrs,
        this.qt,
        this.qtc,
        this.sns,
        this.suspectedflag});

  Ecgval.fromJson(Map<String, dynamic> json) {
    breath = json['breath'];
    heartage = json['heartage'];
    hrmax = json['hrmax'];
    hrmean = json['hrmean'];
    hrmin = json['hrmin'];
    hrv = json['hrv'];
    mood = json['mood'];
    pbcnt = json['pbcnt'];
    pns = json['pns'];
    pr = json['pr'];
    pressure = json['pressure'];
    qrs = json['qrs'];
    qt = json['qt'];
    qtc = json['qtc'];
    sns = json['sns'];
    suspectedflag = json['suspectedflag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['breath'] = breath;
    data['heartage'] = heartage;
    data['hrmax'] = hrmax;
    data['hrmean'] = hrmean;
    data['hrmin'] = hrmin;
    data['hrv'] = hrv;
    data['mood'] = mood;
    data['pbcnt'] = pbcnt;
    data['pns'] = pns;
    data['pr'] = pr;
    data['pressure'] = pressure;
    data['qrs'] = qrs;
    data['qt'] = qt;
    data['qtc'] = qtc;
    data['sns'] = sns;
    data['suspectedflag'] = suspectedflag;
    return data;
  }
}
class ECGInput {
  ECGInput({
    this.breath,
    this.heartage,
    this.hrmax,
    this.hrmean,
    this.hrmin,
    this.hrv,
    this.pbcnt,
    this.pressure,
    this.suspectedflag,});

  ECGInput.fromJson(dynamic json) {
    breath = json['breath'];
    heartage = json['heartage'];
    hrmax = json['hrmax'];
    hrmean = json['hrmean'];
    hrmin = json['hrmin'];
    hrv = json['hrv'];
    pbcnt = json['pbcnt'];
    pressure = json['pressure'];
    suspectedflag = json['suspectedflag'];
  }
  String? breath;
  String? heartage;
  String? hrmax;
  String? hrmean;
  String? hrmin;
  String? hrv;
  String? pbcnt;
  String? pressure;
  String? suspectedflag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['breath'] = breath;
    map['heartage'] = heartage;
    map['hrmax'] = hrmax;
    map['hrmean'] = hrmean;
    map['hrmin'] = hrmin;
    map['hrv'] = hrv;
    map['pbcnt'] = pbcnt;
    map['pressure'] = pressure;
    map['suspectedflag'] = suspectedflag;
    return map;
  }

}
class Ecgsymps {
  String? name;
  String? sympNameBn;
  String? suggestion;
  String? suggestionBn;
  String? sympDesc;
  String? sympDescBn;
  String? colorCode;
  String? sympcode;

  Ecgsymps(
      {this.name,
        this.sympNameBn,
        this.suggestion,
        this.suggestionBn,
        this.sympDesc,
        this.sympDescBn,
        this.colorCode,
        this.sympcode});

  Ecgsymps.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sympNameBn = json['symp_name_bn'];
    suggestion = json['suggestion'];
    suggestionBn = json['suggestion_bn'];
    sympDesc = json['symp_desc'];
    sympDescBn = json['symp_desc_bn'];
    colorCode = json['color_code'];
    sympcode = json['sympcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['symp_name_bn'] = this.sympNameBn;
    data['suggestion'] = this.suggestion;
    data['suggestion_bn'] = this.suggestionBn;
    data['symp_desc'] = this.sympDesc;
    data['symp_desc_bn'] = this.sympDescBn;
    data['color_code'] = this.colorCode;
    data['sympcode'] = this.sympcode;
    return data;
  }
}


class BodyComposition {
  BodyComposition({
    this.bodyFatData,
    this.cAdc,
    this.cAge,
    this.cBfr,
    this.cBm,
    this.cBmi,
    this.cBmr,
    this.cBodyAge,
    this.cFatMass,
    this.cFatNotWeight,
    this.cHeight,
    this.cMuscleMass,
    this.cNumber,
    this.cObesityStatus,
    this.cPp,
    this.cProteinMass,
    this.cRom,
    this.cSex,
    this.cSfr,
    this.cStdWeight,
    this.cUvi,
    this.cVwc,
    this.cWeight,
    this.cWeightDiff,
    this.cWeightDiffStatus,
    this.maleWeight,});

  BodyComposition.fromJson(dynamic json) {
    bodyFatData = json['bodyFatData'] != null ? BodyFatData.fromJson(json['bodyFatData']) : null;
    cAdc = json['c_adc'];
    cAge = json['c_age'];
    cBfr = json['c_bfr'] !=null ? double.parse(json['c_bfr'].toStringAsFixed(2)) : 0;
    cBm = json['c_bm'] !=null ? double.parse(json['c_bm'].toStringAsFixed(2)) : 0;
    cBmi = json['c_bmi'] !=null ? double.parse(json['c_bmi'].toStringAsFixed(2)) : 0;
    cBmr = json['c_bmr'] !=null ? double.parse(json['c_bmr'].toStringAsFixed(2)) : 0;
    cBodyAge = json['c_bodyAge'];
    cFatMass = json['c_fatMass'] !=null ? double.parse(json['c_fatMass'].toStringAsFixed(2)) : 0;
    cFatNotWeight = json['c_fatNotWeight'] !=null ? double.parse(json['c_fatNotWeight'].toStringAsFixed(2)) : 0;
    cHeight = json['c_height'];
    cMuscleMass = json['c_muscleMass'] !=null ? double.parse(json['c_muscleMass'].toStringAsFixed(2)) : 0;
    cNumber = json['c_number'];
    cObesityStatus = json['c_obesityStatus'];
    cPp = json['c_pp'] !=null ? double.parse(json['c_pp'].toStringAsFixed(2)) : 0;
    cProteinMass = json['c_proteinMass'] !=null ? double.parse(json['c_proteinMass'].toStringAsFixed(2)) : 0;
    cRom = json['c_rom'] !=null ? double.parse(json['c_rom'].toStringAsFixed(2)) : 0;
    cSex = json['c_sex'];
    cSfr = json['c_sfr'] !=null ? double.parse(json['c_sfr'].toStringAsFixed(2)) : 0;
    cStdWeight = json['c_stdWeight'];
    cUvi = json['c_uvi'] !=null ? double.parse(json['c_uvi'].toStringAsFixed(2)) : 0;
    cVwc = json['c_vwc'] !=null ? double.parse(json['c_vwc'].toStringAsFixed(2)) : 0;
    cWeight = json['c_weight'];
    cWeightDiff = json['c_weightDiff'] !=null ? double.parse(json['c_weightDiff'].toStringAsFixed(2)) : 0;
    cWeightDiffStatus = json['c_weightDiffStatus'];
    maleWeight = json['maleWeight'];
  }
  BodyFatData? bodyFatData;
  int? cAdc;
  int? cAge;
  double? cBfr;
  double? cBm;
  double? cBmi;
  double? cBmr;
  int? cBodyAge;
  double? cFatMass;
  double? cFatNotWeight;
  int? cHeight;
  double? cMuscleMass;
  int? cNumber;
  String? cObesityStatus;
  double? cPp;
  double? cProteinMass;
  double? cRom;
  int? cSex;
  double? cSfr;
  double? cStdWeight;
  double? cUvi;
  double? cVwc;
  double? cWeight;
  double? cWeightDiff;
  String? cWeightDiffStatus;
  dynamic maleWeight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bodyFatData != null) {
      map['bodyFatData'] = bodyFatData?.toJson();
    }
    map['c_adc'] = cAdc;
    map['c_age'] = cAge;
    map['c_bfr'] = cBfr;
    map['c_bm'] = cBm;
    map['c_bmi'] = cBmi;
    map['c_bmr'] = cBmr;
    map['c_bodyAge'] = cBodyAge;
    map['c_fatMass'] = cFatMass;
    map['c_fatNotWeight'] = cFatNotWeight;
    map['c_height'] = cHeight;
    map['c_muscleMass'] = cMuscleMass;
    map['c_number'] = cNumber;
    map['c_obesityStatus'] = cObesityStatus;
    map['c_pp'] = cPp;
    map['c_proteinMass'] = cProteinMass;
    map['c_rom'] = cRom;
    map['c_sex'] = cSex;
    map['c_sfr'] = cSfr;
    map['c_stdWeight'] = cStdWeight;
    map['c_uvi'] = cUvi;
    map['c_vwc'] = cVwc;
    map['c_weight'] = cWeight;
    map['c_weightDiff'] = cWeightDiff;
    map['c_weightDiffStatus'] = cWeightDiffStatus;
    map['maleWeight'] = maleWeight;

    return map;
  }

}

class BodyFatData {
  BodyFatData({
    this.adc,
    this.age,
    this.bfr,
    this.bm,
    this.bmi,
    this.bmr,
    this.bodyAge,
    this.date,
    this.decimalInfo,
    this.height,
    this.number,
    this.pp,
    this.rom,
    this.sex,
    this.sfr,
    this.time,
    this.uvi,
    this.vwc,
    this.weight,});

  BodyFatData.fromJson(dynamic json) {
    adc = json['adc'];
    age = json['age'];
    bfr = json['bfr'];
    bm = json['bm'];
    bmi = json['bmi'];
    bmr = json['bmr'];
    bodyAge = json['bodyAge'];
    date = json['date'];
    decimalInfo = json['decimalInfo'] != null ? DecimalInfo.fromJson(json['decimalInfo']) : null;
    height = json['height'];
    number = json['number'];
    pp = json['pp'];
    rom = json['rom'];
    sex = json['sex'];
    sfr = json['sfr'];
    time = json['time'];
    uvi = json['uvi'];
    vwc = json['vwc'];
    weight = json['weight'];
  }
  int? adc;
  int? age;
  double? bfr;
  double? bm;
  double? bmi;
  double? bmr;
  int? bodyAge;
  String? date;
  DecimalInfo? decimalInfo;
  int? height;
  int? number;
  double? pp;
  double? rom;
  int? sex;
  double? sfr;
  String? time;
  int? uvi;
  double? vwc;
  double? weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['adc'] = adc;
    map['age'] = age;
    map['bfr'] = bfr;
    map['bm'] = bm;
    map['bmi'] = bmi;
    map['bmr'] = bmr;
    map['bodyAge'] = bodyAge;
    map['date'] = date;
    if (decimalInfo != null) {
      map['decimalInfo'] = decimalInfo?.toJson();
    }
    map['height'] = height;
    map['number'] = number;
    map['pp'] = pp;
    map['rom'] = rom;
    map['sex'] = sex;
    map['sfr'] = sfr;
    map['time'] = time;
    map['uvi'] = uvi;
    map['vwc'] = vwc;
    map['weight'] = weight;
    return map;
  }

}

class DecimalInfo {
  DecimalInfo({
    this.kgDecimal,
    this.kgGraduation,
    this.lbDecimal,
    this.lbGraduation,
    this.sourceDecimal,
    this.stDecimal,});

  DecimalInfo.fromJson(dynamic json) {
    kgDecimal = json['kgDecimal'];
    kgGraduation = json['kgGraduation'];
    lbDecimal = json['lbDecimal'];
    lbGraduation = json['lbGraduation'];
    sourceDecimal = json['sourceDecimal'];
    stDecimal = json['stDecimal'];
  }
  int? kgDecimal;
  int? kgGraduation;
  int? lbDecimal;
  int? lbGraduation;
  int? sourceDecimal;
  int? stDecimal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kgDecimal'] = kgDecimal;
    map['kgGraduation'] = kgGraduation;
    map['lbDecimal'] = lbDecimal;
    map['lbGraduation'] = lbGraduation;
    map['sourceDecimal'] = sourceDecimal;
    map['stDecimal'] = stDecimal;
    return map;
  }
}

class EyeScreening {
  EyeScreening({
    this.background,
    this.createdAt,
    this.icon,
    this.eyeScreeningResult,
    this.screenType,
    this.screenTypeMessageBn,
    this.screenTypeMessageEn,});

  EyeScreening.fromJson(dynamic json) {
    background = json['background'];
    createdAt = json['createdAt'];
    icon = json['icon'];
    eyeScreeningResult = json['result'] != null ? EyeScreeningResult.fromJson(json['result']) : null;
    screenType = json['screenType'];
    screenTypeMessageBn = json['screenTypeMessageBn'];
    screenTypeMessageEn = json['screenTypeMessageEn'];
  }
  String? background;
  int? createdAt;
  int? icon;
  EyeScreeningResult? eyeScreeningResult;
  String? screenType;
  String? screenTypeMessageBn;
  String? screenTypeMessageEn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['background'] = background;
    map['createdAt'] = createdAt;
    map['icon'] = icon;
    if (eyeScreeningResult != null) {
      map['result'] = eyeScreeningResult?.toJson();
    }
    map['screenType'] = screenType;
    map['screenTypeMessageBn'] = screenTypeMessageBn;
    map['screenTypeMessageEn'] = screenTypeMessageEn;
    return map;
  }

  static List<EyeScreening> listFromJson(list) =>
      List<EyeScreening>.from(list.map((x) => EyeScreening.fromJson(x)));
}

class EyeScreeningResult {
  EyeScreeningResult({
    this.leftEye,
    this.rightEye,
    this.message,});

  EyeScreeningResult.fromJson(dynamic json) {
    leftEye = json['leftEye'];
    rightEye = json['rightEye'];
    message = json['message'];
  }
  String? leftEye;
  String? rightEye;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leftEye'] = leftEye;
    map['rightEye'] = rightEye;
    map['message'] = message;
    return map;
  }
  Color getResultColorByEyeScreenType(EyeScreeningTypeEnum eyeScreeningTypeEnum) {
    Color color = Colors.green;
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE) {
      final colorMap = {
        "N5": Colors.green,
        "N6": Colors.green,
        "N8": Colors.green,
        "N10": Colors.red,
        "N12": Colors.red,
        "N14": Colors.red,
        "N18": Colors.red,
        "N24": Colors.red,
      };
      color = colorMap[message!]??color;
    } else if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1 || eyeScreeningTypeEnum == EyeScreeningTypeEnum.ILLITERATE_TEST || eyeScreeningTypeEnum == EyeScreeningTypeEnum.CHILDREN_EYE_TEST) {
      final colorMap = {
        "6/6": Colors.green,
        "6/7.5": Colors.green,
        "6/9": Colors.green,
        "6/12": Colors.red,
        "6/15": Colors.red,
        "6/18": Colors.red,
        "6/24": Colors.red,
        "6/30": Colors.red,
        "6/60": Colors.red,
      };
      final colorLeft = colorMap[leftEye!]??color;
      final colorRight = colorMap[rightEye!]??color;
      if(colorLeft == Colors.green && colorRight == Colors.green) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.COLOR_BLIND_TEST) {
      if(message == EyeScreeningColorBlindResultEnum.BAD.name) {
        return Colors.red;
      };
      return Colors.green;
    } else if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST) {
      var testedResultValue = double.tryParse(message!)??0.0;
      if(testedResultValue <= 1.5) {
        return Colors.red;
      } else if(testedResultValue >= 1.6 && testedResultValue <= 2.0) {
        return Colors.yellow;
      } else {
        return Colors.green;
      }
    }
    return color;
  }

  String getHexColor(EyeScreeningTypeEnum eyeScreeningTypeEnum) {
    Color color = getResultColorByEyeScreenType(eyeScreeningTypeEnum);
    final colorInt = color.toARGB32();
    String hex = '#${colorInt.toRadixString(16).padLeft(8, '0')}';
    return hex;
  }
}