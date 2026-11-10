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
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
  RLog.warning(field.defaultValue);

  String? Function(String?)? activeValidator = validator;
  TextInputType? activeKeyboardType = keyboardType;
  List<TextInputFormatter>? activeInputFormatters = inputFormatters;

  if (activeValidator == null) {
    final nameLower = (field.name ?? '').toLowerCase();
    final labelLower = (field.label ?? '').toLowerCase();
    final isCount = nameLower.contains('count') || labelLower.contains('count');
    if (!isCount) {
      final isNid = nameLower.contains('nid') ||
          labelLower.contains('national id') ||
          labelLower.contains('nid') ||
          labelLower.contains('জাতীয় পরিচয়পত্র');
      final isBcn = nameLower.contains('bcn') ||
          nameLower.contains('birth') ||
          labelLower.contains('birth certificate') ||
          labelLower.contains('bcn') ||
          labelLower.contains('জন্ম নিবন্ধন');

      if (isNid || isBcn) {
        activeKeyboardType ??= TextInputType.number;
        activeInputFormatters ??= [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(17),
        ];
        activeValidator = (val) {
          final text = val?.trim() ?? '';
          if (text.isEmpty) return null;
          if (!RegExp(r'^\d+$').hasMatch(text) ||
              (text.length != 10 && text.length != 13 && text.length != 17)) {
            return isNid
                ? 'NID must be 10, 13, or 17 digits'.tr
                : 'Birth Certificate Number must be 10, 13, or 17 digits'.tr;
          }
          return null;
        };
      }
    }
  }

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
              keyboardType: activeKeyboardType,
              inputFormatters: activeInputFormatters,
              validator: FormBuilderValidators.compose([
                ValidationWrapper(FormBuilderValidators.required(), isRequired: field.required),
                if (activeValidator != null) activeValidator,
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

