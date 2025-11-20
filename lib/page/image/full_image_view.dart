import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:photo_view/photo_view.dart';
import 'full_image_logic.dart';

class FullImageView extends RapidView<FullImageLogic> {
  static String routeName = '/full_image_view';

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () => PhotoView(
                      enableRotation: false,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 3.5,
                      initialScale: PhotoViewComputedScale.contained,
                      basePosition: Alignment.center,
                      imageProvider: _getImageProvider()),

                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getImageProvider(){
    if( controller.isLocalFile.value) {
      return FileImage(File(controller.imageUrl.value));
    }else {
      return CachedNetworkImageProvider(controller.imageUrl.value,);
    }
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {};
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.put(FullImageLogic());
  }
}
