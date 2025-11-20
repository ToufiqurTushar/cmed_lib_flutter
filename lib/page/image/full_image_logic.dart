import 'dart:io';

import 'package:flutter_rapid/extend/rapid_start_logic.dart';
import 'package:get/get.dart';

import 'full_image_arg.dart';

class FullImageLogic extends RapidStartLogic{
  FullImageArg arg = Get.arguments as FullImageArg;

  var imageUrl = ''.obs;
  var isLocalFile = false.obs;

  @override
  void onInit() {
    super.onInit();
    imageUrl.value = arg.image;
    isLocalFile.value = arg.isLocalFile??false;
  }
  
}