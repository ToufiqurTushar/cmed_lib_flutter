class DeviceBodyComposition {
  DeviceBodyComposition({
      this.age, 
      this.bodyFatMap, 
      this.gender, 
      this.height, 
      this.weight,});

  DeviceBodyComposition.fromJson(dynamic json) {
    age = json['age'];
    bodyFatMap = json['bodyFatMap'] != null ? BodyFatMap.fromJson(json['bodyFatMap']) : null;
    gender = json['gender'];
    height = json['height'];
    weight = json['weight'];
  }
  num? age;
  BodyFatMap? bodyFatMap;
  num? gender;
  num? height;
  num? weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['age'] = age;
    if (bodyFatMap != null) {
      map['bodyFatMap'] = bodyFatMap?.toJson();
    }
    map['gender'] = gender;
    map['height'] = height;
    map['weight'] = weight;
    return map;
  }

}

class BodyFatMap {
  BodyFatMap({
      this.weightcontrol, 
      this.musclemass, 
      this.proteinmass, 
      this.bmr, 
      this.fatmass, 
      this.musclerate, 
      this.proteinrate, 
      this.weightwithoutfat, 
      this.bonemass, 
      this.bfr, 
      this.metabolicage, 
      this.bodywater, 
      this.vfi, 
      this.stdweight, 
      this.obesitylevel, 
      this.sfr, 
      this.bmi,});

  BodyFatMap.fromJson(dynamic json) {
    weightcontrol = json['WEIGHT_CONTROL'];
    musclemass = json['MUSCLE_MASS'];
    proteinmass = json['PROTEIN_MASS'];
    bmr = json['BMR'];
    fatmass = json['FAT_MASS'];
    musclerate = json['MUSCLE_RATE'];
    proteinrate = json['PROTEIN_RATE'];
    weightwithoutfat = json['WEIGHT_WITHOUT_FAT'];
    bonemass = json['BONE_MASS'];
    bfr = json['BFR'];
    metabolicage = json['METABOLIC_AGE'];
    bodywater = json['BODY_WATER'];
    vfi = json['VFI'];
    stdweight = json['STD_WEIGHT'];
    obesitylevel = json['OBESITY_LEVEL'];
    sfr = json['SFR'];
    bmi = json['BMI'];
  }
  String? weightcontrol;
  String? musclemass;
  String? proteinmass;
  String? bmr;
  String? fatmass;
  String? musclerate;
  String? proteinrate;
  String? weightwithoutfat;
  String? bonemass;
  String? bfr;
  String? metabolicage;
  String? bodywater;
  String? vfi;
  String? stdweight;
  String? obesitylevel;
  String? sfr;
  String? bmi;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['WEIGHT_CONTROL'] = weightcontrol;
    map['MUSCLE_MASS'] = musclemass;
    map['PROTEIN_MASS'] = proteinmass;
    map['BMR'] = bmr;
    map['FAT_MASS'] = fatmass;
    map['MUSCLE_RATE'] = musclerate;
    map['PROTEIN_RATE'] = proteinrate;
    map['WEIGHT_WITHOUT_FAT'] = weightwithoutfat;
    map['BONE_MASS'] = bonemass;
    map['BFR'] = bfr;
    map['METABOLIC_AGE'] = metabolicage;
    map['BODY_WATER'] = bodywater;
    map['VFI'] = vfi;
    map['STD_WEIGHT'] = stdweight;
    map['OBESITY_LEVEL'] = obesitylevel;
    map['SFR'] = sfr;
    map['BMI'] = bmi;
    return map;
  }

}