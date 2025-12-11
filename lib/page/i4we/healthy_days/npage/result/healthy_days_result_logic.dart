import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import '../../healthy_days_argument.dart';
import '../../healthy_days_view.dart';
import 'healthy_days_result_argument.dart';


class HealthyDaysResultLogic extends BaseLogic {
  final isHistoryView = false.obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  var healthyDaysResultArgument = HealthyDaysResultArgument();

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null){
          healthyDaysResultArgument = Get.arguments as HealthyDaysResultArgument;
          isHistoryView.value = healthyDaysResultArgument.isFromHistory??false;
          selectedSurveyResult.value = healthyDaysResultArgument.selectedSurveyResult??SurveyResultItemDto();
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
    Get.offNamed(HealthyDaysView.routeName, arguments: HealthyDaysArgument(selectedSurvey: healthyDaysResultArgument.selectedSurvey));
  }
}
