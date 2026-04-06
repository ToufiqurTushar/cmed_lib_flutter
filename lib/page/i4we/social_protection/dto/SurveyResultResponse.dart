class SurveyResultDto {
  SurveyResultDto({
    this.id,
    this.uuid,
    this.createdAt,
    this.lastUpdated,
    this.createdById,
    this.updatedById,
    this.inputs,
    this.surveyOn,
    this.surveyId,
    this.icon,
    this.userId,
    this.surveyName,
    this.result,});

  SurveyResultDto.fromJson(dynamic json) {
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    inputs = json['inputs'];
    surveyOn = json['survey_on'];
    surveyId = json['survey_id'];
    icon = json['icon'];
    userId = json['user_id'];
    surveyName = json['survey_name'];
    result = json['result'];
  }
  num? id;
  String? uuid;
  num? createdAt;
  num? lastUpdated;
  num? createdById;
  num? updatedById;
  dynamic inputs;
  num? surveyOn;
  num? surveyId;
  String? icon;
  num? userId;
  String? surveyName;
  String? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['inputs'] = inputs;
    map['survey_on'] = surveyOn;
    map['survey_id'] = surveyId;
    map['icon'] = icon;
    map['user_id'] = userId;
    map['survey_name'] = surveyName;
    map['result'] = result;
    return map;
  }

}
class SurveyResultResponseDto {
  SurveyResultResponseDto({
      this.content,});

  SurveyResultResponseDto.fromJson(dynamic json) {
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content?.add(SurveyResultDto.fromJson(v));
      });
    }
  }
  List<SurveyResultDto>? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) {
      map['content'] = content?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}