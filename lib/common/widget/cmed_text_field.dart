import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CMEDTextField extends StatelessWidget {
  String? label;
  String hintText;
  Icon? prefixIcon;
  Widget? suffixIcon;
  double? topMargin;
  double? bottomMargin;
  double? headingMargin = 2;
  EdgeInsets? contentPadding;
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
  TextAlign? textAlign;
  String? counterText;
  Widget? prefix;

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
    this.contentPadding,
    this.bottomMargin,
    this.headingMargin,
    this.isReadOnly,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.autovalidateMode,
    this.focusNode,
    this.textAlign,
    this.counterText,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _entryField(context);
  }

  Widget _entryField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        Container(
          margin: EdgeInsets.only(
            top: topMargin ?? (label != null ? 0.0 : 8.0),
            bottom: bottomMargin ?? 12,
          ),
          child: TextFormField(
            focusNode: focusNode,
            readOnly: isReadOnly ?? false,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            textAlignVertical: TextAlignVertical.center,
            minLines: minLines ?? 1,
            maxLines: maxLines,
            maxLength: maxLength,
            textAlign: textAlign ?? TextAlign.left,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black, fontSize: 14),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: Color(0xFF7ee7af), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: Color(0xFF7ee7af), width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: Colors.red, width: 1.5),
              ),
              hintStyle: const TextStyle(
                  color: Colors.grey, fontSize: 14),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              fillColor: Colors.white,
              filled: true,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              prefix: prefix ??
                  (prefixIcon != null ? null : const SizedBox(width: 4)),
              counterText: counterText,
            ),
            autovalidateMode: autovalidateMode,
          ),
        )
      ],
    );
  }
}