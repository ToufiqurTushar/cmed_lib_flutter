import '../../../survey/dto/field_dto.dart';

class HouseholdSurevyMember {
  HouseholdSurevyMember({
    this.userId,
    this.memberId,
    this.profileId,
    this.display,
    this.value,
    this.lmpDate,
    this.eddDate,
    this.healthCardNumber,
    this.healthCardCost,
    this.healthCardIssueDate,
    this.healthCardExpireDate,
    this.dead,
    this.dateOfDeath,
    this.condition,
    this.reason,
    this.fields,
    this.inputs,
    this.isHidden,
  });

  HouseholdSurevyMember.fromJson(dynamic json) {
    if (json == null || json is! Map) return;
    userId = json['user_id'];
    memberId = json['member_id'];
    profileId = json['profile_id'];
    display = json['display'];
    value = json['value']?.toString();
    lmpDate = json['lmp_date'];
    eddDate = json['edd_date'];
    healthCardNumber = json['health_card_number']?.toString();
    if (json['health_card_cost'] != null) {
      healthCardCost = (json['health_card_cost'] as num).toDouble();
    }
    healthCardIssueDate = json['health_card_issue_date'];
    healthCardExpireDate = json['health_card_expire_date'];
    dead = json['dead'];
    isHidden = json['isHidden'];
    dateOfDeath = json['date_of_death'];
    condition = json['condition']?.toString();
    reason = json['reason']?.toString();
    if (json['fields'] != null) {
      fields = [];
      json['fields'].forEach((v) {
        if (v is Field) {
          fields?.add(v);
        } else {
          fields?.add(Field.fromJson(v));
        }
      });
    }
    if (json['inputs'] != null && json['inputs'] is Map) {
      inputs = Map<String, dynamic>.from(json['inputs']);
    }
  }

  int? userId;
  int? memberId;
  int? profileId;
  String? display;
  String? value;
  int? lmpDate;
  int? eddDate;
  String? healthCardNumber;
  double? healthCardCost;
  int? healthCardIssueDate;
  int? healthCardExpireDate;
  bool? dead;
  bool? isHidden;
  int? dateOfDeath;
  String? condition;
  String? reason;
  List<Field>? fields;
  Map<String, dynamic>? inputs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['member_id'] = memberId;
    map['profile_id'] = profileId;
    map['display'] = display;
    map['value'] = value;
    map['lmp_date'] = lmpDate;
    map['edd_date'] = eddDate;
    map['isHidden'] = isHidden;
    if (healthCardNumber != null) {
      map['health_card_number'] = healthCardNumber;
    }
    if (healthCardCost != null) {
      map['health_card_cost'] = healthCardCost;
    }
    if (healthCardIssueDate != null) {
      map['health_card_issue_date'] = healthCardIssueDate;
    }
    if (healthCardExpireDate != null) {
      map['health_card_expire_date'] = healthCardExpireDate;
    }
    if (dead != null) {
      map['dead'] = dead;
    }
    if (dateOfDeath != null) {
      map['date_of_death'] = dateOfDeath;
    }
    if (condition != null) {
      map['condition'] = condition;
    }
    if (reason != null) {
      map['reason'] = reason;
    }
    if (inputs != null) {
      inputs!.forEach((key, val) {
        if (!map.containsKey(key)) {
          map[key] = val;
        }
      });
    }
    if (fields != null) {
      map['fields'] = fields?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  HouseholdSurevyMember copyWith({
    int? userId,
    int? memberId,
    int? profileId,
    String? display,
    String? value,
    int? lmpDate,
    int? eddDate,
    String? healthCardNumber,
    double? healthCardCost,
    int? healthCardIssueDate,
    int? healthCardExpireDate,
    bool? dead,
    int? dateOfDeath,
    String? condition,
    String? reason,
    List<Field>? fields,
    Map<String, dynamic>? inputs,
  }) {
    return HouseholdSurevyMember(
      userId: userId ?? this.userId,
      memberId: memberId ?? this.memberId,
      profileId: profileId ?? this.profileId,
      display: display ?? this.display,
      value: value ?? this.value,
      lmpDate: lmpDate ?? this.lmpDate,
      eddDate: eddDate ?? this.eddDate,
      healthCardNumber: healthCardNumber ?? this.healthCardNumber,
      healthCardCost: healthCardCost ?? this.healthCardCost,
      healthCardIssueDate: healthCardIssueDate ?? this.healthCardIssueDate,
      healthCardExpireDate: healthCardExpireDate ?? this.healthCardExpireDate,
      dead: dead ?? this.dead,
      dateOfDeath: dateOfDeath ?? this.dateOfDeath,
      condition: condition ?? this.condition,
      reason: reason ?? this.reason,
      fields: fields ?? this.fields?.map((f) => Field.fromJson(f.toJson())).toList(),
      inputs: inputs ?? (this.inputs != null ? Map<String, dynamic>.from(this.inputs!) : null),
    );
  }
}
