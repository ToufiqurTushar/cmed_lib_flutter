import 'package:cmed_lib_flutter/survey/widget/round_image.dart';
import 'package:flutter_rapid/flutter_rapid.dart';


Card SurveyResultItemWidget({required BuildContext context, Color? color, required String title, required String image, String? defaultImage, String? subtitle, required String date, required GestureTapCallback onTap}) {
  return Card(
    color: Colors.white,
    child: ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color??Colors.red,
        child: ClipOval(child: Container(color:Colors.white, child: RoundImage(image, 42, defaultImage: defaultImage??"assets/images/ic_anemia.svg", color: Colors.white,),)),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color??Colors.black),),
      subtitle: subtitle==null?null:Text(subtitle),
      trailing: Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12),),
      onTap: onTap,
    ),
  );
}
