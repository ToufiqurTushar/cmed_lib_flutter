import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:logger/logger.dart';

import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';

import '../../../../dto/screening_report_result_details_argument.dart';


class HemoglobinInputLogic extends BaseLogic {
  final ScreeningReportRepository repository;

  HemoglobinInputLogic({required this.repository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController hemoglobinController;

  var screeningReport = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    hemoglobinController = TextEditingController();
  }


  String? validateHemoglobin(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.MAX_HEMOGLOBIN) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.MIN_HEMOGLOBIN)) {
      return "${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_HEMOGLOBIN}-${MeasurementConstant.MAX_HEMOGLOBIN})";
    }

    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String getInputText() {
    return "${'Hemoglobin'.tr}: ${hemoglobinController.text}";
  }

  void sendMeasurement() {
    if (isLoading.isTrue) return;
    
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.HEMOGLOBIN.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          HemoglobinAttribute.HEMOGLOBIN_LEVEL.name: double.parse(hemoglobinController.value.text),
        }
    );

    repository.sendData(AppUidConfig.getPostMeasurementUrl(), (measurement).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        measurement.result = value.result;
        screeningReport.value = value;
        updateMeasurementAndNavigate(measurement);
      }
    });
  }

  updateMeasurementAndNavigate(measurement){
    Get.offNamed('/screening_report_result_details', arguments: [
      ScreeningReportResultDetailsArgument(
          screeningReport: screeningReport.value, isAuto: false, measurementsWithResult: [measurement]
      )
    ]);
  }

  @override
  void onClose() {
    super.onClose();
    dateController.dispose();
    hemoglobinController.dispose();
  }


}
