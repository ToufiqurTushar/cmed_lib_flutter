
import 'Condition.dart';

class SkipRule {
  SkipRule({
      this.conditions, 
      this.skipTo, 
      this.skipType,});

  SkipRule.fromJson(dynamic json) {
    if (json['conditions'] != null) {
      conditions = [];
      json['conditions'].forEach((v) {
        conditions?.add(Condition.fromJson(v));
      });
    }
    skipTo = json['skipTo'];
    skipType = json['skipType'];
  }
  List<Condition>? conditions;
  String? skipTo;
  String? skipType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (conditions != null) {
      map['conditions'] = conditions?.map((v) => v.toJson()).toList();
    }
    map['skipTo'] = skipTo;
    map['skipType'] = skipType;
    return map;
  }

}