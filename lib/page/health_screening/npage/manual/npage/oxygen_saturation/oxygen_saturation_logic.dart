import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/base/base_logic.dart';

import '../../../../dto/screening_report_result_details_argument.dart';

class OxygenSaturationLogic extends BaseLogic {
  final ScreeningReportRepository repository;

  OxygenSaturationLogic({required this.repository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController spo2Controller;
  late TextEditingController pulseController;

  var screeningReport = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    spo2Controller = TextEditingController();
    pulseController = TextEditingController();
  }

  String? validateSPO2(String value) {
    if (!GetUtils.isNumericOnly(value)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_SPO2}-${MeasurementConstant.MAX_SPO2})';
    }
    if (GetUtils.isGreaterThan(
            double.parse(value), MeasurementConstant.MAX_SPO2) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.MIN_SPO2)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_SPO2}-${MeasurementConstant.MAX_SPO2})';
    }
    return null;
  }

  String? validatePulse(String value) {
    if(value.isEmpty) return null;
    if (!GetUtils.isNumericOnly(value)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_PULSE}-${MeasurementConstant.MAX_PULSE})';
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.MAX_PULSE) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.MIN_PULSE)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_PULSE}-${MeasurementConstant.MAX_PULSE})';
    }
    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String getInputText() {
    String text = "${'label_spo2'.tr}: ${spo2Controller.text}%";
    if (pulseController.text.isNotEmpty) {
      text += "\n${'label_pulse'.tr}: ${pulseController.text} bpm";
    }
    return text;
  }

  void sendMeasurement() {
    if (isLoading.isTrue) return;
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    isLoading.value = true;

    var pulseMeasurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.PULSE_RATE.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          PulseAttribute.PULSE_RATE.name:
          double.parse(pulseController.value.text),
        }
    );

    repository.sendData(AppUidConfig.getPostMeasurementUrl(), (pulseMeasurement).toJson()).then((pulseMeasurementResponse) {
      if(pulseMeasurementResponse != null) {
        pulseMeasurement.result = pulseMeasurementResponse.result;
        var oxygenMeasurement = MeasurementDTO(
            userId: customer.value.userId,
            measurementTypeCodeId: MeasurementType.SpO2.value,
            measuredAt: dateController.text.isNotEmpty ? int.parse(
                dateController.text) : DateTime
                .now()
                .millisecondsSinceEpoch,
            inputs: {
              SPO2Attribute.SPO2.name: double.parse(spo2Controller.value.text),
            }
        );

        repository.sendData(AppUidConfig.getPostMeasurementUrl(), (oxygenMeasurement).toJson()).then((oxygenMeasurementResponse) {
          isLoading.value = false;
          if (oxygenMeasurementResponse != null) {
            oxygenMeasurement.result = oxygenMeasurementResponse.result;
            oxygenMeasurementResponse.inputs?.addAll({
              PulseAttribute.PULSE_RATE.name: double.parse(pulseController.value.text)
            });
            // bool isValidMeasurementSelectionDetailsLogic = Get.isRegistered<MeasurementSelectionDetailsLogic>();
            // if(isValidMeasurementSelectionDetailsLogic) {
            //   Get.find<MeasurementSelectionDetailsLogic>().updateSelectedServiceTypeMeasurementStatus([oxygenMeasurement, pulseMeasurement]);
            // }
            screeningReport.value = oxygenMeasurementResponse;
            updateMeasurementAndNavigate(oxygenMeasurement, pulseMeasurement);
          }
        });
      }
    });
  }

  updateMeasurementAndNavigate(oxygenMeasurement, pulseMeasurement){
    Get.offNamed('/screening_report_result_details', arguments: [
      ScreeningReportResultDetailsArgument(
          screeningReport: screeningReport.value, isAuto: false, measurementsWithResult: [oxygenMeasurement, pulseMeasurement]
      )
    ]);
  }

  @override
  void onClose() {
    super.onClose();
    dateController.dispose();
    spo2Controller.dispose();
    pulseController.dispose();
  }

}
