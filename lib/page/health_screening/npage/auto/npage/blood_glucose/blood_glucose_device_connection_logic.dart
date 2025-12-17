import 'dart:async';

import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/app_uid_config.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../dto/screening_report_result_details_argument.dart';
import '../../enum/screen_enum.dart';
import 'denumse_device_handler.dart';


class BloodGlucoseDeviceConnectionLogic extends BaseLogic {
  dynamic argumentData = Get.arguments;
  late DnurseDeviceHandler dnurseDeviceHandler;
  StreamSubscription? _statusSub;
  var status = <String>[].obs;
  var deviceEvent = ''.obs;
  RxString result = "".obs;
  var tag = MasterDataDTO().obs;
  RxString instructionImageSrc = "assets/images/measurement/img_glucose_dnurse_first.png".obs;
  RxString instructionTitle = 'label_glucometer_step_1'.tr.obs;
  RxString instructionDesc = 'desc_glucometer_step_1'.tr.obs;
  RxString instructionIconSrc = "".obs;
  RxBool isCenterIconOnly = true.obs;
  var iconColor = (Theme.of(Get.context!).primaryColor).obs;
  var indicatorIcon = Icons.check_circle.obs;
  RxString stepImageSrc = 'assets/images/device/ic_glucose_dnurse_large.svg'.obs;

  var screeningReport = MeasurementDTO().obs;

  final RxString screenStatus = ScreenEnum.CONNECT.name.obs;

  final ScreeningReportRepository repository;

  BloodGlucoseDeviceConnectionLogic({required this.repository});
  var isListning = false.obs;

  @override
  void onInit() {
    super.onInit();
    dnurseDeviceHandler = Get.find<DnurseDeviceHandler>();
    tag.value = argumentData[0][MeasurementConstant.GLUCOSE_TIME_PERIOD];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    stopMeasurement();
    _statusSub = null;
  }

  Future<void> connect() async {
    dnurseDeviceHandler.connect();
    start();
    isListning.value = true;
  }

  Future<void> start() async {
    _statusSub = dnurseDeviceHandler.status.listen((event) {
      debugPrint("glucose_event -> $event");
      deviceEvent.value = event;
      status.value = event.toString().split(":");
      if (status[0] == "DN_SP1_NOT_INSERTED") {
        onStepInit();
      } else if (status[0] == "DN_SP1_COMMUNICATING" || status[0] == "DN_SP1_DEVICE_RECOGNIZING") {
        onStepOne();
      }  else if (status[0] == "ERR_RECOGNIZE") {
        onStepOne();
        Future.delayed(const Duration(seconds: 2), () async {
            connect();
        });
      } else if (status[0] == "DN_SP1_DEVICE_RECOGNIZED") {
        final player = AudioPlayer();
        player.play(AssetSource('audio/device_connected.mp3'));
        onStepTwo();
      } else if (status[0] == "DN_SP1_TEST_PAPER_REMOVED") {
        onStepTwo();
      } else if (status[0] == "DN_SP1_TEST_PAPER_INSERTED") {
        onStepThree();
      } else if (status[0] == "DN_SP1_START_TEST") {
        onStartMeasurement();
      } else if (status[0] == "DN_SP1_TEST_RESULT") {
        onGetMeasurement(status[1]);
      } else if (status[0] == "DN_SP1_OLD_TEST_PAPER_INSERTED") {
        onOldStripInserted(status[1]);
      } else if (status[0] == "ERR_TIME_OUT") {
        onTimeout(status[1]);
      } else {
        // screen_status.value = ScreenEnum.ERROR.name;
      }
    });

  }

  void onStepInit() {
    screenStatus.value = ScreenEnum.CONNECT.name;
    instructionImageSrc.value =
    "assets/images/measurement/img_glucose_dnurse_first.png";
    instructionTitle.value = 'label_glucometer_step_1'.tr;
    instructionDesc.value = 'desc_glucometer_step_1'.tr;
    instructionIconSrc.value = "";
    isCenterIconOnly.value = true;
    stepImageSrc.value = 'assets/images/device/ic_glucose_dnurse_large.svg';
  }

  void onStepOne() {
    instructionDesc.value = trDeviceStatus(status[1]);
    instructionImageSrc.value = "assets/images/measurement/img_glucose_dnurse_first.png";
  }

  void onStepTwo() {
    isCenterIconOnly.value = true;
    stepImageSrc = 'assets/images/device/strip.svg'.obs;
    instructionImageSrc.value =
    "assets/images/measurement/img_glucose_dnurse_third.png";
    instructionDesc.value = 'desc_glucometer_step_2'.tr;
    instructionTitle.value = 'label_glucometer_step_2'.tr;
  }

  void onStepThree() {
    isCenterIconOnly.value = false;
    stepImageSrc = 'assets/images/device/strip_with_blood_sample.svg'.obs;
    instructionImageSrc.value =
    "assets/images/measurement/img_glucose_dnurse_fourth.png";
    instructionDesc.value = 'desc_glucometer_step_3'.tr;
    instructionTitle.value = 'label_glucometer_step_3'.tr;
  }

  void onStepErrorRecognize() {
    instructionDesc.value = trDeviceStatus(status[1]);
    instructionImageSrc.value = "assets/images/measurement/img_glucose_dnurse_first.png";
  }

  void onStartMeasurement() {
    screenStatus.value = ScreenEnum.MEASURING.name;
  }

  void onGetMeasurement(String status) {
    result.value = status;
    screenStatus.value = ScreenEnum.RESULT_FOUND.name;
  }

  String getInputText() {
    if (result.value.isEmpty) return '';
    return "${'label_time_period'.tr}: ${Utils.isLocaleBn() ? tag.value.labelBn : tag.value.labelEn} \n${'label_blood_glucose'.tr}: ${result.value} ${AppUidConfig.getGlucoseLabelHint('input_hint_glucose'.tr)}";
  }

  stopMeasurement() {
    isLoading.value = false;
    screenStatus.value = ScreenEnum.CONNECT.name;
    _statusSub?.cancel();
  }

  void sendMeasurement() {
    if (result.value.isEmpty) return;
    if (isLoading.isTrue) return;
    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BLOOD_SUGAR.value,
        tag: getMeasurementTag(),
        measuredAt: DateTime.now().millisecondsSinceEpoch,
        inputs: {
          BloodGlucoseAttribute.SUGAR.name: double.parse(result.value),
        });

    var json = measurement.toJson().toString();
    debugPrint(json);

    isLoading.value = true;
    repository.sendData(AppUidConfig.getPostMeasurementUrl(), (measurement).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        measurement.result = value.result;
        screeningReport.value = value;
        Get.offNamed('/screening_report_result_details', arguments: [
          ScreeningReportResultDetailsArgument(
              screeningReport: screeningReport.value, isAuto: true, measurementsWithResult: [measurement]
          )
        ]);
      }
    });
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

  void onOldStripInserted(String status) {
    isCenterIconOnly.value = false;
    stepImageSrc = 'assets/images/device/strip.svg'.obs;
    instructionDesc.value = trDeviceStatus(status);
    instructionTitle.value = 'label_error'.tr;
    indicatorIcon.value = Icons.error_outline;
    iconColor.value = Colors.red;
  }

  void onTimeout(String status) {
    onStepInit();
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      isCenterIconOnly.value = false;
      indicatorIcon.value = Icons.error_outline;
      iconColor.value = Colors.red;
      instructionDesc.value = trDeviceStatus(status);
    });
  }

  String trDeviceStatus(String text) {
    Map<String, String> englishToBangla = {
      'Device recognize failed. Please, remove device and reinsert again': 'ডিভাইস শনাক্ত করা ব্যর্থ হয়েছে, ডিভাইস টি খুলে পুনরায় সংযোগ করুন',
      'Communicating': 'সংযোগ করা হচ্ছে',
      'Recognizing': 'সনাক্ত করা হচ্ছে',
      'Recognized, please insert strips': 'সনাক্ত হয়েছে, অনুগ্রহ করে আপনার স্ট্রিপ প্রবেশ করান।',
      'Strips inserted, please take blood': 'স্ট্রিপ প্রবেশ হয়েছে, অনুগ্রহ করে রক্ত নিন',
      'Please insert Dnurse': 'অনুগ্রহ করে Dnurse প্রবেশ করান।',
      'Strips used, please insert new strips': 'স্ট্রিপ ব্যবহার করা হয়েছে, অনুগ্রহ করে নতুন স্ট্রিপ ঢোকান',
      'Strips removed, please insert strips': ' স্ট্রিপ বের করা হয়েছে, দয়া করে স্ট্রিপ ঢোকান',
      'Blood taken, please wait a moment': 'রক্ত নেওয়া হয়েছে, দয়া করে একটু অপেক্ষা করুন',
      'Device no act, plase plug again': 'ডিভাইস টি খুলে পুনরায় সংযোগ করুন',
    };
    if(text == 'Device recognize failed') {
      text = "Device recognize failed. Please, remove device and reinsert again";
    }
    if(Utils.isLocaleBn()) {
      return englishToBangla[text]??text;
    }
    return text;
  }
}
