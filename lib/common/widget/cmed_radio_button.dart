import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide RadioGroup;
import 'package:flutter_rapid/flutter_rapid.dart' hide RadioGroup;
import 'package:group_radio_button/group_radio_button.dart';

import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';

class CMEDRadioButton extends StatefulWidget {
  Function onSelectedItem;
  List<MasterDataDTO> radioItems = [];
  TextEditingController? textEditingController;
  bool? isHorizontal = false;
  bool? isSelectDefaultValue = false;
  int? selectedItemPosition;

  CMEDRadioButton(this.onSelectedItem, this.radioItems,
      {Key? key,
      this.textEditingController,
      this.isHorizontal,
      this.isSelectDefaultValue,
      this.selectedItemPosition})
      : super(key: key);

  @override
  State<CMEDRadioButton> createState() => _CMEDRadioButtonState();
}

class _CMEDRadioButtonState extends State<CMEDRadioButton> {
  MasterDataDTO? _selectedValue;
  String label = '';

  @override
  Widget build(BuildContext context) {
    if (widget.isSelectDefaultValue != null && widget.isSelectDefaultValue!) {
      _selectedValue ??= widget.radioItems[0];
    } else if (widget.selectedItemPosition != null) {
      _selectedValue ??= widget.radioItems[widget.selectedItemPosition!];
    } else {
      _selectedValue ??= MasterDataDTO(labelEn: '', value: -1);
    }

    return RadioGroup<MasterDataDTO>.builder(
      direction: widget.isHorizontal ?? false ? Axis.horizontal : Axis.vertical,
      groupValue: _selectedValue!,
      horizontalAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: (value) => setState(() {
        _selectedValue = value!;
        widget.onSelectedItem(value);
        if (kDebugMode) {
          print("selectedValue: ${value.labelEn} value: ${value.value}");
        }
      }),
      items: widget.radioItems,
      textStyle: const TextStyle(fontSize: 14, color: Colors.black),
      itemBuilder: (item) => RadioButtonBuilder(
        (item.labelEn??'').tr,
      ),
      activeColor: Theme.of(context).primaryColor,
    );
  }
}
