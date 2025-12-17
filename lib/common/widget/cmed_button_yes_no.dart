import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cmed_white_elevated_button.dart';

class CMEDButtonYesNo extends StatefulWidget {
  Function onSelectedItem;
  int? selectedValue;

  CMEDButtonYesNo(
      this.onSelectedItem,
      {Key? key,
      this.selectedValue})
      : super(key: key);

  @override
  State<CMEDButtonYesNo> createState() => _CMEDButtonYesNoState();
}

class _CMEDButtonYesNoState extends State<CMEDButtonYesNo> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CMEDWhiteElevatedButton(
            'label_yes'.tr, () => {
              widget.selectedValue = 1,
              setState((){}),
              widget.onSelectedItem(1)
            },
            buttonTextColor: widget.selectedValue == 1 ? Colors.white : Theme.of(context).primaryColor,
            buttonBgColor: widget.selectedValue == 1 ? Theme.of(context).primaryColor : Colors.white,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: CMEDWhiteElevatedButton(
            'label_no'.tr, () => {
              widget.selectedValue = 0,
              setState((){}),
              widget.onSelectedItem(0)
            },
            buttonTextColor: widget.selectedValue == 0 ? Colors.white : Theme.of(context).primaryColor,
            buttonBgColor: widget.selectedValue == 0 ? Colors.red : Colors.white,
          ),
        ),
      ],
    );
  }
}
