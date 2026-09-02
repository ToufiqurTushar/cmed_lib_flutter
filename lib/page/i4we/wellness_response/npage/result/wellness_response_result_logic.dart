import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import '../../wellness_response_argument.dart';
import '../../wellness_response_view.dart';
import 'wellness_response_result_argument.dart';


class WellnessResponseResultLogic extends BaseLogic {
  final isHistoryView = false.obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  var wellnessResponseResultArgument = WellnessResponseResultArgument();

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
          wellnessResponseResultArgument = Get.arguments as WellnessResponseResultArgument;
          isHistoryView.value = wellnessResponseResultArgument.isFromHistory??false;
          selectedSurveyResult.value = wellnessResponseResultArgument.selectedSurveyResult??SurveyResultItemDto();
    }

  }



  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
  }

  void remeasure() {
    Get.offNamed(WellnessResponseView.routeName, arguments: WellnessResponseArgument(selectedSurvey: wellnessResponseResultArgument.selectedSurvey));
  }
}
