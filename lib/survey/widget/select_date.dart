import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../common/helper/utils.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';


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
            if(field.label != null) ItemLabel(field),
            FormBuilderField<dynamic>(
              name: field.name!,
              initialValue: field.defaultValue,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                ValidationWrapper(FormBuilderValidators.required(), isRequired: field.required),
              ]),
              valueTransformer: null,
              onChanged: (val) {
                if(onChanged != null) {
                  onChanged(val);
                }
              },
              builder: (FormFieldState<dynamic> fieldState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: (fieldState.value != null) ? CustomDateUtils.getDateTimeFromEpoch(fieldState.value): DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(DateTime.now().year+100),
                        );
                        if (picked != null) {
                          //final formatted = "${picked.year}-${picked.month}-${picked.day}";
                          final formatted = picked.millisecondsSinceEpoch;
                          fieldState.didChange(formatted);
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
                              (fieldState.value != null) ? CustomDateUtils.format(fieldState.value): (field.hint ?? "Select date"),
                                style: TextStyle(
                                  color: fieldState.value == null ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                            Icon(Icons.calendar_month, color:  Theme.of(context).primaryColor,)
                          ],
                        ),
                      ),
                    ),
                    if(fieldState.errorText != null) Padding(
                      padding: const EdgeInsets.only(left: 2, top: 4),
                      child: Text(fieldState.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12),),
                    ),
                  ],
                );
              },
            ),
            if(field.description!.isNotEmpty  && !field.readOnly!) Text(field.description!),
          ]
      ),
    ),
  );
}

