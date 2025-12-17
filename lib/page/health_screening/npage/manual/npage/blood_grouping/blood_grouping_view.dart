import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';
import 'blood_grouping_i18n.dart';
import 'blood_grouping_logic.dart';


class BloodGroupingView extends RapidView<BloodGroupingLogic> {
  static String routeName = "/bloodGrouping";

  const BloodGroupingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('Blood Grouping'.tr),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Blood Group & Rh Typing".tr,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      height: 1.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/blood_grouping/ic_blood_grouping_agglutination.svg',
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  "Agglutination".tr,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/blood_grouping/ic_blood_grouping_no_agglutination.svg',
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  "No Agglutination".tr,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      height: 1.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAntigenRow(
                          context,
                          label: "Antigen A".tr,
                          value: controller.antigenAValue,
                        ),
                        const SizedBox(height: 10.0),
                        buildAntigenRow(
                          context,
                          label: "Antigen B".tr,
                          value: controller.antigenBValue,
                        ),
                        const SizedBox(height: 10.0),
                        buildAntigenRow(
                          context,
                          label: "Antigen D".tr,
                          value: controller.antigenDValue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: CMEDPrimaryElevatedButton(
                  'RESULT'.tr,
                  height: 50,
                  () => {
                    controller.sendMeasurement()
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildAntigenRow(BuildContext context,
      {required String label, required RxString value}) {
    return GestureDetector(
      onTap: () => _showValueDialog(context, label, value),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 5.0),
          Container(
            height: 60,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).primaryColorLight,
            ),
            child: Row(
              children: [
                // Update the image based on the value
                SvgPicture.asset(
                  value.value == "Agglutination"
                      ? 'assets/images/blood_grouping/ic_blood_grouping_agglutination.svg'
                      : 'assets/images/blood_grouping/ic_blood_grouping_no_agglutination.svg',
                  width: 24.0,
                  height: 24.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    value.value == "Agglutination"? "Agglutination".tr: "No Agglutination".tr,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 24.0),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      )),
    );
  }


  void _showValueDialog(BuildContext context, String label, RxString value) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'label_select_blood_typing'.tr,
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => ListTile(
                leading: SvgPicture.asset(
                  'assets/images/blood_grouping/ic_blood_grouping_agglutination.svg',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.contain,
                ),
                title: Text("Agglutination".tr),
                tileColor: value.value == "Agglutination"
                    ? Theme.of(context).primaryColorLight
                    : Colors.transparent,
                onTap: () {
                  value.value = "Agglutination"; // Update value here
                  Navigator.of(context).pop(); // Close the dialog
                },
              )),
              const SizedBox(height: 8.0),
              Obx(() => ListTile(
                leading: SvgPicture.asset(
                  'assets/images/blood_grouping/ic_blood_grouping_no_agglutination.svg',
                  width: 24.0,
                  height: 24.0,
                ),
                title: Text("No Agglutination".tr),
                tileColor: value.value == "No Agglutination"
                    ? Theme.of(context).primaryColorLight
                    : Colors.transparent,
                onTap: () {
                  value.value = "No Agglutination"; // Update value here
                  Navigator.of(context).pop(); // Close the dialog
                },
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "label_cancel".tr,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }




  @override
  void loadDependentLogics() {
    Get.put(ScreeningReportRepository());
    Get.put(BloodGroupingLogic(repository: Get.find<ScreeningReportRepository>()));
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return BloodGroupingI18N.getTranslations();
  }
}
