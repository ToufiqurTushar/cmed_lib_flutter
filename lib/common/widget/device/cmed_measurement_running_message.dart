import 'package:flutter/material.dart';

import '../../helper/text_utils.dart';


class CMEDMeasurementRunningMessage extends StatefulWidget {
  String text;

  CMEDMeasurementRunningMessage(this.text, {super.key});

  @override
  State<CMEDMeasurementRunningMessage> createState() =>
      _CMEDMeasurementRunningMessage();
}

class _CMEDMeasurementRunningMessage
    extends State<CMEDMeasurementRunningMessage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              "assets/images/screening/img_pending_connection.png",
              width: 40,
            )


            // RotationTransition(
            //   turns: CurvedAnimation(
            //       parent: AnimationController(
            //           duration: const Duration(seconds: 5), vsync: this)
            //         ..repeat(reverse: false),
            //       curve: Curves.easeInOut),
            //   child: SvgPicture.asset(
            //     "assets/images/common/ic_pending.svg",
            //     width: 48,
            //   ),
            // ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Text(widget.text, style: CMEDTextUtils.header1TextStyle.copyWith()),
            ),
          )
        ],
      ),
    );
  }
}
