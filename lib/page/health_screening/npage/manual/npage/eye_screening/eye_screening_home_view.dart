import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/linear_loading.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_colorblind_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_contrast_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_distancevision_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_nearvision_view.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import '../../../../dto/measurement_dto.dart';
import '../../nview/item_screening_record_home_with_background.dart';
import '../../nview/item_screening_result_home.dart';
import 'enum/eye_screening_type_enum.dart';
import 'npage/eye_screening_result_view.dart';

class EyeScreeningHomeView extends RapidView<EyeScreeningHomeLogic> {
  static String routeName = '/eye_screening_home_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('label_eye_screening'.tr),
      body: Obx(
            ()=> SafeArea(
          child: Column(
            children: [
              LinearLoading(isVisible: controller.isLoading.isTrue),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('label_select_sest'.tr, style: CMEDTextUtils.header1TextStyle,),
                      ),

                      ItemScreeringRecordHomeWithBackground(
                        'label_near_vision_test'.tr,
                        "assets/images/measurement/ic_near_vision_new.svg",
                        boldTitle: false,
                        onClickAction: (){
                          Get.toNamed(EyeScreeningNearvisionView.routeName, arguments: {"accessFrom": controller.accessFrom,});
                        },
                      ),
                      ItemScreeringRecordHomeWithBackground(
                        'label_distance_vision_test'.tr,
                        "assets/images/measurement/ic_distance_vision_new.svg",
                        boldTitle: false,
                        onClickAction: () => {
                          Get.toNamed(EyeScreeningDistancevisionView.routeName, arguments: {"accessFrom": controller.accessFrom,}),
                        },
                      ),
                      ItemScreeringRecordHomeWithBackground(
                        'label_color_blind_test'.tr,
                        "assets/images/measurement/ic_color_blind_new.svg",
                        boldTitle: false,
                        onClickAction: () => {
                          Get.toNamed(EyeScreeningColorblindView.routeName),
                        },
                      ),
                      ItemScreeringRecordHomeWithBackground(
                        'label_color_contrast_test'.tr,
                        "assets/images/measurement/ic_color_contrast_new.svg",
                        boldTitle: false,
                        onClickAction: () => {
                          Get.toNamed(EyeScreeningContrastView.routeName),
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Visibility(
                        visible: controller.showTestResult(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('label_test_result'.tr, style: CMEDTextUtils.header1TextStyle,),
                        ),
                      ),

                      Visibility(
                        visible: GetUtils.isNullOrBlank(controller.nearVisionBothEyeResult.value.createdAt) != true,
                          child: ItemScreeringResultHome(
                            'label_near_vision_both_eye_test'.tr,
                            controller.accessFrom == "User_App"? "assets/images/measurement/ic_near_vision_new.svg" : "assets/images/measurement/ic_near_vision.svg",
                            circularBorderColor: controller.nearVisionBothEyeResult.value.eyeScreeningResult?.getResultColorByEyeScreenType(EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE),
                            isAssetTypePng: false,
                            subTitle: null,
                            boldTitle: false,
                            tailingText: controller.nearVisionBothEyeResult.value.eyeScreeningResult?.message ?? '',
                            footerText: CustomDateUtils.format(
                              controller.nearVisionBothEyeResult.value.createdAt,
                              format: CustomDateUtils.HH_MM_A_DD_MMM_YYYY,
                            ).trDate(),
                            onClickAction: (){
                              Get.toNamed(EyeScreeningResultView.routeName, arguments: [
                                {
                                  "screeningReport": MeasurementDTO(
                                    eyeScreening: [
                                      EyeScreening(
                                        eyeScreeningResult : controller.nearVisionBothEyeResult.value.eyeScreeningResult,
                                        screenType: EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE.name,
                                      )
                                    ],
                                  )
                                }
                              ]);
                            },
                          )
                      ),
                      Visibility(
                        visible: GetUtils.isNullOrBlank(controller.farVisionDistance1Result.value.createdAt) != true,
                        child: ItemScreeringResultHome(
                          EyeScreeningTypeEnum.getNameByNameType(controller.farVisionDistance1Result.value.screenType),
                          controller.accessFrom == "User_App"? "assets/images/measurement/ic_distance_vision_new.svg" : "assets/images/measurement/ic_distance_vision.svg",
                          circularBorderColor: controller.farVisionDistance1Result.value.eyeScreeningResult?.getResultColorByEyeScreenType(EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1),
                          subTitle: null,
                          boldTitle: false,
                          tailingText: '${'label_eye_screening_left'.tr} ${controller.farVisionDistance1Result.value.eyeScreeningResult?.leftEye} \n${'label_eye_screening_right'.tr} ${controller.farVisionDistance1Result.value.eyeScreeningResult?.rightEye}',
                          footerText: CustomDateUtils.format(controller.farVisionDistance1Result.value.createdAt, format: CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDate(),
                          onClickAction: () {
                            Get.toNamed(EyeScreeningResultView.routeName, arguments: [
                              {
                                "screeningReport": MeasurementDTO(
                                  eyeScreening: [
                                    EyeScreening(
                                      eyeScreeningResult : controller.farVisionDistance1Result.value.eyeScreeningResult,
                                      screenType: EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1.name,
                                    )
                                  ],
                                )
                              }
                            ]);
                          },
                        ),
                      ),
                      Visibility(
                        visible: GetUtils.isNullOrBlank(controller.farVisionIlliterateResult.value.createdAt) != true,
                        child: ItemScreeringResultHome(
                          EyeScreeningTypeEnum.getNameByNameType(controller.farVisionIlliterateResult.value.screenType),
                          "assets/images/measurement/ic_distance_vision.svg",
                          circularBorderColor: controller.farVisionIlliterateResult.value.eyeScreeningResult?.getResultColorByEyeScreenType(EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1),
                          subTitle: null,
                          boldTitle: false,
                          tailingText: '${'label_eye_screening_left'.tr} ${controller.farVisionIlliterateResult.value.eyeScreeningResult?.leftEye} \n${'label_eye_screening_right'.tr} ${controller.farVisionIlliterateResult.value.eyeScreeningResult?.rightEye}',
                          footerText: CustomDateUtils.format(controller.farVisionIlliterateResult.value.createdAt, format: CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDate(),
                          onClickAction: () {
                            Get.toNamed(EyeScreeningResultView.routeName, arguments: [
                              {
                                "screeningReport": MeasurementDTO(
                                  eyeScreening: [
                                    EyeScreening(
                                      eyeScreeningResult : controller.farVisionIlliterateResult.value.eyeScreeningResult,
                                      screenType: EyeScreeningTypeEnum.ILLITERATE_TEST.name,
                                    )
                                  ],
                                )
                              }
                            ]);
                          },
                        ),
                      ),
                      Visibility(
                        visible: GetUtils.isNullOrBlank(controller.farVisionChildrenResult.value.createdAt) != true,
                        child: ItemScreeringResultHome(
                          EyeScreeningTypeEnum.getNameByNameType(controller.farVisionChildrenResult.value.screenType),
                          "assets/images/measurement/ic_distance_vision.svg",
                          circularBorderColor: controller.farVisionChildrenResult.value.eyeScreeningResult?.getResultColorByEyeScreenType(EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1),
                          subTitle: null,
                          boldTitle: false,
                          tailingText: '${'label_eye_screening_left'.tr} ${controller.farVisionChildrenResult.value.eyeScreeningResult?.leftEye} \n${'label_eye_screening_right'.tr} ${controller.farVisionChildrenResult.value.eyeScreeningResult?.rightEye}',
                          footerText: CustomDateUtils.format(controller.farVisionChildrenResult.value.createdAt, format: CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDate(),
                          onClickAction: () {
                            Get.toNamed(EyeScreeningResultView.routeName,
                                arguments: [
                                  {
                                    "screeningReport": MeasurementDTO(
                                      eyeScreening: [
                                        EyeScreening(
                                          eyeScreeningResult : controller.farVisionChildrenResult.value.eyeScreeningResult,
                                          screenType: EyeScreeningTypeEnum.CHILDREN_EYE_TEST.name,
                                        )
                                      ],
                                    )
                                  }
                                ]
                            );
                          },
                        ),
                      ),

                      Visibility(
                        visible: GetUtils.isNullOrBlank(controller.colorBlindTestResult.value.createdAt) != true,
                        child: ItemScreeringResultHome(
                          'label_color_blind_test'.tr,
                          "assets/images/measurement/ic_color_blind.svg",
                          subTitle: null,
                          boldTitle: false,
                          circularBorderColor: controller.colorBlindTestResult.value.eyeScreeningResult?.getResultColorByEyeScreenType(EyeScreeningTypeEnum.COLOR_BLIND_TEST),
                          tailingText: EyeScreeningColorBlindResultEnum.getResultByName(controller.colorBlindTestResult.value.eyeScreeningResult?.message),
                          footerText: CustomDateUtils.format(controller.colorBlindTestResult.value.createdAt, format: CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDate(),
                          onClickAction: () {
                            Get.toNamed(EyeScreeningResultView.routeName, arguments: [
                              {
                                "screeningReport": MeasurementDTO(
                                  eyeScreening: [
                                    EyeScreening(
                                      eyeScreeningResult : controller.colorBlindTestResult.value.eyeScreeningResult,
                                      screenType: EyeScreeningTypeEnum.COLOR_BLIND_TEST.name,
                                    )
                                  ],
                                )
                              }
                            ]);
                          },
                        ),
                      ),
                      Visibility(
                        visible: GetUtils.isNullOrBlank(controller.contrastTestResult.value.createdAt) != true,
                        child: ItemScreeringResultHome(
                          'label_color_contrast_test'.tr,
                          "assets/images/measurement/ic_color_contrast.svg",
                          circularBorderColor: controller.contrastTestResult.value.eyeScreeningResult?.getResultColorByEyeScreenType(EyeScreeningTypeEnum.CONTRAST_TEST),
                          subTitle: EyeScreeningColorContrastResultEnum.getTitleBasedOnResult(controller.contrastTestResult.value.eyeScreeningResult?.message??''),
                          boldSubtitle: true,
                          boldTitle: false,
                          tailingText: controller.contrastTestResult.value.eyeScreeningResult?.message,
                          footerText: CustomDateUtils.format(controller.contrastTestResult.value.createdAt, format: CustomDateUtils.HH_MM_A_DD_MMM_YYYY).trDate().trDate(),
                          onClickAction: () {
                            Get.toNamed(EyeScreeningResultView.routeName, arguments: [
                              {
                                "screeningReport": MeasurementDTO(
                                  eyeScreening: [
                                    EyeScreening(
                                      eyeScreeningResult : controller.contrastTestResult.value.eyeScreeningResult,
                                      screenType: EyeScreeningTypeEnum.CONTRAST_TEST.name,
                                    )
                                  ],
                                )
                              }
                            ]);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CMEDWhiteElevatedButton(
                        'label_save'.tr,
                            () => {
                          controller.sendMeasurement(),
                        },
                        isEnable: controller.showSaveButton(),
                      ),
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
    Get.put(EyeScreeningHomeLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
