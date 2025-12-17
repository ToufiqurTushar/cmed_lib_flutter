import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../dto/screening_report_result_details_argument.dart';

class TempInputLogic extends BaseLogic {
  final ScreeningReportRepository repository;

  TempInputLogic({required this.repository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController temperatureEditTextController;

  var temperatureUnit = TemperatureUnit.FAHRENHEIT.name.obs;

  var screeningReport = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    temperatureEditTextController = TextEditingController();
  }

  String? validateTemperatureInput(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(
            double.parse(value),
            temperatureUnit.value == TemperatureUnit.FAHRENHEIT.name
                ? MeasurementConstant.MAX_TEMPERATURE_F
                : MeasurementConstant.MAX_TEMPERATURE_C) ||
        GetUtils.isLowerThan(
            double.parse(value),
            temperatureUnit.value == TemperatureUnit.FAHRENHEIT.name
                ? MeasurementConstant.MIN_TEMPERATURE_F
                : MeasurementConstant.MIN_TEMPERATURE_C)) {
      return '${'error_message_invalid_range'.tr} (${temperatureUnit.value == TemperatureUnit.FAHRENHEIT.name
          ? MeasurementConstant.MIN_TEMPERATURE_F: MeasurementConstant.MIN_TEMPERATURE_C}-${temperatureUnit.value == TemperatureUnit.FAHRENHEIT.name ? MeasurementConstant.MAX_TEMPERATURE_F : MeasurementConstant.MAX_TEMPERATURE_C})';
    }
    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String getInputText() {
    String text = "${'label_body_temp'.tr}: ${temperatureEditTextController.text}";
    if(temperatureUnit.value == TemperatureUnit.FAHRENHEIT.name) {
      return "$text°F";
    } else {
      return "$text°C";
    }
  }

  void sendMeasurement() {
    if (isLoading.isTrue) return;
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.TEMP.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          TemperatureAttribute.TEMP.name: double.parse(temperatureUnit.value ==
                  TemperatureUnit.FAHRENHEIT.name
              ? temperatureEditTextController.text
              : getTemperatureInFahrenheit(temperatureEditTextController.text)),
        });


    repository.sendData(ApiUrl.previewMeasurementUrl(), (measurement).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        measurement.result = value.result;
        // bool isValidMeasurementSelectionDetailsLogic = Get.isRegistered<MeasurementSelectionDetailsLogic>();
        // if(isValidMeasurementSelectionDetailsLogic) {
        //   Get.find<MeasurementSelectionDetailsLogic>().updateSelectedServiceTypeMeasurementStatus([measurement]);
        // }
        screeningReport.value = value;
        Get.offNamed('/screening_report_result_details', arguments: [
          ScreeningReportResultDetailsArgument(
              screeningReport: screeningReport.value, isAuto: false, measurementsWithResult: [measurement]
          )
        ]);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    dateController.dispose();
    temperatureEditTextController.dispose();
  }

  toggleTemperatureUnit() {
    if (temperatureUnit.value == TemperatureUnit.FAHRENHEIT.name) {
      temperatureUnit.value = TemperatureUnit.CELSIUS.name;
      var value =
          ((double.parse(temperatureEditTextController.value.text) - 32) * 5) /
              9;
      temperatureEditTextController.text =
          value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    } else {
      temperatureUnit.value = TemperatureUnit.FAHRENHEIT.name;
      temperatureEditTextController.text =
          getTemperatureInFahrenheit(temperatureEditTextController.text);
    }
    debugPrint(temperatureEditTextController.text.toString());
  }

  String getTemperatureInFahrenheit(String text) {
    var value =
        ((double.parse(temperatureEditTextController.value.text) * 9) / 5) + 32;
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }

}
