import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';


class CMEDTextField extends StatelessWidget {
  String? label;
  String hintText;
  Icon? prefixIcon;
  Widget? suffixIcon;
  double? topMargin;
  double? bottomMargin;
  double? headingMargin = 2;
  TextEditingController? textEditingController;
  Function? onSaved;
  Function? onChanged;
  int? minLines;
  int? maxLines;
  int? maxLength;
  Function? onValidator;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  bool? isReadOnly = false;
  AutovalidateMode? autovalidateMode;
  FocusNode? focusNode;

  CMEDTextField(
      this.hintText, {
        Key? key,
        this.label,
        this.prefixIcon,
        this.suffixIcon,
        this.textEditingController,
        this.onSaved,
        this.onValidator,
        this.keyboardType,
        this.inputFormatters,
        this.topMargin,
        this.bottomMargin,
        this.headingMargin,
        this.isReadOnly,
        this.onChanged,
        this.maxLines,
        this.minLines,
        this.maxLength,
        this.autovalidateMode,
        this.focusNode,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _entryField(context);
  }

  Widget _entryField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null)
          Text(
            label!,
            style: CMEDTextUtils.inputTextLabelStyleForProfileTitle,
          ),
        Container(
          margin:
          EdgeInsets.only(top: topMargin ?? 0, bottom: bottomMargin ?? 12),
          child: TextFormField(
              focusNode: focusNode,
              readOnly: isReadOnly ?? false,
              keyboardType: keyboardType ?? TextInputType.text,
              inputFormatters: inputFormatters,
              textAlignVertical: TextAlignVertical.center,
              minLines: minLines ?? 1,
              maxLines: maxLines,
              maxLength: maxLength,
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
              obscureText: false,
              controller: textEditingController,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
              onSaved: (value) {
                if (onSaved != null) {
                  onSaved!(value!);
                }
              },
              validator: (value) {
                if (onValidator != null) {
                  return onValidator!(value);
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  hintText: hintText,
                  errorMaxLines: 2,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  fillColor: Theme.of(context).primaryColorLight,
                  filled: true,
                  // Changed contentPadding to center the text vertically
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  prefix: SizedBox(width: prefixIcon != null ? 0 : 12),
                  isDense: true // This helps with vertical centering
              ),
              autovalidateMode: autovalidateMode),
        )
      ],
    );
  }
}