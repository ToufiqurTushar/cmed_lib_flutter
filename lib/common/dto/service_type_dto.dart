import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bmi/bmi_height_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto_manual_selection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/blood_grouping/blood_grouping_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/hemoglobin/hemoglobin_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/temp/temp_input_view.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/ecg/ecg_device_connection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/fat/fat_height_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bscan/bscan_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/gmp/gmp_input_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/muac/muac_input_view.dart';
import 'attribute_dto.dart';

class ServiceType {
  int?  codeId;
  String? serviceName;
  String? serviceNameLarge;
  String? serviceNameBn;
  String? image;
  bool? isChecked;
  int? serviceFees;
  int? serviceTypeId;
  bool? isMeasured;
  bool? isUnavailable;
  String? result;
  String? resultBn;
  String? colorCode;
  String? unavailableReason;
  List<ServiceType>? list;
  int adapterPosition;
  int order;
  List<Attribute>? attributes;
  double? serviceRate;
  double? serviceRateDiscounted;
  double? discount;
  List<MeasurementDTO>? measurements;

  // Constructor
  ServiceType({
    this.codeId,
    this.isUnavailable,
    this.unavailableReason,
    this.serviceName,
    this.serviceNameLarge,
    this.serviceNameBn,
    this.image,
    this.isChecked,
    this.serviceFees,
    this.serviceTypeId,
    this.isMeasured,
    this.result,
    this.resultBn,
    this.colorCode = "#536A6D",
    this.list,
    this.adapterPosition = 0,
    this.order = 0,
    this.attributes,
    this.serviceRate,
    this.serviceRateDiscounted,
    this.discount,
    this.measurements,
  });

  // fromJson constructor for JSON deserialization
  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      codeId: json['id'] as int?,
      isUnavailable: json['isUnavailable'] as bool?,
      serviceName: json['code'] as String?,
      unavailableReason: json['unavailableReason'] as String?,
      serviceNameLarge: json['name'] as String?,
      serviceNameBn: json['name_bn'] as String?,
      isChecked: json['isChecked'] as bool?,
      serviceFees: json['cost'] as int?,
      serviceTypeId: json['service_type_id'] as int?,
      isMeasured: json['is_measured'] as bool?,
      result: json['measurementResult'] as String?,
      resultBn: json['measurementResultBn'] as String?,
      colorCode: json['color_code'] as String?,
      list: (json['list'] as List?)
          ?.map((item) => ServiceType.fromJson(item))
          .toList(),
      adapterPosition: json['adapterPosition'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
      attributes: (json['attributes'] as List?)
          ?.map((item) => Attribute.fromJson(item))
          .toList(),
      serviceRate: json['serviceRate'] as double?,
      serviceRateDiscounted: json['serviceRateDiscounted'] as double?,
      discount: json['discount'] as double?,
      measurements: (json['measurements'] as List?)
          ?.map((item) => MeasurementDTO.fromJson(item))
          .toList(),
    );
  }

  // toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': codeId,
      'isUnavailable': isUnavailable,
      'code': serviceName,
      'unavailableReason': unavailableReason,
      'name': serviceNameLarge,
      'name_bn': serviceNameBn,
      'isChecked': isChecked,
      'cost': serviceFees,
      'service_type_id': serviceTypeId,
      'is_measured': isMeasured,
      'measurementResult': result,
      'measurementResultBn': resultBn,
      'color_code': colorCode,
      'list': list?.map((item) => item.toJson()).toList(),
      'adapterPosition': adapterPosition,
      'order': order,
      'attributes': attributes?.map((attr) => attr.toJson()).toList(),
      'serviceRate': serviceRate,
      'serviceRateDiscounted': serviceRateDiscounted,
      'discount': discount,
      'measurements': measurements?.map((attr) => attr.toJson()).toList(),
    };
  }

  String getMeasurementRouteNameString() {
    String value = "";
    if (codeId == MeasurementType.BP.value) {
      value = AutoManualSelectionView.routeName;
    } else if (codeId == MeasurementType.BMI.value) {
      value = BmiHeightInputView.routeName;
    } else if (codeId == MeasurementType.BODY_COMPOSITION.value) {
      value = FatHeightInputView.routeName;
    } else if (codeId == MeasurementType.BLOOD_SUGAR.value) {
      value = AutoManualSelectionView.routeName;
    } else if (codeId == MeasurementType.BLOOD_GROUPING.value) {
      value = BloodGroupingView.routeName;
    } else if (codeId == MeasurementType.TEMP.value) {
      value = TempInputView.routeName;
    } else if (codeId == MeasurementType.PULSE_RATE.value) {
      value = "";
    } else if (codeId == MeasurementType.RESPIRATION_RATE.value) {
      value = "";
    } else if (codeId == MeasurementType.ECG.value) {
      value = EcgDeviceConnectionView.routeName;
    } else if (codeId == MeasurementType.SpO2.value) {
      value = AutoManualSelectionView.routeName;
    } else if (codeId == MeasurementType.MUAC.value) {
      value = MuacInputView.routeName;
    } else if (codeId == MeasurementType.HFA.value) {
      //value = HfaInputView.routeName;
      value = GmpInputView.routeName;
    } else if (codeId == MeasurementType.WFA.value) {
      //value = WfaInputView.routeName;
      value = GmpInputView.routeName;
    }  else if (codeId == MeasurementType.WFL.value) {
      //value = WflInputView.routeName;
      value = GmpInputView.routeName;
    } else if (codeId == MeasurementType.CORONA_COVID19_V2.value || codeId == MeasurementType.COVID19.value) {
      //value = "";
    } else if (codeId == MeasurementType.BREAST_CANCER.value) {
      value = BScanInputView.routeName;
    } else if (codeId == MeasurementType.BLOOD_GROUPING.value) {
      //value = "";
    } else if (codeId == MeasurementType.EYE_SCREENING.value) {
      value = EyeScreeningHomeView.routeName;
    } else if (codeId == MeasurementType.HEMOGLOBIN.value) {
      value = HemoglobinInputView.routeName;
    }

    return value;
  }

  int getColor() {
    return int.parse(colorCode?.replaceAll('#', '0xff') ??
        Colors.black54.value.toString());
  }

  String getStringServiceRate() {
    if(serviceRateDiscounted == null) {
      return "label_free".tr;
    }
    return "${serviceRateDiscounted} ${'label_bdt'.tr}";
  }
}
