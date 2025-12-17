import 'dart:convert';

import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmed_ecg_devices_lib/cmed_ecg_devices_lib.dart';
import 'package:cmed_ecg_devices_lib/ecg_graph_view.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:cmed_ecg_devices_lib/cmed_user.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import '../../enum/screen_enum.dart';

class EcgDeviceConnectionLogic extends BaseLogic {
  final _cmedEcgDevicesLib = CmedEcgDevicesLib();
  var status = <String>[].obs;
  var ecgDeviceEvent = "".obs;
  final RxString reading = "".obs;
  final RxString progress = "0".obs;
  var isResultFound = false.obs;
  var ecgResult = ECG().obs;
  var screeningReport = MeasurementDTO().obs;

  late ECGGraphViewController ecgGraphViewController;

  final RxString screen_status = ScreenEnum.CONNECT.name.obs;

  final RxString buttonText = 'label_connect'.tr.obs;

  final ScreeningReportRepository repository;
  CMEDUser userData = CMEDUser();

  EcgDeviceConnectionLogic({required this.repository});

  @override
  void onInit() {
    super.onInit();
    userData = CMEDUser(
        id: customer.value.userId,
        gender: customer.value.getGenderString(),
        ageInYear: customer.value.getAgeInYear(),
        birthDate: customer.value.birthDate,
        heightInCm: 0.0,
        weightInKg: 0.0,
        name:customer.value.getFullName(),
        number:customer.value.contactNumber.toString(),
        language: Utils.tr("en", bn: "bn"),
        measurementTypeCodeId: MeasurementType.ECG.value
    );

    launchThirdPartyApp();
  }

  launchThirdPartyApp() async {
    _cmedEcgDevicesLib.getStatus().listen((event) {
      debugPrint("ecg_event -> $event");
      ecgDeviceEvent.value = event.toString();
      reading.value = event;
      if (event.contains("IK_ECG_GRAPH_DATA")) {
        var data = event.split("IK_ECG_GRAPH_DATA:")[1];
        debugPrint(data);
        isResultFound.value = true;
        screen_status.value = ScreenEnum.RESULT_FOUND.name;
        ecgResult.value = ECG.fromJson(jsonDecode(data));
        RLog.info(ecgResult.value.toJson());
      }
    });

    isResultFound.value = false;
    screen_status.value = ScreenEnum.CONNECTING.name;
    final result = await _cmedEcgDevicesLib.launchThirdPartyApp(userData);
    if(result) {
      screen_status.value = ScreenEnum.CONNECT.name;
    } else {
      screen_status.value = ScreenEnum.CONNECT.name;
      ShowToast.error('SuSastho IoT App not Found'.tr, isLongLength: true);
    }
  }

  Future<void> connect() async {
    _cmedEcgDevicesLib.setUser(userData);
    if (screen_status.value == ScreenEnum.CONNECTING.name) return;

    launchThirdPartyApp();

    return;

    // isResultFound.value = false;
    // screen_status.value = ScreenEnum.SEARCHING.name;
    // buttonText.value = 'label_searching'.tr;
    //
    // _cmedEcgDevicesLib.getStatus().listen((event) {
    //   debugPrint("ecg_event -> $event");
    //   status.value = event.toString().split(":");
    //   if (status[0] == "IK_ECG_CONNECTING") {
    //     screen_status.value = ScreenEnum.CONNECTING.name;
    //     buttonText.value = 'label_connecting'.tr;
    //   } else if (status[0] == "IK_ECG_CONNECTED") {
    //     screen_status.value = ScreenEnum.CONNECTED.name;
    //     isLoading.value = true;
    //     final player = AudioPlayer();
    //     player.play(AssetSource('audio/device_connected.mp3'));
    //   } else if (status[0] == "IK_ECG_DISCONNECTED" &&
    //       (ecgResult.value.ecgsymps?.isEmpty ?? true)) {
    //     screen_status.value = ScreenEnum.DISCONNECTED.name;
    //     isResultFound.value = false;
    //     buttonText.value = 'label_connect'.tr;
    //     if(isLoading.isTrue) {
    //       isLoading.value = false;
    //     }
    //   } else if (status[0] == "IK_ECG_PULSE_DATA") {
    //     if(isLoading.isTrue) {
    //       isLoading.value = false;
    //     }
    //     reading.value = status[1];
    //   } else if (status[0] == "IK_ECG_PROGRESS_DATA") {
    //     progress.value = status[1];
    //   } else if (status[0] == "IK_ECG_MEASUREMENT_DATA") {
    //     ecgResult.value = ECG.fromJson(jsonDecode(
    //         event.toString().replaceAll("IK_ECG_MEASUREMENT_DATA:", "")));
    //     isResultFound.value = true;
    //     screen_status.value = ScreenEnum.RESULT_FOUND.name;
    //   }  else if (status[0] == "ECG_CONNECTION_ERROR") {
    //     ShowToast.error('label_bluetooth_error'.tr);
    //     screen_status.value = ScreenEnum.CONNECT.name;
    //     buttonText.value = 'label_connect'.tr;
    //   } else {
    //     // screen_status.value = ScreenEnum.ERROR.name;
    //   }
    // });
    //
    // await _cmedEcgDevicesLib.connect();
  }

  String getInputText() {
    return "${'Result'.tr}: ${Utils.tr((ecgResult.value.ecgsymps?[0].name??""), bn:(ecgResult.value.ecgsymps?[0].sympNameBn??""))}";
  }

  disconnect() {
    isLoading.value = false;
    _cmedEcgDevicesLib.disconnect();
    screen_status.value = ScreenEnum.DISCONNECTED.name;
  }

  void sendMeasurement() {
    if (ecgResult.value.ecgsymps?.isEmpty ?? true) return;
    if (isLoading.isTrue) return;
    isLoading.value = true;
    var inputs = ecgResult.value.ecgInput?.toJson();
    inputs?.removeWhere((key, value) => (value == null));
    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.ECG.value,
        measurementTypeCode: MeasurementType.ECG.name,
        measurementTypeName: "Electrocardiogram",
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        ecgsymps: ecgResult.value.ecgsymps,
        ecgGraphValue: "",
        result: ResultDTO(
            colorCode: ecgResult.value.ecgsymps?[0].colorCode,
            status: ecgResult.value.ecgsymps?[0].name,
            statusBn: ecgResult.value.ecgsymps?[0].sympNameBn,
            severity: ecgResult.value.ecgsymps?[0].name,
            suggestion: ecgResult.value.ecgsymps?[0].suggestion,
            suggestionBn: ecgResult.value.ecgsymps?[0].suggestionBn,
            value: double.parse(ecgResult.value.ecgInput!.hrmean!)
        ),
        inputs: inputs
    );

    repository.sendData(AppUidConfig.getPostMeasurementUrl(), (measurement).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        measurement.result = value.result;
        screeningReport.value = value;
        Get.offNamed('/screening_report_ecg_details', arguments: [{
          "screeningReport": screeningReport.value, "isAuto": true, "measurementsWithResult": [measurement]
        }]);
      }
    });
  }

  @override
  void onClose() {
    disconnect();
  }
}
