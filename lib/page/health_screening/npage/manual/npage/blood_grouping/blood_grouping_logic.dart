import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/screening_report_result_details_argument.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'enum/blood_grpup_enum.dart';

class BloodGroupingLogic extends BaseLogic {
  final ScreeningReportRepository repository;

  BloodGroupingLogic({required this.repository});

  RxString antigenAValue = "No Agglutination".obs;
  RxString antigenBValue = "No Agglutination".obs;
  RxString antigenDValue = "No Agglutination".obs;
  late TextEditingController dateController = TextEditingController();

  var screeningReport = MeasurementDTO().obs;

  @override
  void onInit() {
    super.onInit();
  }

  void updateValue(String label, String newValue) {
    switch (label) {
      case "Antigen A":
        antigenAValue.value = newValue;
        break;
      case "Antigen B":
        antigenBValue.value = newValue;
        break;
      case "Antigen D":
        antigenDValue.value = newValue;
        break;
    }
  }


  void sendMeasurement() {
    if (isLoading.isTrue) return;

    // final isValid = screeningReportFormKey.currentState!.validate();
    // if (!isValid) return;
    // screeningReportFormKey.currentState!.save();

    isLoading.value = true;

    var groupingResult = BloodGroupEnum.findBloodGroup(antigenAValue.value != "No Agglutination", antigenBValue.value != "No Agglutination", antigenDValue.value != "No Agglutination");

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BLOOD_GROUPING.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: {
          BloodGroupingAttribute.BLOOD_GROUPING.name: "4.0",
        },
        result: ResultDTO(
          colorCode: groupingResult.colorCode,
          value: groupingResult.id.toDouble(),
          status: groupingResult.nameEn,
          statusBn: groupingResult.nameBn,
          severity: "N/A",
        )
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

}

