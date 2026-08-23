import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/i4we/anemia_survey/npage/result/anemia_survey_result_argument.dart';
import '../../../../../common/helper/text_utils.dart';
import '../../../../../common/widget/basic_app_bar.dart';
import '../../../../../common/widget/marquee_widget.dart';
import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../../survey/widget/round_image.dart';
import '../../anemia_survey_argument.dart';
import '../../anemia_survey_view.dart';
import 'anemia_survey_result_argument.dart';
import 'anemia_survey_result_logic.dart';
import 'anemia_survey_result_logic.dart';

class AnemiaSurveyResultView extends RapidView<AnemiaSurveyResultLogic> {
  static String routeName = '/AnemiaSurveyResultView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('Anemia'.tr),
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
                          padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Image.asset('assets/images/anemia_result.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(4.0, 40 ,4, 12),
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
                                  ),

                                  // Card(
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Text(
                                  //       controller.selectedSurveyResult.value.result?.advice?.tr??'',
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(
                                  //         fontSize: 15,
                                  //         color: Colors.black87,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
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
          name:!controller.isHistoryView.value?'FINISH'.tr: 'End'.tr,
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
    Get.put(AnemiaSurveyResultLogic());
  }
}
