import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../page/rgp/dto/HouseholdSurevyMember.dart';
import '../dto/field_dto.dart';
import '../survey_manager_logic.dart';

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
      if (item is HouseholdSurevyMember) {
        final copy = item.copyWith();
        final ctrl = _getController(copy);
        if (copy.value != null && copy.value!.isNotEmpty) {
          ctrl.text = copy.value!;
        }
        return copy;
      } else if (item is Map) {
        final parsed = HouseholdSurevyMember.fromJson(item);
        final ctrl = _getController(parsed);
        if (parsed.value != null && parsed.value!.isNotEmpty) {
          ctrl.text = parsed.value!;
        }
        return parsed;
      }
      final m = HouseholdSurevyMember(display: item.toString());
      return m;
    }).toList();
  }

  dynamic _memberKey(HouseholdSurevyMember m) =>
      m.userId ?? m.memberId ?? m.profileId ?? m.display;

  void _notify(
    FormFieldState<dynamic> checkFieldState,
    FormFieldState<List<HouseholdSurevyMember>> membersFieldState,
  ) {
    // Sync text from controllers into the members
    for (final m in selectedMembers) {
      final ctrl = _controllers[_memberKey(m)];
      if (ctrl != null) {
        m.value = ctrl.text;
      }
    }

    final statusVal = isChecked ? _getYesValue() : _getNoValue();
    final membersVal = isChecked
        ? selectedMembers.map((m) => m.copyWith(value: m.value)).toList()
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
    final availableMembers = widget.field.members ?? [];

    // Pre-populate with currently selected member keys
    final selectedKeys = selectedMembers.map((m) => _memberKey(m)).toSet();

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
                              separatorBuilder: (_, _) => const SizedBox(height: 12),
                              itemBuilder: (ctx, index) {
                                final member = availableMembers[index];
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
        for (final m in selectedMembers) {
          final ctrl = _controllers[_memberKey(m)];
          existingValues[_memberKey(m)] = ctrl?.text ?? m.value;
        }

        final newList = <HouseholdSurevyMember>[];
        for (final m in availableMembers) {
          final key = _memberKey(m);
          if (resultKeys.contains(key)) {
            final val = existingValues[key] ?? '';
            newList.add(
              HouseholdSurevyMember(
                userId: m.userId,
                memberId: m.memberId,
                profileId: m.profileId,
                display: m.display,
                value: val,
                lmpDate: m.lmpDate,
                eddDate: m.eddDate,
              ),
            );
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
                  if (ctrl != null) {
                    m.value = ctrl.text;
                  }
                }
                if (val != null) {
                  for (final m in val) {
                    final ctrl = _controllers[_memberKey(m)];
                    if (ctrl != null) {
                      m.value = ctrl.text;
                    }
                  }
                }
                final latest = selectedMembers.map((m) => m.copyWith(value: m.value)).toList();
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
                              child: Text(
                                widget.field.label ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
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
                                  fontWeight: FontWeight.w500,
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
                                          : () {
                                              setState(() {
                                                final removed = selectedMembers.removeAt(index);
                                                _controllers.remove(_memberKey(removed))?.dispose();
                                                if (selectedMembers.isEmpty) {
                                                  isChecked = false;
                                                }
                                              });
                                              _notify(checkFieldState, membersFieldState);
                                            },
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  key: ValueKey('${_memberKey(member)}_input'),
                                  controller: _getController(member),
                                  readOnly: widget.field.readOnly ?? false,
                                  decoration: InputDecoration(
                                    hintText: widget.field.label ?? widget.field.hint ?? '',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.2,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: themeColor,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    member.value = text;
                                    selectedMembers[index].value = text;
                                    _notify(checkFieldState, membersFieldState);
                                  },
                                ),
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
