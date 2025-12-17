
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:flutter/material.dart';


class CMEDDeviceConnectionButton extends StatefulWidget {
  final String title;
  IconData? iconData;
  Color? iconColor;
  Function onClickAction;

  CMEDDeviceConnectionButton(this.title, this.iconData, this.onClickAction,
      {super.key, this.iconColor});

  @override
  State<CMEDDeviceConnectionButton> createState() =>
      _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<CMEDDeviceConnectionButton> {
  bool _isAnimate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(300),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            widget.onClickAction();
            setState(() {
              _isAnimate = !_isAnimate;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                onEnd: () {
                  setState(() {
                    _isAnimate = !_isAnimate;
                  });
                },
                width: _isAnimate ? 300 : 170,
                height: _isAnimate ? 300 : 170,
                decoration: BoxDecoration(
                  color: _isAnimate
                      ? Theme.of(context).primaryColorLight
                  //  : AppColor.colorGreenLight,
                      : Theme.of(context).primaryColor,

                  borderRadius: BorderRadius.circular(300),
                ),
                duration: const Duration(seconds: 5),
                curve: Curves.fastOutSlowIn,
              ),
              Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(300),
                  )),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 10),
                  borderRadius: BorderRadius.circular(300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        widget.iconData,
                        color: widget.iconColor??Theme.of(context).primaryColor,
                        size: 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.title,
                        style: CMEDTextUtils.header1TextStyle.copyWith(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
