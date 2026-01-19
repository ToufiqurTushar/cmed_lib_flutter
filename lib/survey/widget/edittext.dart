import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../common/helper/utils.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';


Widget EditText({
    required Field field,
    required context,
    required GlobalKey<FormBuilderState> formKey,
    double elevation = 0,
    double padding = 0,
    Function? onChanged,
  }) {
  RLog.warning(field.defaultValue);
  return Card(
    elevation: elevation,
    margin: EdgeInsets.all(0),
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
          children: [
            if(field.label != null) ItemLabel(field),
            FormBuilderTextField(
              name: field.name!,
              initialValue: field.defaultValue,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                ValidationWrapper(FormBuilderValidators.required(), isRequired: field.required),
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
              onChanged: (val) {
                if(field.readOnly == false){
                  onChanged?.call(val);
                }
              },
            ),
            if(field.description!.isNotEmpty  && !field.readOnly!) Text(field.description!),
          ]
      ),
    ),
  );
}

