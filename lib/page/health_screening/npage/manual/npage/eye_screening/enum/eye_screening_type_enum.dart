import 'package:cmed_lib_flutter/common/helper/utils.dart';

enum EyeScreeningTypeEnum {
  NEAR_VISION_BOTH_EYE(1,'N8', "Near Vision Test", "নিকটদৃষ্টি পরীক্ষা", 'Near Visual Acuity', 'নিকটদৃষ্টি পরীক্ষার','N.B: If your near visual acuity is more than N8, you should consult with an eye doctor soon'),
  FAR_VISION_DISTANCE_1(2,'', "Distance Vision Test", "দূরদৃষ্টি পরীক্ষা", 'Distance Visual Acuity', 'দূরদৃষ্টি','N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon'),
  ILLITERATE_TEST(3,'', "Distance Vision's Illiterate Test", "নিরক্ষর দৃষ্টি পরীক্ষা", 'Distance Visual Acuity', 'নিরক্ষর দূরদৃষ্টি পরীক্ষার','N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon'),
  CHILDREN_EYE_TEST(4,'', "Distance Vision's Children Test", "শিশুদের দৃষ্টি পরীক্ষা", 'Distance Visual Acuity', 'শিশুদের দূরদৃষ্টি পরীক্ষার','N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon'),
  COLOR_BLIND_TEST(5,'', "Color Blind Test", "বর্নান্ধতা পরীক্ষা", 'Color Blindness Test', 'বর্নান্ধতা পরীক্ষার','Possible Red-green deficiency. Please contact with an eye care professional soon'),
  CONTRAST_TEST(6,'2.10 - 2.25', "Color Contrast Test", "কালার কন্ট্রাস্ট পরীক্ষা", 'Contrast Sensitivity Test', 'কালার কন্ট্রাস্ট পরীক্ষার','Your Score is : 0 & you have contrast sensitivity impairment.');

  const EyeScreeningTypeEnum(this.value, this.normalValue, this.nameEn, this.nameBn, this.titleEn, this.titleBn, this.suggestionEn);

  final int value;
  final String normalValue;
  final String nameEn;
  final String nameBn;
  final String titleEn;
  final String titleBn;
  final String suggestionEn;
  //final String suggestionBn;

  static EyeScreeningTypeEnum? getEnumByName(String? name) {
    for (EyeScreeningTypeEnum enm in EyeScreeningTypeEnum.values) {
      if (enm.name == name) {
        return enm;
      }
    }
    return null;
  }

  static String getNameByNameType(String? name) {
    if(Utils.isLocaleBn()) {
      return getEnumByName(name)?.nameBn??'';
    } else {
      return getEnumByName(name)?.nameEn??'';
    }
  }
  static String getSuggestionByEnum(EyeScreeningTypeEnum enumValue) {
    return enumValue.suggestionEn;
  }
}

enum EyeScreeningColorBlindResultEnum {
  GOOD('No red-green deficiency', 'GOOD'),
  BAD('Possible Red-green deficiency. Please contact with an eye care professional soon','BAD');

  const EyeScreeningColorBlindResultEnum(this.titleEn, this.resultEn);

  final String titleEn;
  final String resultEn;

  static EyeScreeningColorBlindResultEnum? getEnumByName(String? name) {
    for (EyeScreeningColorBlindResultEnum enm in EyeScreeningColorBlindResultEnum.values) {
      if (enm.name == name) {
        return enm;
      }
    }
    return null;
  }

  static String getResultByName(String? name) {
    return getEnumByName(name)?.resultEn??'';
  }

  static String getTitleByName(String? name) {
    return getEnumByName(name)?.titleEn??'';
  }
}


enum ControllButtonForIlliterateEnum{
  UP('Up'),
  DOWN('Down'),
  LEFT('Left'),
  RIGHT('Right');
  const ControllButtonForIlliterateEnum(this.labelEn);
  final String labelEn;

  static String getLabelByEnum(ControllButtonForIlliterateEnum enumValue) {
    return enumValue.labelEn;
  }
}

enum EyeScreeningColorContrastResultEnum {
  VISUAL_IMPAIRMENT('Visual impairment', 'দৃষ্টি শক্তি হ্রাস'),
  NORMAL_CONTRAST_SENSITIVITY('Normal contrast Sensitivity', 'স্বাভাবিক কনট্রাস্ট সংবেদনশীলতা'),
  POOR_CONTRAST_SENSITIVITY('Poor contrast Sensitivity', 'দুর্বল কনট্রাস্ট সংবেদনশীলতা');

  const EyeScreeningColorContrastResultEnum(this.titleEn, this.titleBn);

  final String titleEn;
  final String titleBn;

  static EyeScreeningColorContrastResultEnum? getEnumByName(String? name) {
    for (EyeScreeningColorContrastResultEnum enm in EyeScreeningColorContrastResultEnum.values) {
      if (enm.name == name) {
        return enm;
      }
    }
    return null;
  }

  static EyeScreeningColorContrastResultEnum? getEnumBasedOnResult(String result) {
    if((num.tryParse(result)??0) > 2) {
      return EyeScreeningColorContrastResultEnum.NORMAL_CONTRAST_SENSITIVITY;
    } else if((num.tryParse(result)??0) > 1.5) {
      return EyeScreeningColorContrastResultEnum.POOR_CONTRAST_SENSITIVITY;
    } else {
      return EyeScreeningColorContrastResultEnum.VISUAL_IMPAIRMENT;
    }
  }

  static String getTitleBasedOnResult(String result) {
    if(Utils.isLocaleBn()) {
      return getEnumBasedOnResult(result)?.titleBn??'';
    } else {
      return getEnumBasedOnResult(result)?.titleEn??'';
    }
  }
}