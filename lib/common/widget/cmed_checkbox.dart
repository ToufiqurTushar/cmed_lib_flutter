import 'dart:ui';

import 'package:cmed_lib_flutter/common/widget/marquee_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CMEDCheckbox extends StatefulWidget {
  String? label;
  bool isSelected;
  bool isMarqueeTitle;
  Color? textColor;
  double? textSize;
  Function? onChecked;
  double? checkboxSize;

  CMEDCheckbox(
      this.isSelected, {
        Key? key,
        this.label,
        this.textColor,
        this.textSize,
        this.onChecked,
        this.isMarqueeTitle = false,
        this.checkboxSize = 24,
      }) : super(key: key);

  @override
  State<CMEDCheckbox> createState() => _CMEDCheckboxState();
}

class _CMEDCheckboxState extends State<CMEDCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Reduce unnecessary horizontal space
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Transform.scale(
          scale: widget.checkboxSize! / 24,
          child: Checkbox(
            value: widget.isSelected,
            activeColor: widget.textColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target padding
            visualDensity: VisualDensity.compact, // Reduce space around checkbox
            onChanged: (bool? value) {
              setState(() {
                widget.isSelected = value ?? false;
                if (widget.onChecked != null) {
                  widget.onChecked!(widget.isSelected);
                }
              });
            },
          ),
        ),
        const SizedBox(width: 4), // Reduced from 8 or more to 4 pixels
        widget.isMarqueeTitle
            ? Expanded(
          child: MarqueeWidget(
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.isSelected = !widget.isSelected;
                  if (widget.onChecked != null) {
                    widget.onChecked!(widget.isSelected);
                  }
                });
              },
              child: Visibility(
                visible: widget.label != null,
                child: Text(
                  widget.label ?? '',
                  style: TextStyle(
                    color: widget.isSelected
                        ? widget.textColor
                        : Colors.black,
                    fontSize: widget.textSize ?? 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        )
            : InkWell(
          onTap: () {
            setState(() {
              widget.isSelected = !widget.isSelected;
              if (widget.onChecked != null) {
                widget.onChecked!(widget.isSelected);
              }
            });
          },
          child: Visibility(
            visible: widget.label != null,
            child: Text(
              widget.label ?? '',
              style: TextStyle(
                color: widget.isSelected
                    ? widget.textColor
                    : Colors.black,
                fontSize: widget.textSize ?? 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

