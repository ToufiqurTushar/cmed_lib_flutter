import 'dart:convert';

import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:endometriosis_lib_flutter/endometriosis/npage/screening/endometriosis_screening_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/page/health_screening/measurement_view_arg.dart';
import '../../../../../../common/api/app_http.dart';
import '../../../../../../common/dto/customer_dto.dart';
import '../../../../../../common/dto/user_profile_dto.dart';
import '../../../../../../common/helper/toast_utils.dart';
import '../../../../../user_management/repository/profile_repository.dart';
import '../../../../dto/request_bundle_measurement_dto.dart';
import '../../../../dto/screening_report_result_details_argument.dart';


class EndometriosisInputLogic extends EndometriosisScreeningLogic {
  final httpProvider = Get.find<HttpProvider>();
  final envConfig = Get.find<RapidEnvConfig>();
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var customer = CustomerDTO().obs;
  ScreeningReportRepository screningRepository = Get.find();
  EndometriosisInputLogic({
    int? userIdWhileInitLogic,
    int? birthDateWhileInitLogic,
    int? heightInFeetWhileInitLogic,
    double? heightInInchiWhileInitLogic,
    double? weightInKgWhileInitLogic,
  }) : super(
    userIdWhileInitLogic: userIdWhileInitLogic,
    birthDateWhileInitLogic: birthDateWhileInitLogic,
    heightInFeetWhileInitLogic: heightInFeetWhileInitLogic,
    heightInInchiWhileInitLogic: heightInInchiWhileInitLogic,
    weightInKgWhileInitLogic: weightInKgWhileInitLogic,
  );

  var screeningReport = MeasurementDTO().obs;

  bool isNestedRoute = false;
  bool isThemeV2 = false;

  @override
  void onInit() {
    super.onInit();
    if(globalState.currentUser.value is CustomerDTO) {
      customer.value = globalState.currentUser.value as CustomerDTO;
    } else if(globalState.currentUser.value is UserProfile) {
      customer.value = (globalState.currentUser.value as UserProfile).toCustomer();
    }
    if (customer.value.userId != null) {
      userId = customer.value.userId!;
    }
    if (customer.value.birthDate != null) {
      birthDate = customer.value.birthDate!;
    }
    print("Get.arguments: ${Get.arguments}");
    isNestedRoute = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isNestedRoute??false : false;
    isThemeV2 = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isThemeV2??false : false;
  }

  @override
  postAnswer(List<dynamic> answers, double height, double weightInKg){
    print("override:postAnswer");
    if (isLoading.isTrue) return;
    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.ENDOMETRIOSIS.value,
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        inputs: {
          //EndometriosisAttribute.ENDOMETRIOSIS.name: 0,
        },
        endometriosis: EndometriosisInput.listFromJson(answers)
    );

    var json = measurement.toJson().toString();
    debugPrint(json);

    bool useBundleMeasuementApi = false;
    bool useMeasuementApi = false;
    String url = ApiUrl.addMeasurementUrl();
    var requestMeasurementData = measurement.toJson();
    if(AppUidConfig.isCmedUserApp || AppUidConfig.isI4WeMemberApp) {
      useBundleMeasuementApi = true;
      url = AppUidConfig.getMeasurementBundleUrl();
      requestMeasurementData = RequestBundleMeasurementDto(
          userId: customer.value.userId,
          bundlesMeasurements: [measurement]
      ).toJson();
    } else if(AppUidConfig.isCmedAgentApp || AppUidConfig.isI4WeAgentApp) {
      useMeasuementApi = true;
      url = ApiUrl.previewMeasurementUrl();
      requestMeasurementData = measurement.toJson();
    }

    isLoading.value = true;
    httpProvider.POST(url, requestMeasurementData).then((response) {
      isLoading.value = false;
      if(response.isOk) {
        if(useBundleMeasuementApi) {
          final value = RequestBundleMeasurementDto.fromJson(response.body);
          measurement.result = value.bundlesMeasurements?.first.result;
          measurement.inputsWithUnit = value.bundlesMeasurements?.first.inputsWithUnit;
          screeningReport.value = value.bundlesMeasurements!.first;
        } else {
          final value = MeasurementDTO.fromJson(response.body);
          measurement.result = value.result;
          measurement.inputsWithUnit = value.inputsWithUnit;
          screeningReport.value = value;
        }
        updateSelectedCustomerData(measurement, height, weightInKg);
      } else {
        ShowToast.error(response.body.toString());
      }
    });
  }


  updateSelectedCustomerData(MeasurementDTO measurement, double height, double weightInKg) {
    globalState.showBusy();
    isLoading.value = true;
    customer.value.heightCentimeter = height;
    customer.value.weight = weightInKg;
    Get.find<ProfileRepository>().patchSelectedCustomerProfile(
        userId:customer.value.userId!,
        height:height,
        weight:weightInKg,
    ).then((UserProfile? value) {
      isLoading.value = false;
      globalState.hideBusy();
      updateMeasurementAndNavigate(measurement);
    });
  }

  updateMeasurementAndNavigate(MeasurementDTO measurement){
    //update profile
    Get.offNamed('/screening_report_result_details', arguments: [
      ScreeningReportResultDetailsArgument(
          screeningReport: screeningReport.value, isAuto: false, measurementsWithResult: [measurement]
      )
    ], id: isNestedRoute? 1: null);
  }

  @override
  void onClose() {
    super.onClose();
  }

}

