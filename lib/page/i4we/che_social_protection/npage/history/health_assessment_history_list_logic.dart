import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:intl/intl.dart';

import '../../../../../common/api/api_url.dart';
import '../../../../../common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';

import 'health_assessment_history_argument.dart';


class HealthAssessmentHistoryListLogic extends BaseLogic {
  final HttpProvider httpProvider = Get.find();
  final isHistoryView = false.obs;

  final surveyResultList = <SurveyResultItemDto>[].obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  int fromDate = 0;
  int toDate = 0;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments is HealthAssessmentHistoryArgument) {
      final arg = Get.arguments as HealthAssessmentHistoryArgument;
      if (arg.date != null) {
        String date = arg.date??'';
        DateTime selectedDate = DateFormat('yyyy-MMM-dd').parse(date);
        fromDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0).toUtc().millisecondsSinceEpoch;
        toDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999).toUtc().millisecondsSinceEpoch;
      }
    }
  }



  @override
  void onReady() {
    super.onReady();
    getData();
  }

  @override
  void onClose() {

  }

  getData() async {

    globalState.showBusy();
    httpProvider.GET(ApiUrl.getHealthAssessmentSurveyUrl(customer.value.userId!, fromDate: fromDate, toDate: toDate)).then((response){
      globalState.hideBusy();
      if(response.isOk) {
        surveyResultList.addAll(SurveyResultItemDto.fromJsonList(response.body['content']));
      } else {
        ShowToast.error('something_wrong'.tr);
      }
    });
  }
}
