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
  State<CheckboxHouseholdMemberWidget> createState() => _CheckboxHouseholdMemberWidgetState();
}

class _CheckboxHouseholdMemberWidgetState extends State<CheckboxHouseholdMemberWidget>
    with AutomaticKeepAliveClientMixin {
  bool isChecked = false;
  List<HouseholdSurevyMember> selectedMembers = [];
  final Map<dynamic, TextEditingController> _controllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  TextEditingController _getController(HouseholdSurevyMember member) {
    final key = _memberKey(member);
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: member.value ?? '');
    }
    return _controllers[key]!;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

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

  void _initData() {
    dynamic currentMembers =
        widget.formKey.currentState?.fields['${widget.field.name}_members']?.value ??
        widget.formKey.currentState?.value['${widget.field.name}_members'] ??
        widget.formKey.currentState?.initialValue['${widget.field.name}_members'] ??
        widget.field.defaultValue;

    dynamic currentStatus =
        widget.formKey.currentState?.fields[widget.field.name]?.value ??
        widget.formKey.currentState?.value[widget.field.name] ??
        widget.formKey.currentState?.initialValue[widget.field.name] ??
        widget.field.defaultValue;

    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      final membersFromAnswers = logic.answers['${widget.field.name}_members'];
      if (membersFromAnswers is List && membersFromAnswers.isNotEmpty) {
        currentMembers = membersFromAnswers;
      }
      final statusFromAnswers = logic.answers[widget.field.name];
      if (statusFromAnswers != null) {
        currentStatus = statusFromAnswers;
      }
    }

    if (currentMembers is List && currentMembers.isNotEmpty) {
      _parseMembers(currentMembers);
      isChecked = selectedMembers.isNotEmpty;
    } else {
      final yesVal = _getYesValue();
      if (currentStatus != null &&
          (currentStatus == yesVal ||
              currentStatus == true ||
              currentStatus == 'yes' ||
              currentStatus == 'true' ||
              currentStatus == 1)) {
        isChecked = true;
      } else {
        isChecked = false;
      }
    }
  }

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

      if ((member.fields == null || member.fields!.isEmpty) && widget.field.members != null) {
        final def = widget.field.members!.firstWhereOrNull((m) => _memberKey(m) == _memberKey(member));
        if (def?.fields != null && def!.fields!.isNotEmpty) {
          member.fields = def.fields!.map((f) => Field.fromJson(f.toJson())).toList();
        }
      }
      if ((member.fields == null || member.fields!.isEmpty) &&
          widget.field.fields != null &&
          widget.field.fields!.isNotEmpty) {
        member.fields = widget.field.fields!.map((f) => Field.fromJson(f.toJson())).toList();
      }

      final ctrl = _getController(member);
      if (member.value != null && member.value!.isNotEmpty) {
        ctrl.text = member.value!;
      }
      return member;
    }).toList();
  }

  dynamic _memberKey(HouseholdSurevyMember m) =>
      m.userId ?? m.memberId ?? m.profileId ?? m.display;

  String _getMemberScopedFieldName(HouseholdSurevyMember member, Field subField) {
    final memberKey = _memberKey(member).toString();
    final baseName = subField.name ?? 'field';
    if (baseName.contains(memberKey)) {
      return baseName;
    }
    return '${baseName}_$memberKey';
  }

  List<Field>? _getMemberFields(HouseholdSurevyMember member) {
    if (member.fields != null && member.fields!.isNotEmpty) {
      return member.fields;
    }
    if (widget.field.members != null) {
      final def = widget.field.members!.firstWhereOrNull((m) => _memberKey(m) == _memberKey(member));
      if (def?.fields != null && def!.fields!.isNotEmpty) {
        member.fields = def.fields!.map((f) => Field.fromJson(f.toJson())).toList();
        return member.fields;
      }
    }
    if (widget.field.fields != null && widget.field.fields!.isNotEmpty) {
      member.fields = widget.field.fields!.map((f) => Field.fromJson(f.toJson())).toList();
      return member.fields;
    }
    return null;
  }

  dynamic _getMemberFieldValue(HouseholdSurevyMember member, Field subField) {
    final uniqueName = _getMemberScopedFieldName(member, subField);

    if (member.inputs != null) {
      if (subField.name != null && member.inputs!.containsKey(subField.name)) {
        return member.inputs![subField.name];
      }
      if (member.inputs!.containsKey(uniqueName)) {
        return member.inputs![uniqueName];
      }
    }

    final formValue = widget.formKey.currentState?.fields[uniqueName]?.value ??
        widget.formKey.currentState?.value[uniqueName];
    if (formValue != null) return formValue;

    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      if (logic.answers.containsKey(uniqueName)) {
        return logic.answers[uniqueName];
      }
      if (subField.name != null && logic.answers.containsKey(subField.name)) {
        return logic.answers[subField.name];
      }
    }

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
    if (name.contains('death') && member.dateOfDeath != null) return member.dateOfDeath;
    if (name.contains('condition') && member.condition != null) return member.condition;
    if (name.contains('reason') && member.reason != null) return member.reason;
    if (member.value != null && member.value!.isNotEmpty) return member.value;

    return subField.defaultValue;
  }

  void _syncValueToMember(HouseholdSurevyMember member, Field subField, dynamic val) {
    final name = (subField.name ?? '').toLowerCase();
    final strVal = val?.toString();

    if (name.contains('value') ||
        name.contains('nid') ||
        name.contains('bcn') ||
        member.value == null ||
        member.value!.isEmpty) {
      if (strVal != null && strVal.isNotEmpty) {
        member.value = strVal;
      }
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
    originalField.defaultValue = val;

    _syncValueToMember(member, originalField, val);

    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      logic.answers[uniqueFieldName] = val;
      if (originalField.name != null) {
        logic.answers[originalField.name!] = val;
      }
    }

    _notify(checkFieldState, membersFieldState);
  }

  void _removeMember(
    int index,
    FormFieldState<dynamic> checkFieldState,
    FormFieldState<List<HouseholdSurevyMember>> membersFieldState,
  ) {
    if (widget.field.readOnly == true) return;
    setState(() {
      final removed = selectedMembers.removeAt(index);
      _controllers.remove(_memberKey(removed))?.dispose();

      if (Get.isRegistered<SurveyManagerLogic>()) {
        final logic = Get.find<SurveyManagerLogic>();
        final memberFields = _getMemberFields(removed);
        if (memberFields != null) {
          for (final sf in memberFields) {
            final uniqueName = _getMemberScopedFieldName(removed, sf);
            logic.answers.remove(uniqueName);
            if (sf.name != null) logic.answers.remove(sf.name);
            widget.formKey.currentState?.fields[uniqueName]?.didChange(null);
          }
        }
      }

      if (selectedMembers.isEmpty) {
        isChecked = false;
      }
    });
    _notify(checkFieldState, membersFieldState);
  }

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
    scopedField.label = scopedField.label?.tr;
    scopedField.hint = scopedField.hint?.tr;
    scopedField.description = scopedField.description?.tr ?? '';
    scopedField.readOnly = widget.field.readOnly ?? field.readOnly ?? false;
    scopedField.options?.forEach((e) {
      e.title = e.title?.tr;
    });

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
    } else if (scopedField.text) {
      return EditText(
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
      return EditText(
        field: scopedField,
        context: context,
        formKey: widget.formKey,
        padding: 0,
        elevation: 0,
        onChanged: onValueChanged,
      );
    }
  }

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
        logic.answers['${widget.field.name}_count'] = membersVal.length;
      } else {
        logic.answers.remove('${widget.field.name}_members');
        logic.answers.remove('${widget.field.name}_count');
      }
    }

    try {
      widget.onChanged?.call(statusVal, membersVal);
    } catch (_) {
      try {
        widget.onChanged?.call(statusVal);
      } catch (_) {}
    }
  }

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
                                              color: isSelected ? themeColor : Colors.grey.shade400,
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
                                            member.display ?? '',
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
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
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

        final newList = <HouseholdSurevyMember>[];
        for (final m in availableMembers) {
          final key = _memberKey(m);
          if (resultKeys.contains(key)) {
            final oldMember = existingMembersMap[key];
            final val = existingValues[key] ?? oldMember?.value ?? '';
            final inputs = existingInputs[key] ?? (m.inputs != null ? Map<String, dynamic>.from(m.inputs!) : null);
            List<Field>? mFields;
            if (m.fields != null && m.fields!.isNotEmpty) {
              mFields = m.fields!.map((f) => Field.fromJson(f.toJson())).toList();
            } else if (oldMember?.fields != null && oldMember!.fields!.isNotEmpty) {
              mFields = oldMember.fields!.map((f) => Field.fromJson(f.toJson())).toList();
            } else if (widget.field.fields != null && widget.field.fields!.isNotEmpty) {
              mFields = widget.field.fields!.map((f) => Field.fromJson(f.toJson())).toList();
            }

            final copy = m.copyWith(
              value: val,
              lmpDate: oldMember?.lmpDate ?? m.lmpDate,
              eddDate: oldMember?.eddDate ?? m.eddDate,
              healthCardNumber: oldMember?.healthCardNumber ?? m.healthCardNumber,
              healthCardCost: oldMember?.healthCardCost ?? m.healthCardCost,
              healthCardIssueDate: oldMember?.healthCardIssueDate ?? m.healthCardIssueDate,
              healthCardExpireDate: oldMember?.healthCardExpireDate ?? m.healthCardExpireDate,
              dead: oldMember?.dead ?? m.dead,
              isHidden: oldMember?.isHidden ?? m.isHidden,
              dateOfDeath: oldMember?.dateOfDeath ?? m.dateOfDeath,
              condition: oldMember?.condition ?? m.condition,
              reason: oldMember?.reason ?? m.reason,
              fields: mFields,
              inputs: inputs,
            );
            newList.add(copy);
            _getController(m).text = val;
          }
        }
        selectedMembers = newList;
        if (selectedMembers.isEmpty) {
          isChecked = false;
        } else {
          isChecked = true;
        }
      });

      _notify(checkFieldState, membersFieldState);
    });
  }

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
            return FormBuilderField<List<HouseholdSurevyMember>>(
              name: '${widget.field.name}_members',
              initialValue: isChecked ? selectedMembers : <HouseholdSurevyMember>[],
              onSaved: (val) {
                for (final m in selectedMembers) {
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
                if (val != null) {
                  for (final m in val) {
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
                final latest = selectedMembers.map((m) => m.copyWith()).toList();
                if (Get.isRegistered<SurveyManagerLogic>()) {
                  final logic = Get.find<SurveyManagerLogic>();
                  if (isChecked && latest.isNotEmpty) {
                    logic.answers['${widget.field.name}_members'] = latest;
                    logic.answers['${widget.field.name}_count'] = latest.length;
                  } else {
                    logic.answers.remove('${widget.field.name}_members');
                    logic.answers.remove('${widget.field.name}_count');
                  }
                }
              },
              validator: (val) {
                if (isChecked && widget.field.required == true && (val == null || val.isEmpty)) {
                  return 'Please select at least one member'.tr;
                }
                return null;
              },
              builder: (FormFieldState<List<HouseholdSurevyMember>> membersFieldState) {
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
                            if (Get.isRegistered<SurveyManagerLogic>()) {
                              final logic = Get.find<SurveyManagerLogic>();
                              for (final m in selectedMembers) {
                                final memberFields = _getMemberFields(m);
                                if (memberFields != null) {
                                  for (final sf in memberFields) {
                                    final uniqueName = _getMemberScopedFieldName(m, sf);
                                    logic.answers.remove(uniqueName);
                                    if (sf.name != null) logic.answers.remove(sf.name);
                                    widget.formKey.currentState?.fields[uniqueName]?.didChange(null);
                                  }
                                }
                              }
                            }
                            selectedMembers.clear();
                            for (final ctrl in _controllers.values) {
                              ctrl.dispose();
                            }
                            _controllers.clear();
                          }
                        });
                        _notify(checkFieldState, membersFieldState);

                        if (isChecked && selectedMembers.isEmpty) {
                          _openMemberSelectionDialog(context, membersFieldState, checkFieldState);
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
                                  color: isChecked ? themeColor : Colors.grey.shade400,
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
                              child:  ItemLabel(widget.field),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // When checked: Show "+ Select Member" button and selected cards
                    if (isChecked) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: widget.field.readOnly == true
                            ? null
                            : () => _openMemberSelectionDialog(context, membersFieldState, checkFieldState),
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
                      const SizedBox(height: 6),

                      // Selected members list
                      ...List.generate(selectedMembers.length, (index) {
                        final member = selectedMembers[index];
                        final memberFields = _getMemberFields(member);
                        return Card(
                          elevation: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: Colors.grey.shade200, width: 0.8),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: widget.field.readOnly == true
                                          ? null
                                          : () => _removeMember(
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
                                    Expanded(
                                      child: Text(
                                        member.display ?? '',
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
                                if (memberFields != null && memberFields.isNotEmpty)
                                  ...memberFields.map((subField) {
                                    return Visibility(
                                      visible: !(subField.isHidden??false),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: _buildMemberFieldWidget(
                                          member: member,
                                          field: subField,
                                          checkFieldState: checkFieldState,
                                          membersFieldState: membersFieldState,
                                        ),
                                      ),
                                    );
                                  })
                                // else
                                //   TextFormField(
                                //     key: ValueKey('${_memberKey(member)}_input'),
                                //     controller: _getController(member),
                                //     readOnly: widget.field.readOnly ?? false,
                                //     decoration: InputDecoration(
                                //       hintText: widget.field.label ?? widget.field.hint ?? '',
                                //       hintStyle: TextStyle(
                                //         color: Colors.grey.shade400,
                                //         fontSize: 14,
                                //       ),
                                //       isDense: true,
                                //       contentPadding: const EdgeInsets.symmetric(vertical: 6),
                                //       enabledBorder: UnderlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: Colors.grey.shade300,
                                //           width: 1.2,
                                //         ),
                                //       ),
                                //       focusedBorder: UnderlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: themeColor,
                                //           width: 1.5,
                                //         ),
                                //       ),
                                //     ),
                                //     onChanged: (text) {
                                //       member.value = text;
                                //       selectedMembers[index].value = text;
                                //       _notify(checkFieldState, membersFieldState);
                                //     },
                                //   ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],

                    // Errors
                    if (checkFieldState.errorText != null || membersFieldState.errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 4),
                        child: Text(
                          checkFieldState.errorText ?? membersFieldState.errorText!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),

                    // Field description
                    if (widget.field.description?.isNotEmpty == true &&
                        !(widget.field.readOnly ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.field.description!,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
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
