import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:logger/logger.dart';

import '../../../../repository/screening_report_repository.dart';
import 'enum/eye_screening_type_enum.dart';



class EyeScreeningHomeLogic extends BaseLogic {
  final ScreeningReportRepository repository;
  EyeScreeningHomeLogic({required this.repository});

  late TextEditingController dateLogic = TextEditingController();
  var screeningReport = MeasurementDTO().obs;
  var nearVisionBothEyeResult = EyeScreening().obs;
  var farVisionDistance1Result = EyeScreening().obs;
  var farVisionIlliterateResult = EyeScreening().obs;
  var farVisionChildrenResult = EyeScreening().obs;
  var colorBlindTestResult = EyeScreening().obs;
  var contrastTestResult = EyeScreening().obs;

  void sendMeasurement() {
    if (isLoading.isTrue) return;

    isLoading.value = true;
    List<EyeScreening> eyeScreenings = [];
    if(GetUtils.isNullOrBlank(nearVisionBothEyeResult.value.createdAt) != true) {
      eyeScreenings.add(nearVisionBothEyeResult.value);
    }
    if(GetUtils.isNullOrBlank(farVisionDistance1Result.value.createdAt) != true) {
      eyeScreenings.add(farVisionDistance1Result.value);
    }
    if(GetUtils.isNullOrBlank(farVisionIlliterateResult.value.createdAt) != true) {
      eyeScreenings.add(farVisionIlliterateResult.value);
    }
    if(GetUtils.isNullOrBlank(farVisionChildrenResult.value.createdAt) != true) {
      eyeScreenings.add(farVisionChildrenResult.value);
    }
    if(GetUtils.isNullOrBlank(colorBlindTestResult.value.createdAt) != true) {
      eyeScreenings.add(colorBlindTestResult.value);
    }
    if(GetUtils.isNullOrBlank(contrastTestResult.value.createdAt) != true) {
      eyeScreenings.add(contrastTestResult.value);
    }
    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.EYE_SCREENING.value,
        measuredAt: dateLogic.text.isNotEmpty ? int.parse(dateLogic.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          EyeScreeningAttribute.EYE_SCREENING.name: "0",
        },
        eyeScreening: eyeScreenings
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

        Get.offNamed('/screening_report_eye_details_view', arguments: [
          {
            "screeningReport": screeningReport.value, "measurementsWithResult": [measurement]
          }
        ]);
      } else {

      }
    });
  }


  bool showTestResult() {
    if(GetUtils.isNullOrBlank(nearVisionBothEyeResult.value.createdAt) != true) {
      return true;
    }
    if(GetUtils.isNullOrBlank(farVisionDistance1Result.value.createdAt) != true) {
      return true;
    }
    if(GetUtils.isNullOrBlank(farVisionIlliterateResult.value.createdAt) != true) {
      return true;
    }
    if(GetUtils.isNullOrBlank(farVisionChildrenResult.value.createdAt) != true) {
      return true;
    }
    if(GetUtils.isNullOrBlank(colorBlindTestResult.value.createdAt) != true) {
      return true;
    }
    if(GetUtils.isNullOrBlank(contrastTestResult.value.createdAt) != true) {
      return true;
    }

    return false;
  }

  bool showSaveButton() {
    if(
    GetUtils.isNullOrBlank(nearVisionBothEyeResult.value.createdAt) != true ||
        GetUtils.isNullOrBlank(farVisionDistance1Result.value.createdAt) != true ||
        GetUtils.isNullOrBlank(farVisionIlliterateResult.value.createdAt) != true ||
        GetUtils.isNullOrBlank(farVisionChildrenResult.value.createdAt) != true ||
        GetUtils.isNullOrBlank(colorBlindTestResult.value.createdAt) != true ||
        GetUtils.isNullOrBlank(contrastTestResult.value.createdAt) != true
    ) {
      return true;
    }

    return false;
  }

}