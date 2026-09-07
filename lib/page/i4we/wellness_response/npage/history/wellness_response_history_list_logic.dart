import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:intl/intl.dart';

import '../../../../../common/api/api_url.dart';
import '../../../../../common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

import '../../wellness_response_argument.dart';


class WellnessResponseHistoryListLogic extends BaseLogic {
  final HttpProvider httpProvider = Get.find();
  final isHistoryView = false.obs;

  final surveyResultList = <SurveyResultItemDto>[].obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;
  int fromDate = 0;
  int toDate = 0;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments is WellnessResponseArgument) {
      final arg = Get.arguments as WellnessResponseArgument;
      if (arg.date != null) {
        String date = arg.date??'';
        DateTime selectedDate = DateFormat('yyyy-MMM-dd').parse(date);
        fromDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0).millisecondsSinceEpoch;
        toDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999).millisecondsSinceEpoch;
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
    httpProvider.GET(ApiUrl.getWellnessResponseSurveyUrl(customer.value.userId!, fromDate: fromDate, toDate: toDate)).then((response){
      globalState.hideBusy();
      if(response.isOk) {
        surveyResultList.addAll(SurveyResultItemDto.fromJsonList(response.body['content']));
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    });
  }

  String formatSingleUnitAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    final days = difference.inDays;

    if (days < 30) {
      final key = days == 1 ? 'single_day_ago' : 'single_days_ago';

      return key.tr.replaceAll(
        '@days',
        days.toString(),
      );
    }

    final months = days ~/ 30;

    if (months < 12) {
      final key = months == 1 ? 'single_month_ago' : 'single_months_ago';

      return key.tr.replaceAll(
        '@months',
        months.toString(),
      );
    }

    final years = months ~/ 12;

    final key = years == 1 ? 'single_year_ago' : 'single_years_ago';

    return key.tr.replaceAll(
      '@years',
      years.toString(),
    );
  }
}