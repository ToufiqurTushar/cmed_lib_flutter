import 'package:cmed_lib_flutter/survey/widget/round_image.dart';
import 'package:flutter_rapid/flutter_rapid.dart';


Card SurveyResultItemWidget({required BuildContext context, Color? color, required String title, required String serverImage, String? defaultImage, String? subtitle, bool isColoredTitle = false, required String date, required GestureTapCallback onTap}) {
  return Card(
    color: Colors.white,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color ?? Colors.red,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  child: RoundImage(
                    serverImage,
                    42,
                    defaultImage: defaultImage ?? "assets/images/ic_anemia.svg",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: isColoredTitle ? color ?? Colors.black : Colors.black),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
