import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';

class CMEDDropdownWidget extends StatefulWidget {
  final String? dropdownTitle;
  final List<MasterDataDTO> items;
  final EdgeInsetsGeometry? padding;

  final Function? onItemSelected;
  Color? color;
  Color? borderColor;
  bool? isShowBorder = false;
  double? width;

  CMEDDropdownWidget(this.items,
      {Key? key,
      this.dropdownTitle,
      this.onItemSelected,
      this.color,
      this.borderColor,
      this.isShowBorder,
      this.width,
      this.padding})
      : super(key: key);

  @override
  State<CMEDDropdownWidget> createState() => _CMEDDropdownWidgetState();
}

class _CMEDDropdownWidgetState extends State<CMEDDropdownWidget> {
  MasterDataDTO? selectedValue;

  @override
  Widget build(BuildContext context) {
    widget.color ??= Theme.of(context).primaryColorLight;
    if (widget.borderColor == null) widget.color = Theme.of(context).primaryColorLight;
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              widget.dropdownTitle ?? "",
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            items: widget.items
                .map((item) => DropdownMenuItem<MasterDataDTO>(
                      value: item,
                      child: Row(
                        children: [
                          if(item.image != null)
                          Image.asset('${item.image}', width: 20, height: 20),
                          if(item.image != null)
                          const SizedBox(width: 8),
                          Text(
                            Utils.isLocaleBn()
                                ? item.labelBn ?? ''
                                : item.labelEn ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value as MasterDataDTO;
                if (widget.onItemSelected != null) {
                  widget.onItemSelected!(selectedValue);
                }
              });
            },
            // buttonHeight: 50,
            /*buttonWidth: widget.width ?? MediaQuery.of(context).size.width,*/
            // itemHeight: 40,
            /*buttonElevation: widget.isShowBorder ?? false ? 2 : 0,
            dropdownElevation: 8,
            offset: const Offset(0, 0),
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.isShowBorder ?? false ? 1 : 0),
              border: Border.all(
                color: widget.borderColor ?? Theme.of(context).primaryColorLight,
              ),
              color: widget.color ?? Theme.of(context).primaryColorLight,
            ),*/
          ),
        ),
      ),
    );
  }
}
