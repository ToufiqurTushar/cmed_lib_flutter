import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:logger/logger.dart';

import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';

import '../../../../dto/screening_report_result_details_argument.dart';


class MuacInputLogic extends BaseLogic {
  final ScreeningReportRepository repository;

  MuacInputLogic({required this.repository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController muacController;
  var muacUnit = MuacUnit.CENTIMETER.name.obs;

  var screeningReport = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    muacController = TextEditingController();
  }

  toggleMuacUnit() {
    if (muacUnit.value == MuacUnit.INCH.name) {
      if(muacController.value.text.isNotEmpty) {
        var cm = Utils.getCentimeterFromInch(double.parse(muacController.value.text));
        muacController.text = cm.toStringAsFixed(cm.truncateToDouble() == cm ? 0 : 2).replaceAll(".00", "");
      }
      muacUnit.value = MuacUnit.CENTIMETER.name;
    } else {
      if(muacController.value.text.isNotEmpty) {
        var inch = Utils.getInchFromCentimeter(double.parse(muacController.value.text));
        muacController.text = inch.toStringAsFixed(inch.truncateToDouble() == inch ? 0 : 2).replaceAll(".00", "");
      }
      muacUnit.value = MuacUnit.INCH.name;
    }
  }
  String? validateMuac(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (muacUnit.value == MuacUnit.INCH.name) {
      if (GetUtils.isGreaterThan(
          double.parse(value), MeasurementConstant.MAX_MUAC_INCH) ||
          GetUtils.isLowerThan(
              double.parse(value), MeasurementConstant.MIN_MUAC)) {
        return "${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_MUAC}-${MeasurementConstant.MAX_MUAC_INCH})";
      }
    } else {
      if (GetUtils.isGreaterThan(
          double.parse(value), MeasurementConstant.MAX_MUAC_CM) ||
          GetUtils.isLowerThan(
              double.parse(value), MeasurementConstant.MIN_MUAC)) {
        return "${'error_message_invalid_range'.tr} (${MeasurementConstant.MIN_MUAC}-${MeasurementConstant.MAX_MUAC_CM})";
      }
    }

    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String getInputText() {
    return "${'label_muac'
        ''.tr}: ${muacController.text} ${(muacUnit.value == MuacUnit.INCH.name) ? "inch" : "cm"}";
  }

  void sendMeasurement() {
    if (isLoading.isTrue) return;
    
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.MUAC.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          MuacAttribute.MUAC.name: muacUnit.value == MuacUnit.INCH.name ? Utils.getCentimeterFromInch(double.parse(muacController.value.text)) : double.parse(muacController.value.text),
        }
    );

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
    muacController.dispose();
  }


}
