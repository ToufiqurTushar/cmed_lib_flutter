import 'dart:convert';

import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

class BodyFatRuleDto {
  BodyFatRuleDto({
      this.colorCode, 
      this.comment, 
      this.defBn, 
      this.defEn, 
      this.femaleNormalRanges, 
      this.maleNormalRanges, 
      this.type,});

  BodyFatRuleDto.fromJson(dynamic json) {
    colorCode = json['color_code'];
    comment = json['comment'];
    defBn = json['def_bn'];
    defEn = json['def_en'];
    if (json['normal_range_female'] != null) {
      femaleNormalRanges = [];
      json['normal_range_female'].forEach((v) {
        femaleNormalRanges?.add(NormalRange.fromJson(v));
      });
    }
    if (json['normal_range_male'] != null) {
      maleNormalRanges = [];
      json['normal_range_male'].forEach((v) {
        maleNormalRanges?.add(NormalRange.fromJson(v));
      });
    }
    type = json['type'];
  }
  String? colorCode;
  String? comment;
  String? defBn;
  String? defEn;
  List<NormalRange>? femaleNormalRanges;
  List<NormalRange>? maleNormalRanges;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['color_code'] = colorCode;
    map['comment'] = comment;
    map['def_bn'] = defBn;
    map['def_en'] = defEn;
    if (femaleNormalRanges != null) {
      map['normal_range_female'] = femaleNormalRanges?.map((v) => v.toJson()).toList();
    }
    if (maleNormalRanges != null) {
      map['normal_range_male'] = maleNormalRanges?.map((v) => v.toJson()).toList();
    }
    map['type'] = type;
    return map;
  }

  static fromJsonList(list) => List<BodyFatRuleDto>.from(list.map((x) => BodyFatRuleDto.fromJson(x)));

  static Future<List<BodyFatRuleDto>> getBodyFatRules() async {
    final String jsonString = await rootBundle.loadString('assets/json/body_composition_rules.json');
    final List<BodyFatRuleDto> bodyFatRules = BodyFatRuleDto.fromJsonList(jsonDecode(jsonString));
    return bodyFatRules;
  }

  static void getBodyCompositionData({
    required String type,
    required dynamic value,
    required int gender,
    required List<BodyFatRuleDto> allRules,
    required void Function(BodyFatRuleDto bodyFatRule, String colorCode, String advice, String adviceBn, String status, String statusBn) result,
  }) async {
    double score = 0.0;
    if(value is double) {
      score = value;
    } else if(value is String) {
      score = double.parse(value);
    } else if(value is int) {
      score = value.toDouble();
    }

    BodyFatRuleDto? bodyFatRule = allRules.firstWhereOrNull((e)=>e.type == type);
      if(bodyFatRule == null) {
        return;
      }
      List<NormalRange>? normalRanges = bodyFatRule.maleNormalRanges;
      if(normalRanges == null){
        RLog.error("No range found! $type");
        result(bodyFatRule, "#000000", '', '', '', '');
        return;
      }
      if(gender == 2){
        normalRanges = bodyFatRule.femaleNormalRanges!;
      }

      for (int i = normalRanges.length - 1; i >= 0; i--) {
        if (i == normalRanges.length - 1) {
          normalRanges[i].rangeEnd = double.infinity;
        }
        if (i > 0) {
          normalRanges[i].rangeStart = normalRanges[i - 1].rangeEnd! + 0.1;
        }
        if (i != 0 && i != normalRanges.length - 1 && normalRanges[i].rangeEnd == 0.0) {
          normalRanges[i].rangeEnd = (normalRanges[i + 1].rangeStart ?? 0) - 0.1;
        }
      }

      final currentStatus = normalRanges.firstWhere((NormalRange normalRange) =>
      (normalRange.rangeStart ?? 0) <= score && (normalRange.rangeEnd == 0.0 ? 9999.0 : (normalRange.rangeEnd ?? 9999.0)) >= score,
        orElse: () => NormalRange(), // Default/fallback Status
      );

      result(bodyFatRule, currentStatus.colorCode ?? "#000000", currentStatus.adviceEn??'', currentStatus.adviceBn??'', currentStatus.statusEn??'', currentStatus.statusBn??'');

  }
}

class NormalRange {
  NormalRange({
    this.adviceBn,
    this.adviceEn,
    this.colorCode,
    this.rangeEnd,
    this.rangeStart,
    this.statusBn,
    this.statusEn,});

  NormalRange.fromJson(dynamic json) {
    adviceBn = json['advice_bn'];
    adviceEn = json['advice_en'];
    colorCode = json['color_code'];
    rangeEnd = json['range_end'];
    rangeStart = json['range_start'];
    statusBn = json['status_bn'];
    statusEn = json['status_en'];
  }
  String? adviceBn;
  String? adviceEn;
  String? colorCode;
  num? rangeEnd;
  num? rangeStart;
  String? statusBn;
  String? statusEn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['advice_bn'] = adviceBn;
    map['advice_en'] = adviceEn;
    map['color_code'] = colorCode;
    map['range_end'] = rangeEnd;
    map['range_start'] = rangeStart;
    map['status_bn'] = statusBn;
    map['status_en'] = statusEn;
    return map;
  }

}
