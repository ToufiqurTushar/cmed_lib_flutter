import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart' hide Condition;

import '../enum/enum.dart';
import 'Condition.dart';
import 'SkipRule.dart';

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
    this.defaultValue,
    this.visibilityConditions,
    this.requiredConditions,
    this.skipRule
  });

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

    if (json['visibility_conditions'] != null) {
      visibilityConditions = [];
      json['visibility_conditions'].forEach((v) {
        visibilityConditions?.add(Condition.fromJson(v));
      });
    }
    if (json['required_conditions'] != null) {
      requiredConditions = [];
      json['required_conditions'].forEach((v) {
        requiredConditions?.add(Condition.fromJson(v));
      });
    }
    skipRule = json['skip_rule'] != null ? SkipRule.fromJson(json['skip_rule']) : null;
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
  List<Condition>? visibilityConditions;
  List<Condition>? requiredConditions;
  SkipRule? skipRule;

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
    if (visibilityConditions != null) {
      map['visibility_conditions'] = visibilityConditions?.map((v) => v.toJson()).toList();
    }
    if (requiredConditions != null) {
      map['required_conditions'] = requiredConditions?.map((v) => v.toJson()).toList();
    }
    if (skipRule != null) {
      map['skip_rule'] = skipRule?.toJson();
    }
    
    
    return map;
  }

  get switchButton => inputType == 'switchButton';
  get dropdown => inputType == 'dropdown';
  get radio => inputType == 'radio';
  get number => inputType == 'number';
  get text => inputType == 'text';
  get date => inputType == 'date';

  bool visibleWhen(GlobalKey<FormBuilderState> formKey, Map<String, dynamic> answers) {
    final results = <bool>[];

    // if(visibilityConditions?.isNotEmpty??false) {
    //   RLog.info(visibilityConditions!.first.toJson());
    // } else {
    //   RLog.info('no visibilityConditions found');
    // }

    for (final Condition condition in visibilityConditions??[]) {
      final dynamic inputValue = answers[condition.sourceField];
      final dynamic expectedValue = condition.expectedValue?.first;
      //final dynamic expectedValue = 'yes';

      bool r = false;

      switch (fbConditionFromString(condition.operator)) {
        case FBConditionType.EQUALS:
          //RLog.info('${answers}');
          //RLog.info('${inputValue} ${expectedValue}');
          r = inputValue == expectedValue;
          break;
        case FBConditionType.notEquals:
          r = inputValue != expectedValue;
          break;
        case FBConditionType.inList:
          r = condition.expectedValue?.contains(inputValue)??false;
          break;
        case FBConditionType.notInList:
          r = !(condition.expectedValue?.contains(inputValue)??false);
          break;
        case FBConditionType.lessThan:
          try {
            r = inputValue != null && (inputValue is Comparable) && (inputValue.compareTo(expectedValue) < 0);
          } catch (_) {
            r = false;
          }
          break;
        case FBConditionType.greaterThan:
          try {
            r = inputValue != null && (inputValue is Comparable) && (inputValue.compareTo(expectedValue) > 0);
          } catch (_) {
            r = false;
          }
          break;
        case FBConditionType.lessOrEqual:
          try {
            r = inputValue != null && (inputValue is Comparable) && (inputValue.compareTo(expectedValue) <= 0);
          } catch (_) {
            r = false;
          }
          break;
        case FBConditionType.greaterOrEqual:
          try {
            r = inputValue != null && (inputValue is Comparable) && (inputValue.compareTo(expectedValue) >= 0);
          } catch (_) {
            r = false;
          }
          break;
        case FBConditionType.between:
        // expect Map {'min': x, 'max': y} or List [min, max]
          try {
            final min = condition.expectedValue?[0]??null;
            final max = condition.expectedValue?[1]??null;
            if (min == null || max == null) {
              r = false;
            } else {
              r = inputValue != null && (inputValue is Comparable) && (inputValue.compareTo(min) >= 0 && inputValue.compareTo(max) <= 0);
            }
          } catch (_) {
            r = false;
          }
          break;
        case FBConditionType.notBetween:
          try {
            final min = condition.expectedValue?[0]??null;
            final max = condition.expectedValue?[1]??null;
            if (min == null || max == null) {
              r = false;
            } else {
              r = inputValue == null ||
                  !(inputValue is Comparable) ||
                  !(inputValue.compareTo(min) >= 0 && inputValue.compareTo(max) <= 0);
            }
          } catch (_) {
            r = false;
          }
          break;
        case FBConditionType.isEmpty:
          r = inputValue == '' ||
              (inputValue is Iterable && inputValue.isEmpty) ||
              (inputValue is Map && inputValue.isEmpty) ||
              (inputValue == null);
          break;
        case FBConditionType.isNotEmpty:
          r = !(inputValue == '' ||
              (inputValue is Iterable && inputValue.isEmpty) ||
              (inputValue is Map && inputValue.isEmpty) ||
              (inputValue == null));
          break;
        case FBConditionType.isNull:
          r = inputValue == null;
          break;
        case FBConditionType.isNotNull:
          r = inputValue != null;
          break;
      }

      results.add(r);
    }
    if(results.isNotEmpty) {
      //RLog.info(results.first.toString());
      var isVisible = visibilityConditions?.first.logic == FBConditionLogic.AND ? results.every((e) => e) : results.any((e) => e);
      if(!isVisible){
        answers.remove(name);
        final fieldState = formKey.currentState?.fields[name];
        if (fieldState != null) {
          //formKey.currentState!.unregisterField(name!, fieldState);
          formKey.currentState!.fields[name!]?.didChange(null);
          print('$name is null');
        } else {
          //print('$name not found in form state.');
        }
      }
      return isVisible;
    } else {
      return true;
    }
  }

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
