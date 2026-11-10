import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../common/helper/utils.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';

int? _parseDateEpoch(dynamic val) {
  if (val == null) return null;
  if (val is int) return val;
  if (val is num) return val.toInt();
  if (val is DateTime) return val.millisecondsSinceEpoch;
  if (val is String) {
    final parsedInt = int.tryParse(val);
    if (parsedInt != null) return parsedInt;
    final parsedDt = DateTime.tryParse(val);
    if (parsedDt != null) return parsedDt.millisecondsSinceEpoch;
  }
  return null;
}

Widget SelectDate({
  required Field field,
  required context,
  required GlobalKey<FormBuilderState> formKey,
  double elevation = 0,
  double padding = 0,
  Function? onChanged,
}) {
  return Card(
    elevation: elevation,
    margin: EdgeInsets.all(0),
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          if (field.label != null) ItemLabel(field),
          FormBuilderField<dynamic>(
            name: field.name!,
            initialValue: field.defaultValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              ValidationWrapper(
                FormBuilderValidators.required(),
                isRequired: field.required,
              ),
            ]),
            valueTransformer: null,
            onChanged: (val) {
              if (onChanged != null) {
                onChanged(val);
              }
            },
            builder: (FormFieldState<dynamic> fieldState) {
              final currentEpoch =
                  _parseDateEpoch(fieldState.value) ?? _parseDateEpoch(field.defaultValue);
              final minEpoch = _parseDateEpoch(field.min);
              final maxEpoch = _parseDateEpoch(field.max);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      final initialDate = currentEpoch != null
                          ? DateTime.fromMillisecondsSinceEpoch(currentEpoch)
                          : DateTime.now();
                      final firstDate = minEpoch != null
                          ? DateTime.fromMillisecondsSinceEpoch(minEpoch)
                          : DateTime(1900);
                      final lastDate = maxEpoch != null
                          ? DateTime.fromMillisecondsSinceEpoch(maxEpoch)
                          : DateTime(DateTime.now().year + 100);

                      final safeInitialDate = initialDate.isBefore(firstDate)
                          ? firstDate
                          : (initialDate.isAfter(lastDate) ? lastDate : initialDate);

                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: safeInitialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (pickedDate != null) {
                        fieldState.didChange(pickedDate.millisecondsSinceEpoch);
                      }
                    },
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentEpoch != null
                                  ? CustomDateUtils.format(currentEpoch)
                                  : ((field.hint != null && field.hint!.isNotEmpty)
                                      ? field.hint!
                                      : "Select date".tr),
                              style: TextStyle(
                                color: currentEpoch == null ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.calendar_month,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (fieldState.errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 2, top: 4),
                      child: Text(
                        fieldState.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
          if ((field.description?.isNotEmpty ?? false) && !(field.readOnly ?? false))
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                field.description!,
                textAlign: TextAlign.left,
              ),
            ),
        ],
      ),
    ),
  );
}
