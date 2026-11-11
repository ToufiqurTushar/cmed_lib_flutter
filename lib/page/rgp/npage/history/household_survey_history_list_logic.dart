import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:cmed_lib_flutter/page/rgp/dto/HouseholdSurveyContexDto.dart';
import 'package:cmed_lib_flutter/page/rgp/household_survey_argument.dart';
import 'package:cmed_lib_flutter/page/rgp/household_survey_view.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:intl/intl.dart';
import 'household_survey_history_list_argument.dart';

class HouseholdSurveyListLogic extends BaseLogic {
  final HttpProvider httpProvider = Get.find();
  final isHistoryView = false.obs;

  final surveyResultList = <SurveyResultItemDto>[].obs;
  final surveyHistoryList = <HouseholdSurveyHistoryItem>[].obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;

  int fromDate = 0;
  int toDate = 0;
  int? householdId;
  int? targetUserId;
  bool? isFromActivity;

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
      isFromActivity = arg.isFromActivity;
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

    globalState.showBusy();
    httpProvider.GET(ApiUrl.getHouseholdSurveyListUrl(
      householdId: effectiveHouseholdId,
      userId: (isFromActivity??false)? targetUserId:null ,//null=for all user within household
      fromDate: fromDate,
      toDate: toDate,
      page: 0,
      size: 30,
      direction: "DESC",
      sortBy: "id",
    ))
        .then((response) {
      globalState.hideBusy();
      if (response.isOk && response.body != null) {
        surveyResultList.clear();
        surveyHistoryList.clear();
        final content = response.body is List ? response.body : response.body['content'];
        if (content is List) {
          for (var item in content) {
            if (item is Map) {
              final map = Map<String, dynamic>.from(item);
              final historyItem = HouseholdSurveyHistoryItem.fromJson(map);
              surveyHistoryList.add(historyItem);
              if (historyItem.survey != null) {
                surveyResultList.add(historyItem.survey!);
              }
            } else if (item is SurveyResultItemDto) {
              surveyResultList.add(item);
            }
          }
        }
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    }).catchError((e) {
      globalState.hideBusy();
      ShowToast.error('error_massage_something_wrong'.tr);
    });
  }

  /// Converts a history item to HouseholdSurveyContexDto within history controller
  HouseholdSurveyContexDto convertToHouseholdSurveyContextDto(HouseholdSurveyHistoryItem historyItem, {List<SurveyMember>? members}) {
    return HouseholdSurveyContexDto.fromHistoryItem(historyItem.raw, members: members);
  }

  /// Converts to HouseholdSurveyContexDto within history controller and passes to HouseholdSurveyView
  void openSurveyHistoryDetails(int index) {
    if (index < 0 || index >= surveyHistoryList.length) {
      if (index >= 0 && index < surveyResultList.length) {
        Get.toNamed(
          HouseholdSurveyView.routeName,
          arguments: HouseholdSurveyArg(
            customer: customer.value,
            isFromHistory: true,
            selectedSurveyResult: surveyResultList[index],
          ),
        );
      }
      return;
    }

    final historyItem = surveyHistoryList[index];
    final HouseholdSurveyContexDto householdSurveyContexDto =
        convertToHouseholdSurveyContextDto(historyItem);

    Get.toNamed(
      HouseholdSurveyView.routeName,
      arguments: HouseholdSurveyArg(
        customer: customer.value,
        isFromHistory: true,
        selectedSurveyResult: historyItem.survey,
        historyItem: historyItem.raw,
        historyContextDto: householdSurveyContexDto,
      ),
    );
  }

  void onHistoryItemTap(HouseholdSurveyHistoryItem historyItem) {
    final HouseholdSurveyContexDto householdSurveyContexDto =
        convertToHouseholdSurveyContextDto(historyItem);

    Get.toNamed(
      HouseholdSurveyView.routeName,
      arguments: HouseholdSurveyArg(
        customer: customer.value,
        isFromHistory: true,
        selectedSurveyResult: historyItem.survey,
        historyItem: historyItem.raw,
        historyContextDto: householdSurveyContexDto,
      ),
    );
  }
}
