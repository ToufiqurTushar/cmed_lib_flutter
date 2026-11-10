import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../common/helper/utils.dart';
import '../dto/field_dto.dart';
import '../survey_manager_logic.dart';
import 'item_label.dart';

Widget IntNumberEditText({
  Key? key,
  required Field field,
  required BuildContext context,
  required GlobalKey<FormBuilderState> formKey,
  double elevation = 0,
  double padding = 0,
  Function? onChanged,
}) {
  return IntNumberEditTextWidget(
    key: key ?? ValueKey('int_number_${field.name}'),
    field: field,
    formKey: formKey,
    elevation: elevation,
    padding: padding,
    onChanged: onChanged,
  );
}

class IntNumberEditTextWidget extends StatefulWidget {
  final Field field;
  final GlobalKey<FormBuilderState> formKey;
  final double elevation;
  final double padding;
  final Function? onChanged;

  const IntNumberEditTextWidget({
    super.key,
    required this.field,
    required this.formKey,
    this.elevation = 0,
    this.padding = 0,
    this.onChanged,
  });

  @override
  State<IntNumberEditTextWidget> createState() => _IntNumberEditTextWidgetState();
}

class _IntNumberEditTextWidgetState extends State<IntNumberEditTextWidget> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  dynamic _getLatestValue() {
    if (Get.isRegistered<SurveyManagerLogic>()) {
      final logic = Get.find<SurveyManagerLogic>();
      if (logic.answers.containsKey(widget.field.name)) {
        return logic.answers[widget.field.name];
      }
    }
    return widget.formKey.currentState?.fields[widget.field.name]?.value ??
        widget.field.defaultValue;
  }

  @override
  void initState() {
    super.initState();
    final initialVal = _getLatestValue();
    _controller = TextEditingController(
      text: initialVal != null && initialVal != '' ? '$initialVal' : '',
    );
  }

  @override
  void didUpdateWidget(covariant IntNumberEditTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncValue();
  }

  void _syncValue() {
    final latestVal = _getLatestValue();
    final latestStr = latestVal != null && latestVal != '' ? '$latestVal' : '';
    if (_controller.text != latestStr) {
      if (!_focusNode.hasFocus || widget.field.readOnly == true) {
        _controller.text = latestStr;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            widget.formKey.currentState?.fields[widget.field.name]?.didChange(latestStr);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _syncValue();
    return Card(
      elevation: widget.elevation,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Column(
          children: [
            if (widget.field.label != null) ItemLabel(widget.field),
            FormBuilderTextField(
              controller: _controller,
              focusNode: _focusNode,
              name: widget.field.name!,
              readOnly: widget.field.readOnly ?? false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                ValidationWrapper(
                  FormBuilderValidators.required(),
                  isRequired: widget.field.required,
                ),
                ValidationWrapper(
                  FormBuilderValidators.numeric(),
                  isRequired: widget.field.required,
                ),
                ValidationWrapper(
                  FormBuilderValidators.max(
                    widget.field.max ?? 0,
                    errorText: "Must be less than or equal to ${widget.field.max}",
                  ),
                  isRequired: widget.field.required,
                  isAapplyValidation: widget.field.max != null,
                ),
                ValidationWrapper(
                  FormBuilderValidators.min(
                    widget.field.min ?? 0,
                    errorText: "Must be greater than or equal to ${widget.field.min}",
                  ),
                  isRequired: widget.field.required,
                  isAapplyValidation: widget.field.min != null,
                ),
              ]),
              valueTransformer: null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hint: Text(
                  (widget.field.hint != null && widget.field.hint!.isNotEmpty)
                      ? widget.field.hint!
                      : "Write here".tr,
                  style: const TextStyle(color: Colors.grey),
                ),
                filled: true,
                fillColor: Theme.of(context).primaryColorLight,
                border: InputBorder.none,
                errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (widget.field.readOnly != true) {
                  widget.onChanged?.call(val);
                }
              },
            ),
            if ((widget.field.description?.isNotEmpty ?? false) &&
                !(widget.field.readOnly ?? false))
              Text(
                widget.field.description!,
                textAlign: TextAlign.left,
              ),
          ],
        ),
      ),
    );
  }
}
