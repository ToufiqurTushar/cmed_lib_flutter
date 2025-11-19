import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../dto/field_dto.dart';
import 'item_label.dart';

Widget RadioGroups({
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
      child: ListBody(
          children: [
            if(field.label != null) ItemLabel(field),
            Theme(
              data: Theme.of(context).copyWith(
                radioTheme: Theme.of(context).radioTheme.copyWith(
                  fillColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
              child: FormBuilderRadioGroup<dynamic>(
                //enabled: parentCondition,
                initialValue: field.defaultValue,
                name: field.name!,
                options: field.options!.map((Option option) => FormBuilderFieldOption(
                  value: option.value,
                  child: Container(padding: const EdgeInsets.symmetric(vertical: 4),width:field.options?.length == 2? Get.width*.3: null, child: Align(alignment: Alignment.centerLeft, child: Text(option.title!, textAlign: TextAlign.left,)),),
                )).toList(growable: false),
                wrapAlignment: WrapAlignment.start,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Theme.of(context).primaryColorLight,
                  filled: true,
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                activeColor: Theme.of(context).primaryColor,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (val) {
                  if(onChanged != null) {
                    onChanged(val);
                  }
                },
                valueTransformer: null,
                controlAffinity: ControlAffinity.leading,
                validator: field.required!? FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Select'.tr)
                ]) : null,

              ),
            ),
            if(field.description != null  && !field.readOnly!) Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4),
              child: Text(field.description!),
            ),
          ]
      ),
    ),
  );
}
