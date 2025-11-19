
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundImage extends StatelessWidget {
  final String? image;
  final double size;
  final String? defaultImage;
  final Color? color;
  const RoundImage(this.image, this.size,  {this.defaultImage, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    if(image == null || image?.trim() == "") {
      if(defaultImage != null && defaultImage!.contains("svg")) {
        return SvgPicture.asset(defaultImage!, width: size,);
      } else if(defaultImage != null){
        return Image.asset(defaultImage!, width: size,);
      }
      return SvgPicture.asset("assets/images/ic_male.svg", width: size, package: 'cmed_lib_flutter',);
    }
    return CachedNetworkImage(
      imageUrl: image!,
      imageBuilder: (context, imageProvider) =>
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color??Theme.of(context).primaryColor,
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover),
            ),
          ),
      placeholder: (context, url) => SvgPicture.asset(defaultImage??"assets/images/ic_male.svg", width: size, package: 'cmed_lib_flutter',),
      errorWidget: (context, url, error) => SvgPicture.asset(defaultImage??"assets/images/ic_male.svg", width: size, package: 'cmed_lib_flutter',),
    );
  }
}
