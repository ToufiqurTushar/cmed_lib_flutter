import 'package:cmed_lib_flutter/survey/widget/round_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final String? subLabel;
  final VoidCallback onTap;  // Callback function for tap event

  const GroupItem({
    Key? key,
    required this.iconPath,
    required this.label,
    this.subLabel,
    required this.onTap,  // Initialize the callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // Handle tap event
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0), // No rounded corners
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.transparent, // Make the card's background transparent to avoid border
        child: Container(
          padding: const EdgeInsets.only(left: 6.0), // Added 10 dp padding here
          height: 80, // Fixed height of the card
          child: Row(
            children: [
              // SVG Image on the left
              RoundImage(iconPath, 45, defaultImage: "assets/images/ic_anemia.svg",color: Colors.white70,),
              const SizedBox(width: 12.0), // Space between image and text
              // Text on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis, // Handle long text overflow
                    ),

                    //subLabel if not null
                    if(subLabel != null)
                    const SizedBox(height: 4,),
                    if(subLabel != null)
                    Text(
                      subLabel!,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis, // Handle long text overflow
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
