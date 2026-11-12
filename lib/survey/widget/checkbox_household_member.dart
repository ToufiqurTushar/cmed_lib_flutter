import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../page/rgp/dto/HouseholdSurevyMember.dart';
import '../dto/field_dto.dart';
import '../survey_manager_logic.dart';
import 'decimal_edittext.dart';
import 'dropdown_select.dart';
import 'edittext.dart';
import 'item_label.dart';
import 'multiselect_checkbox.dart';
import 'number_edittext.dart';
import 'radio_groups.dart';
import 'select_date.dart';
import 'select_date_time.dart';
import 'switch_buttons.dart';

// =============================================================================
// SECTION 1: CONVENIENCE FACTORY & WIDGET DECLARATION
// =============================================================================

/// Convenience functional builder for [CheckboxHouseholdMemberWidget].
/// Integrates with the CMED dynamic survey framework.
Widget CheckboxHouseholdMember({
  required Field field,
  required BuildContext context,
  required GlobalKey<FormBuilderState> formKey,
  double elevation = 0,
  double padding = 0,
  Function? onChanged,
}) {
  return CheckboxHouseholdMemberWidget(
    field: field,
    formKey: formKey,
    elevation: elevation,
    padding: padding,
    onChanged: onChanged,
  );
}

/// A specialized survey widget that manages household member selections with
/// child/sub-fields (e.g., NID/BCN, LMP, EDD, health card information).
///
/// Key responsibilities:
/// 1. Controls a parent Yes/No checkbox in FormBuilder state (`field.name`).
/// 2. Manages selected household members in FormBuilder state (`${field.name}_members`).
/// 3. Scopes each subfield uniquely to each member (`${field.name}_${memberKey}`) to prevent
///    data cross-leakage between members.
/// 4. Synchronizes member counts (`${field.name}_count`, `hs_18_44_total_patient`) with [SurveyManagerLogic].
/// 5. Automatically computes EDD date (LMP + 280 days) when LMP date is updated.
/// 6. Fully purges state and controllers when a member is deselected or removed.
class CheckboxHouseholdMemberWidget extends StatefulWidget {
  final Field field;
  final GlobalKey<FormBuilderState> formKey;
  final double elevation;
  final double padding;
  final Function? onChanged;

  const CheckboxHouseholdMemberWidget({
    super.key,
    required this.field,
    required this.formKey,
    this.elevation = 0,
    this.padding = 0,
    this.onChanged,
  });

  @override
  State<CheckboxHouseholdMemberWidget> createState() =>
      _CheckboxHouseholdMemberWidgetState();
}

// =============================================================================
// SECTION 2: STATE DECLARATION & LIFECYCLE MANAGEMENT
// =============================================================================

class _CheckboxHouseholdMemberWidgetState
    extends State<CheckboxHouseholdMemberWidget>
    with AutomaticKeepAliveClientMixin {
  /// Whether the parent checkbox is checked (i.e. members are selected).
  bool isChecked = false;

  /// Currently selected household members for this survey question.
  List<HouseholdSurevyMember> selectedMembers = [];

  /// Dedicated text controllers keyed by member identifier to isolate inputs.
  final Map<dynamic, TextEditingController> _controllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  /// Retrieves or initializes a [TextEditingController] uniquely scoped to [member].
  TextEditingController _getController(HouseholdSurevyMember member) {
    final key = _memberKey(member);
    return _controllers.putIfAbsent(
      key,
      () => TextEditingController(text: member.value ?? ''),
    );
  }

  // =============================================================================
  // SECTION 3: OPTION EVALUATION & VALUE RESOLUTION
  // =============================================================================

  /// Resolves the 'yes' value configured on the field, falling back to 'yes'.
  dynamic _getYesValue() {
    final opts = widget.field.options;
    if (opts != null && opts.isNotEmpty) {
      for (final opt in opts) {
        final valStr = opt.value?.toString().toLowerCase().trim();
        final titleStr = opt.title?.toString().toLowerCase().trim();
        if (valStr == 'yes' ||
            valStr == 'true' ||
            valStr == '1' ||
            titleStr == 'yes' ||
            titleStr == 'হ্যাঁ') {
          return opt.value;
        }
      }
      return opts.first.value;
    }
    return 'yes';
  }

  /// Resolves the 'no' value configured on the field, falling back to 'no'.
  dynamic _getNoValue() {
    final opts = widget.field.options;
    if (opts != null && opts.isNotEmpty) {
      for (final opt in opts) {
        final valStr = opt.value?.toString().toLowerCase().trim();
        final titleStr = opt.title?.toString().toLowerCase().trim();
        if (valStr == 'no' ||
            valStr == 'false' ||
            valStr == '0' ||
            titleStr == 'no' ||
            titleStr == 'না') {
          return opt.value;
        }
      }
      if (opts.length > 1) {
        return opts.last.value;
      }
    }
    return 'no';
  }

  // =============================================================================
  // SECTION 4: INITIALIZATION & DATA PARSING
  // =============================================================================

  /// Initializes the widget state from FormBuilder, SurveyManagerLogic, or default values.
  void _initData() {
    dynamic currentMembers =
        widget.formKey.currentState?.fields['${widget.field.name}_members']?.value ??
        widget.formKey.currentState?.value['${widget.field.name}_members'] ??
        widget.formKey.currentState?.initialValue['${widget.field.name}_members'] ??
        widget.field.preselectedMembers;

    if (currentMembers == null && widget.field.defaultValue is List) {
      currentMembers = widget.field.defaultValue;
    }

    dynamic currentStatus =
        widget.formKey.currentState?.fields[widget.field.name]?.value ??
        widget.formKey.currentState?.value[widget.field.name] ??
        widget.formKey.currentState?.initialValue[widget.field.name];

    if (currentStatus == null && widget.field.defaultValue is! List) {
      currentStatus = widget.field.defaultValue;
    }

    // Check SurveyManagerLogic for answers stored across tabs
    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      final membersFromAnswers = logic.answers['${widget.field.name}_members'];
      if (membersFromAnswers is List && membersFromAnswers.isNotEmpty) {
        currentMembers = membersFromAnswers;
      }
      final statusFromAnswers = logic.answers[widget.field.name];
      if (statusFromAnswers != null && statusFromAnswers is! List) {
        currentStatus = statusFromAnswers;
      }
    }

    // Parse members and determine initial checked state
    if (currentMembers is List && currentMembers.isNotEmpty) {
      _parseMembers(currentMembers);
      isChecked = selectedMembers.isNotEmpty;
    } else {
      final yesVal = _getYesValue();
      isChecked = currentStatus != null &&
          (currentStatus == yesVal ||
              currentStatus == true ||
              currentStatus == 'yes' ||
              currentStatus == 'true' ||
              currentStatus == 1);
    }

    final yesVal = _getYesValue();
    final noVal = _getNoValue();
    final statusVal = isChecked ? yesVal : noVal;
    final membersVal = isChecked
        ? selectedMembers.map((m) => m.copyWith()).toList()
        : <HouseholdSurevyMember>[];

    final count = isChecked ? selectedMembers.length : 0;

    // Post-frame dispatch to ensure FormBuilder and SurveyManagerLogic stay in sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Enforce parent field is ALWAYS yes/no, never a List!
      final statusField = widget.formKey.currentState?.fields[widget.field.name];
      if (statusField != null &&
          (statusField.value is List || statusField.value != statusVal)) {
        statusField.didChange(statusVal);
      }

      final membersField =
          widget.formKey.currentState?.fields['${widget.field.name}_members'];
      if (membersField != null && membersField.value != membersVal) {
        membersField.didChange(membersVal);
      }

      if (Get.isRegistered<SurveyManagerLogic>()) {
        final logic = Get.find<SurveyManagerLogic>();
        logic.answers[widget.field.name!] = statusVal;
        if (membersVal.isNotEmpty) {
          logic.answers['${widget.field.name}_members'] = membersVal;
        } else {
          logic.answers.remove('${widget.field.name}_members');
        }
      }

      if (!(widget.field.readOnly ?? false) || count > 0) {
        _updateCountField('${widget.field.name}_count', count);
      }
    });
  }

  /// Parses raw member items into deep-copied [HouseholdSurevyMember] instances with field schemas.
  void _parseMembers(List list) {
    selectedMembers = list.map((item) {
      HouseholdSurevyMember member;
      if (item is HouseholdSurevyMember) {
        member = item.copyWith();
      } else if (item is Map) {
        member = HouseholdSurevyMember.fromJson(item);
      } else {
        member = HouseholdSurevyMember(display: item.toString());
      }

      // Merge definition fields from widget.field.members if available
      if (widget.field.members != null) {
        final def = widget.field.members!.firstWhereOrNull(
          (m) => _memberKey(m) == _memberKey(member),
        );
        if (def != null) {
          if (member.display == null || member.display!.isEmpty) {
            member.display = def.display;
          }
          if ((member.fields == null || member.fields!.isEmpty) &&
              def.fields != null &&
              def.fields!.isNotEmpty) {
            member.fields =
                def.fields!.map((f) => Field.fromJson(f.toJson())).toList();
          }
        }
      }

      // Fallback to widget.field.fields if member still has no subfields
      if ((member.fields == null || member.fields!.isEmpty) &&
          widget.field.fields != null &&
          widget.field.fields!.isNotEmpty) {
        member.fields =
            widget.field.fields!.map((f) => Field.fromJson(f.toJson())).toList();
      }

      final ctrl = _getController(member);
      if (member.value != null && member.value!.isNotEmpty) {
        ctrl.text = member.value!;
      }
      return member;
    }).toList();
  }

  // =============================================================================
  // SECTION 5: MEMBER IDENTIFICATION & SCOPED FIELD NAMING
  // =============================================================================

  /// Derives a stable, unique identifier for a [HouseholdSurevyMember].
  dynamic _memberKey(HouseholdSurevyMember m) =>
      m.userId ?? m.memberId ?? m.profileId ?? m.display;

  /// Generates a globally unique, scoped form field name per member.
  /// Format: `${subField.name}_${memberKey}`.
  /// Prevents cross-member form state pollution.
  String _getMemberScopedFieldName(
    HouseholdSurevyMember member,
    Field subField,
  ) {
    final memberKey = _memberKey(member).toString();
    final baseName = subField.name ?? 'field';
    if (baseName.contains(memberKey)) {
      return baseName;
    }
    return '${baseName}_$memberKey';
  }

  // =============================================================================
  // SECTION 6: MEMBER FIELD GETTERS & TWO-WAY SYNCHRONIZATION
  // =============================================================================

  /// Retrieves cloned subfield schemas for [member].
  List<Field>? _getMemberFields(HouseholdSurevyMember member) {
    if (member.fields != null && member.fields!.isNotEmpty) {
      return member.fields;
    }
    if (widget.field.members != null) {
      final def = widget.field.members!.firstWhereOrNull(
        (m) => _memberKey(m) == _memberKey(member),
      );
      if (def?.fields != null && def!.fields!.isNotEmpty) {
        member.fields =
            def.fields!.map((f) => Field.fromJson(f.toJson())).toList();
        return member.fields;
      }
    }
    if (widget.field.fields != null && widget.field.fields!.isNotEmpty) {
      member.fields =
          widget.field.fields!.map((f) => Field.fromJson(f.toJson())).toList();
      return member.fields;
    }
    return null;
  }

  /// Resolves the current value for a given member's subfield across inputs, FormBuilder,
  /// SurveyManagerLogic, member entity properties, and defaults.
  dynamic _getMemberFieldValue(HouseholdSurevyMember member, Field subField) {
    final uniqueName = _getMemberScopedFieldName(member, subField);

    // 1. Check member.inputs map
    if (member.inputs != null) {
      if (subField.name != null && member.inputs!.containsKey(subField.name)) {
        return member.inputs![subField.name];
      }
      if (member.inputs!.containsKey(uniqueName)) {
        return member.inputs![uniqueName];
      }
    }

    // 2. Check current FormBuilder form state
    final formValue = widget.formKey.currentState?.fields[uniqueName]?.value ??
        widget.formKey.currentState?.value[uniqueName];
    if (formValue != null) return formValue;

    // 3. Check SurveyManagerLogic answers
    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      if (logic.answers.containsKey(uniqueName)) {
        return logic.answers[uniqueName];
      }
    }

    // 4. Check strongly typed properties on HouseholdSurevyMember
    final name = (subField.name ?? '').toLowerCase();
    if (name.contains('lmp') && member.lmpDate != null) return member.lmpDate;
    if (name.contains('edd') && member.eddDate != null) return member.eddDate;
    if ((name.contains('card_number') || name.contains('health_card_number')) &&
        member.healthCardNumber != null) {
      return member.healthCardNumber;
    }
    if ((name.contains('cost') || name.contains('health_card_cost')) &&
        member.healthCardCost != null) {
      return member.healthCardCost;
    }
    if (name.contains('issue_date') && member.healthCardIssueDate != null) {
      return member.healthCardIssueDate;
    }
    if (name.contains('expire_date') && member.healthCardExpireDate != null) {
      return member.healthCardExpireDate;
    }
    if ((name == 'dead' || name.contains('is_dead')) && member.dead != null) {
      return member.dead;
    }
    if (name.contains('death') && member.dateOfDeath != null) {
      return member.dateOfDeath;
    }
    if (name.contains('condition') && member.condition != null) {
      return member.condition;
    }
    if (name.contains('reason') && member.reason != null) {
      return member.reason;
    }
    if (member.value != null && member.value!.isNotEmpty) {
      return member.value;
    }

    return subField.defaultValue;
  }

  /// Synchronizes an updated value into the strongly typed properties of [member].
  void _syncValueToMember(
    HouseholdSurevyMember member,
    Field subField,
    dynamic val,
  ) {
    final name = (subField.name ?? '').toLowerCase();
    final strVal = val?.toString();

    if (name.contains('value') ||
        name.contains('nid') ||
        name.contains('bcn') ||
        member.value == null ||
        member.value!.isEmpty) {
      member.value = strVal ?? '';
    }

    if (name.contains('lmp')) {
      if (val is int) {
        member.lmpDate = val;
      } else if (val is num) {
        member.lmpDate = val.toInt();
      } else if (val is DateTime) {
        member.lmpDate = val.millisecondsSinceEpoch;
      } else if (strVal != null) {
        member.lmpDate = int.tryParse(strVal);
      }
    }

    if (name.contains('edd')) {
      if (val is int) {
        member.eddDate = val;
      } else if (val is num) {
        member.eddDate = val.toInt();
      } else if (val is DateTime) {
        member.eddDate = val.millisecondsSinceEpoch;
      } else if (strVal != null) {
        member.eddDate = int.tryParse(strVal);
      }
    }

    if (name.contains('health_card_number') || name.contains('card_number')) {
      member.healthCardNumber = strVal;
    }

    if (name.contains('health_card_cost') || name.contains('cost')) {
      if (val is num) {
        member.healthCardCost = val.toDouble();
      } else if (strVal != null) {
        member.healthCardCost = double.tryParse(strVal);
      }
    }

    if (name.contains('issue_date')) {
      if (val is int) {
        member.healthCardIssueDate = val;
      } else if (val is num) {
        member.healthCardIssueDate = val.toInt();
      } else if (val is DateTime) {
        member.healthCardIssueDate = val.millisecondsSinceEpoch;
      } else if (strVal != null) {
        member.healthCardIssueDate = int.tryParse(strVal);
      }
    }

    if (name.contains('expire_date')) {
      if (val is int) {
        member.healthCardExpireDate = val;
      } else if (val is num) {
        member.healthCardExpireDate = val.toInt();
      } else if (val is DateTime) {
        member.healthCardExpireDate = val.millisecondsSinceEpoch;
      } else if (strVal != null) {
        member.healthCardExpireDate = int.tryParse(strVal);
      }
    }

    if (name == 'dead' || name.contains('is_dead')) {
      if (val is bool) {
        member.dead = val;
      } else if (strVal == 'true' || strVal == '1') {
        member.dead = true;
      } else if (strVal == 'false' || strVal == '0') {
        member.dead = false;
      }
    }

    if (name.contains('date_of_death') || name.contains('death_date')) {
      if (val is int) {
        member.dateOfDeath = val;
      } else if (val is num) {
        member.dateOfDeath = val.toInt();
      } else if (val is DateTime) {
        member.dateOfDeath = val.millisecondsSinceEpoch;
      } else if (strVal != null) {
        member.dateOfDeath = int.tryParse(strVal);
      }
    }

    if (name.contains('condition')) {
      member.condition = strVal;
    }

    if (name.contains('reason')) {
      member.reason = strVal;
    }
  }

  /// Synchronizes all subfield values and controller texts from the UI form into [members].
  void _syncMemberFormValues(Iterable<HouseholdSurevyMember> members) {
    for (final m in members) {
      final ctrl = _controllers[_memberKey(m)];
      if (ctrl != null && ctrl.text.isNotEmpty) {
        m.value = ctrl.text;
      }
      final memberFields = _getMemberFields(m);
      if (memberFields != null) {
        for (final sf in memberFields) {
          final uniqueName = _getMemberScopedFieldName(m, sf);
          final fVal = widget.formKey.currentState?.fields[uniqueName]?.value;
          if (fVal != null) {
            m.inputs ??= {};
            if (sf.name != null) m.inputs![sf.name!] = fVal;
            m.inputs![uniqueName] = fVal;
            _syncValueToMember(m, sf, fVal);
          }
        }
      }
    }
  }

  // =============================================================================
  // SECTION 7: VALUE CHANGE HANDLERS & AUTOMATED CALCULATIONS (LMP -> EDD)
  // =============================================================================

  /// Handles value updates from subfield inputs and triggers auto-calculations.
  void _onMemberFieldValueChanged(
    HouseholdSurevyMember member,
    Field originalField,
    String uniqueFieldName,
    dynamic val,
    FormFieldState<dynamic> checkFieldState,
    FormFieldState<List<HouseholdSurevyMember>> membersFieldState,
  ) {
    member.inputs ??= {};
    if (originalField.name != null) {
      member.inputs![originalField.name!] = val;
    }
    member.inputs![uniqueFieldName] = val;

    _syncValueToMember(member, originalField, val);

    // Auto-calculation: When LMP date is changed, automatically calculate EDD = LMP + 280 days
    final fieldNameLower = (originalField.name ?? '').toLowerCase();
    if (fieldNameLower.contains('lmp') || fieldNameLower.contains('emp')) {
      int? lmpEpoch;
      if (val is int) {
        lmpEpoch = val;
      } else if (val is num) {
        lmpEpoch = val.toInt();
      } else if (val is DateTime) {
        lmpEpoch = val.millisecondsSinceEpoch;
      } else if (val != null) {
        lmpEpoch = int.tryParse(val.toString());
      }

      if (lmpEpoch != null) {
        final lmpDateTime = DateTime.fromMillisecondsSinceEpoch(lmpEpoch);
        final eddDateTime = lmpDateTime.add(const Duration(days: 280));
        final eddEpoch = eddDateTime.millisecondsSinceEpoch;

        member.eddDate = eddEpoch;

        final memberFields = _getMemberFields(member);
        final eddField = memberFields?.firstWhereOrNull(
          (f) => (f.name ?? '').toLowerCase().contains('edd'),
        );

        if (eddField != null) {
          final eddUniqueName = _getMemberScopedFieldName(member, eddField);
          member.inputs ??= {};
          if (eddField.name != null) {
            member.inputs![eddField.name!] = eddEpoch;
          }
          member.inputs![eddUniqueName] = eddEpoch;

          if (Get.isRegistered<SurveyManagerLogic>()) {
            final logic = Get.find<SurveyManagerLogic>();
            logic.answers[eddUniqueName] = eddEpoch;
          }

          widget.formKey.currentState?.fields[eddUniqueName]?.didChange(eddEpoch);
        }
      }
    }

    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      logic.answers[uniqueFieldName] = val;
    }

    setState(() {});
    _notify(checkFieldState, membersFieldState);
  }

  // =============================================================================
  // SECTION 8: MEMBER PURGING & CONTROLLER DISPOSAL
  // =============================================================================

  /// Resets an entity's internal value state back to a clean empty state.
  void _resetMemberState(HouseholdSurevyMember target) {
    target.value = '';
    target.inputs?.clear();
    target.inputs = null;
    target.lmpDate = null;
    target.eddDate = null;
    target.healthCardNumber = null;
    target.healthCardCost = null;
    target.healthCardIssueDate = null;
    target.healthCardExpireDate = null;
    target.dead = null;
    target.dateOfDeath = null;
    target.condition = null;
    target.reason = null;
  }

  /// Completely purges all memory, scoped answers, FormBuilder state, and controllers for [member].
  /// Called when a member is deselected or removed so that no stale data leaks if re-selected later.
  void _clearMemberData(HouseholdSurevyMember member) {
    final memberKey = _memberKey(member);

    // 1. Dispose & remove controller
    final ctrl = _controllers.remove(memberKey);
    if (ctrl != null) {
      ctrl.text = '';
      ctrl.dispose();
    }

    // 2. Clear scoped FormBuilder fields & SurveyManagerLogic answers
    final logic =
        Get.isRegistered<SurveyManagerLogic>() ? Get.find<SurveyManagerLogic>() : null;
    final memberFields = _getMemberFields(member);

    if (memberFields != null) {
      for (final sf in memberFields) {
        final uniqueName = _getMemberScopedFieldName(member, sf);
        if (logic != null) {
          logic.answers.remove(uniqueName);
        }
        widget.formKey.currentState?.fields[uniqueName]?.didChange(null);
        sf.defaultValue = null;
      }
    }

    final singleUniqueName = _getMemberScopedFieldName(
      member,
      Field(name: "${widget.field.name}_input_"),
    );
    if (logic != null) {
      logic.answers.remove(singleUniqueName);
    }
    widget.formKey.currentState?.fields[singleUniqueName]?.didChange(null);

    // 3. Clear all member internal state
    _resetMemberState(member);

    // 4. Clear matching definition in widget.field.members
    if (widget.field.members != null) {
      for (final def in widget.field.members!) {
        if (_memberKey(def) == memberKey) {
          _resetMemberState(def);
          if (def.fields != null) {
            for (final f in def.fields!) {
              final fName = (f.name ?? '').toLowerCase();
              if (fName.contains('nid') ||
                  fName.contains('bcn') ||
                  fName.contains('input') ||
                  fName.contains('lmp') ||
                  fName.contains('edd') ||
                  fName.contains('value')) {
                f.defaultValue = null;
              }
            }
          }
        }
      }
    }
  }

  /// Removes a member by index from [selectedMembers] and purges their data.
  void _removeMember(
    int index,
    FormFieldState<dynamic> checkFieldState,
    FormFieldState<List<HouseholdSurevyMember>> membersFieldState,
  ) {
    if (widget.field.readOnly == true) return;
    setState(() {
      final removed = selectedMembers.removeAt(index);
      _clearMemberData(removed);

      if (selectedMembers.isEmpty) {
        isChecked = false;
      }
    });
    _notify(checkFieldState, membersFieldState);
  }

  // =============================================================================
  // SECTION 9: NID & BCN VALIDATION & EXTRACTION
  // =============================================================================

  /// Checks if [field] represents a National ID (NID) field.
  bool _isNidField(Field field) {
    final name = (field.name ?? '').toLowerCase();
    final label = (field.label ?? '').toLowerCase();
    if (name.contains('count') || label.contains('count')) return false;
    return name.contains('nid') ||
        label.contains('national id') ||
        label.contains('nid') ||
        label.contains('জাতীয় পরিচয়পত্র');
  }

  /// Checks if [field] represents a Birth Certificate Number (BCN) field.
  bool _isBcnField(Field field) {
    final name = (field.name ?? '').toLowerCase();
    final label = (field.label ?? '').toLowerCase();
    if (name.contains('count') || label.contains('count')) return false;
    return name.contains('bcn') ||
        name.contains('birth') ||
        label.contains('birth certificate') ||
        label.contains('bcn') ||
        label.contains('জন্ম নিবন্ধন');
  }

  /// Validates NID/BCN strings (must be numeric and either 10, 13, or 17 digits).
  String? _validateNidOrBcnValue(
    String? value, {
    required bool isNid,
    bool isRequired = false,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      if (isRequired) return 'Required field!'.tr;
      return null;
    }
    if (!RegExp(r'^\d+$').hasMatch(text) ||
        (text.length != 10 && text.length != 13 && text.length != 17)) {
      return isNid
          ? 'NID must be 10, 13, or 17 digits'.tr
          : 'Birth Certificate Number must be 10, 13, or 17 digits'.tr;
    }
    return null;
  }

  /// Extracts the NID or BCN value entered for a given member.
  String? _getMemberNidOrBcnValue(HouseholdSurevyMember m) {
    final memberKey = _memberKey(m).toString();
    if (widget.formKey.currentState != null) {
      final subFieldName = _getMemberScopedFieldName(
        m,
        Field(name: "${widget.field.name}_input_"),
      );
      final fieldState = widget.formKey.currentState!.fields[subFieldName];
      if (fieldState != null &&
          fieldState.value != null &&
          fieldState.value.toString().trim().isNotEmpty) {
        return fieldState.value.toString().trim();
      }
      for (final entry in widget.formKey.currentState!.fields.entries) {
        if (entry.key.contains(memberKey) &&
            (entry.key.toLowerCase().contains('nid') ||
                entry.key.toLowerCase().contains('bcn')) &&
            entry.value.value != null &&
            entry.value.value.toString().trim().isNotEmpty) {
          return entry.value.value.toString().trim();
        }
      }
    }
    if (m.inputs != null) {
      for (final entry in m.inputs!.entries) {
        if ((entry.key.toLowerCase().contains('nid') ||
                entry.key.toLowerCase().contains('bcn')) &&
            entry.value != null &&
            entry.value.toString().trim().isNotEmpty) {
          return entry.value.toString().trim();
        }
      }
    }
    if (m.value != null && m.value!.trim().isNotEmpty) {
      return m.value!.trim();
    }
    final ctrl = _controllers[_memberKey(m)];
    if (ctrl != null && ctrl.text.trim().isNotEmpty) {
      return ctrl.text.trim();
    }
    return null;
  }

  // =============================================================================
  // SECTION 10: MEMBER SUBFIELD WIDGET DISPATCHER
  // =============================================================================

  /// Dispatches the appropriate UI input widget for each subfield schema of a member.
  Widget _buildMemberFieldWidget({
    required HouseholdSurevyMember member,
    required Field field,
    required FormFieldState<dynamic> checkFieldState,
    required FormFieldState<List<HouseholdSurevyMember>> membersFieldState,
  }) {
    final uniqueName = _getMemberScopedFieldName(member, field);
    final currentVal = _getMemberFieldValue(member, field);

    final scopedField = Field.fromJson(field.toJson());
    scopedField.name = uniqueName;
    scopedField.defaultValue = currentVal ?? field.defaultValue;
    scopedField.min ??= field.min;
    scopedField.max ??= field.max;
    scopedField.label = scopedField.label?.tr;
    scopedField.hint = scopedField.hint?.tr;
    scopedField.description = scopedField.description?.tr ?? '';
    scopedField.readOnly = widget.field.readOnly ?? field.readOnly ?? false;
    scopedField.options?.forEach((e) {
      e.title = e.title?.tr;
    });

    final isNid = _isNidField(field) || _isNidField(widget.field);
    final isBcn = _isBcnField(field) || _isBcnField(widget.field);

    String? Function(String?)? customValidator;
    TextInputType? customKeyboardType;
    List<TextInputFormatter>? customInputFormatters;

    if (isNid || isBcn) {
      customKeyboardType = TextInputType.number;
      customInputFormatters = [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(17),
      ];
      customValidator = (val) => _validateNidOrBcnValue(
            val,
            isNid: isNid,
            isRequired: scopedField.required ?? false,
          );
    }

    void onValueChanged(dynamic val) {
      _onMemberFieldValueChanged(
        member,
        field,
        uniqueName,
        val,
        checkFieldState,
        membersFieldState,
      );
    }

    if (scopedField.switchButton) {
      return SwitchButtons(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: onValueChanged,
      );
    } else if (scopedField.number || scopedField.intNumber) {
      return NumberEditText(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: (val) {
          final parsed = int.tryParse(val?.toString() ?? '');
          onValueChanged(parsed ?? val);
        },
      );
    } else if (scopedField.decimal) {
      return DecimalEditText(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: (val) {
          final parsed = double.tryParse(val?.toString() ?? '');
          onValueChanged(parsed ?? val);
        },
      );
    } else if (scopedField.radio) {
      return RadioGroups(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: onValueChanged,
      );
    } else if (scopedField.dropdown) {
      return DropdownSelect(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: onValueChanged,
      );
    } else if (scopedField.date || scopedField.dateStart || scopedField.dateEnd) {
      return SelectDate(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: onValueChanged,
      );
    } else if (scopedField.dateTime) {
      return SelectDateTime(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: onValueChanged,
      );
    } else if (scopedField.multiSelect) {
      return MultiSelectCheckbox(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: onValueChanged,
      );
    } else {
      // Default to EditText for text and other standard input types
      return EditText(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        validator: customValidator,
        keyboardType: customKeyboardType,
        inputFormatters: customInputFormatters,
        onChanged: onValueChanged,
      );
    }
  }

  // =============================================================================
  // SECTION 11: FORM NOTIFICATION & SURVEY COUNT AGGREGATION
  // =============================================================================

  /// Notifies the parent FormBuilder fields and triggers the onChanged callback.
  void _notify(
    FormFieldState<dynamic> checkFieldState,
    FormFieldState<List<HouseholdSurevyMember>> membersFieldState,
  ) {
    // Sync text from single controllers into the members
    for (final m in selectedMembers) {
      final ctrl = _controllers[_memberKey(m)];
      if (ctrl != null && ctrl.text.isNotEmpty) {
        m.value = ctrl.text;
      }
    }

    final statusVal = isChecked ? _getYesValue() : _getNoValue();
    final membersVal = isChecked
        ? selectedMembers.map((m) => m.copyWith()).toList()
        : <HouseholdSurevyMember>[];

    checkFieldState.didChange(statusVal);
    membersFieldState.didChange(membersVal);

    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      logic.answers[widget.field.name!] = statusVal;
      if (membersVal.isNotEmpty) {
        logic.answers['${widget.field.name}_members'] = membersVal;
      } else {
        logic.answers.remove('${widget.field.name}_members');
      }
    }

    final count = isChecked ? membersVal.length : 0;
    _updateCountField('${widget.field.name}_count', count);

    try {
      widget.onChanged?.call(statusVal, membersVal);
    } catch (_) {
      try {
        widget.onChanged?.call(statusVal);
      } catch (_) {}
    }
  }

  /// Synchronizes dynamic count fields and aggregate total patients (`hs_18_44_total_patient`)
  /// with [SurveyManagerLogic] and active FormBuilder fields.
  void _updateCountField(String fieldName, int count) {
    void executeUpdate() {
      if (!mounted) return;
      RLog.warning("fieldName:$fieldName, count:$count");
      final baseName = widget.field.name ?? '';
      final nameParts = baseName.split('_');
      final keyword =
          nameParts.length > 3 ? nameParts.sublist(3).join('_') : nameParts.last;

      final logic =
          Get.isRegistered<SurveyManagerLogic>() ? Get.find<SurveyManagerLogic>() : null;
      final matchedKeys = <String>{fieldName, '${baseName}_count'};

      if (logic != null) {
        logic.answers[fieldName] = count;
        logic.answers['${baseName}_count'] = count;

        void checkAndMatchCountField(Field f) {
          final fName = f.name;
          if (fName != null && fName.endsWith('_count')) {
            if (fName == fieldName ||
                fName == '${baseName}_count' ||
                (keyword.isNotEmpty && fName.contains(keyword))) {
              matchedKeys.add(fName);
              f.defaultValue = count;
            }
          }
        }

        for (final survey in [...logic.allSurveys, ...logic.selectedSurveys]) {
          for (final f in (survey.fields ?? [])) {
            checkAndMatchCountField(f);
          }
        }

        for (final tab in logic.tabPages) {
          for (final f in (tab.questions ?? [])) {
            checkAndMatchCountField(f);
          }
        }

        for (final k in logic.answers.keys) {
          if (k.endsWith('_count') &&
              (k == fieldName ||
                  k == '${baseName}_count' ||
                  (keyword.isNotEmpty && k.contains(keyword)))) {
            matchedKeys.add(k);
          }
        }
      }

      final formFields = widget.formKey.currentState?.fields;
      if (formFields != null) {
        for (final k in formFields.keys) {
          if (k.endsWith('_count') &&
              (k == fieldName ||
                  k == '${baseName}_count' ||
                  (keyword.isNotEmpty && k.contains(keyword)))) {
            matchedKeys.add(k);
          }
        }
      }

      for (final k in matchedKeys) {
        if (logic != null) {
          logic.answers[k] = count;
        }
        try {
          final f = widget.formKey.currentState?.fields[k];
          if (f != null && f.value?.toString() != '$count') {
            f.didChange('$count');
          }
        } catch (_) {}
      }

      // Aggregate calculation for hs_18_44_total_patient
      const totalPatientField = 'hs_18_44_total_patient';
      if (logic != null) {
        final uniquePatients = <dynamic>{};
        for (final key in const [
          'hs_18_18_diabetes_members',
          'hs_18_20_high_bp_members',
          'hs_18_22_kidney_members',
          'hs_18_24_cancer_members',
          'hs_18_26_low_bp_members',
          'hs_18_28_malnutrition_u5_members',
          'hs_18_30_eye_members',
          'hs_18_32_ear_members',
          'hs_18_34_pneumonia_members',
          'hs_18_36_diarrhea_members',
          'hs_18_38_hepatitis_members',
          'hs_18_40_paralysis_members',
          'hs_18_42_other_complicated_members',
        ]) {
          final list = logic.answers[key];
          if (list is List) {
            for (final m in list) {
              if (m is HouseholdSurevyMember) {
                uniquePatients.add(_memberKey(m));
              } else if (m is Map) {
                uniquePatients.add(m['user_id'] ?? m['member_id'] ?? m['profile_id']);
              }
            }
          }
        }
        if (uniquePatients.isNotEmpty || logic.answers.containsKey(totalPatientField)) {
          final totalPatients = uniquePatients.length;
          logic.answers[totalPatientField] = totalPatients;
          for (final survey in [...logic.allSurveys, ...logic.selectedSurveys]) {
            for (final f in (survey.fields ?? [])) {
              if (f.name == totalPatientField) f.defaultValue = totalPatients;
            }
          }
          for (final tab in logic.tabPages) {
            for (final f in (tab.questions ?? [])) {
              if (f.name == totalPatientField) f.defaultValue = totalPatients;
            }
          }
          try {
            final tpField = widget.formKey.currentState?.fields[totalPatientField];
            if (tpField != null && tpField.value?.toString() != '$totalPatients') {
              tpField.didChange('$totalPatients');
            }
          } catch (_) {}
        }
      }

      logic?.answers.refresh();
    }

    if (WidgetsBinding.instance.buildOwner?.debugBuilding ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) => executeUpdate());
    } else {
      executeUpdate();
    }
  }

  // =============================================================================
  // SECTION 12: MEMBER SELECTION MULTI-SELECT DIALOG
  // =============================================================================

  /// Displays the modal dialog allowing the user to select or deselect household members.
  void _openMemberSelectionDialog(
    BuildContext context,
    FormFieldState<List<HouseholdSurevyMember>> membersFieldState,
    FormFieldState<dynamic> checkFieldState,
  ) {
    final themeColor = Theme.of(context).primaryColor;
    final availableMembers = (widget.field.members ?? [])
        .where((m) => m.isHidden != true)
        .toList();

    // Pre-populate with currently selected member keys
    final selectedKeys = selectedMembers
        .where((m) => m.isHidden != true)
        .map((m) => _memberKey(m))
        .toSet();

    showDialog<Set<dynamic>>(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 380, maxHeight: 520),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Member'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(dialogCtx).pop(),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Member list
                    Expanded(
                      child: availableMembers.isEmpty
                          ? Center(
                              child: Text(
                                'No members found'.tr,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: availableMembers.length,
                              separatorBuilder: (ctx, idx) => Divider(
                                color: Colors.grey.shade200,
                                height: 1,
                              ),
                              itemBuilder: (ctx, idx) {
                                final member = availableMembers[idx];
                                final key = _memberKey(member);
                                final isSelected = selectedKeys.contains(key);

                                return InkWell(
                                  onTap: () {
                                    setDialogState(() {
                                      if (isSelected) {
                                        selectedKeys.remove(key);
                                      } else {
                                        selectedKeys.add(key);
                                      }
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: isSelected ? themeColor : Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: isSelected
                                                  ? themeColor
                                                  : Colors.grey.shade400,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            member.getDisplayName(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Done button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogCtx).pop(selectedKeys);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 10,
                          ),
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: Text(
                          'Done'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((resultKeys) {
      if (resultKeys == null) {
        if (selectedMembers.isEmpty) {
          setState(() {
            isChecked = false;
          });
          _notify(checkFieldState, membersFieldState);
        }
        return;
      }

      setState(() {
        final existingValues = <dynamic, String?>{};
        final existingInputs = <dynamic, Map<String, dynamic>>{};
        final existingMembersMap = <dynamic, HouseholdSurevyMember>{};
        for (final m in selectedMembers) {
          final key = _memberKey(m);
          final ctrl = _controllers[key];
          existingValues[key] = ctrl?.text ?? m.value;
          if (m.inputs != null) {
            existingInputs[key] = Map<String, dynamic>.from(m.inputs!);
          }
          existingMembersMap[key] = m;
        }

        // Clean up data for members that were deselected
        for (final entry in existingMembersMap.entries) {
          if (!resultKeys.contains(entry.key)) {
            _clearMemberData(entry.value);
          }
        }

        final newList = <HouseholdSurevyMember>[];
        for (final m in availableMembers) {
          final key = _memberKey(m);
          if (resultKeys.contains(key)) {
            final oldMember = existingMembersMap[key];
            if (oldMember != null) {
              // Retain existing selected member data
              final val = existingValues[key] ?? oldMember.value ?? '';
              final inputs = existingInputs[key] ??
                  (m.inputs != null ? Map<String, dynamic>.from(m.inputs!) : null);
              List<Field>? mFields;
              if (m.fields != null && m.fields!.isNotEmpty) {
                mFields = m.fields!.map((f) => Field.fromJson(f.toJson())).toList();
              } else if (oldMember.fields != null && oldMember.fields!.isNotEmpty) {
                mFields =
                    oldMember.fields!.map((f) => Field.fromJson(f.toJson())).toList();
              } else if (widget.field.fields != null &&
                  widget.field.fields!.isNotEmpty) {
                mFields =
                    widget.field.fields!.map((f) => Field.fromJson(f.toJson())).toList();
              }

              final copy = m.copyWith(
                value: val,
                lmpDate: oldMember.lmpDate ?? m.lmpDate,
                eddDate: oldMember.eddDate ?? m.eddDate,
                healthCardNumber:
                    oldMember.healthCardNumber ?? m.healthCardNumber,
                healthCardCost: oldMember.healthCardCost ?? m.healthCardCost,
                healthCardIssueDate:
                    oldMember.healthCardIssueDate ?? m.healthCardIssueDate,
                healthCardExpireDate:
                    oldMember.healthCardExpireDate ?? m.healthCardExpireDate,
                dead: oldMember.dead ?? m.dead,
                isHidden: oldMember.isHidden ?? m.isHidden,
                dateOfDeath: oldMember.dateOfDeath ?? m.dateOfDeath,
                condition: oldMember.condition ?? m.condition,
                reason: oldMember.reason ?? m.reason,
                fields: mFields,
                inputs: inputs,
              );
              newList.add(copy);
              _getController(copy).text = val;
            } else {
              // Brand new member selected - initialize fresh and empty
              List<Field>? mFields;
              if (m.fields != null && m.fields!.isNotEmpty) {
                mFields = m.fields!.map((f) => Field.fromJson(f.toJson())).toList();
              } else if (widget.field.fields != null &&
                  widget.field.fields!.isNotEmpty) {
                mFields =
                    widget.field.fields!.map((f) => Field.fromJson(f.toJson())).toList();
              }
              if (mFields != null) {
                for (final f in mFields) {
                  final fName = (f.name ?? '').toLowerCase();
                  if (fName.contains('nid') ||
                      fName.contains('bcn') ||
                      fName.contains('input') ||
                      fName.contains('value')) {
                    f.defaultValue = null;
                  }
                }
              }

              final copy = m.copyWith(
                value: '',
                lmpDate: null,
                eddDate: null,
                healthCardNumber: null,
                healthCardCost: null,
                healthCardIssueDate: null,
                healthCardExpireDate: null,
                dead: null,
                isHidden: m.isHidden,
                dateOfDeath: null,
                condition: null,
                reason: null,
                fields: mFields,
                inputs: <String, dynamic>{},
              );
              newList.add(copy);
              _getController(copy).text = '';
            }
          }
        }
        selectedMembers = newList;
        isChecked = selectedMembers.isNotEmpty;
      });

      _notify(checkFieldState, membersFieldState);
    });
  }

  // =============================================================================
  // SECTION 13: BUILD METHOD & FORM BUILDER INTEGRATION
  // =============================================================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeColor = Theme.of(context).primaryColor;

    return Card(
      elevation: widget.elevation,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: FormBuilderField<dynamic>(
          name: widget.field.name!,
          initialValue: isChecked ? _getYesValue() : _getNoValue(),
          valueTransformer: (val) {
            if (val is List || val == null) {
              return isChecked ? _getYesValue() : _getNoValue();
            }
            return val;
          },
          onSaved: (val) {
            final yesVal = _getYesValue();
            final noVal = _getNoValue();
            final finalVal = (val is List || val == null)
                ? (isChecked ? yesVal : noVal)
                : val;
            if (Get.isRegistered<SurveyManagerLogic>()) {
              Get.find<SurveyManagerLogic>().answers[widget.field.name!] = finalVal;
            }
          },
          validator: widget.field.required == true
              ? FormBuilderValidators.compose([
                  (val) {
                    final yesVal = _getYesValue();
                    if (val != yesVal && val != true && val != 'yes') {
                      return 'Required field!'.tr;
                    }
                    return null;
                  }
                ])
              : null,
          builder: (FormFieldState<dynamic> checkFieldState) {
            if (checkFieldState.value is List) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                checkFieldState.didChange(
                  isChecked ? _getYesValue() : _getNoValue(),
                );
              });
            }
            return FormBuilderField<List<HouseholdSurevyMember>>(
              name: '${widget.field.name}_members',
              initialValue: isChecked ? selectedMembers : <HouseholdSurevyMember>[],
              onSaved: (val) {
                // Synchronize all subfields and controllers into member objects
                _syncMemberFormValues(selectedMembers);
                if (val != null) {
                  _syncMemberFormValues(val);
                }

                final latest = selectedMembers.map((m) => m.copyWith()).toList();
                if (Get.isRegistered<SurveyManagerLogic>()) {
                  final logic = Get.find<SurveyManagerLogic>();
                  if (isChecked && latest.isNotEmpty) {
                    logic.answers['${widget.field.name}_members'] = latest;
                  } else {
                    logic.answers.remove('${widget.field.name}_members');
                  }
                }
                final count = isChecked ? latest.length : 0;
                if (!(widget.field.readOnly ?? false) || count > 0) {
                  _updateCountField('${widget.field.name}_count', count);
                }
              },
              validator: (val) {
                if (isChecked &&
                    widget.field.required == true &&
                    (val == null || val.isEmpty)) {
                  return 'Please select at least one member'.tr;
                }
                if (isChecked && val != null && val.isNotEmpty) {
                  final isNid = _isNidField(widget.field);
                  final isBcn = _isBcnField(widget.field);
                  if (isNid || isBcn) {
                    for (final m in val) {
                      final memberValue = _getMemberNidOrBcnValue(m);
                      if (memberValue == null || memberValue.isEmpty) {
                        return isNid
                            ? 'Please enter NID for all selected members'.tr
                            : 'Please enter Birth Certificate Number for all selected members'.tr;
                      }
                      final error = _validateNidOrBcnValue(
                        memberValue,
                        isNid: isNid,
                        isRequired: true,
                      );
                      if (error != null) {
                        return error;
                      }
                    }
                  }
                }
                return null;
              },
              builder:
                  (FormFieldState<List<HouseholdSurevyMember>> membersFieldState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top checkbox with title
                    InkWell(
                      onTap: () {
                        if (widget.field.readOnly == true) return;
                        setState(() {
                          isChecked = !isChecked;
                          if (!isChecked) {
                            for (final m in selectedMembers) {
                              _clearMemberData(m);
                            }
                            selectedMembers.clear();
                          }
                        });
                        _notify(checkFieldState, membersFieldState);

                        if (isChecked && selectedMembers.isEmpty) {
                          _openMemberSelectionDialog(
                            context,
                            membersFieldState,
                            checkFieldState,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isChecked ? themeColor : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: isChecked
                                      ? themeColor
                                      : Colors.grey.shade400,
                                  width: 1.5,
                                ),
                              ),
                              child: isChecked
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ItemLabel(widget.field),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // When checked: Show "+ Select Member" button and selected cards
                    if (isChecked) ...[
                      if (widget.field.readOnly != true) ...[
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () => _openMemberSelectionDialog(
                            context,
                            membersFieldState,
                            checkFieldState,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Select Member'.tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),

                      // Selected members list
                      ...List.generate(selectedMembers.length, (index) {
                        final member = selectedMembers[index];
                        final memberFields = _getMemberFields(member);
                        final memberKey = _memberKey(member);
                        return Card(
                          key: ValueKey('member_card_$memberKey'),
                          elevation: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                              color: Colors.grey.shade200,
                              width: 0.8,
                            ),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (widget.field.readOnly != true) ...[
                                      InkWell(
                                        onTap: () => _removeMember(
                                          index,
                                          checkFieldState,
                                          membersFieldState,
                                        ),
                                        child: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.redAccent,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        member.getDisplayName(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (memberFields != null &&
                                    memberFields.isNotEmpty)
                                  ...memberFields.map((subField) {
                                    final subFieldName =
                                        _getMemberScopedFieldName(member, subField);
                                    return Visibility(
                                      key: ValueKey('member_field_$subFieldName'),
                                      visible: !(subField.isHidden ?? false),
                                      child: IgnorePointer(
                                        ignoring: subField.ignore ?? false,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: _buildMemberFieldWidget(
                                            member: member,
                                            field: subField,
                                            checkFieldState: checkFieldState,
                                            membersFieldState: membersFieldState,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],

                    // Validation errors
                    if (checkFieldState.errorText != null ||
                        membersFieldState.errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 4),
                        child: Text(
                          checkFieldState.errorText ??
                              membersFieldState.errorText!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),

                    // Field description text
                    if (widget.field.description?.isNotEmpty == true &&
                        !(widget.field.readOnly ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.field.description!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
