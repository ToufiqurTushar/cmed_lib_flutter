import 'package:cached_network_image/cached_network_image.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import 'package:cmed_lib_flutter/common/widget/marquee_widget.dart';
import 'package:cmed_lib_flutter/page/image/full_image_arg.dart';
import 'package:cmed_lib_flutter/page/image/full_image_view.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_rapid/logic/rapid_global_state_logic.dart';
import 'package:flutter_svg/svg.dart';
import '../helper/utils.dart';

class HeaderWithBack extends StatelessWidget {
  final String? title;
  String? phone;
  String? fullName;
  String? profileUrl;
  int? gender;
  final Color? color;
  final bool? hasProfile;
  final Widget? trailingWidget;
  Function? onClickAction;

  HeaderWithBack(this.title,  {this.phone,this.profileUrl, this.fullName, this.color,this.hasProfile, this.onClickAction, this.trailingWidget});


  @override
  Widget build(BuildContext context) {
    return Obx((){
      final globalState = Get.find<RapidGlobalStateLogic>();
      if(globalState.currentUser.value is CustomerDTO) {
        final customer = globalState.currentUser.value as CustomerDTO;
        phone = customer.getPhoneNumber();
        fullName = customer.getFullName();
        gender = customer.gender;
      }

      return Card(
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        elevation: 2,
        shadowColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if(onClickAction == null) {
                      Get.back();
                    } else {
                      onClickAction!();
                    }
                  },
                ),
                MarqueeWidget(
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Visibility(
              visible: hasProfile??true,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      if(profileUrl?.isEmpty??false) return;
                      goToFullImageView(profileUrl);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CachedNetworkImage(
                        imageUrl: profileUrl ?? 'http://',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => SvgPicture.asset(Utils.getDefaultProfileAsset(gender), height: 40),
                        errorWidget: (context, url, error) => SvgPicture.asset(Utils.getDefaultProfileAsset(gender), height: 40),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName ?? 'label_guest_login'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          phone?.trDigit() ?? "01xxxxxxxxx",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Visibility(
                      visible: false,
                      child: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: Theme.of(context).primaryColor,
                      )
                  ),
                  if(trailingWidget != null)
                  trailingWidget!,
                  Visibility(visible: Get.find<RapidEnvConfig>().debug,child: InkWell(onTap:()=>ChuckerFlutter.showChuckerScreen(),child: Text('Network ')))
                ],
              ),
            ),
            // ),
            Visibility(
              visible: hasProfile??true,
              child: const SizedBox(
                height: 8,
              ),
            ),
          ],
        ),
      );});
  }

  static void goToFullImageView(String? imageUrl,{bool? isFile = false}){
    Get.toNamed(FullImageView.routeName,arguments: FullImageArg(image: imageUrl!, isLocalFile: isFile??false));
  }
}


