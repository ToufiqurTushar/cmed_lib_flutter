import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:intl/intl.dart';
import 'household_survey_history_list_argument.dart';

class HouseholdSurveyListLogic extends BaseLogic {
  final HttpProvider httpProvider = Get.find();
  final isHistoryView = false.obs;

  final surveyResultList = <SurveyResultItemDto>[].obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;

  int fromDate = 0;
  int toDate = 0;
  int? householdId;
  int? targetUserId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is HouseholdSurveyHistoryListArgument) {
      final arg = Get.arguments as HouseholdSurveyHistoryListArgument;
      if (arg.customer != null) {
        customer.value = arg.customer!;
      }
      householdId = arg.householdId;
      targetUserId = arg.userId;
      if (arg.date != null && arg.date!.isNotEmpty) {
        try {
          String date = arg.date!;
          DateTime selectedDate = DateFormat('yyyy-MMM-dd').parse(date);
          fromDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0).millisecondsSinceEpoch;
          toDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999).millisecondsSinceEpoch;
        } catch (_) {}
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    getData();
  }

  @override
  void onClose() {}

  getData() async {
    final effectiveHouseholdId = householdId ?? customer.value.householdId ?? 0;
    final effectiveUserId = targetUserId ?? customer.value.userId ?? 0;

    globalState.showBusy();
    httpProvider
        .GET(ApiUrl.getHouseholdSurveyListUrl(
      householdId: effectiveHouseholdId,
      userId: effectiveUserId,
      fromDate: fromDate,
      toDate: toDate,
      page: 0,
      size: 10,
      direction: "DESC",
      sortBy: "id",
    ))
        .then((response) {
      globalState.hideBusy();
      if (response.isOk && response.body != null) {
        surveyResultList.clear();
        final content = response.body is List ? response.body : response.body['content'];
        if (content is List) {
          surveyResultList.addAll(SurveyResultItemDto.fromJsonList(content));
        }
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    }).catchError((e) {
      globalState.hideBusy();
      ShowToast.error('error_massage_something_wrong'.tr);
    });
  }
}

