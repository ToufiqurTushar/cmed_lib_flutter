import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToast{
  static success(String message){
    Widget toastWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
      ),
      child: ListTile(
        minLeadingWidth: 0,
        dense: true,
        //leading: const Icon(Icons.close_rounded, color: Colors.white),
        title: Text(message, style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
      ),
    );

    FToast fToast = FToast();
    fToast.init(Get.overlayContext!);
    fToast.removeCustomToast();
    fToast.showToast(
      toastDuration: const Duration(milliseconds: 1500),
      child: toastWidget,
      gravity: ToastGravity.BOTTOM,
    );
  }
  static error(String message, {int? milliseconds}){
    Widget toastWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      child: ListTile(
        minLeadingWidth: 0,
        dense: true,
        //leading: const Icon(Icons.close_rounded, color: Colors.white),
        title: Text(message, style: const TextStyle(color: Colors.white, fontSize: 16),textAlign: TextAlign.center),
      ),
    );

    FToast fToast = FToast();
    fToast.init(Get.overlayContext!);
    fToast.removeCustomToast();
    fToast.showToast(
      toastDuration: Duration(milliseconds: milliseconds??1500),
      child: toastWidget,
      gravity: ToastGravity.BOTTOM,
    );
  }
}