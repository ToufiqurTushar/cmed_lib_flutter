import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ItemMeasurementCard extends StatefulWidget {
  int codeId;
  String? label;
  String? subTitle;
  String? asset;
  bool isThemeV2;
  Function? onClickAction;

  ItemMeasurementCard(this.label, this.asset, {Key? key,required this.codeId, this.isThemeV2 = false, this.subTitle,this.onClickAction}) : super(key: key);

  @override
  State<ItemMeasurementCard> createState() => _ItemMeasurementCard();
}

class _ItemMeasurementCard extends State<ItemMeasurementCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      shadowColor: Theme.of(context).primaryColor,
      child: InkWell(
        splashColor: Theme.of(context).primaryColorLight,
        onTap: (){
          if(widget.onClickAction!=null) {
            widget.onClickAction!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 2,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 7),
                    child: SvgPicture.asset(
                        width: 40,
                        widget.asset ?? "assets/images/home/home_payment.svg",
                        semanticsLabel: widget.label ?? "label"),
                  ),
                  if(widget.isThemeV2)
                  SvgPicture.asset(
                    "assets/icons-v2/seal.svg",
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Expanded(
                child: Text(widget.label ?? "",
                    textAlign: TextAlign.center,
                    style:
                    const TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold,)),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
