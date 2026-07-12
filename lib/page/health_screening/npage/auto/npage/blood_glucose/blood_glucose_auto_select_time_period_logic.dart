import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../constant/measurementconstants.dart';
import '../../../../measurement_view_arg.dart';
import 'blood_glucose_device_connection_view.dart';



class BloodGlucoseAutoSelectTimePeriodLogic extends BaseLogic {

  var selectedItem = MasterDataDTO().obs;

  bool isSusasthoV2 = false;

  BloodGlucoseAutoSelectTimePeriodLogic();

  Future<void> onInit() async{
    super.onInit();
    isSusasthoV2 = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isSusasthoV2??false : false;
  }

  Future<void> requestMicrophonePermissionAndNavigate() async {
    var status = await Permission.microphone.status;

    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      Get.toNamed(BloodGlucoseDeviceConnectionView.routeName,
        arguments: MeasurementViewArg(isAuto: true, masterDataDTO: selectedItem.value, isSusasthoV2: isSusasthoV2));
    } else {
      ShowToast.error("Permission is required");
    }
  }
}