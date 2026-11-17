
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';

import 'gender_enum.dart';

enum RelationshipEnum{
  N_BY_A(labelEn: "N/A", type: 1, id: 0, gender:null),
  SELF(labelEn: "Self", type: 1, id: 0),
  WIFE(labelEn: "Wife", type: 1, id: 2, gender: 2),
  HUSBAND(labelEn: "Husband", type: 1, id: 3, gender: 1),
  SON(labelEn: "Son", type: 1, id: 4, gender: 1),
  DAUGHTER(labelEn: "Daughter", type: 1, id: 5, gender: 2),
  FATHER(labelEn: "Father", type: 1, id: 6, gender: 1),
  MOTHER(labelEn: "Mother", type: 1, id: 7, gender: 2),
  BROTHER(labelEn: "Brother", type: 1, id: 8, gender: 1),
  SISTER(labelEn: "Sister", type: 1, id: 9, gender: 2),
  FATHER_IN_LAW(labelEn: "Father-in-law", type: 1, id: 10, gender: 1),
  MOTHER_IN_LAW(labelEn: "Mother-in-law", type: 1, id: 11, gender: 2),
  SISTERS_HUSBAND(labelEn: "Sister's Husband", type: 1, id: 12, gender: 1),
  HUSBANDS_BROTHER(labelEn: "Husband's Brother (Younger)", type: 1, id: 13, gender: 1),
  HUSBANDS_ELDER_BROTHER(labelEn: "Husband's Brother (Elder)", type: 1, id: 14, gender: 1),
  WIFES_BROTHER(labelEn: "Wife's Brother (Younger)", type: 1, id: 15, gender: 1),
  WIFES_SISTER(labelEn: "Wife's Sister (Younger)", type: 1, id: 16, gender: 2),
  WIFE_OF_HUSBANDS_BROTHER(labelEn: "Wife of Husband's Brother", type: 1, id: 17, gender: 1),
  HUSBANDS_SISTER(labelEn: "Husband's Sister", type: 1, id: 18, gender: 2),
  BROTHERS_WIFE(labelEn: "Brother's Wife", type: 1, id: 19, gender: 2),
  BROTHERS_SON(labelEn: "Brother's Son", type: 1, id: 20, gender: 1),
  BROTHERS_DAUGHTER(labelEn: "Brother's Daughter", type: 1, id: 21, gender: 2),
  NEPHEW(labelEn: "Nephew", type: 1, id: 22, gender: 1),
  NIECE(labelEn: "Niece", type: 1, id: 23, gender: 2),
  GRANDSON(labelEn: "Grandson", type: 1, id: 24,gender: 1),
  GRANDDAUGHTER(labelEn: "Granddaughter", type: 1, id: 25, gender: 2),
  SERVANT(labelEn: "Servant", type: 1, id: 26, gender: null),
  DAUGHTER_IN_LAW(labelEn: "Daughter-in-law", type: 1, id: 27, gender: 2),
  SON_IN_LAW(labelEn: "Son-in-law", type: 1, id: 28, gender: 1),
  OTHER(labelEn: "Others", type: 1, id: 29, gender: null),
  CHILD(labelEn: "Child", type: 1, id: 30, gender: null),
  SPOUSE(labelEn: "Spouse", type: 1, id: 31, gender: 2),
  BROSIS(labelEn: "Brosis", type: 1, id: 32, gender: null);


  const RelationshipEnum({required this.labelEn, required this.type, required this.id, this.gender});

  final String labelEn;
  final int type;
  final int id;
  final int? gender;


  static RelationshipEnum getEnumByName(String? name) {
    for (RelationshipEnum enm in RelationshipEnum.values) {
      if (enm.name.toLowerCase() == name?.toLowerCase()) {
        return enm;
      }
    }
    return RelationshipEnum.SELF;
  }

  static RelationshipEnum getEnumByValue(int? value) {
    for (RelationshipEnum enm in RelationshipEnum.values) {
      if (enm.id == value) {
        return enm;
      }
    }
    return RelationshipEnum.N_BY_A;
  }

  static String getLocaleStringByName(String name) {
    var label = RelationshipEnum.getEnumByName(name).labelEn;
    label = label.replaceAll(' of ', 'Of').replaceAll(' ', '').replaceAll('\'', '').replaceAll('-in-law', 'InLaw').replaceAll('(', '').replaceAll(')', '');
    return ('Relationship$label').tr;
  }

  static List<MasterDataDTO> getMasterDataList({int? selectedId}) {
    return RelationshipEnum.values.where((w)=>w.id != 0).map((m)=>MasterDataDTO(
      value: m.id,
      labelEn: m.labelEn,
      labelBn: getLocaleStringByName(m.name),
      name: m.name,
      type: m.type,
      gender: m.gender,
      isSelected: selectedId != null && m.id == selectedId,
    )).toList();
  }
}
extension RelationshipEnumExtension on RelationshipEnum {
  MasterDataDTO toMasterDataDTO() => MasterDataDTO(labelEn: this.labelEn,value: this.id, name: this.name, gender:this.gender, type: this.type);
  GenderEnum toGenderEnum() => GenderEnum.getEnumById(gender??0);
}


