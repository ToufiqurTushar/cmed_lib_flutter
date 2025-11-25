class SurveyResultItemDto {
  SurveyResultItemDto({
      this.inputs, 
      this.surveyOn, 
      this.surveyId, 
      this.userId, 
      this.surveyName, 
      this.uuid, 
      this.createdAt, 
      this.lastUpdated, 
      this.createdById,
      this.result,
      this.icon,
      this.updatedById,});

  SurveyResultItemDto.fromJson(dynamic json) {
    inputs = json['inputs'];
    surveyOn = json['survey_on'];
    surveyId = json['survey_id'];
    userId = json['user_id'];
    surveyName = json['survey_name'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    icon = json['icon'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  dynamic inputs;
  int? surveyOn;
  int? surveyId;
  int? userId;
  String? surveyName;
  String? uuid;
  String? icon;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inputs'] = inputs;
    map['survey_on'] = surveyOn;
    map['survey_id'] = surveyId;
    map['user_id'] = userId;
    map['survey_name'] = surveyName;
    map['icon'] = icon;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }

  static fromJsonList(list) => List<SurveyResultItemDto>.from(list.map((x) => SurveyResultItemDto.fromJson(x)));

}

class Result {
  Result({
    this.value,
    this.status,
    this.severity,
    this.remarks,
    this.suggestion,
    this.advice,
    this.colorCode,
    this.icon,});

  Result.fromJson(dynamic json) {
    value = json['value'];
    status = json['status'];
    severity = json['severity'];
    remarks = json['remarks'];
    suggestion = json['suggestion'];
    advice = json['advice'];
    colorCode = json['colorCode'];
    icon = json['icon'];
  }
  double? value;
  String? status;
  String? severity;
  String? remarks;
  String? suggestion;
  String? advice;
  String? colorCode;
  String? icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['status'] = status;
    map['severity'] = severity;
    map['remarks'] = remarks;
    map['suggestion'] = suggestion;
    map['advice'] = advice;
    map['colorCode'] = colorCode;
    map['icon'] = icon;
    return map;
  }

}