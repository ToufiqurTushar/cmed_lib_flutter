import 'package:audioplayers/audioplayers.dart';
import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_bp_device_lib/bp/riocom/riocom_bp_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import '../../../../dto/screening_report_result_details_argument.dart';
import '../../enum/screen_enum.dart';

class BpDeviceConnectionLogic extends BaseLogic {
  final ScreeningReportRepository repository;
  BpDeviceConnectionLogic({required this.repository});

  late RiocomBpHandler riocomBpHandler;
  final RxString status = "".obs;
  var isSave = false.obs;
  var isResultFound = false.obs;
  final RxString pressure = "".obs;
  RxList<String> result = <String>[].obs;

  var screeningReport = MeasurementDTO().obs;

  final RxString screen_status = ScreenEnum.CONNECT.name.obs;

  final RxString buttonText = 'label_connect'.tr.obs;
  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    riocomBpHandler = RiocomBpHandler();

  }


  Future<void> connect() async {
    pressure.value = "";
    if (screen_status.value == ScreenEnum.CONNECTING.name) return;
    if (screen_status.value == ScreenEnum.SEARCHING.name) return;
    isResultFound.value = false;

    buttonText.value = 'label_searching'.tr;

    riocomBpHandler.status.listen((String event) {
      RLog.info(event);
      status.value = event;
      if (event == "connecting") {
        screen_status.value = ScreenEnum.CONNECTING.name;
        buttonText.value = 'label_connecting'.tr;
      } else if (event == "searching") {
        screen_status.value = ScreenEnum.SEARCHING.name;
        buttonText.value = 'label_searching'.tr;
      } else if (event == "measuring") {
        screen_status.value = ScreenEnum.MEASURING.name;
      } else if (event == "disconnected" || event == "error_connection_lost") {
        screen_status.value = ScreenEnum.DISCONNECTED.name;
        buttonText.value = 'label_connect'.tr;
        pressure.value = "";
        isResultFound.value = false;
      } else if (event == "noDeviceFound" || event == "bluetoothDisabled" || event == "reconnectError" || event == "deviceNotConnected") {
        screen_status.value = ScreenEnum.DEVICE_NOT_FOUND.name;
        buttonText.value = 'label_connect'.tr;
        pressure.value = "";
        isResultFound.value = false;
      } else if (event == "connected") {
        screen_status.value = ScreenEnum.CONNECTED.name;
        if(player.state != PlayerState.playing){
          player.play(AssetSource('audio/device_connected.mp3'));
        }
      } else if (event == "error_gasing" &&
          screen_status.value != ScreenEnum.CONNECTED.name) {
        // disconnect();
        Future.delayed(const Duration(milliseconds: 100))
            .then((value) => screen_status.value = ScreenEnum.CONNECTED.name);
        // TODO Handle error here.
      } else {
        // screen_status.value = ScreenEnum.ERROR.name;
      }
    });

    riocomBpHandler.pressure.listen((String event) {
      if (screen_status.value != ScreenEnum.MEASURING.name) {
        screen_status.value = ScreenEnum.MEASURING.name;
        isLoading.value = false;
      }
      pressure.value = event.split(":")[0];
    });

    riocomBpHandler.result.listen((String event) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        result.value = event.split(":");
        screen_status.value = ScreenEnum.RESULT_FOUND.name;
        isResultFound.value = true;
      });
    });

    FlutterBluePlus.isOn.then((value) async {
      if (!value) {
        Future.delayed(const Duration(milliseconds: 100)).then((value) {
          ShowToast.error('label_bluetooth_error'.tr);
          screen_status.value = ScreenEnum.CONNECT.name;
          buttonText.value = 'label_connect'.tr;
        });
      } else {
        await riocomBpHandler.connect();
      }
    });
  }

  String getInputText() {
    if (result.isEmpty) return '';
    String text =
        "${'label_systolic'.tr}: ${result[0]} ${'input_hint_systolic_bp'.tr} \n${'label_diastolic'.tr}: ${result[1]} ${'input_hint_systolic_bp'.tr}";

    if (result.length >= 3) {
      text += "\n${'label_pulse'.tr}: ${result[2]} bpm";
    }

    return text;
  }

  startMeasurement() {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      screen_status.value = ScreenEnum.MEASURING.name;
      riocomBpHandler.startMeasurement();
    });
  }

  disconnect() async{
    isLoading.value = false;
    await riocomBpHandler.disconnect().then((bool isDisconnected){
      if(isDisconnected) {
        screen_status.value = ScreenEnum.DISCONNECTED.name;
      }
    });
  }

  void sendBpAndPulseMeasurement() {
    if (result.isEmpty) return;
    if (isLoading.isTrue) return;
    isLoading.value = true;

    var BPMeasurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BP.value,
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        inputs: {
          BPAttribute.SYSTOLIC.name: double.parse(result[0]),
          BPAttribute.DIASTOLIC.name: double.parse(result[1]),
        });

    var allMeasurements = [BPMeasurement];

    var pulseMeasurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.PULSE_RATE.value,
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        inputs: {}
    );

    if (result.length >= 3) {
      pulseMeasurement.inputs!.addAll({
        PulseAttribute.PULSE_RATE.name: double.parse(result[2]),
      });
      allMeasurements = [BPMeasurement, pulseMeasurement];
    }

    isLoading.value = true;
    repository.sendData(ApiUrl.previewMeasurementUrl(), (BPMeasurement).toJson()).then((bpMeasurementWithResult) {
      if (bpMeasurementWithResult != null) {
        allMeasurements[0].result = bpMeasurementWithResult.result;
        if (result.length >= 3) {
          repository.sendData(ApiUrl.previewMeasurementUrl(), (pulseMeasurement).toJson()).then((pulseMeasurementWithResult) {
            isLoading.value = false;
            screeningReport.value = bpMeasurementWithResult;
            allMeasurements[1].result = pulseMeasurementWithResult!.result;

            if (result.length >= 3) {
              screeningReport.value.inputs!.addAll({
                BPAttribute.PULSE.name: double.parse(result[2])
              });
            }
            Get.offNamed('/screening_report_result_details', arguments: [
              ScreeningReportResultDetailsArgument(
                  screeningReport: screeningReport.value, isAuto: true, measurementsWithResult: allMeasurements
              )
            ]);
          });
        }
      }
    });
  }

  @override
  void onClose() async{
    await disconnect();
  }

  Future<void> reconnect() async {
    await riocomBpHandler.reconnect();
    buttonText.value = 'label_searching'.tr;
  }
}
