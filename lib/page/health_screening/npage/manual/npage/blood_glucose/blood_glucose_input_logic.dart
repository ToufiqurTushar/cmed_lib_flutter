import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/common/base/base_logic.dart';

import '../../../../dto/screening_report_result_details_argument.dart';

class BloodGlucoseInputLogic extends BaseLogic {
  dynamic argumentData = Get.arguments;
  final ScreeningReportRepository repository;

  var tag = MasterDataDTO().obs;

  BloodGlucoseInputLogic({required this.repository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController bloodGlucoseEditTextController;

  var screeningReport = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    bloodGlucoseEditTextController = TextEditingController();
    tag.value = (argumentData[0][MeasurementConstant.GLUCOSE_TIME_PERIOD] as MasterDataDTO);
    debugPrint(tag.value.toString());
  }

  String? validateGlucoseInput(String value) {
    if (!GetUtils.isNum(value)) {
      return 'error_message_invalid_range'.tr;
    }
    if (GetUtils.isGreaterThan(double.parse(value), getMaxGlucoseValue()) ||
        GetUtils.isLowerThan(double.parse(value), getMinGlucoseValue())) {
      return '${'error_message_invalid_range'.tr} (${getMinGlucoseValue()}-${getMaxGlucoseValue()})';
    }
    return null;
  }

  bool isValidInput() {
    return screeningReportFormKey.currentState!.validate();
  }

  String getInputText() {
    return "${'label_time_period'.tr}: ${Utils.isLocaleBn() ? tag.value.labelBn : tag.value.labelEn} \n${'label_blood_glucose'.tr}: ${bloodGlucoseEditTextController.text} ${AppUidConfig.getGlucoseLabelHint('input_hint_glucose'.tr)}";
  }


  void sendMeasurement() {
    if (isLoading.isTrue) return;
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BLOOD_SUGAR.value,
        tag: getMeasurementTag(),
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          BloodGlucoseAttribute.SUGAR.name:
              double.parse(bloodGlucoseEditTextController.value.text),
        });

    var json = measurement.toJson().toString();
    debugPrint(json);

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
    bloodGlucoseEditTextController.dispose();
  }

  num getMaxGlucoseValue() {
    if (tag.value.id == GlucoseTag.OGTT.tagId) {
      return MeasurementConstant.MAX_GLUCOSE_OGTT;
    } else {
      return MeasurementConstant.MAX_GLUCOSE;
    }
  }

  num getMinGlucoseValue() {
    if (tag.value.id == GlucoseTag.OGTT.tagId) {
      return MeasurementConstant.MIN_GLUCOSE_OGTT;
    } else {
      return MeasurementConstant.MIN_GLUCOSE;
    }
  }

  String getMeasurementTag() {
    if (tag.value.id == GlucoseTag.OGTT.tagId) {
      return GlucoseTag.OGTT.name;
    } else if (tag.value.id == GlucoseTag.FASTING.tagId) {
      return GlucoseTag.FASTING.name;
    } else if (tag.value.id == GlucoseTag.RANDOM.tagId) {
      return GlucoseTag.RANDOM.name;
    } else if (tag.value.id == GlucoseTag.TWO_HR_AFB.tagId) {
      return GlucoseTag.TWO_HR_AFB.name;
    } else {
      return GlucoseTag.RANDOM.name;
    }
  }
}
