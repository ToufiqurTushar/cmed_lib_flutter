import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/enum/eye_screening_type_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_distancevision_logic.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../../../common/widget/basic_app_bar.dart';

class EyeScreeningDistancevisionView extends RapidView<EyeScreeningDistancevisionLogic> {
  static String routeName = '/eye_screening_distancevision_view';
  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> WillPopScope(
            onWillPop: () async {
              if (controller.startScreening.isTrue) {
                controller.resetPage();
                return false;
              }
              return true;
            },
            child: Scaffold(
              appBar: BasicAppBar('label_distance_vision_test'.tr),
              body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Visibility(
                                visible: controller.startScreening.isFalse,
                                child: Column(
                                  children: [
                                    Text('info_distance_vision1'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.normal, fontSize: 16),),
                                    const SizedBox(height: 20,),
                                    Text('info_distance_vision2'.tr, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap:(){
                                              controller.startScreening.value = true;
                                              controller.farVisionTestType.value = EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1.name;
                                              controller.screeningForLeftEye.value = true;
                                              controller.screeningEyeTitle.value = 'label_distance_vision_test_left'.tr;
                                            },
                                            child: Container(
                                              height:50,
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(24)),
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Center(child: Text('label_check_distance_vision_test_left'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white),)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: InkWell(
                                            onTap:(){
                                              controller.startScreening.value = true;
                                              controller.farVisionTestType.value = EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1.name;
                                              controller.screeningForRightEye.value = true;
                                              controller.screeningEyeTitle.value = 'label_distance_vision_test_right'.tr;
                                            },
                                            child: Container(
                                              height:50,
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(24)),
                                                color: Colors.red,
                                              ),
                                              child: Center(child: Text('label_check_distance_vision_test_right'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white),)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                                      child: Center(child: Text('label_distance_vision_alternative_test'.tr, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Colors.red),)),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap:(){
                                              controller.startScreening.value = true;
                                              controller.farVisionTestType.value = EyeScreeningTypeEnum.ILLITERATE_TEST.name;
                                              controller.screeningForLeftEye.value = true;
                                              controller.screeningEyeTitle.value = 'label_distance_vision_test_left'.tr;
                                            },
                                            child: Container(
                                              height:80,
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Center(child: Text('label_distance_vision_illiterate_test'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white),)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: InkWell(
                                            onTap:(){
                                              controller.startScreening.value = true;
                                              controller.farVisionTestType.value = EyeScreeningTypeEnum.CHILDREN_EYE_TEST.name;
                                              controller.screeningForLeftEye.value = true;
                                              controller.screeningEyeTitle.value = 'label_distance_vision_test_left'.tr;
                                            },
                                            child: Container(
                                              height:80,
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Center(child: Text('label_distance_vision_children_test'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16,color: Colors.white),)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.isLeftEyeScreening() || controller.isRightEyeScreening(),
                                child: Text('${controller.screeningEyeTitle.value}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ),
                              const Spacer(),

                              Visibility(
                                visible: controller.isTextTypeTest(),
                                child: Text(controller.getLabel(), style: TextStyle(fontSize: controller.getFontSize()+5)),
                              ),
                              Visibility(
                                visible: controller.isImageTypeTest(),
                                child: Image.asset(controller.getImageAsset(), height: controller.getImageSize(),),
                              ),

                              const Spacer(),
                              Visibility(
                                visible: controller.isDefaultControllButton(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CMEDPrimaryElevatedButton(
                                        'label_clear'.tr,
                                        buttonBgColor: Theme.of(context).primaryColor,
                                            () => {
                                          controller.nextScreening(clear: true),
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12,),
                              Visibility(
                                visible: controller.isDefaultControllButton(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CMEDPrimaryElevatedButton(
                                        'label_unclear'.tr,
                                        buttonBgColor: Colors.red,
                                            () => {
                                          controller.nextScreening(clear: false),
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.isIlliterateControllButton(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CMEDPrimaryElevatedButton(
                                      ControllButtonForIlliterateEnum.getLabelByEnum(ControllButtonForIlliterateEnum.UP),
                                      width: 140,
                                      buttonBgColor: Colors.red,
                                          () => {
                                        controller.nextScreening(clear: controller.getClearOrUnclearStatus(ControllButtonForIlliterateEnum.UP)),
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12,),
                              Visibility(
                                visible: controller.isIlliterateControllButton(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CMEDPrimaryElevatedButton(
                                      ControllButtonForIlliterateEnum.getLabelByEnum(ControllButtonForIlliterateEnum.LEFT),
                                      width: 140,
                                      buttonBgColor: Theme.of(context).primaryColor,
                                          () => {
                                        controller.nextScreening(clear: controller.getClearOrUnclearStatus(ControllButtonForIlliterateEnum.LEFT)),
                                      },
                                    ),
                                    const SizedBox(width: 20,),
                                    CMEDPrimaryElevatedButton(
                                      ControllButtonForIlliterateEnum.getLabelByEnum(ControllButtonForIlliterateEnum.RIGHT),
                                      width: 140,
                                      buttonBgColor: Theme.of(context).primaryColor,
                                          () => {
                                        controller.nextScreening(clear: controller.getClearOrUnclearStatus(ControllButtonForIlliterateEnum.RIGHT)),
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12,),
                              Visibility(
                                visible: controller.isIlliterateControllButton(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CMEDPrimaryElevatedButton(
                                      ControllButtonForIlliterateEnum.getLabelByEnum(ControllButtonForIlliterateEnum.DOWN),
                                      width: 140,
                                      buttonBgColor: Colors.red,
                                          () => {
                                        controller.nextScreening(clear: false),
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
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
    Get.put(EyeScreeningDistancevisionLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
