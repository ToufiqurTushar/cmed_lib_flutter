import 'dart:math';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/widget/app_dialog.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/enum/eye_screening_type_enum.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_result_view.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../repository/screening_report_repository.dart';


class EyeScreeningDistancevisionLogic extends BaseLogic {

  final ScreeningReportRepository repository;
  EyeScreeningDistancevisionLogic({required this.repository});

  var letters = ["C", "D", "H", "K", "N", "O", "R", "S", "V", "Z"];
  var lettersBn = ["গ", "চ", "ক", "ন", "ব", "ফ", "দ", "ছ", "প"];
  var fontSizes = [32, 16, 12, 10, 8, 6, 5, 4, 3];
  var imageSizes = [55, 50, 45, 35, 30, 25, 15, 10, 5];

  var startScreening = false.obs;
  var screeningForLeftEye = false.obs;
  var screeningForRightEye = false.obs;
  var screeningEyeTitle = ''.obs;
  var farVisionTestType = ''.obs;
  var screeningQuestions = <MasterDataDTO>[];
  var farVisionLeftEyeResult = '';
  var farVisionRightEyeResult = '';

  var screeningIndex = 0.obs;
  var countWrongAnswer = 0;

  @override
  void onInit() {
    super.onInit();
    screeningQuestions = <MasterDataDTO>[
      MasterDataDTO(image:'1', name: '6/60', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 0),
      MasterDataDTO(image:'2', name: '6/60', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 0),
      MasterDataDTO(image:'3', name: '6/60', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 0),

      MasterDataDTO(image:'1', name: '6/30', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 1),
      MasterDataDTO(image:'2', name: '6/30', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 1),
      MasterDataDTO(image:'3', name: '6/30', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 1),

      MasterDataDTO(image:'1', name: '6/24', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 2),
      MasterDataDTO(image:'2', name: '6/24', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 2),
      MasterDataDTO(image:'3', name: '6/24', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 2),

      MasterDataDTO(image:'1', name: '6/18', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 3),
      MasterDataDTO(image:'2', name: '6/18', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 3),
      MasterDataDTO(image:'3', name: '6/18', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 3),

      MasterDataDTO(image:'1', name: '6/15', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 4),
      MasterDataDTO(image:'2', name: '6/15', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 4),
      MasterDataDTO(image:'3', name: '6/15', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 4),

      MasterDataDTO(image:'1', name: '6/12', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 5),
      MasterDataDTO(image:'2', name: '6/12', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 5),
      MasterDataDTO(image:'3', name: '6/12', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 5),

      MasterDataDTO(image:'1', name: '6/9', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 6),
      MasterDataDTO(image:'2', name: '6/9', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 6),
      MasterDataDTO(image:'3', name: '6/9', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 6),

      MasterDataDTO(image:'1', name: '6/7.5', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 7),
      MasterDataDTO(image:'2', name: '6/7.5', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 7),
      MasterDataDTO(image:'3', name: '6/7.5', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 7),

      MasterDataDTO(image:'1', name: '6/6', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 8),
      MasterDataDTO(image:'2', name: '6/6', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 8),
      MasterDataDTO(image:'3', name: '6/6', labelEn: letters[Random().nextInt(letters.length-1)], labelBn: lettersBn[Random().nextInt(letters.length-1)], value: 8),
    ];

  }

  nextScreening({bool clear = false}) {
    if(clear) {
      countWrongAnswer = 0;
    } else {
      countWrongAnswer++;
    }

    if(countWrongAnswer >= 3) {
      screeningComplete();
    } else {
      var lastIndex = screeningQuestions.length - 1;

      if(screeningIndex.value < lastIndex) {
        screeningIndex.value = screeningIndex.value + 1;
      } else {
        screeningComplete();
      }
    }
  }

  bool getClearOrUnclearStatus(ControllButtonForIlliterateEnum controllButtonForIlliterateEnum) {
    if(controllButtonForIlliterateEnum.name == ControllButtonForIlliterateEnum.UP.name && screeningQuestions[screeningIndex.value].image == '1') {
      return true;
    } else if(controllButtonForIlliterateEnum.name == ControllButtonForIlliterateEnum.LEFT.name && screeningQuestions[screeningIndex.value].image == '2') {
      return true;
    } else if(controllButtonForIlliterateEnum.name == ControllButtonForIlliterateEnum.RIGHT.name && screeningQuestions[screeningIndex.value].image == '3') {
      return true;
    }
    return false;
  }

  screeningComplete() {
    var resultFound = false;
    if(screeningForLeftEye.isTrue && screeningForRightEye.isTrue) {
      resultFound = true;
      if(farVisionLeftEyeResult.isEmpty) {
        farVisionLeftEyeResult = getName();
      }
      if(farVisionRightEyeResult.isEmpty) {
        farVisionRightEyeResult = getName();
      }
    } else if(screeningForLeftEye.isTrue) {
      farVisionLeftEyeResult = getName();
      AppDialogs.showSingleButtonDialog('message_distance_vision_test_left_complete'.tr, cancelable: false, onButtonClick: (){});
      screeningForRightEye.value = true;
      screeningIndex.value = 0;
      countWrongAnswer = 0;
      screeningEyeTitle.value = 'label_distance_vision_test_right'.tr;
    } else if(screeningForRightEye.isTrue) {
      farVisionRightEyeResult = getName();
      AppDialogs.showSingleButtonDialog('message_distance_vision_test_right_complete'.tr, cancelable: false, onButtonClick: (){});
      screeningForLeftEye.value = true;
      screeningIndex.value = 0;
      countWrongAnswer = 0;
      screeningEyeTitle.value = 'label_distance_vision_test_left'.tr;
    }

    if(resultFound) {
      Get.offNamed(EyeScreeningResultView.routeName, arguments: [
        {
          "screeningReport": MeasurementDTO(
            eyeScreening: [
              EyeScreening(
                  eyeScreeningResult : EyeScreeningResult(
                    leftEye: farVisionLeftEyeResult,
                    rightEye: farVisionRightEyeResult,
                  ),
                  screenType: EyeScreeningTypeEnum.getEnumByName(farVisionTestType.value)!.name,
              ),
            ],
          )
        }
      ]);
    }
  }

  String getImageAsset() {
    if(farVisionTestType.value == EyeScreeningTypeEnum.ILLITERATE_TEST.name){
      return "assets/images/measurement/distance_vision_test_illiterate_${screeningQuestions[screeningIndex.value].image}.png";
    } else if(farVisionTestType.value == EyeScreeningTypeEnum.CHILDREN_EYE_TEST.name){
      return "assets/images/measurement/distance_vision_test_child_${screeningQuestions[screeningIndex.value].image}.png";
    }
    return "assets/images/measurement/${screeningQuestions[screeningIndex.value].image}.png";
  }



  String getName() {
    return screeningQuestions[screeningIndex.value].name??'';
  }

  String getLabel() {
    if(Utils.isLocaleBn()) {
      return screeningQuestions[screeningIndex.value].labelBn??'';
    } else {
      return screeningQuestions[screeningIndex.value].labelEn??'';
    }
  }

  double getFontSize() {
    int index = screeningQuestions[screeningIndex.value].value??0;
    return fontSizes[index].toDouble();
  }

  double getImageSize() {
    int index = screeningQuestions[screeningIndex.value].value??0;
    return imageSizes[index].toDouble();
  }

  bool isIlliterateControllButton() {
    if(startScreening.isTrue && farVisionTestType.value == EyeScreeningTypeEnum.ILLITERATE_TEST.name){
      return true;
    }
    return false;
  }
  bool isDefaultControllButton() {
    if(startScreening.isTrue && farVisionTestType.value != EyeScreeningTypeEnum.ILLITERATE_TEST.name){
      return true;
    }
    return false;
  }

  EyeScreeningHomeLogic getEyeScreeningHomeLogic() {
    return  Get.find<EyeScreeningHomeLogic>();
  }

  bool isImageTypeTest() {
    if(startScreening.isTrue && farVisionTestType.value != EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1.name){
      return true;
    }
    return false;
  }


  bool isTextTypeTest() {
    if(startScreening.isTrue && farVisionTestType.value == EyeScreeningTypeEnum.FAR_VISION_DISTANCE_1.name){
      return true;
    }
    return false;
  }

  bool isLeftEyeScreening() {
    if(startScreening.isTrue && screeningForLeftEye.isTrue){
      return true;
    }
    return false;
  }
  bool isRightEyeScreening() {
    if(startScreening.isTrue && screeningForRightEye.isTrue){
      return true;
    }
    return false;
  }

  resetPage() {
    startScreening.value = false;
    farVisionTestType.value = '';
    screeningForLeftEye.value = false;
    screeningForRightEye.value = false;
    screeningEyeTitle.value = 'label_distance_vision_test'.tr;
  }
}