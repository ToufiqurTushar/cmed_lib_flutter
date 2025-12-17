import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';

class CMEDDropdownSelect extends StatelessWidget {
  String? label;
  String? dropdownTitle;
  final List<MasterDataDTO> items;
  final MasterDataDTO? item;
  final EdgeInsetsGeometry? padding;
  final Function onItemSelected;
  Color? color;
  Color? borderColor;
  bool? isShowBorder = false;
  double? width;
  CMEDDropdownSelect(this.items,
      {Key? key,
      this.dropdownTitle,
      this.label,
      this.item,
      required this.onItemSelected,
      this.color,
      this.borderColor,
      this.isShowBorder,
      this.width,
      this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).primaryColorLight;
    if (item != null) {
      dropdownTitle = (item?.labelEn??'').tr;
    }
    if (borderColor == null) color = Theme.of(context).primaryColorLight;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: CMEDTextUtils.inputTextLabelStyleForProfileTitle,
          ),
        Container(
          color: color ?? Theme.of(context).primaryColorLight,
          margin: const EdgeInsets.only(top: 0, bottom: 12),
          height: 50,
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isDense: false,
                  isExpanded: true,
                  hint: Text(
                    dropdownTitle ?? "label_select".tr,
                    style: TextStyle(
                        fontSize: 14,
                        color: dropdownTitle != null
                            ? Colors.black
                            : Theme.of(context).hintColor),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<MasterDataDTO>(
                            value: item,
                            child: Text((item.labelEn ?? '').tr,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: null,
                  onChanged: (value) {
                    onItemSelected(value);
                  },
                  // buttonHeight: 50,
                  /* buttonWidth: width ?? MediaQuery.of(context).size.width,*/
                  // itemHeight: 40,
                  /*buttonElevation: isShowBorder ?? false ? 2 : 0,
                  dropdownElevation: 8,
                  offset: const Offset(0, 0),
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isShowBorder ?? false ? 1 : 0),
                    border: Border.all(
                      color: borderColor ?? Theme.of(context).primaryColorLight,
                    ),
                    color: color ?? Theme.of(context).primaryColorLight,
                  ),*/
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
