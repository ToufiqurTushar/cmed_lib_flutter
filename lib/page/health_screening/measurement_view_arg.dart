class MeasurementViewArg {
  MeasurementViewArg({
      this.isSusasthoV2,});

  MeasurementViewArg.fromJson(dynamic json) {
    isSusasthoV2 = json['isSusasthoV2'];
  }
  bool? isSusasthoV2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSusasthoV2'] = isSusasthoV2;
    return map;
  }

}