class BscanInputDto {
  BscanInputDto({
      this.prfAge, 
      this.prfBmiHeights, 
      this.prfBmiWeights, 
      this.prfMenstrualPeriodAge, 
      this.prfMarried, 
      this.prfHaveChildren, 
      this.prfFirstChildBirthAge, 
      this.prfChildBreastFeed, 
      this.prfBreastDisease, 
      this.frfMother, 
      this.frfSister, 
      this.frfDaughter, 
      this.frfMaternalAunt, 
      this.frfMaternalGrandmother, 
      this.frfPaternalAunt, 
      this.frfPaternalGrandmother, 
      this.bsaDiscomfortorArmpit, 
      this.bsaAbnormalSizeOrChangeShape, 
      this.bsaDimpledOrNippleLikeAnOrange, 
      this.bsaWoundOrUlcerNippleForTwoMonth, 
      this.bsaNippleTurnedInwardsNotOutwards, 
      this.bsaDischargeFromNippleAsBloodOrPus, 
      this.bsaRednessTtLastTwoWeeks, 
      this.bsaLumpOrSwelling, 
      this.bsaLumpOrSwellingInArmpit,});

  BscanInputDto.fromJson(dynamic json) {
    prfAge = json['PRF_AGE'];
    prfBmiHeights = json['PRF_BMI_HEIGHTS'];
    prfBmiWeights = json['PRF_BMI_WEIGHTS'];
    prfMenstrualPeriodAge = json['PRF_MENSTRUAL_PERIOD_AGE'];
    prfMarried = json['PRF_MARRIED'];
    prfHaveChildren = json['PRF_HAVE_CHILDREN'];
    prfFirstChildBirthAge = json['PRF_FIRST_CHILD_BIRTH_AGE'];
    prfChildBreastFeed = json['PRF_CHILD_BREASTFEED'];
    prfBreastDisease = json['PRF_BREAST_DISEASE'];
    frfMother = json['FRF_MOTHER'];
    frfSister = json['FRF_SISTER'];
    frfDaughter = json['FRF_DAUGHTER'];
    frfMaternalAunt = json['FRF_MATERNAL_AUNT'];
    frfMaternalGrandmother = json['FRF_MATERNAL_GRANDMOTHER'];
    frfPaternalAunt = json['FRF_PATERNAL_AUNT'];
    frfPaternalGrandmother = json['FRF_PATERNAL_GRANDMOTHER'];
    bsaDiscomfortorArmpit = json['BSA_DISCOMFORT_OR_ARMPIT'];
    bsaAbnormalSizeOrChangeShape = json['BSA_ABNORMAL_SIZE_OR_CHANGE_SHAPE'];
    bsaDimpledOrNippleLikeAnOrange = json['BSA_DIMPLED_OR_NIPPLE_LIKE_AN_ORANGE'];
    bsaWoundOrUlcerNippleForTwoMonth = json['BSA_WOUND_OR_ULCER_NIPPLE_FOR_TWO_MONTH'];
    bsaNippleTurnedInwardsNotOutwards = json['BSA_NIPPLE_TURNED_INWARDS_NOT_OUTWARDS'];
    bsaDischargeFromNippleAsBloodOrPus = json['BSA_DISCHARGE_FROM_NIPPLE_AS_BLOOD_OR_PUS'];
    bsaRednessTtLastTwoWeeks = json['BSA_REDNESS_AT_LAST_TWO_WEEKS'];
    bsaLumpOrSwelling = json['BSA_LUMP_OR_SWELLING'];
    bsaLumpOrSwellingInArmpit = json['BSA_LUMP_OR_SWELLING_IN_ARMPIT'];
  }
  num? prfAge;
  num? prfBmiHeights;
  num? prfBmiWeights;
  num? prfMenstrualPeriodAge;
  num? prfMarried;
  num? prfHaveChildren;
  num? prfFirstChildBirthAge;
  num? prfChildBreastFeed;
  num? prfBreastDisease;
  num? frfMother;
  num? frfSister;
  num? frfDaughter;
  num? frfMaternalAunt;
  num? frfMaternalGrandmother;
  num? frfPaternalAunt;
  num? frfPaternalGrandmother;
  num? bsaDiscomfortorArmpit;
  num? bsaAbnormalSizeOrChangeShape;
  num? bsaDimpledOrNippleLikeAnOrange;
  num? bsaWoundOrUlcerNippleForTwoMonth;
  num? bsaNippleTurnedInwardsNotOutwards;
  num? bsaDischargeFromNippleAsBloodOrPus;
  num? bsaRednessTtLastTwoWeeks;
  num? bsaLumpOrSwelling;
  num? bsaLumpOrSwellingInArmpit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PRF_AGE'] = prfAge;
    map['PRF_BMI_HEIGHTS'] = prfBmiHeights;
    map['PRF_BMI_WEIGHTS'] = prfBmiWeights;
    map['PRF_MENSTRUAL_PERIOD_AGE'] = prfMenstrualPeriodAge;
    map['PRF_MARRIED'] = prfMarried;
    map['PRF_HAVE_CHILDREN'] = prfHaveChildren;
    map['PRF_FIRST_CHILD_BIRTH_AGE'] = prfFirstChildBirthAge;
    map['PRF_CHILD_BREASTFEED'] = prfChildBreastFeed;
    map['PRF_BREAST_DISEASE'] = prfBreastDisease;
    map['FRF_MOTHER'] = frfMother;
    map['FRF_SISTER'] = frfSister;
    map['FRF_DAUGHTER'] = frfDaughter;
    map['FRF_MATERNAL_AUNT'] = frfMaternalAunt;
    map['FRF_MATERNAL_GRANDMOTHER'] = frfMaternalGrandmother;
    map['FRF_PATERNAL_AUNT'] = frfPaternalAunt;
    map['FRF_PATERNAL_GRANDMOTHER'] = frfPaternalGrandmother;
    map['BSA_DISCOMFORT_OR_ARMPIT'] = bsaDiscomfortorArmpit;
    map['BSA_ABNORMAL_SIZE_OR_CHANGE_SHAPE'] = bsaAbnormalSizeOrChangeShape;
    map['BSA_DIMPLED_OR_NIPPLE_LIKE_AN_ORANGE'] = bsaDimpledOrNippleLikeAnOrange;
    map['BSA_WOUND_OR_ULCER_NIPPLE_FOR_TWO_MONTH'] = bsaWoundOrUlcerNippleForTwoMonth;
    map['BSA_NIPPLE_TURNED_INWARDS_NOT_OUTWARDS'] = bsaNippleTurnedInwardsNotOutwards;
    map['BSA_DISCHARGE_FROM_NIPPLE_AS_BLOOD_OR_PUS'] = bsaDischargeFromNippleAsBloodOrPus;
    map['BSA_REDNESS_AT_LAST_TWO_WEEKS'] = bsaRednessTtLastTwoWeeks;
    map['BSA_LUMP_OR_SWELLING'] = bsaLumpOrSwelling;
    map['BSA_LUMP_OR_SWELLING_IN_ARMPIT'] = bsaLumpOrSwellingInArmpit;
    return map;
  }

}