class MeasurementViewArg {
  MeasurementViewArg({
      this.isSusasthoV2,
      this.isAuto,

  });

  MeasurementViewArg.fromJson(dynamic json) {
    isSusasthoV2 = json['isSusasthoV2'];
    isAuto = json['isAuto'];
  }
  bool? isSusasthoV2;
  bool? isAuto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSusasthoV2'] = isSusasthoV2;
    map['isAuto'] = isAuto;
    return map;
  }

}