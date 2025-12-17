import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import '../../../../dto/screening_report_result_details_argument.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import '../../../../../user_management/repository/profile_repository.dart';

class BmiHeightWeightInputLogic extends BaseLogic {
  final ScreeningReportRepository repository;
  final ProfileRepository profileRepository;

  BmiHeightWeightInputLogic({required this.repository, required this.profileRepository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController heightInFeetEditTextController;
  late TextEditingController heightInInchEditTextController;
  late TextEditingController heightInCentimeterEditTextController;
  late TextEditingController weightEditTextController;

  var heightInCentimeter = ''.obs;
  var weight = ''.obs;
  var weightUnit = BmiUnit.KG.name.obs;
  var heightUnit = BmiUnit.FEET_INCH.name.obs;


  var screeningReport = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    heightUnit.value = Get.arguments[0]['heightUnit'];
    heightInCentimeterEditTextController = TextEditingController(text: Get.arguments[0]['heightInCm'].toString());
    heightInFeetEditTextController = TextEditingController(text: Get.arguments[0]['heightInFeet']);
    heightInInchEditTextController = TextEditingController(text: Get.arguments[0]['heightInInch']);
    weightEditTextController = TextEditingController();
    RLog.error(Get.arguments[0]);
  }

  String? validateHeightInFeet(String value) {
    if (!GetUtils.isNumericOnly(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.HEIGHT_FEET_MAX) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.HEIGHT_FEET_MIN)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HEIGHT_FEET_MIN}-${MeasurementConstant.HEIGHT_FEET_MAX})';
    }
    if(getHeightInCentimeter() < MeasurementConstant.BMI_HEIGHT_CENTIMETER_MIN || getHeightInCentimeter() > MeasurementConstant.HEIGHT_CENTIMETER_MAX) {
      return 'error_message_invalid_range'.tr;
    }
    return null;
  }

  String? validateHeightInInch(String value) {
    if(value.isEmpty) {
      return null;
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.HEIGHT_INCH_MAX) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.HEIGHT_INCH_MIN)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HEIGHT_INCH_MIN}-${MeasurementConstant.HEIGHT_INCH_MAX})';
    }
    if(getHeightInCentimeter() < MeasurementConstant.BMI_HEIGHT_CENTIMETER_MIN || getHeightInCentimeter() > MeasurementConstant.HEIGHT_CENTIMETER_MAX) {
      return 'error_message_invalid_range'.tr;
    }
    return null;
  }

  String? validateHeightInCentimeter(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.HEIGHT_CENTIMETER_MAX) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.BMI_HEIGHT_CENTIMETER_MIN)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.BMI_HEIGHT_CENTIMETER_MIN}-${MeasurementConstant.HEIGHT_CENTIMETER_MAX})';
    }

    return null;
  }

  String? validateWeight(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(double.parse(value), getMaxWeight()) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.WEIGHT_MIN)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.WEIGHT_MIN}-${getMaxWeight()})';
    }
    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String getInputText() {
    String text = "";
    String height = "";

    if(heightInInchEditTextController.text.isEmpty) {
      heightInInchEditTextController.text = "0";
    }
    if (heightUnit.value == BmiUnit.FEET_INCH.name) {
      height =
          "${'label_height'.tr}: ${heightInFeetEditTextController.text}'${heightInInchEditTextController.text}\"";
    } else {
      height =
          "${'label_height'.tr}: ${heightInCentimeterEditTextController.text} ${'hint_input_height_cm'.tr}";
    }

    text =
        "$height \n${'label_weight'.tr}: ${weightEditTextController.text} ${weightUnit.value}";

    return text;
  }

  void sendMeasurement() {
    if (isLoading.isTrue) return;
    
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BMI.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          BmiAttribute.HEIGHT.name: getHeightInCentimeter(),
          BmiAttribute.WEIGHT.name: getWeightInKg(),
        });
    isLoading.value = true;
    repository.sendData(ApiUrl.previewMeasurementUrl(), (measurement).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        measurement.result = value.result;
        // bool isValidMeasurementSelectionDetailsLogic = Get.isRegistered<MeasurementSelectionDetailsLogic>();
        // if(isValidMeasurementSelectionDetailsLogic) {
        //   Get.find<MeasurementSelectionDetailsLogic>().updateSelectedServiceTypeMeasurementStatus([measurement]);
        // }
        screeningReport.value = value;
        updateSelectedCustomerHeight([measurement]);
      }
    });
  }

  updateSelectedCustomerHeight(List<MeasurementDTO> measurementsWithResult) {
    isLoading.value = true;
    customer.value.heightCentimeter = getHeightInCentimeter() as double?;
    profileRepository.updateSelectedCustomerHeight(customer.value).then((CustomerDTO? value) => {
      isLoading.value = false,
       Get.offNamed('/screening_report_result_details', arguments: [
          ScreeningReportResultDetailsArgument(
            screeningReport: screeningReport.value, isAuto: false, measurementsWithResult: measurementsWithResult
          )
        ]),
    });
  }


  @override
  void onClose() {
    super.onClose();
    dateController.dispose();
    heightInFeetEditTextController.dispose();
    heightInInchEditTextController.dispose();
    heightInCentimeterEditTextController.dispose();
    weightEditTextController.dispose();
  }

  toggleHeightUnit() {
    if (heightUnit.value == BmiUnit.FEET_INCH.name) {
      var value = getHeightInCentimeter();
      heightUnit.value = BmiUnit.CENTIMETER.name;
      heightInCentimeterEditTextController.text =
          value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    } else {
      heightUnit.value = BmiUnit.FEET_INCH.name;
      var feet = Utils.getFeetFromCentimeter(
          double.parse(heightInCentimeterEditTextController.value.text));
      heightInFeetEditTextController.text =
          feet.toStringAsFixed(feet.truncateToDouble() == feet ? 0 : 0);

      var inch = Utils.getInchFromCentimeter(
          double.parse(heightInCentimeterEditTextController.value.text));
      heightInInchEditTextController.text = inch
          .toStringAsFixed(inch.truncateToDouble() == inch ? 0 : 2)
          .replaceAll(".00", "");
    }
  }

  toggleWeightUnit() {
    if (weightUnit.value == BmiUnit.KG.name) {
      weightUnit.value = BmiUnit.LB.name;
      if(weightEditTextController.text.isNotEmpty) {
        var value = double.parse(weightEditTextController.value.text) * 2.205;
        weightEditTextController.text =
            value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
      }
    } else {
      var value = getWeightInKg();
      weightUnit.value = BmiUnit.KG.name;
      if(weightEditTextController.text.isNotEmpty) {
        weightEditTextController.text =
            value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
      }
    }
  }

  num getHeightInCentimeter() {
    if (heightUnit.value == BmiUnit.CENTIMETER.name &&
        heightInCentimeterEditTextController.value.text.isNotEmpty) {
      return double.parse(heightInCentimeterEditTextController.value.text);
    } else if (heightInFeetEditTextController.value.text.isNotEmpty) {
      if(heightInInchEditTextController.value.text.isEmpty) {
        heightInInchEditTextController.text = "0";
      }
      return ((double.parse(heightInFeetEditTextController.value.text) * 12.0) +
              double.parse(heightInInchEditTextController.value.text)) *
          2.54;
    } else {
      return 0;
    }
  }

  num getWeightInKg() {
    if (weightEditTextController.value.text.isEmpty) return 0;

    if (weightUnit.value == BmiUnit.KG.name) {
      return double.parse(weightEditTextController.value.text);
    } else {
      return Utils.getKgFromLb(
          double.parse(weightEditTextController.value.text));
    }
  }

  double getMaxWeight() {
    if (weightUnit.value == BmiUnit.LB.name) {
      return MeasurementConstant.WEIGHT_MAX_LB;
    }
    return MeasurementConstant.WEIGHT_MAX_KG;
  }

}
