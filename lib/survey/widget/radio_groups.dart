import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';

double _measureTextWidth(String text, TextStyle? style, {double maxWidth = double.infinity}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);
  return painter.width;
}

Widget RadioGroups({
  required Field field,
  required context,
  required GlobalKey<FormBuilderState> formKey,
  double elevation = 0,
  double padding = 0,
  Function? onChanged,
}) {
  final textStyle = Theme.of(context).textTheme.bodyMedium;

  return Card(
    elevation: elevation,
    margin: EdgeInsets.all(0),
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: ListBody(
        children: [
          if (field.label != null) ItemLabel(field),
          Theme(
            data: Theme.of(context).copyWith(
              radioTheme: Theme.of(context).radioTheme.copyWith(
                    fillColor: MaterialStateProperty.all(Colors.black),
                  ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final optionCount = field.options!.length;

                return FormBuilderRadioGroup<dynamic>(
                  initialValue: field.defaultValue,
                  name: field.name!,
                  options: field.options!.map((FieldOption option) {
                    final textWidth = _measureTextWidth(
                      option.title!,
                      textStyle,
                      maxWidth: availableWidth,
                    );

                    const extraChrome = 48.0;
                    final desiredWidth = textWidth + extraChrome;
                    final equalShare = availableWidth / optionCount;
                    final itemWidth = math.max(desiredWidth, math.min(equalShare, desiredWidth));

                    return FormBuilderFieldOption(
                      value: option.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        width: optionCount <= 4 ? itemWidth : null,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            option.title!,
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                      ),
                    );
                  }).toList(growable: false),
                  wrapAlignment: WrapAlignment.start,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    fillColor: Theme.of(context).primaryColorLight,
                    filled: true,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (val) {
                    if (onChanged != null) {
                      onChanged(val);
                    }
                  },
                  valueTransformer: null,
                  controlAffinity: ControlAffinity.leading,
                  validator: field.required!
                      ? FormBuilderValidators.compose(
                          [FormBuilderValidators.required(errorText: 'Select'.tr)],
                        )
                      : null,
                );
              },
            ),
          ),
          if (field.description != null && field.description != "" && !field.readOnly!)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4),
              child: Text(field.description!),
            ),
        ],
      ),
    ),
  );
}