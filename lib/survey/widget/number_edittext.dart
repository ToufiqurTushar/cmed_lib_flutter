import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../common/helper/utils.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';


Widget NumberEditText({
    Key? key,
    required Field field,
    required context,
    required GlobalKey<FormBuilderState> formKey,
    double elevation = 0,
    double padding = 0,
    Function? onChanged,
  }) {
  final currentVal = formKey.currentState?.fields[field.name]?.value ?? field.defaultValue;
  return Card(
    key: key,
    elevation: elevation,
    margin: EdgeInsets.all(0),
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
          children: [
            if(field.label != null) ItemLabel(field),
            FormBuilderTextField(
              key: ValueKey('${field.name}_${currentVal ?? field.defaultValue}'),
              name: field.name!,
              initialValue: (currentVal ?? field.defaultValue)?.toString()??'',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                ValidationWrapper(FormBuilderValidators.required(), isRequired: field.required),
                ValidationWrapper(FormBuilderValidators.numeric(), isRequired: field.required),
                ValidationWrapper(FormBuilderValidators.max(field.max??0, errorText: "Must be less than or equal to ${field.max}"), isRequired: field.required, isAapplyValidation: field.max != null),
                ValidationWrapper(FormBuilderValidators.min(field.min??0, errorText: "Must be greater than or equal to ${field.min}"), isRequired: field.required, isAapplyValidation: field.min != null),
              ]),
              valueTransformer: null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hint: Text((field.hint!=null && field.hint!.isNotEmpty)?field.hint!:"Write here".tr, style: TextStyle(color: Colors.grey),),
                  filled: true,
                  fillColor: Theme.of(context).primaryColorLight,
                  border: InputBorder.none,
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 12)
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (field.readOnly != true) {
                  onChanged?.call(val);
                }
              },
            ),
            if ((field.description?.isNotEmpty ?? false) && !(field.readOnly ?? false))
              Text(field.description!, textAlign: TextAlign.left,),
          ]
      ),
    ),
  );
}

