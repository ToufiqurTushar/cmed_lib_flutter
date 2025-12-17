import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmed_bmi_devices_lib/cmed_bmi_devices_lib.dart';
import 'package:cmed_bmi_devices_lib/cmed_user.dart';
import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import '../../../../../user_management/repository/profile_repository.dart';
import '../../enum/screen_enum.dart';

class FatDeviceConnectionLogic extends BaseLogic {
  dynamic argumentData = Get.arguments;
  final ScreeningReportRepository repository;
  final ProfileRepository profileRepository;
  FatDeviceConnectionLogic({required this.repository, required this.profileRepository});

  final cmedFatDevicesLib = CmedBmiDevicesLib();
  var status = <String>[].obs;
  var isSave = false.obs;
  var isScreenOff = false.obs;
  final RxString reading = "".obs;
  RxString result = "".obs;
  var bodyComposition = BodyComposition().obs;
  RxString heightUnit = BmiUnit.FEET_INCH.name.obs;
  RxDouble heightInCm = 0.0.obs;
  RxString heightInFeet = "".obs;
  RxString heightInInch = "".obs;
  var resultFound = false.obs;

  var screeningReport = MeasurementDTO().obs;

  final RxString screen_status = ScreenEnum.CONNECT.name.obs;

  final RxString buttonText = 'label_connect'.tr.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    heightUnit.value = argumentData[0]['heightUnit'];
    heightInCm.value = argumentData[0]['heightInCm'];
    heightInFeet.value = argumentData[0]['heightInFeet'];
    heightInInch.value = argumentData[0]['heightInInch'];
  }

  void setUserDataForDevice() {
    var userData = CMEDUser(
        id: customer.value.userId,
        gender: customer.value.getGenderString(),
        ageInYear: customer.value.getAgeInYear(),
        birthDate: customer.value.birthDate,
        heightInCm: heightInCm.value,
        weightInKg: 0.0
    );
    print(userData.toJson());
    cmedFatDevicesLib.setUser(userData);
  }

  Future<void> connect() async {
    setUserDataForDevice();
    resultFound.value = false;
    if (screen_status.value == ScreenEnum.CONNECTING.name) return;

    screen_status.value = ScreenEnum.SEARCHING.name;
    buttonText.value = 'label_searching'.tr;

    cmedFatDevicesLib.getStatus().listen((event) {
      RLog.info("getStatusEvent -> $event");
      status.value = event.toString().split(":");
      if (status[0] == "CS_WEIGHT_ACTION_DEVICE_FOUND" ||
          status[0] == "CS_WEIGHT_ACTION_CONNECTING") {
        screen_status.value = ScreenEnum.CONNECTING.name;
        buttonText.value = 'label_connecting'.tr;
      } else if (status[0] == "CS_ONLINE_WEIGHT") {
        if(isScreenOff.isTrue) {
          final player = AudioPlayer();
          player.play(AssetSource('audio/device_connected.mp3'));
          isScreenOff.value = false;
        }
        if (screen_status.value != ScreenEnum.MEASURING.name) {
          screen_status.value = ScreenEnum.MEASURING.name;
          isLoading.value = false;
        }
        if (status[1] != "-1") {
          reading.value = status[1];
          result.value = status[1];
        }
      } else if (status[0] == "CS_WEIGHT_ACTION_DISCONNECTED" || status[0] == "CS_SCREEN_OFF") {
        isScreenOff.value = true;
        screen_status.value = ScreenEnum.DISCONNECTED.name;
        buttonText.value = 'label_connect'.tr;
      } else if (status[0] == "CS_WEIGHT_ACTION_DEVICE_NOT_FOUND" ||
          status[0] == "bluetoothDisabled") {
        screen_status.value = ScreenEnum.DEVICE_NOT_FOUND.name;
        buttonText.value = 'label_connect'.tr;
        // ShowToast.error('label_device_not_found'.tr);
      } else if (status[0] == "CS_WEIGHT_ACTION_CONNECTED") {
        screen_status.value = ScreenEnum.CONNECTED.name;
        final player = AudioPlayer();
        player.play(AssetSource('audio/device_connected.mp3'));
      } else if (status[0] == "CS_WEIGHT_BLE_DISABLED") {
        ShowToast.error('label_bluetooth_error'.tr);
        screen_status.value = ScreenEnum.CONNECT.name;
        buttonText.value = 'label_connect'.tr;
      } else if (status[0] == "CS_FAT_DATA") {
        bodyComposition.value = BodyComposition.fromJson(jsonDecode(event.toString().replaceAll("CS_FAT_DATA:", "")));
        screen_status.value = ScreenEnum.RESULT_FOUND.name;
        resultFound.value = true;
        stopMeasurement();
        RLog.error(bodyComposition.value.toJson());
      } else if (event == "CS_IMPEDANCE_MEASUREMENT_FAILED") {
        // disconnect();
        Future.delayed(const Duration(milliseconds: 100))
            .then((value) => screen_status.value = ScreenEnum.CONNECTED.name);
        // TODO Handle error here.
      } else {
        // screen_status.value = ScreenEnum.ERROR.name;
      }
    });

    await cmedFatDevicesLib.connect();
  }

  String getInputText() {
    String text = "";
    String height = "";

    if (heightUnit.value == BmiUnit.FEET_INCH.name) {
      height = "${'label_height'.tr}: ${heightInFeet.value}'${heightInInch.value}\"";
    } else {
      height = "${'label_height'.tr}: ${heightInCm.value} ${'hint_input_height_cm'.tr}";
    }

    text = "$height \n${'label_weight'.tr}: ${reading.value}Kg";

    return text;
  }

  disconnect() {
    isLoading.value = false;
    cmedFatDevicesLib.disconnect();
    screen_status.value = ScreenEnum.DISCONNECTED.name;
  }

  void sendMeasurement() {
    if (result.value.isEmpty) return;
    if (isLoading.isTrue) return;
    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BODY_COMPOSITION.value,
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        inputs: {
          BodyCompositionAttribute.BODY_COMPOSITION.name: bodyComposition.value.cBmi,
        },
        bodyComposition: bodyComposition.value,
    );
    measurement.result = ResultDTO(
      value: bodyComposition.value.cBmi,
      status: measurement.getStatus(),
      statusBn: measurement.getStatus(isLocaleBn: true),
      colorCode: measurement.getHashColorCode(),
      severity: measurement.getStatus(),
    );

    isLoading.value = true;
    repository.sendData(AppUidConfig.getPostMeasurementUrl(), (measurement).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        measurement.result = value.result;
        screeningReport.value = value;
        updateSelectedCustomerHeightAndNavigate([measurement]);
      }
    });
  }

  updateSelectedCustomerHeightAndNavigate(List<MeasurementDTO> allMeasurements) {
    isLoading.value = true;
    customer.value.heightCentimeter = heightInCm.value;
    profileRepository.updateSelectedCustomerHeight(customer.value).then((CustomerDTO? value) => {
      isLoading.value = false,
      Get.offNamed('/screening_report_fat_scale_details', arguments: [{
        "screeningReport": screeningReport.value, "isAuto": true, "measurementsWithResult": allMeasurements
      }]),
    });
  }

  @override
  void onClose() {
    disconnect();
  }

  stopMeasurement() {
     cmedFatDevicesLib.disconnect();
  }
}
