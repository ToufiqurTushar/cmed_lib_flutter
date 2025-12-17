import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';

import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';

import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import '../../../../dto/screening_report_result_details_argument.dart';
import '../../../../../user_management/repository/profile_repository.dart';


class WfaInputLogic extends BaseLogic {
  final ScreeningReportRepository repository;
  final ProfileRepository profileRepository;

  WfaInputLogic(
      {required this.repository, required this.profileRepository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController heightInFeetEditTextController;
  late TextEditingController heightInInchEditTextController;
  late TextEditingController heightInCentimeterEditTextController;
  late TextEditingController weightEditTextController;

  var heightInCentimeter = ''.obs;
  var weight = ''.obs;
  var weightUnit = GmpUnit.KG.name.obs;
  var heightUnit = GmpUnit.FEET_INCH.name.obs;

  var screeningReportWfa = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    heightInFeetEditTextController = TextEditingController();
    heightInInchEditTextController = TextEditingController();
    heightInCentimeterEditTextController = TextEditingController();
    weightEditTextController = TextEditingController();

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

  String? validateHeightInFeet(String value) {
    if (!GetUtils.isNumericOnly(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if(customer.value.getAgeInMonth() <24) {
      if (GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_FT_MAX_UNDER_24_MONTH) ||
          GetUtils.isLowerThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_FT_MIN_UNDER_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_FT_MIN_UNDER_24_MONTH}-${MeasurementConstant.HFA_HEIGHT_FT_MAX_UNDER_24_MONTH})';
      }
    } else {
      if (GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_FT_MAX_ABOVE_24_MONTH) ||
          GetUtils.isLowerThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_FT_MIN_ABOVE_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_FT_MIN_ABOVE_24_MONTH}-${MeasurementConstant.HFA_HEIGHT_FT_MAX_ABOVE_24_MONTH})';
      }
    }
    return null;
  }

  String? validateHeightInInch(String value) {
    var heightInCM = getHeightInCentimeter().toString();
    //range validate
    if(customer.value.getAgeInMonth() <24) {
      if (GetUtils.isGreaterThan(double.parse(heightInCM), MeasurementConstant.HFA_HEIGHT_CM_MAX_UNDER_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_FT_MAX_UNDER_24_MONTH}ft. ${MeasurementConstant.HFA_HEIGHT_INCH_MAX_UNDER_24_MONTH}inch)';
      }
      if (GetUtils.isLowerThan(double.parse(heightInCM), MeasurementConstant.HFA_HEIGHT_CM_MIN_UNDER_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_FT_MIN_UNDER_24_MONTH}ft. ${MeasurementConstant.HFA_HEIGHT_INCH_MIN_UNDER_24_MONTH}inch)';
      }
    } else {
      if (GetUtils.isGreaterThan(double.parse(heightInCM), MeasurementConstant.HFA_HEIGHT_CM_MAX_ABOVE_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_FT_MAX_ABOVE_24_MONTH}ft. ${MeasurementConstant.HFA_HEIGHT_INCH_MAX_ABOVE_24_MONTH}inch)';
      }
      if (GetUtils.isLowerThan(double.parse(heightInCM), MeasurementConstant.HFA_HEIGHT_CM_MIN_ABOVE_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_FT_MIN_ABOVE_24_MONTH}ft. ${MeasurementConstant.HFA_HEIGHT_INCH_MIN_ABOVE_24_MONTH}inch)';
      }
    }
    if(value.isEmpty) {
      return null;
    }
    //inch validate 0-11
    if (GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.HEIGHT_INCH_MAX) ||
        GetUtils.isLowerThan(double.parse(value), MeasurementConstant.HEIGHT_INCH_MIN)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HEIGHT_INCH_MIN}-${MeasurementConstant.HEIGHT_INCH_MAX})';
    }

    return null;
  }

  String? validateHeightInCentimeter(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if(customer.value.getAgeInMonth() <24) {
      if (GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_CM_MAX_UNDER_24_MONTH) ||
          GetUtils.isLowerThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_CM_MIN_UNDER_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_CM_MIN_UNDER_24_MONTH}-${MeasurementConstant.HFA_HEIGHT_CM_MAX_UNDER_24_MONTH})';
      }
    } else {
      if (GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_CM_MAX_ABOVE_24_MONTH) ||
          GetUtils.isLowerThan(double.parse(value), MeasurementConstant.HFA_HEIGHT_CM_MIN_ABOVE_24_MONTH)) {
        return '${'error_message_invalid_range'.tr} (${MeasurementConstant.HFA_HEIGHT_CM_MIN_ABOVE_24_MONTH}-${MeasurementConstant.HFA_HEIGHT_CM_MAX_ABOVE_24_MONTH})';
      }
    }

    return null;
  }

  String? validateWeight(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.WFA_WEIGHT_KG_MAX) ||
        GetUtils.isLowerThan(
            double.parse(value), MeasurementConstant.WFA_WEIGHT_KG_MIN)) {
      return '${'error_message_invalid_range'.tr} (${MeasurementConstant.WFA_WEIGHT_KG_MIN}-${MeasurementConstant.WFA_WEIGHT_KG_MAX})';
    }
    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String getInputText() {
    String text = "";
    String height = "";

    var heightInInch = heightInInchEditTextController.text;
    if(heightInInch.trim().isEmpty) {
      heightInInch = "0";
    }

    if (heightUnit.value == GmpUnit.FEET_INCH.name) {
      height =
          "${'label_height'.tr}: ${heightInFeetEditTextController.text}'${heightInInch}\"";
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

    var measuredAt = dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch;
    // var measurementHfa = MeasurementDTO(
    //     userId: customer.value.userId,
    //     measurementTypeCodeId: MeasurementType.HFA.value,
    //     measuredAt: measuredAt,
    //     inputs: {
    //       GmpAttribute.HFA_HEIGHT.name: getHeightInCentimeter(),
    //     }
    // );
    var measurementWfa = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.WFA.value,
        measuredAt: measuredAt,
        inputs: {
          GmpAttribute.WFA_WEIGHT.name: getWeightInKg(),
        }
    );
    // var measurementWfl = MeasurementDTO(
    //     userId: customer.value.userId,
    //     measurementTypeCodeId: MeasurementType.WFL.value,
    //     measuredAt: measuredAt,
    //     inputs: {
    //       GmpAttribute.WFL_LENGTH.name: getHeightInCentimeter().toStringAsFixed(0),
    //       GmpAttribute.WFL_WEIGHT.name: getWeightInKg(),
    //     }
    // );


    isLoading.value = true;
    repository.sendData(AppUidConfig.getPostMeasurementUrl(), (measurementWfa).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        screeningReportWfa.value = value;
        measurementWfa.result = value.result;
        updateMeasurementAndNavigate();
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    });
  }

  updateMeasurementAndNavigate(){
      Get.offNamed('/screening_report_result_details', arguments: [
        ScreeningReportResultDetailsArgument(
            screeningReport: screeningReportWfa.value,
            isAuto: false
        )
      ]);
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
    if (heightUnit.value == GmpUnit.FEET_INCH.name) {
      var value = getHeightInCentimeter();
      heightUnit.value = GmpUnit.CENTIMETER.name;
      heightInCentimeterEditTextController.text =
          value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    } else {
      heightUnit.value = GmpUnit.FEET_INCH.name;
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
    if (weightUnit.value == GmpUnit.KG.name) {
      weightUnit.value = GmpUnit.LB.name;
      if(weightEditTextController.text.isNotEmpty) {
        var value = double.parse(weightEditTextController.value.text) * 2.205;
        weightEditTextController.text =
            value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
      }
    } else {
      var value = getWeightInKg();
      weightUnit.value = GmpUnit.KG.name;
      if(weightEditTextController.text.isNotEmpty) {
        weightEditTextController.text =
            value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
      }
    }
  }

  num getHeightInCentimeter() {
    var heightInInch = heightInInchEditTextController.text;
    if(heightInInch.trim().isEmpty) {
      heightInInch = "0";
    }
    if (heightUnit.value == GmpUnit.CENTIMETER.name && heightInCentimeterEditTextController.value.text.isNotEmpty) {
      return double.parse(heightInCentimeterEditTextController.value.text);
    } else if (heightInFeetEditTextController.value.text.isNotEmpty) {
      if(heightInInch.trim().isEmpty) {
        heightInInch = "0";
      }
      return ((double.parse(heightInFeetEditTextController.value.text) * 12.0) + double.parse(heightInInch)) * 2.54;
    } else {
      return 0;
    }
  }


  num getWeightInKg() {
    if (weightEditTextController.value.text.isEmpty) return 0;

    if (weightUnit.value == GmpUnit.KG.name) {
      return double.parse(weightEditTextController.value.text);
    } else {
      return Utils.getKgFromLb(
          double.parse(weightEditTextController.value.text));
    }
  }

  double getMaxWeight() {
    if (weightUnit.value == GmpUnit.LB.name) {
      return MeasurementConstant.WEIGHT_MAX_LB;
    }
    return MeasurementConstant.WEIGHT_MAX_KG;
  }

}
