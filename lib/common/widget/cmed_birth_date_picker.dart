import 'package:date_format/date_format.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';

class CMEDBirthDatePicker extends StatefulWidget {
  String? label;
  String? title;
  String? hint;
  bool? isShowCurrentDate = false;
  bool? isCalendarIconVisible = true; // New parameter to control icon visibility
  double? bottomMargin;
  Function? onDateSelect;
  var selectedDate = DateTime.now();

  CMEDBirthDatePicker({
    Key? key,
    this.label,
    this.bottomMargin,
    this.title,
    this.hint,
    this.isShowCurrentDate,
    this.isCalendarIconVisible, // Add it as a parameter
    this.onDateSelect,
  }) {
    if ((isShowCurrentDate ?? false) && title == null) {
      title = _getFormattedDate(DateTime.now());
    }
  }

  @override
  State<CMEDBirthDatePicker> createState() => _CMEDBirthDatePickerState();
}

class _CMEDBirthDatePickerState extends State<CMEDBirthDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: CMEDTextUtils.inputTextLabelStyleForProfileTitle,
          ),
        Container(
          color: Theme.of(context).primaryColorLight,
          height: 55,
          margin: EdgeInsets.only(top: 0, bottom: widget.bottomMargin ?? 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  datePicker(true);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                            widget.title ??
                                widget.hint ??
                                'label_select_date'.tr,
                            style: TextStyle(
                                color: widget.title == null
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ),
                      if (widget.isCalendarIconVisible ?? true) // Control visibility
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 5))))) {
      return true;
    }
    return false;
  }

  datePicker(bool isFrom) {
    return DatePicker.showDatePicker(context,
        pickerTheme: DateTimePickerTheme.Default,
        onMonthChangeStartWithFirstDate: true,
        minDateTime: DateTime.now().subtract(Duration(days: 43800)),
        onClose: () => {
          debugPrint("onClose"),
        },
        onCancel: () => {
          debugPrint("onCancel"),
        },
        onConfirm: (DateTime dateTime, List<int> selectedIndex) => {
          setState(() {
            widget.title = _getFormattedDate(dateTime);
            if (widget.onDateSelect != null) {
              widget.onDateSelect!(dateTime);
            }
          }),
          debugPrint("onConfirm$dateTime selectedIndex:$selectedIndex"),
          widget.selectedDate = dateTime,
        },
        onChange: (DateTime dateTime, List<int> selectedIndex) => {
          debugPrint("onChange$dateTime selectedIndex:$selectedIndex"),
        },
        maxDateTime: DateTime.now(),
        pickerMode: DateTimePickerMode.date);
  }
}

String _getFormattedDate(DateTime dateTime) {
  return formatDate(dateTime, [dd, ' ', M, ' ', yyyy]);
}

