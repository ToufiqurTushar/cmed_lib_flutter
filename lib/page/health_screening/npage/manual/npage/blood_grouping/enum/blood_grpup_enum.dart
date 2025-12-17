enum BloodGroupEnum {
  BG_A_POSITIVE(1, "A+", "এ+", "#f84f26"),
  BG_A_NEGATIVE(2, "A-", "এ-", "#b82a07"),
  BG_B_POSITIVE(3, "B+", "বি+", "#974f3d"),
  BG_B_NEGATIVE(4, "B-", "বি-", "#561201"),
  BG_AB_POSITIVE(5, "AB+", "এবি+", "#ab948e"),
  BG_AB_NEGATIVE(6, "AB-", "এবি-", "#dc7b00"),
  BG_O_POSITIVE(7, "O+", "ও+", "#b59d4d"),
  BG_O_NEGATIVE(8, "O-", "ও-", "#f29645"),
  BG_UNKNOWN(9, "Unknown", "অজানা", "#536A6D");

  final int id;
  final String nameEn;
  final String nameBn;
  final String colorCode;

  const BloodGroupEnum(this.id, this.nameEn, this.nameBn, this.colorCode);

  static int getBloodGroupId(String? value) {
    if (value == null || value.isEmpty) return BG_UNKNOWN.id;
    for (var bg in BloodGroupEnum.values) {
      if (bg.nameEn == value || bg.nameBn == value) {
        return bg.id;
      }
    }
    return BG_UNKNOWN.id;
  }

  static String getBloodGroupEn(int? value) {
    if (value == null) return BG_UNKNOWN.nameEn;
    for (var bg in BloodGroupEnum.values) {
      if (bg.id == value) {
        return bg.nameEn;
      }
    }
    return BG_UNKNOWN.nameEn;
  }

  static String getBloodGroupBn(int? value) {
    if (value == null) return BG_UNKNOWN.nameBn;
    for (var bg in BloodGroupEnum.values) {
      if (bg.id == value) {
        return bg.nameBn;
      }
    }
    return BG_UNKNOWN.nameBn;
  }

  static String getBloodGroupString(int? value, bool isEnglishSelected) {
    if (value == null) return isEnglishSelected ? BG_UNKNOWN.nameEn : BG_UNKNOWN.nameBn;
    for (var bg in BloodGroupEnum.values) {
      if (bg.id == value) {
        return isEnglishSelected ? bg.nameEn : bg.nameBn;
      }
    }
    return isEnglishSelected ? BG_UNKNOWN.nameEn : BG_UNKNOWN.nameBn;
  }

  static BloodGroupEnum findBloodGroup(bool antigenA, bool antigenB, bool antigenD) {
    if (!antigenA && !antigenB && !antigenD) {
      return BloodGroupEnum.BG_O_NEGATIVE;
    } else if (!antigenA && !antigenB && antigenD) {
      return BloodGroupEnum.BG_O_POSITIVE;
    } else if (antigenA && !antigenB && !antigenD) {
      return BloodGroupEnum.BG_A_NEGATIVE;
    } else if (antigenA && !antigenB && antigenD) {
      return BloodGroupEnum.BG_A_POSITIVE;
    } else if (!antigenA && antigenB && !antigenD) {
      return BloodGroupEnum.BG_B_NEGATIVE;
    } else if (!antigenA && antigenB && antigenD) {
      return BloodGroupEnum.BG_B_POSITIVE;
    } else if (antigenA && antigenB && !antigenD) {
      return BloodGroupEnum.BG_AB_NEGATIVE;
    } else if (antigenA && antigenB && antigenD) {
      return BloodGroupEnum.BG_AB_POSITIVE;
    }
    return BloodGroupEnum.BG_UNKNOWN;
  }


}




