import 'package:cmed_lib_flutter/common/helper/utils.dart';

enum EyeScreeningTypeEnum {
  NEAR_VISION_BOTH_EYE(1,'N8', "Near Vision Test", "নিকটদৃষ্টি পরীক্ষা", 'Near Visual Acuity', 'নিকটদৃষ্টি পরীক্ষার','N.B: If your near visual acuity is more than N8, you should consult with an eye doctor soon', 'বি.দ্র :আপনার ফলাফল যদি N8 থেকে বেশি হয় তাহলে অতিসত্বর একজন চক্ষু বিশেষজ্ঞের পরামর্শ নিন'),
  FAR_VISION_DISTANCE_1(2,'', "Distance Vision Test", "দূরদৃষ্টি পরীক্ষা", 'Distance Visual Acuity', 'দূরদৃষ্টি','N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon', 'বি.দ্র.: আপনার দূরবর্তী দৃষ্টিসীমা যদি 6/9 থেকে বেশি হয় তাহলে অতিসত্বর একজন চক্ষু বিশেষজ্ঞের এর পরামর্শ নিন।'),
  ILLITERATE_TEST(3,'', "Distance Vision's Illiterate Test", "নিরক্ষর দৃষ্টি পরীক্ষা", 'Distance Visual Acuity', 'নিকটদৃষ্টি পরীক্ষার','N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon', 'বি.দ্র.: আপনার দূরবর্তী দৃষ্টিসীমা যদি 6/9 থেকে বেশি হয় তাহলে অতিসত্বর একজন চক্ষু বিশেষজ্ঞের এর পরামর্শ নিন।'),
  CHILDREN_EYE_TEST(4,'', "Distance Vision's Children Test", "শিশুদের দৃষ্টি পরীক্ষা", 'Distance Visual Acuity', 'নিকটদৃষ্টি পরীক্ষার','N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon', 'বি.দ্র.: আপনার দূরবর্তী দৃষ্টিসীমা যদি 6/9 থেকে বেশি হয় তাহলে অতিসত্বর একজন চক্ষু বিশেষজ্ঞের এর পরামর্শ নিন।'),
  COLOR_BLIND_TEST(5,'', "Color Blind Test", "বর্নান্ধতা পরীক্ষা", 'Color Blindness Test', 'বর্নান্ধতা পরীক্ষার','Possible Red-green deficiency. Please contact with an eye care professional soon',''),
  CONTRAST_TEST(6,'2.10 - 2.25', "Color Contrast Test", "কালার কন্ট্রাস্ট পরীক্ষা", 'Contrast Sensitivity Test', 'কালার কন্ট্রাস্ট পরীক্ষার','Your Score is : 0 & you have contrast sensitivity impairment.', '');

  const EyeScreeningTypeEnum(this.value, this.normalValue, this.nameEn, this.nameBn, this.titleEn, this.titleBn, this.suggestionEn, this.suggestionBn);

  final int value;
  final String normalValue;
  final String nameEn;
  final String nameBn;
  final String titleEn;
  final String titleBn;
  final String suggestionEn;
  final String suggestionBn;

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
    if(Utils.isLocaleBn()) {
      return enumValue.suggestionBn;
    } else {
      return enumValue.suggestionEn;
    }
  }
}

enum EyeScreeningColorBlindResultEnum {
  GOOD('No red-green deficiency', 'লাল সবুজ ঘাটতি নেই', 'GOOD', 'GOOD'),
  BAD('Possible Red-green deficiency. Please contact with an eye care professional soon', 'সম্ভাব্য লাল-সবুজ ঘাটতি। অতিসত্বর একজন চক্ষু বিশেষজ্ঞের পরামর্শ নিন', 'BAD', 'BAD');

  const EyeScreeningColorBlindResultEnum(this.titleEn, this.titleBn, this.resultEn, this.resultBn);

  final String titleEn;
  final String titleBn;
  final String resultEn;
  final String resultBn;

  static EyeScreeningColorBlindResultEnum? getEnumByName(String? name) {
    for (EyeScreeningColorBlindResultEnum enm in EyeScreeningColorBlindResultEnum.values) {
      if (enm.name == name) {
        return enm;
      }
    }
    return null;
  }

  static String getResultByName(String? name) {
    if(Utils.isLocaleBn()) {
      return getEnumByName(name)?.resultBn??'';
    } else {
      return getEnumByName(name)?.resultEn??'';
    }
  }

  static String getTitleByName(String? name) {
    if(Utils.isLocaleBn()) {
      return getEnumByName(name)?.titleBn??'';
    } else {
      return getEnumByName(name)?.titleEn??'';
    }
  }
}


enum ControllButtonForIlliterateEnum{
  UP('Up', 'উপরে'),
  DOWN('Down', 'নিচে'),
  LEFT('Left', 'বামে'),
  RIGHT('Right', 'ডানে');
  const ControllButtonForIlliterateEnum(this.labelEn, this.labelBn);
  final String labelEn;
  final String labelBn;

  static String getLabelByEnum(ControllButtonForIlliterateEnum enumValue) {
    if(Utils.isLocaleBn()) {
      return enumValue.labelBn;
    } else {
      return enumValue.labelEn;
    }
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