class ScreeningTypeDTO {
  int? id;
  String? name;
  String? nameBn;
  String? code;
  int? codeId;
  bool? isSelected;

  ScreeningTypeDTO({this.id, this.name, this.nameBn, this.code, this.codeId, this.isSelected});

  ScreeningTypeDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameBn = json['name_bn'];
    code = json['code'];
    codeId = json['code_id'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_bn'] = nameBn;
    data['code'] = code;
    data['code_id'] = codeId;
    data['is_selected'] = isSelected;
    return data;
  }

  static List<ScreeningTypeDTO> listFromJson(list) => List<ScreeningTypeDTO>.from(list.map((x) => ScreeningTypeDTO.fromJson(x)));
  static int TYPE_ALL_ID = 0;
}
