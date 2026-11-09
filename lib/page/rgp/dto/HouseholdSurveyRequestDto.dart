import '../../../survey/dto/survey_item_dto.dart';
import 'ProfileMemberData.dart';

class HouseholdSurveyRequestDto extends SurveyResultItemDto{
  HouseholdSurveyRequestDto({
      super.inputs, super.surveyOn, super.surveyId, super.userId, super.surveyName, super.uuid, super.createdAt, super.year, super.month, super.lastUpdated, super.createdById, super.updatedById, super.result, super.icon,
      this.profileMemberData,
  });

  HouseholdSurveyRequestDto.fromJson(dynamic json) {
    super.surveyOn = json['survey_on'];
    super.surveyId = json['survey_id'];
    super.userId = json['user_id'];
    super.surveyName = json['survey_name'];
    super.uuid = json['uuid'];
    super.inputs = json['inputs'];
    profileMemberData = json['profile_member_data'] != null ? ProfileMemberData.fromJson(json['profile_member_data']) : null;
  }
  ProfileMemberData? profileMemberData;

  Map<String, dynamic> toJson() {
    final map = super.toJson();
    if (profileMemberData != null) {
      map['profile_member_data'] = profileMemberData?.toJson();
    }
    return map;
  }

}