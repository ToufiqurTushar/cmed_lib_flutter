class FieldCondition {
  FieldCondition({
      this.hide,
      this.sourceField, 
      this.operator, 
      this.expectedValue, 
      this.logic, 
      this.effectType,});

  FieldCondition.fromJson(dynamic json) {
    hide = json['hide'];
    sourceField = json['sourceField'];
    operator = json['operator'];
    expectedValue = json['expectedValue'] != null ? json['expectedValue'].cast<String>() : [];
    logic = json['logic'];
    effectType = json['effectType'];
  }
  bool? hide;
  String? sourceField;
  String? operator;
  List<String>? expectedValue;
  String? logic;
  String? effectType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hide'] = hide;
    map['sourceField'] = sourceField;
    map['operator'] = operator;
    map['expectedValue'] = expectedValue;
    map['logic'] = logic;
    map['effectType'] = effectType;
    return map;
  }

}