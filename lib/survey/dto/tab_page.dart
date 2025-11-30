import 'field_dto.dart';

class TabPage {
  final String id;
  final String title;
  List<Field>? questions;
  List<String>? listOfQuestionUid;

  /// Visibility rule: "field:value"
  final String? visibleWhen;

  TabPage({
    required this.id,
    required this.title,
    this.questions,
    this.listOfQuestionUid,
    this.visibleWhen,
  });
}