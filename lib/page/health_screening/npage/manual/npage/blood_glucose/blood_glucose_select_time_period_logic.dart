import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../measurement_view_arg.dart';

class BloodGlucoseSelectTimePeriodLogic extends BaseLogic {

  var selectedItem = MasterDataDTO().obs;
  bool isNestedRoute = false;
  bool isThemeV2 = false;
  BloodGlucoseSelectTimePeriodLogic();

  Future<void> onInit() async{
    super.onInit();
    isNestedRoute = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isNestedRoute??false : false;
    isThemeV2 = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isThemeV2??false : false;
  }

}