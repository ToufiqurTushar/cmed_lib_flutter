import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';

enum GenderEnum{
  N_BY_A(0,"N/A", 'N/A'),
  MALE(1,"GenderMale", 'Male'),
  FEMALE(2,"GenderFemale", 'Female'),
  OTHERS(3,"GenderOthers", 'Others');

  final String label;
  final String uuid;
  final int value;
  const GenderEnum(this.value, this.label, this.uuid);


  static GenderEnum getEnumById(int id) {
    for (var gender in GenderEnum.values) {
      if (gender.value == id) {
        return gender;
      }
    }
    return GenderEnum.N_BY_A;
  }

  static GenderEnum getEnumByName(String? name) {
    for (GenderEnum enm in GenderEnum.values) {
      if (enm.name.toLowerCase() == name?.toLowerCase()) {
        return enm;
      }
    }
    return GenderEnum.N_BY_A;
  }

  static GenderEnum getEnumByUid(String? uid) {
    for (GenderEnum enm in GenderEnum.values) {
      if (enm.uuid.toLowerCase() == uid?.toLowerCase()) {
        return enm;
      }
    }
    return GenderEnum.N_BY_A;
  }

  static MasterDataDTO getMasterDataById(int? id) {
    for (var m in GenderEnum.values) {
      if (m.value == id) {
        return MasterDataDTO(value:m.value, labelEn:m.label);
      }
    }
    return GenderEnum.N_BY_A.toMasterDataDTO();
  }

  static List<MasterDataDTO> getMasterDataList({int? selectedId}) {
    return GenderEnum.values.where((w)=>w.value != 0).map((m)=>MasterDataDTO(value:m.value, labelEn:m.label, uuid: m.uuid, name: m.name, isSelected: selectedId != null && m.value == selectedId)).toList();
  }
}

extension FoodPreferenceEnumExtension on GenderEnum {
  MasterDataDTO toMasterDataDTO() => MasterDataDTO(labelEn: this.label, value: this.value, name: this.name, uuid: this.uuid);
}
