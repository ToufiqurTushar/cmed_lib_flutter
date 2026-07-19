import 'package:audioplayers/audioplayers.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_bp_device_lib/bp/riocom/riocom_bp_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import '../../../../../../common/api/api_url.dart';
import '../../../../../../common/widget/radar_pulsator.dart';
import '../../../../dto/screening_report_result_details_argument.dart';
import '../../../../measurement_view_arg.dart';
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

  var screeningReport = MeasurementDTO(
      measurementTypeCodeId: MeasurementType.BP.value,
      inputs: {
        BPAttribute.SYSTOLIC.name: 0,
        BPAttribute.DIASTOLIC.name: 0,
        BPAttribute.PULSE.name: 0,
      },
      measuredAt: DateTime.now().millisecondsSinceEpoch
  ).obs;

  final RxString screen_status = ScreenEnum.CONNECT.name.obs;

  final RxString buttonText = 'label_connect'.tr.obs;
  final player = AudioPlayer();
  bool isNestedRoute = false;

  var bpCurrentStatusObs = BPDeviceStatus.Idle.name.obs;
  var bpValueObs = ''.obs;


  @override
  Future<void> onInit() async{
    super.onInit();
    riocomBpHandler = RiocomBpHandler();
    isNestedRoute = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isNestedRoute??false : false;
	  Future.delayed(Duration(milliseconds:300), () async {
		  if(isNestedRoute){
        connect();
      }
  	});
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
        bpCurrentStatusObs.value = BPDeviceStatus.Connecting.name;
      } else if (event == "searching") {
        screen_status.value = ScreenEnum.SEARCHING.name;
        buttonText.value = 'label_searching'.tr;
        bpCurrentStatusObs.value = BPDeviceStatus.Connecting.name;
      } else if (event == "measuring") {
        globalState.hideBusy();
        screen_status.value = ScreenEnum.MEASURING.name;
        bpCurrentStatusObs.value = BPDeviceStatus.Measuring.name;
      } else if (event == "disconnected" || event == "error_connection_lost") {
        screen_status.value = ScreenEnum.DISCONNECTED.name;
        buttonText.value = 'label_connect'.tr;
        pressure.value = "";
        isResultFound.value = false;
        bpCurrentStatusObs.value = BPDeviceStatus.TapConnect.name;
        bpValueObs.value = "";
      } else if (event == "noDeviceFound" || event == "bluetoothDisabled" || event == "reconnectError" || event == "deviceNotConnected") {
        screen_status.value = ScreenEnum.DEVICE_NOT_FOUND.name;
        buttonText.value = 'label_connect'.tr;
        pressure.value = "";
        isResultFound.value = false;
        bpCurrentStatusObs.value = BPDeviceStatus.DeviceNotFound.name;
        bpValueObs.value = "";
      } else if (event == "connected") {
        screen_status.value = ScreenEnum.CONNECTED.name;
        bpCurrentStatusObs.value = BPDeviceStatus.DeviceConnected.name;
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
        bpCurrentStatusObs.value = BPDeviceStatus.Measuring.name;
        isLoading.value = false;
      }
      pressure.value = event.split(":")[0];
      bpValueObs.value = "${pressure.value} mmHg";
      globalState.hideBusy();
    });

    riocomBpHandler.result.listen((String event) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        globalState.hideBusy();
        result.value = event.split(":");
        screen_status.value = ScreenEnum.RESULT_FOUND.name;
        isResultFound.value = true;
        bpCurrentStatusObs.value = BPDeviceStatus.Measured.name;
        if (result.length >= 3) {
          bpValueObs.value = "${result[0]}/${result[1]} mmHg";
          screeningReport.value = MeasurementDTO(
              measurementTypeCodeId: MeasurementType.BP.value,
              inputs: {
                BPAttribute.SYSTOLIC.name: double.parse(result[0]),
                BPAttribute.DIASTOLIC.name: double.parse(result[1]),
                BPAttribute.PULSE.name: double.parse(result[2]),
              },
              measuredAt: DateTime.now().millisecondsSinceEpoch
          );
        }
        if(isNestedRoute){
          sendBpAndPulseMeasurement();
        }
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
    globalState.showBusy();
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
    final url = isNestedRoute?ApiUrl.addMeasurementUrl():AppUidConfig.getPostMeasurementUrl();
    repository.sendData(url, (BPMeasurement).toJson()).then((bpMeasurementWithResult) {
      if (bpMeasurementWithResult != null) {
        allMeasurements[0].result = bpMeasurementWithResult.result;
        if (result.length >= 3) {
          repository.sendData(url, (pulseMeasurement).toJson()).then((pulseMeasurementWithResult) {
            isLoading.value = false;
            screeningReport.value = bpMeasurementWithResult;
            allMeasurements[1].result = pulseMeasurementWithResult!.result;

            if (result.length >= 3) {
              screeningReport.value.inputs!.addAll({
                BPAttribute.PULSE.name: double.parse(result[2])
              });
            }

            String route = isNestedRoute? '/screening_preview_result_details': '/screening_report_result_details';
            Get.offNamed(route, arguments: [
              ScreeningReportResultDetailsArgument(
                  screeningReport: screeningReport.value, isAuto: true, measurementsWithResult: allMeasurements
              )
            ], id: isNestedRoute? 1: null);
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

// Your existing enum remains perfectly clean and unchanged
enum BPDeviceStatus {
  Idle, TapConnect, TapReConnect, Connecting, ReConnecting, DeviceConnected, DeviceNotFound, Measuring, Measured;

  // Simply add a mapper translation helper
  DeviceUiState toUiState(BuildContext context, String? liveValue) {
    return switch (this) {
      BPDeviceStatus.Idle || BPDeviceStatus.TapConnect || BPDeviceStatus.TapReConnect => DeviceUiState(
        type: DeviceUiType.interactiveAction,
        title: 'label_device_disconnected_please_reconnect_to_get_measurements'.tr,
        subtitle: 'label_keep_device_switch_on'.tr,
        themeColor: Theme.of(context).primaryColor,
        actionButtonLabel: 'label_connect'.tr,
        child: CenterRadar(oneFullRotationInMilliSeconds: 2000)
      ),
      BPDeviceStatus.Connecting || BPDeviceStatus.ReConnecting => DeviceUiState(
        type: DeviceUiType.loadingProgress,
        title: Get.find<BpDeviceConnectionLogic>().buttonText.value,
        subtitle: 'label_keep_device_switch_on'.tr,
        themeColor: Colors.amber,
        child: CenterRadar(oneFullRotationInMilliSeconds: 2000)
      ),
      BPDeviceStatus.DeviceConnected => DeviceUiState(
        type: DeviceUiType.interactiveAction,
        title: ''.tr,
        subtitle: 'Your device is connected and ready to use'.tr,
        child: ListTile(leading: Image.asset('assets/images/measurement/wear_the_cuff.png', color: Theme.of(context).primaryColor,), title: Text('Wear the cuffs properly'.tr, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),), subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Wrap the cuff around your bare upper arm. Keep your arm still and resting on a flat surface.'),
        ),),
        themeColor: Theme.of(context).primaryColor,
        actionButtonLabel: 'label_start'.tr,
      ),
      BPDeviceStatus.Measuring => DeviceUiState(
        type: DeviceUiType.loadingProgress,
        title: 'label_please_wait_while_taking_measurement'.tr,
        subtitle: ''.tr,
        value: liveValue ?? '0 mmHg',
        //icon: Icons.favorite,
        themeColor: Theme.of(context).primaryColor,
      ),
      BPDeviceStatus.Measured => DeviceUiState(
        type: DeviceUiType.successDone,
        title: ''.tr,
        subtitle: ''.tr,
        value: '',//liveValue ?? '---/--- mmHg',
        //icon: Icons.check_circle_outline,
        themeColor: Theme.of(context).primaryColor,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Get.find<BpDeviceConnectionLogic>().sendBpAndPulseMeasurement();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  Get.locale?.languageCode == 'bn' ? "পরিমাপ সংরক্ষণ করুন" : "Save Measurement",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: TextButton(
                onPressed: () {
                  Get.find<BpDeviceConnectionLogic>().connect();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFE5F7EE),
                  foregroundColor:Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  Get.locale?.languageCode == 'bn' ? "আবার পরিমাপ করুন" : "Measure Again",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      BPDeviceStatus.DeviceNotFound => DeviceUiState(
        type: DeviceUiType.errorFault,
        title: 'label_device_not_found'.tr,
        subtitle: 'label_keep_device_switch_on'.tr,
        icon: Icons.error_outline,
        themeColor: Colors.red,
        actionButtonLabel: 'label_connect'.tr,
      ),
    };
  }

  static BPDeviceStatus fromString(String stringName){
    return BPDeviceStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == stringName.toLowerCase(),
      orElse: () => BPDeviceStatus.Idle,
    );
  }
}




// enum OximeterStatus { disconnected, scanning, analyzing, syncError }
//
// extension OximeterUiAdapter on OximeterStatus {
//   DeviceUiState toUiState(String? Spo2) {
//     return switch (this) {
//       OximeterStatus.disconnected => const DeviceUiState(
//         type: DeviceUiType.interactiveAction,
//         title: 'Oximeter Offline',
//         subtitle: 'Clip device to your index finger',
//         icon: Icons.fingerprint,
//         themeColor: Colors.indigo,
//         actionButtonLabel: 'Initialize Sensor',
//       ),
//       OximeterStatus.scanning => const DeviceUiState(
//         type: DeviceUiType.loadingProgress,
//         title: 'Acquiring Signal',
//         subtitle: 'Reading blood pulse waves...',
//         icon: Icons.waves,
//         themeColor: Colors.cyan,
//       ),
//       OximeterStatus.analyzing => DeviceUiState(
//         type: DeviceUiType.successDone,
//         title: 'Pulse SpO2 Captured',
//         subtitle: 'Oxygen levels normal',
//         value: Spo2 ?? '98%',
//         icon: Icons.health_and_safety,
//         themeColor: Colors.green,
//       ),
//       OximeterStatus.syncError => const DeviceUiState(
//         type: DeviceUiType.errorFault,
//         title: 'Hardware Error',
//         subtitle: 'Sensor dirty or detached from finger',
//         icon: Icons.warning_amber_rounded,
//         themeColor: Colors.deepOrange,
//         actionButtonLabel: 'Clean and Retry',
//       ),
//     };
//   }
// }

