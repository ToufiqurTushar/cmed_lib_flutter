import 'dart:convert';

abstract class BaseEntity {
  @override
  String toString() {
    return jsonEncode(this);
  }
}
