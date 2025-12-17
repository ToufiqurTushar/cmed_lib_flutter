import 'package:flutter/material.dart';
import '../../../common/helper/text_utils.dart';
import '../../../common/widget/marquee_widget.dart';


class ItemIndicator extends StatelessWidget {
  String label;
  Color color;
  Gradient? gradient;

  ItemIndicator(this.label, this.color, {Key? key, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: color,
            gradient: gradient),
          ),
          Flexible(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: MarqueeWidget(
                  direction: Axis.horizontal,
                  child: Text(label, maxLines: 1, style: CMEDTextUtils.labelTextStyle)
                )
            ),
          )

        ],
      ),
    );
  }
}
