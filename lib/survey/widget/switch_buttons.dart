import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';

Widget SwitchButtons({
    required Field field,
    required context,
    required GlobalKey<FormBuilderState> formKey,
    double elevation = 0,
    double padding = 0,
    Function? onChanged
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
              validator: field.required!? FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Required field!'.tr)
              ]) : null,
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
                    Row(
                      children: [
                        ...field.options!.map((option) {
                          final isSelected = fieldState.value == option.value;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: OutlinedButton(
                                onPressed: () {
                                  if(field.readOnly == false){
                                    fieldState.didChange(option.value);
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0,
                                  ),
                                  backgroundColor: isSelected ? Theme.of(context).primaryColor: Colors.white,
                                  foregroundColor: isSelected ? Theme.of(context).primaryColor : Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(option.title!, textAlign: TextAlign.center, style: TextStyle(color:  isSelected ? Colors.white : Colors.black),),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
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
