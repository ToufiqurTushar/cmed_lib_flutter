import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/enum/eye_screening_type_enum.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_result_logic.dart';
import 'package:cmed_lib_flutter/common/widget/marquee_widget.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../common/widget/basic_app_bar.dart';


class EyeScreeningResultView extends RapidView<EyeScreeningResultLogic> {
  static String routeName = '/eye_screening_result_view';

  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> Scaffold(
        appBar: BasicAppBar(controller.getTitle()),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text('${controller.getTitle()}',
                                      style: CMEDTextUtils.header1TextStyle,
                                    )
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(height: 8,),
                                Visibility(
                                  visible: controller.showRemeasureButton(),
                                  child: InkWell(
                                    onTap: (){
                                      controller.reMeasure();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        color: Theme.of(context).primaryColorLight,
                                      ),
                                      child: Row(children: [
                                        Expanded(child: MarqueeWidget(child: Text(controller.getRemeasureTitle(),style: TextStyle(fontWeight: FontWeight.bold),))),
                                       // const Icon(Icons.refresh)
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            child: IconButton(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                constraints: BoxConstraints(),
                                                onPressed: (){
                                                  controller.reMeasure();
                                                },
                                                icon: const Icon(Icons.refresh, color: Colors.white,)
                                            )
                                        )
                                      ],),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(120),
                                              border: Border.all(
                                                  color: controller.screeningReport.value.eyeScreening!.first.eyeScreeningResult!.getResultColorByEyeScreenType(controller.eyeScreeningTypeEnum!),
                                                  width: 4.0,
                                                  style: BorderStyle.solid)),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  width: 30,
                                                  height: 30,
                                                  'assets/images/measurement/${controller.getImageAsset()}'
                                              ),
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(controller.testedResultSuggestion.value,textAlign: TextAlign.left,)
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(height: 8,),
                                Visibility(visible:controller.isLoading.isTrue,child: const Text('loading')),
                                Visibility(
                                  visible:controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE || controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CMEDPrimaryElevatedButton(
                                          'label_tested_value'.tr,
                                          radius: 8,
                                          buttonBgColor: Theme.of(context).primaryColor,
                                              () => {

                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 4,),
                                      Visibility(
                                        visible:controller.eyeScreeningTypeEnum != EyeScreeningTypeEnum.CONTRAST_TEST,
                                        child: Expanded(
                                          child: CMEDPrimaryElevatedButton(
                                            'label_normal_value'.tr,
                                            radius: 8,
                                            buttonBgColor: Theme.of(context).primaryColor,
                                                () => {

                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1 ||controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.ILLITERATE_TEST ||controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.CHILDREN_EYE_TEST,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CMEDPrimaryElevatedButton(
                                          'label_distance_vision_left_va'.tr,
                                          radius: 8,
                                          buttonBgColor: Theme.of(context).primaryColor,
                                              () => {

                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8,),
                                      Expanded(
                                        child: CMEDPrimaryElevatedButton(
                                          'label_distance_vision_right_va'.tr,
                                          radius: 8,
                                          buttonBgColor: Theme.of(context).primaryColor,
                                              () => {

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Visibility(
                                  visible:controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE || controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CMEDPrimaryElevatedButton(
                                          controller.testedResultMessage.value,
                                          radius: 8,
                                          buttonTextColor: Colors.black,
                                          buttonBgColor: Theme.of(context).primaryColorLight,
                                              () => {

                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 4,),
                                      Visibility(
                                        visible:controller.eyeScreeningTypeEnum != EyeScreeningTypeEnum.CONTRAST_TEST,
                                        child: Expanded(
                                          child: CMEDPrimaryElevatedButton(
                                            controller.eyeScreeningTypeEnum?.normalValue??'',
                                            radius: 8,
                                            buttonTextColor: Colors.black,
                                            buttonBgColor: Theme.of(context).primaryColorLight,
                                                () => {

                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1 ||controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.ILLITERATE_TEST ||controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.CHILDREN_EYE_TEST,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CMEDPrimaryElevatedButton(
                                          controller.testedResultLeftEyeMessage.value,
                                          radius: 8,
                                          buttonTextColor: Colors.black,
                                          buttonBgColor: Theme.of(context).primaryColorLight,
                                              () => {

                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 4,),
                                      Expanded(
                                        child: CMEDPrimaryElevatedButton(
                                          controller.testedResultRightEyeMessage.value,
                                          radius: 8,
                                          buttonTextColor: Colors.black,
                                          buttonBgColor: Theme.of(context).primaryColorLight,
                                              () => {

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16,),
                                Visibility(visible:controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST, child:Text('label_color_contrast_referal_criteria'.tr, style: CMEDTextUtils.header1TextStyle,)),
                                const SizedBox(height: 8,),
                                Visibility(
                                  visible:controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:Container(
                                          height:65,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Center(child: Text('label_dangerous_value'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),)),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child:Container(
                                          height:65,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Center(child: Text('label_normal_value'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),)),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child:Container(
                                          height:65,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Center(child: Text('label_referral_value'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Visibility(
                                  visible:controller.eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:Container(
                                          height: 70,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: Theme.of(context).primaryColorLight,
                                          ),
                                          child: Center(child: Text('1.5 - 2.0'.tr, textAlign: TextAlign.center)),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child:Container(
                                          height: 70,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: Theme.of(context).primaryColorLight,
                                          ),
                                          child: Center(child: Text('2.1 - 2.25'.tr, textAlign: TextAlign.center)),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child:Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: Theme.of(context).primaryColorLight,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Center(child: Text('label_less_than_one_point_five'.tr, textAlign: TextAlign.center)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                            children: [
                              Visibility(
                                visible:controller.showstartDistanceVisionEyeScreeningButton(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CMEDPrimaryElevatedButton(
                                        'label_start_distance_vision_test'.tr,
                                        buttonBgColor: Theme.of(context).primaryColor,
                                            () => {
                                          controller.startDistanceVisionEyeScreening()
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12,),
                              Visibility(
                                visible: controller.showSaveButton(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CMEDPrimaryElevatedButton(
                                        'label_save'.tr,
                                        buttonBgColor: Theme.of(context).primaryColor,
                                            () => {
                                          controller.saveLocal(),
                                          Get.back(),
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12,),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return EyeScreeningHomeI18N.getTranslations();
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {

    Get.put(ScreeningReportRepository());
    Get.put(EyeScreeningResultLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
