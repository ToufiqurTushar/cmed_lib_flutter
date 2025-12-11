import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'header_with_back.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(100);

  BasicAppBar(
      this.title, {
        super.key,
        this.trailingWidget,
        this.onClickAction,
        this.color,
        this.hasProfile,
        this.showTitleBar,
      }
      );

  final String title;
  final Widget? trailingWidget;
  Function? onClickAction;
  Color? color;
  bool? hasProfile;
  bool? showTitleBar;


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: HeaderWithBack(title, trailingWidget: trailingWidget, onClickAction: onClickAction, color: color, hasProfile: hasProfile, showTitleBar: showTitleBar,));
  }
}
