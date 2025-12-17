import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:themed/themed.dart';


class ItemScreeringRecordHomeWithBackground extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? tailingText;
  final String? footerText;
  final String? asset;
  final bool? boldTitle;
  final bool? boldSubtitle;
  final Function? onClickAction;
  final bool? isAssetTypePng;

  ItemScreeringRecordHomeWithBackground(
      this.title,
      this.asset, {
        Key? key,
        this.subTitle,
        this.tailingText,
        this.footerText,
        this.boldTitle,
        this.boldSubtitle,
        this.onClickAction,
        this.isAssetTypePng,
      }) : super(key: key);

  @override
  State<ItemScreeringRecordHomeWithBackground> createState() => _ItemScreeringRecordHomeWithBackground();
}

class _ItemScreeringRecordHomeWithBackground extends State<ItemScreeringRecordHomeWithBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Card(
        shadowColor: Theme.of(context).primaryColor,
        elevation: 2,
        child: InkWell(
          splashColor: Theme.of(context).primaryColorLight,
          onTap: widget.onClickAction as void Function()?,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 84, // Keep the same size for the background
                      height: 54, // Keep the same size for the background
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight.withOpacity(0.2), // Lighter color by reducing opacity
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Increased padding to make the image smaller
                        child: widget.isAssetTypePng ?? false
                            ? Image.asset(
                          widget.asset ?? "",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 32);
                          },
                        )
                            : SvgPicture.asset(
                          widget.asset ?? "assets/images/home/home_payment.svg",
                          fit: BoxFit.contain,
                          placeholderBuilder: (context) =>
                          const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title ?? "",
                            style: TextStyle(
                              fontWeight: widget.boldTitle == false
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          if (widget.subTitle != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              widget.subTitle ?? "",
                              style: TextStyle(
                                fontWeight: widget.boldSubtitle == true
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.tailingText != null)
                      SizedBox(
                        width: 70,
                        child: Text(
                          widget.tailingText!,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                if (widget.footerText != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.footerText!,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
