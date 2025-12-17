class MeasurementTag {
  String? label;
  String? code;
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  int? createdById;
  int? updatedById;
  int? tagId;

  MeasurementTag(
      {this.label,
      this.code,
      this.id,
      this.uuid,
      this.createdAt,
      this.lastUpdated,
      this.createdById,
      this.updatedById,
      this.tagId});

  MeasurementTag.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    code = json['code'];
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    tagId = json['tag_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['code'] = code;
    data['id'] = id;
    data['uuid'] = uuid;
    data['created_at'] = createdAt;
    data['last_updated'] = lastUpdated;
    data['created_by_id'] = createdById;
    data['updated_by_id'] = updatedById;
    data['tag_id'] = tagId;
    return data;
  }

  static var glucoseTags = [
    MeasurementTag(label: "Random", code: "RANDOM", tagId: 9),
    MeasurementTag(label: "Fasting", code: "FASTING", tagId: 10),
    MeasurementTag(label: "OGTT", code: "OGTT", tagId: 11)
  ];
}
