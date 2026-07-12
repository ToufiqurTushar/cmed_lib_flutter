import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../measurement_view_arg.dart';

class BloodGlucoseSelectTimePeriodLogic extends BaseLogic {

  var selectedItem = MasterDataDTO().obs;
  bool isSusasthoV2 = false;
  BloodGlucoseSelectTimePeriodLogic();

  Future<void> onInit() async{
    super.onInit();
    isSusasthoV2 = Get.arguments is MeasurementViewArg? (Get.arguments as MeasurementViewArg).isSusasthoV2??false : false;
  }

}