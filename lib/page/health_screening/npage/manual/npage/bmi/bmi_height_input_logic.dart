import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:flutter_rapid/flutter_rapid.dart';


class BmiHeightInputLogic extends BaseLogic {
  late TextEditingController heightInFeetEditTextController;
  late TextEditingController heightInInchEditTextController;
  late TextEditingController heightInCentimeterEditTextController;
  var weightUnit = BmiUnit.KG.name.obs;
  var heightUnit = BmiUnit.FEET_INCH.name.obs;
  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    heightInFeetEditTextController = TextEditingController();
    heightInInchEditTextController = TextEditingController();
    heightInCentimeterEditTextController = TextEditingController();

    initUserProfile();
  }

  initUserProfile() {
    if (customer.value.heightCentimeter != null && customer.value.heightCentimeter! >= 1.0) {
      heightInFeetEditTextController.text =
          Utils.getFeetFromCentimeter(customer.value.heightCentimeter).toString();
      heightInInchEditTextController.text =
          Utils.getInchFromCentimeter(customer.value.heightCentimeter)
              .toStringAsFixed(1)
              .toString();
      heightInCentimeterEditTextController.text =
          customer.value.heightCentimeter.toString();
    }
  }

  num getHeightInCentimeter() {
    if (heightUnit.value == BmiUnit.CENTIMETER.name &&
        heightInCentimeterEditTextController.value.text.isNotEmpty) {
      return double.parse(heightInCentimeterEditTextController.value.text);
    } else if (heightInFeetEditTextController.value.text.isNotEmpty) {
      return ((double.parse(heightInFeetEditTextController.value.text) * 12.0) +
              double.parse(heightInInchEditTextController.value.text)) *
          2.54;
    } else {
      return 0;
    }
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

  String? validateHeightInCentimeter(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.HEIGHT_CENTIMETER_MAX) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.BMI_HEIGHT_CENTIMETER_MIN)) {
      return 'error_message_invalid_range'.tr;
    }
    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String? validateHeightInFeet(String value) {
    if (!GetUtils.isNumericOnly(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.HEIGHT_FEET_MAX) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.HEIGHT_FEET_MIN)) {
      return 'error_message_invalid_range'.tr;
    }
    if(getHeightInCentimeter() < MeasurementConstant.BMI_HEIGHT_CENTIMETER_MIN || getHeightInCentimeter() > MeasurementConstant.HEIGHT_CENTIMETER_MAX) {
      return 'error_message_invalid_range'.tr;
    }
    return null;
  }

  String? validateHeightInInch(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(
        double.parse(value), MeasurementConstant.HEIGHT_INCH_MAX) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.HEIGHT_INCH_MIN)) {
      return 'error_message_invalid_range'.tr;
    }
    if(getHeightInCentimeter() < MeasurementConstant.BMI_HEIGHT_CENTIMETER_MIN || getHeightInCentimeter() > MeasurementConstant.HEIGHT_CENTIMETER_MAX) {
      return 'error_message_invalid_range'.tr;
    }
    return null;
  }
}
