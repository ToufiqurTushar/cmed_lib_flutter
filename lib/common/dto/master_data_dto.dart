

import 'package:cmed_lib_flutter/common/helper/utils.dart';

class MasterDataDTO  {
  int? id;
  String? uuid;
  int? createdAt;
  int? lastUpdated;
  String? labelEn;
  String? labelBn;
  String? name;
  String? image;
  int? type;
  int? value;
  int? index;
  int? gender;
  Map<String, dynamic>? mapData;
  bool isSelected = false;
  double? number;

  MasterDataDTO({this.id, this.uuid, this.name, this.number, this.image, this.createdAt, this.lastUpdated, this.labelEn, this.labelBn, this.type, this.value, this.index, this.gender, this.mapData, this.isSelected = false});

  MasterDataDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
    lastUpdated = json['last_updated'];
    labelEn = json['label_en'];
    labelBn = json['label_bn'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
    value = json['value'];
    gender = json['gender'];
    mapData = json['mapData'];
    number = json['number'];
    isSelected = json['isSelected']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['created_at'] = createdAt;
    data['last_updated'] = lastUpdated;
    data['label_en'] = labelEn;
    data['label_bn'] = labelBn;
    data['type'] = type;
    data['name'] = name;
    data['image'] = image;
    data['value'] = value;
    data['gender'] = gender;
    data['mapData'] = mapData;
    data['number'] = number;
    data['isSelected'] = isSelected;
    return data;
  }

  static List<MasterDataDTO> listFromJson(list) => List<MasterDataDTO>.from(list.map((x) => MasterDataDTO.fromJson(x)));

  getLabel() {
    if(Utils.isLocaleBn()) {
      return labelBn;
    } else {
      return labelEn;
    }
  }

}
