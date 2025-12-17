import 'package:audioplayers/audioplayers.dart';
import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_spo2_devices_lib/cmed_spo2_devices_lib.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get/get.dart';

import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import '../../../../dto/screening_report_result_details_argument.dart';
import '../../enum/screen_enum.dart';

class OxygenSaturationDeviceConnectionLogic extends BaseLogic {
  late CmedSpo2DevicesLib cmedSpO2DevicesLib;
  var status = <String>[].obs;
  var isSave = false.obs;
  final RxString reading = "".obs;
  RxString spo2Result = "".obs;
  RxString pulseResult = "".obs;

  var screeningReport = MeasurementDTO().obs;
  RxBool isResultFound = false.obs;

  final RxString screenStatus = ScreenEnum.CONNECT.name.obs;

  final RxString buttonText = 'label_connect'.tr.obs;

  final ScreeningReportRepository repository;

  OxygenSaturationDeviceConnectionLogic({required this.repository});

  @override
  void onInit() {
    super.onInit();
    cmedSpO2DevicesLib = CmedSpo2DevicesLib();
  }

  Future<void> connect() async {
    if (screenStatus.value == ScreenEnum.CONNECTING.name) {
      isResultFound.value = false;
      return;
    }

    buttonText.value = 'label_searching'.tr;

    cmedSpO2DevicesLib.getStatus().listen((event) {
      debugPrint("contec_event -> $event");
      status.value = event.toString().split(":");
      if (status[0] == "CN_SEARCHING") {
        screenStatus.value = ScreenEnum.SEARCHING.name;
        buttonText.value = 'label_searching'.tr;
      } else if (status[0] == "CN_DEVICE_FOUND" ||
          status[0] == "CN_CONNECTED" ||
          status[0] == "CN_DISCOVER_SERVICES") {
        screenStatus.value = ScreenEnum.CONNECTING.name;
        buttonText.value = 'label_connecting'.tr;
      } else if (status[0] == "CN_FINGER_OUT") {
        RLog.error(status[0]);
        screenStatus.value = ScreenEnum.FINGER_OUT.name;
        reading.value = "";
        spo2Result.value = "";
        pulseResult.value = "";
      } else if (status[0] == "CN_FINGER_IN") {
        RLog.error(status[0]);
        screenStatus.value = ScreenEnum.FINGER_IN.name;
      }
      else if (status[0] == "CN_SPO2_DATA") {
        if (screenStatus.value != ScreenEnum.FINGER_OUT.name) {
          screenStatus.value = ScreenEnum.MEASURING.name;
          isLoading.value = false;
        }
        if (status[1] != "-1") {
          reading.value = status[1];
          spo2Result.value = status[1];
          pulseResult.value = status[2];
        }
        RLog.error(event);
      } else if (status[0] == "CN_DISCONNECTED") {
        screenStatus.value = ScreenEnum.DISCONNECTED.name;
        buttonText.value = 'label_connect'.tr;
      } else if (status[0] == "CN_ERROR") {
        Future.delayed(const Duration(milliseconds: 100)).then((value) {
          ShowToast.error('label_bluetooth_error'.tr);
          screenStatus.value = ScreenEnum.CONNECT.name;
          buttonText.value = 'label_connect'.tr;
        });
      } else if (status[0] == "noDeviceFound" ||
          status[0] == "bluetoothDisabled" || status[0] == "CN_NO_DEVICE_FOUND") {
        screenStatus.value = ScreenEnum.DEVICE_NOT_FOUND.name;
        buttonText.value = 'label_connect'.tr;

      } else if (status[0] == "CN_NOTIFY_SUCCESSFULLY") {
        screenStatus.value = ScreenEnum.CONNECTED.name;
        final player = AudioPlayer();
        player.play(AssetSource('audio/device_connected.mp3'));
      } else if (event == "error_gasing" &&
          screenStatus.value != ScreenEnum.CONNECTED.name) {
        // disconnect();
        Future.delayed(const Duration(milliseconds: 100))
            .then((value) => screenStatus.value = ScreenEnum.CONNECTED.name);
        // TODO Handle error here.
      } else {
        // screen_status.value = ScreenEnum.ERROR.name;
      }
    });

    await cmedSpO2DevicesLib.connect();
  }

  String getInputText() {
    if (spo2Result.value.isEmpty) return '';
    return "${'label_spo2'.tr}: ${spo2Result.value}%";
  }

  startMeasurement() {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      isLoading.value = true;
      cmedSpO2DevicesLib.measure();
    });
  }

  disconnect() {
    isResultFound.value = false;
    isLoading.value = false;
    cmedSpO2DevicesLib.disconnect();
    screenStatus.value = ScreenEnum.DISCONNECTED.name;
  }

  void sendMeasurement() {
    if (spo2Result.value.isEmpty) return;
    if (isLoading.isTrue) return;
    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.SpO2.value,
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        inputs: {
          SPO2Attribute.SPO2.name: double.parse(spo2Result.value),
        });

    var pulseMeasurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.PULSE_RATE.value,
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        inputs: {
          PulseAttribute.PULSE_RATE.name: double.parse(pulseResult.value)
        }
    );

    repository.sendData(AppUidConfig.getPostMeasurementUrl(), (measurement).toJson()).then((spo2MeasurementWithResult) {
      debugPrint(spo2MeasurementWithResult?.toJson().toString());
      if (spo2MeasurementWithResult != null) {
        measurement.result = spo2MeasurementWithResult.result;
        repository.sendData(AppUidConfig.getPostMeasurementUrl(), (pulseMeasurement).toJson()).then((pulseMeasurementWithResult) {
          isLoading.value = false;
          if (pulseMeasurementWithResult != null) {
            pulseMeasurement.result = pulseMeasurementWithResult.result;
            //send to next page
            screeningReport.value = spo2MeasurementWithResult;
            screeningReport.value.inputs!.addAll({
              SPO2Attribute.SPO2.name: double.parse(spo2Result.value),
              PulseAttribute.PULSE_RATE.name: double.parse(pulseResult.value),
            });
            updateMeasurementAndNavigate([measurement, pulseMeasurement]);
          }
        });
      }
    });
  }

  updateMeasurementAndNavigate(List<MeasurementDTO> allMeasurements) {
    // bool isValidMeasurementSelectionDetailsLogic = Get.isRegistered<MeasurementSelectionDetailsLogic>();
    // if(isValidMeasurementSelectionDetailsLogic) {
    //   Get.find<MeasurementSelectionDetailsLogic>().updateSelectedServiceTypeMeasurementStatus(allMeasurements);
    // }
    Get.offNamed('/screening_report_result_details', arguments: [
      ScreeningReportResultDetailsArgument(
          screeningReport: screeningReport.value, isAuto: true, measurementsWithResult: allMeasurements
      )
    ]);
  }

  @override
  void onClose() {
    disconnect();
  }

  stopMeasurement() {
    cmedSpO2DevicesLib.cancelMeasurement();
  }


  Future<void> reconnect() async {
    await cmedSpO2DevicesLib.disconnect();
    cmedSpO2DevicesLib = CmedSpo2DevicesLib();
    buttonText.value = 'label_connecting'.tr;
    await connect();
  }
}
