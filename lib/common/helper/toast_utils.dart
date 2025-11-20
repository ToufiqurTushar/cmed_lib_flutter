import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ShowToast{
  static error(String message, {bool isLongLength = false}){
    Fluttertoast.showToast(
        msg: message,
        toastLength: isLongLength?Toast.LENGTH_SHORT: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // Widget toastWidget = Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: Colors.red,
    //   ),
    //   child: ListTile(
    //     minLeadingWidth: 0,
    //     leading: const Icon(Icons.close_rounded, color: Colors.white),
    //     title: Text(message, style: const TextStyle(color: Colors.white, fontSize: 16),),
    //   ),
    // );
    //
    // FToast fToast = FToast();
    // fToast.init(Get.overlayContext!);
    // fToast.showToast(
    //   toastDuration: Duration(milliseconds: milliseconds??1500),
    //   child: toastWidget,
    //   gravity: ToastGravity.CENTER,
    // );
  }
  static success(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // Widget toastWidget = Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: Colors.green,
    //   ),
    //   child: ListTile(
    //     minLeadingWidth: 0,
    //     leading: const Icon(Icons.check, color: Colors.white),
    //     title: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14),),
    //   ),
    // );
    //
    // FToast fToast = FToast();
    // fToast.init(Get.overlayContext!);
    // fToast.showToast(
    //   toastDuration: const Duration(milliseconds: 1500),
    //   child: toastWidget,
    //   gravity: ToastGravity.CENTER,
    // );
  }

  static showLoadingToast({String? message}){
    Widget toastWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
      ),
      child: ListTile(
        minLeadingWidth: 0,
        leading: Transform.scale(scale: 0.5, child: const CircularProgressIndicator(color: Colors.white)),
        title: Text(message??"Loading...", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
      ),
    );

    FToast fToast = FToast();
    fToast.init(Get.overlayContext!);
    fToast.showToast(
      toastDuration: const Duration(milliseconds: 3000),
      child: toastWidget,
      gravity: ToastGravity.CENTER,
    );
  }
}