
import 'field_dto.dart';

class SurveyDataResponseDto {
  SurveyDataResponseDto({
      this.content,});

  SurveyDataResponseDto.fromJson(dynamic json) {
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content?.add(SurveyDto.fromJson(v));
      });
    }
  }
  List<SurveyDto>? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) {
      map['content'] = content?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class SurveyDto {
  SurveyDto({
    this.id,
    this.uuid,
    this.createdAt,
    this.lastUpdated,
    this.createdById,
    this.updatedById,
    this.groupName,
    this.name,
    this.icon,
    this.otherLanguageName,
    this.fields,});

  SurveyDto.fromJson(dynamic json) {
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    groupName = json['group_name'];
    name = json['name'];
    icon = json['icon'];
    otherLanguageName = json['other_language_name'];
    if (json['fields'] != null) {
      fields = [];
      json['fields'].forEach((v) {
        fields?.add(Field.fromJson(v));
      });
    }
  }
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  String? groupName;
  String? name;
  String? icon;
  String? otherLanguageName;
  List<Field>? fields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['created_at'] = createdAt;
    map['last_updated'] = lastUpdated;
    map['created_by_id'] = createdById;
    map['updated_by_id'] = updatedById;
    map['group_name'] = groupName;
    map['name'] = name;
    map['icon'] = icon;
    map['other_language_name'] = otherLanguageName;
    if (fields != null) {
      map['fields'] = fields?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  static fromJsonList(list) => List<SurveyDto>.from(list.map((x) => SurveyDto.fromJson(x)));

}