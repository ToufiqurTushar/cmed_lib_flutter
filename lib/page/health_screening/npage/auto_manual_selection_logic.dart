import 'dart:io';

import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/bmi/bmi_device_connection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/fat/fat_device_connection_view.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'auto/npage/blood_glucose/blood_glucose_auto_select_time_period_view.dart';
import 'auto/npage/bp/bp_device_connection_view.dart';
import 'auto/npage/oxygen_saturation/oxygen_saturation_device_connection_view.dart';
import 'manual/npage/blood_glucose/blood_glucose_select_time_period_view.dart';
import 'manual/npage/bmi/bmi_height_weight_input_view.dart';
import 'manual/npage/bp/bp_input_view.dart';
import 'manual/npage/oxygen_saturation/oxygen_saturation_input_view.dart';
import 'manual/npage/temp/temp_input_view.dart';

class AutoManualSelectionLogic extends BaseLogic {
  var code = 0.obs;
  var image = "".obs;
  var connectRoute = ''.obs;
  var manualRoute = ''.obs;
  var isBodyFat = false.obs;
  var isBMI = false.obs;
  var isAutoFeatureEnable = true.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('codeId')) {
      code.value = arguments['codeId']; // Set the dynamic value
    }
  }

  setImageAndRoute() {
    if (code.value == MeasurementType.BP.value) {
      image.value = "assets/images/screening/ic_bp_connect.svg";
      connectRoute.value = BpDeviceConnectionView.routeName;
      manualRoute.value = BpInputView.routeName;
      if(Platform.isAndroid || Platform.isIOS) {
        isAutoFeatureEnable.value = true;
      }
    } else if (code.value == MeasurementType.SpO2.value) {
      image.value = "assets/images/screening/ic_spo2.svg";
      connectRoute.value = OxygenSaturationDeviceConnectionView.routeName;
      manualRoute.value = OxygenSaturationInputView.routeName;
      if(!Platform.isAndroid) {
        isAutoFeatureEnable.value = false;
      }
    } else if (code.value == MeasurementType.TEMP.value) {
      image.value = "assets/images/screening/ic_temp.svg";
      connectRoute.value = "";
      manualRoute.value = TempInputView.routeName;
      if(!Platform.isAndroid) {
        isAutoFeatureEnable.value = false;
      }
    } else if (code.value == MeasurementType.BMI.value) {
      image.value = "assets/images/screening/ic_bmi_connect.svg";
      connectRoute.value = BmiDeviceConnectionView.routeName;
      manualRoute.value = BmiHeightWeightInputView.routeName;
      isBMI.value = true;
      if(!Platform.isAndroid) {
        isAutoFeatureEnable.value = false;
      }
    } else if (code.value == MeasurementType.BODY_COMPOSITION.value) {
      image.value = "assets/images/screening/ic_bmi_connect.svg";
      connectRoute.value = FatDeviceConnectionView.routeName;
      manualRoute.value = "";
      isBodyFat.value = true; // Set BMI-specific flag
      if(!Platform.isAndroid) {
        isAutoFeatureEnable.value = false;
      }
    } else if (code.value == MeasurementType.BLOOD_SUGAR.value) {
      image.value = "assets/images/measurement/img_glucose_dnurse_first.png";
      connectRoute.value = BloodGlucoseAutoSelectTimePeriodView.routeName;
      manualRoute.value = BloodGlucoseSelectTimePeriodView.routeName;
      if(!Platform.isAndroid) {
        isAutoFeatureEnable.value = false;
      }
    }
  }
}


