class MeasurementViewArg {
  MeasurementViewArg({
      this.isV2,});

  MeasurementViewArg.fromJson(dynamic json) {
    isV2 = json['isV2'];
  }
  bool? isV2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isV2'] = isV2;
    return map;
  }

}