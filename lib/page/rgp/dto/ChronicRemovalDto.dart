class ChronicRemovalDto {
  ChronicRemovalDto({
      this.userId, 
      this.memberId, 
      this.profileId, 
      this.reason,
      this.condition,});

  ChronicRemovalDto.fromJson(dynamic json) {
    userId = json['user_id'];
    memberId = json['member_id'];
    profileId = json['profile_id'];
    condition = json['condition'];
    reason = json['reason'];
  }
  int? userId;
  int? memberId;
  int? profileId;
  String? condition;
  String? reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['member_id'] = memberId;
    map['profile_id'] = profileId;
    map['condition'] = condition;
    map['reason'] = reason;
    return map;
  }

}