import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../common/helper/utils.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';


Widget NumberEditText({
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
                ValidationWrapper(FormBuilderValidators.numeric(), isRequired: field.required),
                ValidationWrapper(FormBuilderValidators.max(field.max!, errorText: "Must be less than or equal to ${field.max}"), isRequired: field.required, applyValidationIf: field.max != null),
                ValidationWrapper(FormBuilderValidators.min(field.min!, errorText: "Must be greater than or equal to ${field.min}"), isRequired: field.required, applyValidationIf: field.min != null),
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
                    TextFormField(
                      decoration: InputDecoration(
                        hint: Text(field.hint??"Write", style: TextStyle(color: Colors.grey),),
                        filled: true,
                        fillColor: Theme.of(context).primaryColorLight,
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        if(field.readOnly == false){
                          fieldState.didChange(val);
                        }
                      },
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

