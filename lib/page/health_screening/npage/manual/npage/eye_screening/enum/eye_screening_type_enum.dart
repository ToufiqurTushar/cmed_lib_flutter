import 'package:cmed_lib_flutter/common/helper/utils.dart';

enum EyeScreeningTypeEnum {
  NEAR_VISION_BOTH_EYE(1,'N8', "label_near_vision_test", 'Near Visual Acuity', 'N.B: If your near visual acuity is more than N8, you should consult with an eye doctor soon'),
  FAR_VISION_DISTANCE_1(2,'', "label_distance_vision_test", 'Distance Visual Acuity', 'N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon'),
  ILLITERATE_TEST(3,'', "Distance Vision's Illiterate Test", 'Distance Visual Acuity', 'N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon'),
  CHILDREN_EYE_TEST(4,'', "Distance Vision's Children Test", 'Distance Visual Acuity','N.B: If your distance visual acuity is more than 6/9, you should consult with an eye doctor soon'),
  COLOR_BLIND_TEST(5,'', "label_color_blind_test", 'Color Blindness Test', 'Possible Red-green deficiency. Please contact with an eye care professional soon'),
  CONTRAST_TEST(6,'2.10 - 2.25', "label_color_contrast_test", 'Contrast Sensitivity Test', 'Your Score is : 0 & you have contrast sensitivity impairment.');

  const EyeScreeningTypeEnum(this.value, this.normalValue, this.nameEn, this.titleEn, this.suggestionEn);

  final int value;
  final String normalValue;
  final String nameEn;
  final String titleEn;
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
    return getEnumByName(name)?.nameEn??'';
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
  VISUAL_IMPAIRMENT('Visual impairment'),
  NORMAL_CONTRAST_SENSITIVITY('Normal contrast Sensitivity'),
  POOR_CONTRAST_SENSITIVITY('Poor contrast Sensitivity');

  const EyeScreeningColorContrastResultEnum(this.titleEn);

  final String titleEn;

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
    return getEnumBasedOnResult(result)?.titleEn??'';
  }
}