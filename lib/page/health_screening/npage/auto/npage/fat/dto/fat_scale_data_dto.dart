import 'package:cmed_lib_flutter/common/helper/utils.dart';

class FatScaleDataDto {
  FatScaleDataDto({
      this.asset, 
      this.title,
      this.titleBn,
      this.type,
      this.value,
      this.unit, 
      this.status, 
      this.statusColor, 
      this.colors, 
      this.results, 
      this.resultsBn,
      this.maxRanges,});

  FatScaleDataDto.fromJson(dynamic json) {
    asset = json['asset'];
    title = json['title'];
    titleBn = json['titleBn'];
    type = json['type'];
    value = json['value'];
    unit = json['unit'];
    status = json['status'];
    statusColor = json['statusColor'];
    colors = json['colors'] != null ? json['colors'].cast<String>() : [];
    results = json['results'] != null ? json['results'].cast<String>() : [];
    resultsBn = json['resultsBn'] != null ? json['resultsBn'].cast<String>() : [];
    maxRanges = json['maxRanges'] != null ? json['maxRanges'].cast<int>() : [];
  }

  String? asset;
  String? title;
  String? titleBn;
  String? type;
  dynamic value;
  String? unit;
  String? status;
  String? statusColor;
  List<String>? colors;
  List<String>? results;
  List<String>? resultsBn;
  List<double>? maxRanges;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['asset'] = asset;
    map['title'] = title;
    map['titleBn'] = titleBn;
    map['type'] = type;
    map['value'] = value;
    map['unit'] = unit;
    map['status'] = status;
    map['statusColor'] = statusColor;
    map['colors'] = colors;
    map['results'] = results;
    map['resultsBn'] = resultsBn;
    map['maxRanges'] = maxRanges;
    return map;
  }

  getValueWithUnit(){
    return "${value?.toString().trAmount()} ${unit??''}";
  }
}