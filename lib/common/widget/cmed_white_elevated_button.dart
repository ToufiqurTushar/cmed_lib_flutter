import 'package:flutter_rapid/flutter_rapid.dart';

class CMEDWhiteElevatedButton extends StatefulWidget {
  String buttonText;
  double? width;
  double? height;
  bool? isEnable = true;
  Function onClickAction;
  Color? buttonBgColor;
  Color? buttonTextColor;
  bool? showIcon;
  IconData? iconData;
  CMEDWhiteElevatedButton(this.buttonText, this.onClickAction,
      {Key? key,
      this.width,
      this.height,
      this.buttonBgColor,
      this.buttonTextColor,
      this.isEnable,
      this.showIcon,
      this.iconData})
      : super(key: key);

  @override
  State<CMEDWhiteElevatedButton> createState() =>
      _CMEDWhiteElevatedButtonState();
}

class _CMEDWhiteElevatedButtonState extends State<CMEDWhiteElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return _widget(context);
  }

  Widget _widget(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: (widget.isEnable ?? true)
              ? (widget.buttonBgColor ?? Colors.white)
              : Theme.of(context).disabledColor,
          elevation: 2,
          shadowColor: (widget.isEnable ?? true)
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          fixedSize: Size(widget.width ?? 220, widget.height ?? 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10)),
      onPressed: () => {
        if (widget.isEnable ?? true) {widget.onClickAction()} else null
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              visible: widget.showIcon ?? false,
              child: Icon(
                widget.iconData ?? Icons.add,
                color: widget.buttonTextColor ?? Theme.of(context).primaryColor,
              )),
          Text(
            widget.buttonText,
            style: TextStyle(
                fontSize: 14,
                color: (widget.isEnable ?? true)
                    ? (widget.buttonTextColor ?? Theme.of(context).primaryColor)
                    : Theme.of(context).disabledColor,
                fontWeight: (widget.isEnable ?? true)
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
