class BodyComposition {
  BodyComposition({
      this.bodyFatData, 
      this.cAdc, 
      this.cAge, 
      this.cBfr, 
      this.cBm, 
      this.cBmi, 
      this.cBmr, 
      this.cBodyAge, 
      this.cFatMass, 
      this.cFatNotWeight, 
      this.cHeight, 
      this.cMuscleMass, 
      this.cNumber, 
      this.cObesityStatus, 
      this.cPp, 
      this.cProteinMass, 
      this.cRom, 
      this.cSex, 
      this.cSfr, 
      this.cStdWeight, 
      this.cUvi, 
      this.cVwc, 
      this.cWeight, 
      this.cWeightDiff, 
      this.cWeightDiffStatus, 
      this.maleWeight,});

  BodyComposition.fromJson(dynamic json) {
    bodyFatData = json['bodyFatData'] != null ? BodyFatData.fromJson(json['bodyFatData']) : null;
    cAdc = json['c_adc'];
    cAge = json['c_age'];
    cBfr = json['c_bfr'];
    cBm = json['c_bm'];
    cBmi = json['c_bmi'];
    cBmr = json['c_bmr'];
    cBodyAge = json['c_bodyAge'];
    cFatMass = json['c_fatMass'];
    cFatNotWeight = json['c_fatNotWeight'];
    cHeight = json['c_height'];
    cMuscleMass = json['c_muscleMass'];
    cNumber = json['c_number'];
    cObesityStatus = json['c_obesityStatus'];
    cPp = json['c_pp'];
    cProteinMass = json['c_proteinMass'];
    cRom = json['c_rom'];
    cSex = json['c_sex'];
    cSfr = json['c_sfr'];
    cStdWeight = json['c_stdWeight'];
    cUvi = json['c_uvi'];
    cVwc = json['c_vwc'];
    cWeight = json['c_weight'];
    cWeightDiff = json['c_weightDiff'];
    cWeightDiffStatus = json['c_weightDiffStatus'];
    maleWeight = json['maleWeight'];
  }
  BodyFatData? bodyFatData;
  int? cAdc;
  int? cAge;
  double? cBfr;
  double? cBm;
  double? cBmi;
  double? cBmr;
  int? cBodyAge;
  double? cFatMass;
  double? cFatNotWeight;
  int? cHeight;
  double? cMuscleMass;
  int? cNumber;
  String? cObesityStatus;
  double? cPp;
  double? cProteinMass;
  double? cRom;
  int? cSex;
  double? cSfr;
  double? cStdWeight;
  int? cUvi;
  double? cVwc;
  double? cWeight;
  double? cWeightDiff;
  String? cWeightDiffStatus;
  dynamic maleWeight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bodyFatData != null) {
      map['bodyFatData'] = bodyFatData?.toJson();
    }
    map['c_adc'] = cAdc;
    map['c_age'] = cAge;
    map['c_bfr'] = cBfr;
    map['c_bm'] = cBm;
    map['c_bmi'] = cBmi;
    map['c_bmr'] = cBmr;
    map['c_bodyAge'] = cBodyAge;
    map['c_fatMass'] = cFatMass;
    map['c_fatNotWeight'] = cFatNotWeight;
    map['c_height'] = cHeight;
    map['c_muscleMass'] = cMuscleMass;
    map['c_number'] = cNumber;
    map['c_obesityStatus'] = cObesityStatus;
    map['c_pp'] = cPp;
    map['c_proteinMass'] = cProteinMass;
    map['c_rom'] = cRom;
    map['c_sex'] = cSex;
    map['c_sfr'] = cSfr;
    map['c_stdWeight'] = cStdWeight;
    map['c_uvi'] = cUvi;
    map['c_vwc'] = cVwc;
    map['c_weight'] = cWeight;
    map['c_weightDiff'] = cWeightDiff;
    map['c_weightDiffStatus'] = cWeightDiffStatus;
    map['maleWeight'] = maleWeight;

    return map;
  }

}


class BodyFatData {
  BodyFatData({
      this.adc, 
      this.age, 
      this.bfr, 
      this.bm, 
      this.bmi, 
      this.bmr, 
      this.bodyAge, 
      this.date, 
      this.decimalInfo, 
      this.height, 
      this.number, 
      this.pp, 
      this.rom, 
      this.sex, 
      this.sfr, 
      this.time, 
      this.uvi, 
      this.vwc, 
      this.weight,});

  BodyFatData.fromJson(dynamic json) {
    adc = json['adc'];
    age = json['age'];
    bfr = json['bfr'];
    bm = json['bm'];
    bmi = json['bmi'];
    bmr = json['bmr'];
    bodyAge = json['bodyAge'];
    date = json['date'];
    decimalInfo = json['decimalInfo'] != null ? DecimalInfo.fromJson(json['decimalInfo']) : null;
    height = json['height'];
    number = json['number'];
    pp = json['pp'];
    rom = json['rom'];
    sex = json['sex'];
    sfr = json['sfr'];
    time = json['time'];
    uvi = json['uvi'];
    vwc = json['vwc'];
    weight = json['weight'];
  }
  int? adc;
  int? age;
  double? bfr;
  double? bm;
  double? bmi;
  double? bmr;
  int? bodyAge;
  String? date;
  DecimalInfo? decimalInfo;
  int? height;
  int? number;
  double? pp;
  double? rom;
  int? sex;
  double? sfr;
  String? time;
  int? uvi;
  double? vwc;
  double? weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['adc'] = adc;
    map['age'] = age;
    map['bfr'] = bfr;
    map['bm'] = bm;
    map['bmi'] = bmi;
    map['bmr'] = bmr;
    map['bodyAge'] = bodyAge;
    map['date'] = date;
    if (decimalInfo != null) {
      map['decimalInfo'] = decimalInfo?.toJson();
    }
    map['height'] = height;
    map['number'] = number;
    map['pp'] = pp;
    map['rom'] = rom;
    map['sex'] = sex;
    map['sfr'] = sfr;
    map['time'] = time;
    map['uvi'] = uvi;
    map['vwc'] = vwc;
    map['weight'] = weight;
    return map;
  }

}

class DecimalInfo {
  DecimalInfo({
      this.kgDecimal, 
      this.kgGraduation, 
      this.lbDecimal, 
      this.lbGraduation, 
      this.sourceDecimal, 
      this.stDecimal,});

  DecimalInfo.fromJson(dynamic json) {
    kgDecimal = json['kgDecimal'];
    kgGraduation = json['kgGraduation'];
    lbDecimal = json['lbDecimal'];
    lbGraduation = json['lbGraduation'];
    sourceDecimal = json['sourceDecimal'];
    stDecimal = json['stDecimal'];
  }
  int? kgDecimal;
  int? kgGraduation;
  int? lbDecimal;
  int? lbGraduation;
  int? sourceDecimal;
  int? stDecimal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kgDecimal'] = kgDecimal;
    map['kgGraduation'] = kgGraduation;
    map['lbDecimal'] = lbDecimal;
    map['lbGraduation'] = lbGraduation;
    map['sourceDecimal'] = sourceDecimal;
    map['stDecimal'] = stDecimal;
    return map;
  }

}