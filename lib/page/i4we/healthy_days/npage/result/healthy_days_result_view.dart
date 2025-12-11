import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../common/widget/basic_app_bar.dart';
import 'healthy_days_result_logic.dart';

class HealthyDaysResultView extends RapidView<HealthyDaysResultLogic> {
  static String routeName = '/HealthyDaysResultView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('Healthy Days'.tr),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/healthy_days_result.png', package:'cmed_lib_flutter'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(4.0, 12 ,4, 4),
                                    child: Container(
                                      width: double.infinity,
                                      child: FrElevatedButton(
                                        name:controller.selectedSurveyResult.value.result?.status??'',
                                        onPressed: () => {

                                        },
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: controller.selectedSurveyResult.value.result?.colorCode?.toColor(),
                                          foregroundColor: Colors.white,
                                          elevation: 10,
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Rounded corners
                                          ),
                                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0 ,12, 12),
        child: FrElevatedButton(
          name:!controller.healthyDaysResultArgument.isFromHistory?'FINISH'.tr: 'End'.tr,
          onPressed: () => {
            Get.back()
          },
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 10,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
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
    Get.put(HealthyDaysResultLogic());
  }
}
