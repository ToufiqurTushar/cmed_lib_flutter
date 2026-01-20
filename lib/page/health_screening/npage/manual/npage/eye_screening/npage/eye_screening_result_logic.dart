import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/enum/eye_screening_type_enum.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_colorblind_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_contrast_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_distancevision_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_nearvision_view.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../repository/screening_report_repository.dart';

class EyeScreeningResultLogic extends BaseLogic {
  dynamic argumentData = Get.arguments;
  var screeningReport = MeasurementDTO().obs;
  var testedResultMessage = ''.obs;
  var testedResultLeftEyeMessage = ''.obs;
  var testedResultRightEyeMessage = ''.obs;
  var testedResultSuggestion = ''.obs;
  RxString accessFrom = ''.obs;
  EyeScreeningTypeEnum? eyeScreeningTypeEnum;
  final ScreeningReportRepository repository;
  EyeScreeningResultLogic({required this.repository});

  @override
  void onInit() {
    super.onInit();
    accessFrom = argumentData[1]['accessFrom'];
    screeningReport.value = argumentData[0]['screeningReport'];
    RLog.error(screeningReport.value.toJson());
    testedResultMessage.value = screeningReport.value.eyeScreening!.first.eyeScreeningResult!.message ??"";
    testedResultLeftEyeMessage.value = screeningReport.value.eyeScreening!.first.eyeScreeningResult!.leftEye ??"";
    testedResultRightEyeMessage.value = screeningReport.value.eyeScreening!.first.eyeScreeningResult!.rightEye ??"";
    eyeScreeningTypeEnum = EyeScreeningTypeEnum.getEnumByName(screeningReport.value.eyeScreening!.first.screenType);

    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.COLOR_BLIND_TEST) {
      testedResultSuggestion.value = EyeScreeningColorBlindResultEnum.getTitleByName(testedResultMessage.value);
    } else if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST) {
      var testedResultValue = double.tryParse(testedResultMessage.value)??0.0;
      if(testedResultValue >= 1.5) {
        if(Utils.isLocaleBn()) {
          testedResultSuggestion.value = 'কালার কন্ট্রাস্ট ফলাফল : $testedResultMessage এবং আপনার কন্ট্রাস্ট সেনসিটিভিটি নেই।';
        } else {
          testedResultSuggestion.value = 'Your Score is : $testedResultMessage & you have no contrast sensitivity impairment.';
        }
      } else {
        if(Utils.isLocaleBn()) {
          testedResultSuggestion.value = 'কালার কন্ট্রাস্ট ফলাফল : $testedResultMessage এবং আপনার কন্ট্রাস্ট সেনসিটিভিটি রয়েছে।';
        } else {
          testedResultSuggestion.value = 'Your Score is : $testedResultMessage & you have contrast sensitivity impairment.';

        }
      }
    } else {
      testedResultSuggestion.value = EyeScreeningTypeEnum.getSuggestionByEnum(eyeScreeningTypeEnum!);
    }
  }

  void reMeasure() {
    var pageRouteName = EyeScreeningNearvisionView.routeName;
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE) {
      pageRouteName = EyeScreeningNearvisionView.routeName;
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1) {
      pageRouteName = EyeScreeningDistancevisionView.routeName;
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.ILLITERATE_TEST) {
      pageRouteName = EyeScreeningDistancevisionView.routeName;
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.CHILDREN_EYE_TEST) {
      pageRouteName = EyeScreeningDistancevisionView.routeName;
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.COLOR_BLIND_TEST) {
      pageRouteName = EyeScreeningColorblindView.routeName;
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST) {
      pageRouteName = EyeScreeningContrastView.routeName;
    }

    Get.offNamedUntil(pageRouteName, (route) => route.settings.name == EyeScreeningHomeView.routeName);
  }

  void startNextEyeScreening() {
    saveLocal();
    var pageRouteName = EyeScreeningDistancevisionView.routeName;
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE) {
      pageRouteName = EyeScreeningDistancevisionView.routeName;
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1) {
      pageRouteName = EyeScreeningColorblindView.routeName;
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.COLOR_BLIND_TEST) {
      pageRouteName = EyeScreeningContrastView.routeName;
    }

    Get.offNamedUntil(pageRouteName, (route) => route.settings.name == EyeScreeningHomeView.routeName);
  }

  EyeScreeningHomeLogic getEyeScreeningHomeLogic() {
    return Get.find<EyeScreeningHomeLogic>();
  }

  saveLocal() {
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE) {
      getEyeScreeningHomeLogic().nearVisionBothEyeResult.value = EyeScreening(
          eyeScreeningResult : EyeScreeningResult(
            message: testedResultMessage.value,
          ),
          screenType: eyeScreeningTypeEnum!.name,
          createdAt: DateTime.now().millisecondsSinceEpoch
      );
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1) {
      getEyeScreeningHomeLogic().farVisionDistance1Result.value = EyeScreening(
          eyeScreeningResult : EyeScreeningResult(
            leftEye: testedResultLeftEyeMessage.value,
            rightEye: testedResultRightEyeMessage.value,
          ),
          screenType: eyeScreeningTypeEnum!.name,
          createdAt: DateTime.now().millisecondsSinceEpoch
      );
    }

    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.ILLITERATE_TEST) {
      getEyeScreeningHomeLogic().farVisionIlliterateResult.value = EyeScreening(
          eyeScreeningResult : EyeScreeningResult(
            leftEye: testedResultLeftEyeMessage.value,
            rightEye: testedResultRightEyeMessage.value,
          ),
          screenType: eyeScreeningTypeEnum!.name,
          createdAt: DateTime.now().millisecondsSinceEpoch
      );
    }

    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.CHILDREN_EYE_TEST) {
      getEyeScreeningHomeLogic().farVisionChildrenResult.value = EyeScreening(
          eyeScreeningResult : EyeScreeningResult(
            leftEye: testedResultLeftEyeMessage.value,
            rightEye: testedResultRightEyeMessage.value,
          ),
          screenType: eyeScreeningTypeEnum!.name,
          createdAt: DateTime.now().millisecondsSinceEpoch
      );
    }

    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.COLOR_BLIND_TEST) {
      getEyeScreeningHomeLogic().colorBlindTestResult.value = EyeScreening(
          eyeScreeningResult : EyeScreeningResult(
            message: testedResultMessage.value,
          ),
          screenType: eyeScreeningTypeEnum!.name,
          createdAt: DateTime.now().millisecondsSinceEpoch
      );
    }
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST) {
      getEyeScreeningHomeLogic().contrastTestResult.value = EyeScreening(
          eyeScreeningResult : EyeScreeningResult(
            message: testedResultMessage.value,
          ),
          screenType: eyeScreeningTypeEnum!.name,
          createdAt: DateTime.now().millisecondsSinceEpoch
      );
    }

  }

  startDistanceVisionEyeScreening() {
    saveLocal();
    Get.offNamedUntil(EyeScreeningDistancevisionView.routeName, (route) => route.settings.name == EyeScreeningHomeView.routeName);
  }

  showstartDistanceVisionEyeScreeningButton() {
    return screeningReport.value.id == null && eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE;
  }

  showSaveButton() {
    return screeningReport.value.id == null && Get.isRegistered<EyeScreeningHomeLogic>();
  }

  showRemeasureButton() {
    return screeningReport.value.id == null && Get.isRegistered<EyeScreeningHomeLogic>();
  }
  showHomeButton() {
    return screeningReport.value.id != null;
  }

  String getImageAsset() {
    if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE) {
      return accessFrom.value == 'User_App'? 'ic_near_vision_new.svg' : 'ic_near_vision.svg';
    } else if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1) {
      return accessFrom.value == 'User_App'? 'ic_distance_vision_new.svg' : 'ic_distance_vision.svg';
    } else if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.COLOR_BLIND_TEST) {
      return 'ic_color_blind.svg';
    } else if(eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST) {
      return 'ic_color_contrast.svg';
    }
    return accessFrom.value == 'User_App'? 'ic_near_vision_new.svg' : 'ic_near_vision.svg';
  }

  // Color getResultColor() {
  //   RLog.error(eyeScreeningTypeEnum?.name);
  //   if (eyeScreeningTypeEnum == EyeScreeningTypeEnum.COLOR_BLIND_TEST && testedResultMessage.value == EyeScreeningColorBlindResultEnum.BAD.name) {
  //     return AppColor.colorRed;
  //   }
  //   else if (eyeScreeningTypeEnum == EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE || eyeScreeningTypeEnum == EyeScreeningTypeEnum.CONTRAST_TEST || eyeScreeningTypeEnum == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1) {
  //     return AppColor.colorGreen;
  //   } else {
  //     return AppColor.colorGreen;
  //   }
  // }

  String getTitle() {
    if(Utils.isLocaleBn()) {
      return '${eyeScreeningTypeEnum?.titleBn??""} ফলাফল';
    } else {
      return '${eyeScreeningTypeEnum?.titleEn??""} Result';
    }

  }

  String getRemeasureTitle() {
    if(Utils.isLocaleBn()) {
      return 'পুনরায় ${eyeScreeningTypeEnum?.nameBn??""} করুন';
    } else {
      return 'Remeasure ${eyeScreeningTypeEnum?.nameEn??""}';
    }

  }
}