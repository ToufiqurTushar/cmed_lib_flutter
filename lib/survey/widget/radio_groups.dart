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
  Function? onChanged,
}) {
  // Decide layout direction based on option count / total label length,
  // instead of hardcoding pixel widths per option.
  final totalLabelLength = field.options!
      .map((o) => o.title!.length)
      .fold<int>(0, (a, b) => a + b);

  final useVertical = field.options!.length > 3 || totalLabelLength > 30;

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
            child: Theme(
              data: Theme.of(context).copyWith(
                radioTheme: Theme.of(context).radioTheme.copyWith(
                  fillColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
              child: FormBuilderRadioGroup<dynamic>(
                initialValue: field.defaultValue,
                name: field.name!,
                orientation: useVertical
                    ? OptionsOrientation.vertical
                    : OptionsOrientation
                          .wrap,
                wrapAlignment: WrapAlignment.start,
                wrapSpacing: 16.0,
                wrapRunSpacing: 8.0,
                options: field.options!
                    .map((FieldOption option) {
                      return FormBuilderFieldOption(
                        value: option.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 4,
                          ),
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
                    })
                    .toList(growable: false),
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
                    ? FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Select'.tr),
                      ])
                    : null,
              ),
            ),
          ),
          if (field.description != null &&
              field.description != "" &&
              !field.readOnly!)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4),
              child: Text(field.description!),
            ),
        ],
      ),
    ),
  );
}
