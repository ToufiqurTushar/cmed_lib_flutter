import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../dto/screening_report_result_details_argument.dart';

class BpInputLogic extends BaseLogic {
  final ScreeningReportRepository repository;

  BpInputLogic({required this.repository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController systolicController;
  late TextEditingController diastolicController;
  late TextEditingController pulseController;

  var screeningReport = MeasurementDTO().obs;



  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    systolicController = TextEditingController();
    diastolicController = TextEditingController();
    pulseController = TextEditingController();
  }

  String? validateSystolic(String value) {
    if (!value.isNum){
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_SYSTOLIC}-${MeasurementConstant.MAX_SYSTOLIC})';
    }
    if (GetUtils.isGreaterThan(
            double.parse(value), MeasurementConstant.MAX_SYSTOLIC) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.MIN_SYSTOLIC)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_SYSTOLIC}-${MeasurementConstant.MAX_SYSTOLIC})';
    }
    if (diastolicController.value.text.isBlank == false && GetUtils.isNum(diastolicController.value.text) &&
        (GetUtils.isEqual(double.parse(value),
                double.parse(diastolicController.value.text)) ||
            GetUtils.isLowerThan(double.parse(value),
                double.parse(diastolicController.value.text)))) {
      return 'error_systolic_is_equal_or_less_than_diastolic'.tr;
    }
    return null;
  }

  String? validateDiastolic(String value) {
    if (!value.isNum){
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_DIASTOLIC}-${MeasurementConstant.MAX_DIASTOLIC})';
    }
    if (GetUtils.isGreaterThan(
            double.parse(value), MeasurementConstant.MAX_DIASTOLIC) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.MIN_DIASTOLIC)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_DIASTOLIC}-${MeasurementConstant.MAX_DIASTOLIC})';
    }
    if (systolicController.value.text.isBlank == false && GetUtils.isNum(systolicController.value.text) &&
        (GetUtils.isEqual(double.parse(value),
                double.parse(systolicController.value.text)) ||
            GetUtils.isGreaterThan(double.parse(value),
                double.parse(systolicController.value.text)))) {
      return 'error_diastolic_is_equal_or_greater_than_systolic'.tr;
    }
    return null;
  }

  String? validatePulse(String value) {
    if (value.isEmpty) return null;
    if (!GetUtils.isNumericOnly(value)) {
      return 'error_message_invalid_range'.tr;
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
    String text =
        "${'label_systolic'.tr}: ${systolicController.text} ${'input_hint_systolic_bp'.tr} \n${'label_diastolic'.tr}: ${diastolicController.text} ${'input_hint_systolic_bp'.tr}";

    if (pulseController.text.isNotEmpty) {
      text += "\n${'label_pulse'.tr}: ${pulseController.text} bpm";
    }

    return text;
  }

  void sendBpAndPulseMeasurement() {

    if (isLoading.isTrue) return;
    
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    isLoading.value = true;


    var BPMeasurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BP.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          BPAttribute.SYSTOLIC.name:
              double.parse(systolicController.value.text),
          BPAttribute.DIASTOLIC.name:
              double.parse(diastolicController.value.text),
        }
    );
    var allMeasurements = [BPMeasurement];

    var pulseMeasurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.PULSE_RATE.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {}
    );

    if (pulseController.value.text.isNotEmpty) {
      pulseMeasurement.inputs!.addAll({
        PulseAttribute.PULSE_RATE.name: double.parse(pulseController.value.text)
      });
      allMeasurements = [BPMeasurement, pulseMeasurement];
    }

    isLoading.value = true;
    repository.sendData(ApiUrl.previewMeasurementUrl(), (BPMeasurement).toJson()).then((bpMeasurementWithResult) {
      isLoading.value = false;
      if (bpMeasurementWithResult != null) {
        screeningReport.value = bpMeasurementWithResult;
        allMeasurements[0].result = bpMeasurementWithResult.result;
        if (pulseController.value.text.isNotEmpty) {
          isLoading.value = true;
          repository.sendData(ApiUrl.previewMeasurementUrl(), (pulseMeasurement).toJson()).then((pulseMeasurementWithResult) {
            isLoading.value = false;
            allMeasurements[1].result = pulseMeasurementWithResult!.result;
            screeningReport.value.inputs!.addAll({
              BPAttribute.PULSE.name: double.parse(pulseController.value.text)
            });
            updateMeasurementAndNavigate(allMeasurements);
          });
        } else {
          updateMeasurementAndNavigate(allMeasurements);
        }
      }
    });
  }

  updateMeasurementAndNavigate(List<MeasurementDTO> allMeasurements) {
    // bool isValidMeasurementSelectionDetailsLogic = Get.isRegistered<MeasurementSelectionDetailsLogic>();
    // if(isValidMeasurementSelectionDetailsLogic) {
    //   Get.find<MeasurementSelectionDetailsLogic>().updateSelectedServiceTypeMeasurementStatus(allMeasurements);
    // }
    Get.offNamed('/screening_report_result_details', arguments: [
      ScreeningReportResultDetailsArgument(
          screeningReport: screeningReport.value, isAuto: false, measurementsWithResult: allMeasurements
      )
    ]);
  }

  @override
  void onClose() {
    super.onClose();
    dateController.dispose();
    systolicController.dispose();
    diastolicController.dispose();
    pulseController.dispose();
  }
}
