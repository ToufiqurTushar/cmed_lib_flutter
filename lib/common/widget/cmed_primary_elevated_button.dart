import 'package:cmed_lib_flutter/common/widget/marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

class CMEDPrimaryElevatedButton extends StatefulWidget {
  String buttonText;
  double? width;
  double? height;
  Function onClickAction;
  Color? buttonBgColor;
  Color? buttonTextColor;
  double? fontSize;
  double? radius;
  FontWeight? fontWeight;
  bool? isLoading;
  bool? isEnable;

  CMEDPrimaryElevatedButton(this.buttonText, this.onClickAction,
      {Key? key,
      this.width,
      this.height,
      this.radius,
      this.buttonBgColor,
      this.buttonTextColor,
      this.fontSize,
      this.isLoading,
      this.isEnable,
      this.fontWeight})
      : super(key: key);

  @override
  State<CMEDPrimaryElevatedButton> createState() =>
      _CMEDPrimaryElevatedButtonState();
}

class _CMEDPrimaryElevatedButtonState extends State<CMEDPrimaryElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return _widget(context);
  }

  Widget _widget(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonBgColor ?? Theme.of(context).primaryColor,
          shadowColor: Colors.white,
          fixedSize: Size(widget.width ?? 220, widget.height ?? 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius??30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10)),
      onPressed: () {
        if(widget.isEnable??true) {
          widget.onClickAction();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MarqueeWidget(
              child: Text(
                widget.buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: widget.fontSize ?? 16,
                    color: widget.buttonTextColor ?? Colors.white,
                    fontWeight: widget.fontWeight ?? FontWeight.normal),
              ),
            ),
            Visibility(
              visible: widget.isLoading??false,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(width:10, height:10,child: CircularProgressIndicator(color: Colors.white,)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
