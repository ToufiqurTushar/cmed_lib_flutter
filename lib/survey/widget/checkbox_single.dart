import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../dto/field_dto.dart';

Widget CheckboxSingle({
  required Field field,
  required context,
  required GlobalKey<FormBuilderState> formKey,
  double elevation = 0,
  double padding = 0,
  Function? onChanged,
}) {
  dynamic getYesValue() {
    final opts = field.options;
    if (opts != null && opts.isNotEmpty) {
      for (final opt in opts) {
        final valStr = opt.value?.toString().toLowerCase().trim();
        final titleStr = opt.title?.toString().toLowerCase().trim();
        if (valStr == 'yes' ||
            valStr == 'true' ||
            valStr == '1' ||
            titleStr == 'yes' ||
            titleStr == 'হ্যাঁ') {
          return opt.value;
        }
      }
      return opts.first.value;
    }
    return true;
  }

  dynamic getNoValue() {
    final opts = field.options;
    if (opts != null && opts.isNotEmpty) {
      for (final opt in opts) {
        final valStr = opt.value?.toString().toLowerCase().trim();
        final titleStr = opt.title?.toString().toLowerCase().trim();
        if (valStr == 'no' ||
            valStr == 'false' ||
            valStr == '0' ||
            titleStr == 'no' ||
            titleStr == 'না') {
          return opt.value;
        }
      }
      if (opts.length > 1) {
        return opts.last.value;
      }
    }
    return false;
  }

  final yesVal = getYesValue();
  final noVal = getNoValue();

  return Card(
    elevation: elevation,
    margin: const EdgeInsets.all(0),
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormBuilderField<dynamic>(
            name: field.name!,
            initialValue: field.defaultValue ?? noVal,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (field.required ?? false)
                ? FormBuilderValidators.compose([
                    (val) {
                      if (val != yesVal) {
                        return 'Required field!'.tr;
                      }
                      return null;
                    }
                  ])
                : null,
            onChanged: (val) {
              if (onChanged != null) {
                onChanged(val);
              }
            },
            builder: (FormFieldState<dynamic> fieldState) {
              final isChecked = fieldState.value == yesVal ||
                  fieldState.value == true ||
                  fieldState.value == 'yes';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (field.readOnly != true) {
                        final nextVal = isChecked ? noVal : yesVal;
                        fieldState.didChange(nextVal);
                      }
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: isChecked
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade400,
                                width: 1.5,
                              ),
                            ),
                            child: isChecked
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              field.label ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
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
          if (field.description != null &&
              field.description!.isNotEmpty &&
              !(field.readOnly ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(field.description!),
            ),
        ],
      ),
    ),
  );
}
