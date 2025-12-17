import 'package:flutter/material.dart';

class CMEDDeviceConnectionView extends StatelessWidget {
  final String title;
  final String description;
  IconData indicatorIcon;
  Widget image;
  bool isCenterIconOnly;
  Color? iconColor;

  CMEDDeviceConnectionView(this.title, this.description, this.image,
      {this.indicatorIcon = Icons.check_circle,
      this.iconColor,
      this.isCenterIconOnly = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Text(title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  )))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: !isCenterIconOnly,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      indicatorIcon,
                                      color: iconColor??Theme.of(context).primaryColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: (isCenterIconOnly ? 8 : 18)),
                                  child: SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: image),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Center(
                                child: Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
