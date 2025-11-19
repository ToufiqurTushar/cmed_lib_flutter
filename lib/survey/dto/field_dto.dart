class Field {
  Field({
    this.label,
    this.serial,
    this.images,
    this.description,
    this.hint,
    this.inputType,
    this.required,
    this.readOnly,
    this.name,
    this.min,
    this.max,
    this.options,
    this.defaultValue,});

  Field.fromJson(dynamic json) {
    label = json['label'];
    serial = json['serial'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    description = json['description'];
    hint = json['hint'];
    min = json['min'];
    max = json['max'];
    inputType = json['input_type'];
    required = json['required'];
    readOnly = json['read_only'];
    name = json['name'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options?.add(Option.fromJson(v));
      });
    }
    defaultValue = json['default_value'];
  }
  String? serial;
  String? label;
  List<Images>? images;
  String? description;
  String? hint;
  String? name;
  String? inputType;
  bool? required;
  bool? readOnly;
  num? min;
  num? max;
  List<Option>? options;
  dynamic defaultValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = label;
    map['serial'] = serial;
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }
    map['description'] = description;
    map['hint'] = hint;
    map['input_type'] = inputType;
    map['required'] = required;
    map['read_only'] = readOnly;
    map['name'] = name;
    if (options != null) {
      map['options'] = options?.map((v) => v.toJson()).toList();
    }
    map['default_value'] = defaultValue;
    return map;
  }

  get switchButton => inputType == 'switchButton';
  get dropdown => inputType == 'dropdown';
  get number => inputType == 'number';
}
class Images {
  Images({
    this.name,
    this.url,});

  Images.fromJson(dynamic json) {
    name = json['name'];
    url = json['url'];
  }
  String? name;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['url'] = url;
    return map;
  }

}

class Option {
  Option({
    this.title,
    this.name,
    this.value,
    this.weight,
    this.icon,});

  Option.fromJson(dynamic json) {
    title = json['title'];
    name = json['name'];
    value = json['value'];
    weight = json['weight'];
    icon = json['icon'];
  }
  String? title;
  String? name;
  String? value;
  int? weight;
  String? icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['name'] = name;
    map['value'] = value;
    map['weight'] = weight;
    map['icon'] = icon;
    return map;
  }

}
