import 'field_dto.dart';

class TabPage {
  final String id;
  final String title;
  List<Field>? questions;
  List<String>? listOfQuestionUid;

  /// Visibility rule: "field:value"
  final String? visibleWhen;
  final bool isTabVisible;

  TabPage({
    required this.id,
    required this.title,
    this.questions,
    this.listOfQuestionUid,
    this.visibleWhen,
    this.isTabVisible = true,
  });
}