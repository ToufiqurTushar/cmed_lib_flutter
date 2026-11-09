class HouseholdSurevyMember {
  HouseholdSurevyMember({
      this.userId, 
      this.memberId, 
      this.profileId, 
      this.display, 
      this.value, 
      this.lmpDate, 
      this.eddDate,});

  HouseholdSurevyMember.fromJson(dynamic json) {
    userId = json['user_id'];
    memberId = json['member_id'];
    profileId = json['profile_id'];
    display = json['display'];
    value = json['value'];
    lmpDate = json['lmp_date'];
    eddDate = json['edd_date'];
  }
  int? userId;
  int? memberId;
  int? profileId;
  String? display;
  String? value;
  int? lmpDate;
  int? eddDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['member_id'] = memberId;
    map['profile_id'] = profileId;
    map['display'] = display;
    map['value'] = value;
    map['lmp_date'] = lmpDate;
    map['edd_date'] = eddDate;
    return map;
  }

}