import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import 'package:cmed_lib_flutter/page/rgp/dto/ProfileMemberData.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';

class HouseholdSurveyHistoryListArgument {
  HouseholdSurveyHistoryListArgument({
    this.date,
    this.householdId,
    this.userId,
    this.customer,
    this.isFromActivity,
  });
  String? date;
  int? householdId;
  int? userId;
  bool? isFromActivity;
  CustomerDTO? customer;
}

class HouseholdSurveyHistoryItem {
  final SurveyResultItemDto? survey;
  final ProfileMemberData? profileMemberData;
  final Map<String, dynamic> raw;

  HouseholdSurveyHistoryItem({
    this.survey,
    this.profileMemberData,
    this.raw = const {},
  });

  factory HouseholdSurveyHistoryItem.fromJson(Map<String, dynamic> json) {
    SurveyResultItemDto? s;
    if (json['survey'] != null && json['survey'] is Map) {
      s = SurveyResultItemDto.fromJson(json['survey']);
    } else if (json['survey_on'] != null) {
      s = SurveyResultItemDto.fromJson(json);
    }

    ProfileMemberData? p;
    if (json['profile_member_data'] != null && json['profile_member_data'] is Map) {
      p = ProfileMemberData.fromJson(json['profile_member_data']);
    }

    return HouseholdSurveyHistoryItem(
      survey: s,
      profileMemberData: p,
      raw: json,
    );
  }
}
