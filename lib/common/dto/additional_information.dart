class AdditionalInformation {
  AdditionalInformation({
      this.migrationStatus,});

  AdditionalInformation.fromJson(dynamic json) {
    migrationStatus = json['Migration Status'];
  }
  String? migrationStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Migration Status'] = migrationStatus;
    return map;
  }

}