import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:themed/themed.dart';


class ItemScreeringRecordHome extends StatefulWidget {
  String? title;
  String? subTitle;
  String? tailingText;
  String? footerText;
  String? asset;
  bool? boldSubtitle;
  bool? boldTitle;
  Function? onClickAction;
  bool? isAssetTypePng;
  bool isCircleRequired;
  Color? circularBorderColor;

  ItemScreeringRecordHome(
      this.title,
      this.asset, {
        Key? key,
        this.subTitle,
        this.tailingText,
        this.footerText,
        this.boldSubtitle,
        this.boldTitle,
        this.onClickAction,
        this.isAssetTypePng,
        this.isCircleRequired = false,
        this.circularBorderColor,
      }) : super(key: key);

  @override
  State<ItemScreeringRecordHome> createState() => _ItemScreeringRecordHomeState();
}

class _ItemScreeringRecordHomeState extends State<ItemScreeringRecordHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 8),
      child: Card(
        shadowColor: Theme.of(context).primaryColor,
        elevation: 2,
        child: InkWell(
          splashColor: Theme.of(context).primaryColorLight,
          onTap: () {
            if (widget.onClickAction != null) {
              widget.onClickAction!();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                   /* if(widget.isAssetTypePng??false)
                    Image.asset(
                        width: 56,
                        widget.asset!
                    ),
                    if(widget.isAssetTypePng == null || widget.isAssetTypePng == false)
                      SvgPicture.asset(
                        width: 56,
                        widget.asset ?? "assets/images/home/home_payment.svg"
                                            ),*/
                    widget.isCircleRequired
                        ? Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.circularBorderColor??Colors.green,
                          width: 3.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: widget.isAssetTypePng ?? false
                            ? Image.asset(
                          widget.asset!,
                          width: 30,
                          height: 30,
                        )
                            : SvgPicture.asset(
                          widget.asset ??
                              "assets/images/home/home_payment.svg",
                          width: 30,
                          height: 30,
                        ),
                      ),
                    )
                        : (widget.isAssetTypePng ?? false
                        ? Image.asset(
                      widget.asset!,
                      width: 56,
                    )
                        : SvgPicture.asset(
                      widget.asset ??
                          "assets/images/home/home_payment.svg",
                      width: 56,
                    )),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(widget.title ?? "",
                                  style: TextStyle(
                                      fontWeight: widget.boldTitle==false?FontWeight.normal: FontWeight.bold,
                                      fontSize: 14, color: Colors.black))
                          ),
                          Visibility(visible: widget.subTitle!=null, child: const SizedBox(height: 8,)),
                          Visibility(
                            visible: widget.subTitle != null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(widget.subTitle ?? "",
                                style: TextStyle(
                                  fontWeight: widget.boldSubtitle==true? FontWeight.bold: FontWeight.normal,
                                  fontSize: 12, color: Colors.black, overflow: TextOverflow.ellipsis,), maxLines: 1,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(visible: widget.tailingText != null, child: SizedBox(width: 70, child: Text(widget.tailingText??'', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),))),
                  ],
                ),
                Visibility(visible: widget.footerText != null, child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(widget.footerText??'', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11),),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}