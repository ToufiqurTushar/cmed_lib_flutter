import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';

enum YesNoEnum {
  YES("Yes", "Yes", 1),
  NO("No", "No", 0);

  const YesNoEnum(this.label, this.uuid, this.value);

  final String label;
  final String uuid;
  final int value;

  static YesNoEnum? getEnumByName(String? name) {
    for (YesNoEnum enm in YesNoEnum.values) {
      if (enm.name == name) {
        return enm;
      }
    }
    return null;
  }


  static List<MasterDataDTO> getMasterDataList({int? selectedId}) {
    return YesNoEnum.values.map((m)=>MasterDataDTO(value:m.value, labelEn: m.label, uuid: m.uuid, isSelected: selectedId != null && m.value == selectedId)).toList();
  }
}

extension YesNoEnumExtension on YesNoEnum {
  MasterDataDTO toMasterDataDTO() => MasterDataDTO(labelEn: this.label, value: this.value);
}