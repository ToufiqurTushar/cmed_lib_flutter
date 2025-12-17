import 'package:flutter/material.dart';


class CMEDWhiteIconElevatedButton extends StatefulWidget {
  String buttonText;
  double? width;
  double? height;
  Function onClickAction;
  IconData iconData;
  Color? buttonColor;
  Color? textColor;
  double? radius;

  CMEDWhiteIconElevatedButton(this.buttonText, this.onClickAction,this.iconData,
      {Key? key, this.width, this.height, this.buttonColor,this.textColor, this.radius})
      : super(key: key);

  @override
  State<CMEDWhiteIconElevatedButton> createState() =>
      _CMEDWhiteIconElevatedButtonState();
}

class _CMEDWhiteIconElevatedButtonState
    extends State<CMEDWhiteIconElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return _widget(context);
  }

  Widget _widget(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor??Colors.white,
          shadowColor: Theme.of(context).primaryColor,
          fixedSize:  Size(widget.width ?? 220, widget.height ?? 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius??30.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10)),
      icon: Icon(
        widget.iconData,
        color:widget.textColor??Theme.of(context).primaryColor,
      ),
      onPressed: () {
        widget.onClickAction();
      },
      label:  Text(
       widget.buttonText,
        style: TextStyle(fontSize: 14, color: widget.textColor??Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
      ),
    );
  }
}
