import '../../../common/dto/base_entity_dto.dart';

class Attribute extends BaseEntity {
  String? name;
  String? unit;
  String? code;
  int order;
  int? id;
  int? measurementTypeId;

  // Constructor
  Attribute({
    this.name,
    this.unit,
    this.code,
    required this.order,
    this.id,
    this.measurementTypeId,
  });

  // fromJson constructor
  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'] as String?,
      unit: json['unit'] as String?,
      code: json['code'] as String?,
      order: json['order'] as int,
      id: json['id'] as int?,
      measurementTypeId: json['measurement_type_id'] as int?,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data.addAll({
      'name': name,
      'unit': unit,
      'code': code,
      'order': order,
      'id': id,
      'measurement_type_id': measurementTypeId,
    });
    return data;
  }
}
