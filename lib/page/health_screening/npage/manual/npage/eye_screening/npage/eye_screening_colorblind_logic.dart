import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_result_view.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../repository/screening_report_repository.dart';
import '../enum/eye_screening_type_enum.dart';

class EyeScreeningColorblindLogic extends BaseLogic {

  final ScreeningReportRepository repository;
  EyeScreeningColorblindLogic({required this.repository});
  var countRightAnswer = 0;
  var countWrongAnswer = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var textEditingController = TextEditingController();
  var screeningQuestions = <MasterDataDTO>[
    MasterDataDTO(image: 'color_blind_test_1', name: '12'),
    MasterDataDTO(image: 'color_blind_test_2', name: '8'),
    MasterDataDTO(image: 'color_blind_test_3', name: '29'),
    MasterDataDTO(image: 'color_blind_test_4', name: '5'),
    MasterDataDTO(image: 'color_blind_test_5', name: '3'),
    MasterDataDTO(image: 'color_blind_test_6', name: '15'),
    MasterDataDTO(image: 'color_blind_test_7', name: '74'),
    MasterDataDTO(image: 'color_blind_test_8', name: '6'),
    MasterDataDTO(image: 'color_blind_test_9', name: '45'),
    MasterDataDTO(image: 'color_blind_test_10', name: '5'),
    MasterDataDTO(image: 'color_blind_test_11', name: '7'),
    MasterDataDTO(image: 'color_blind_test_12', name: '16'),
    MasterDataDTO(image: 'color_blind_test_13', name: '73'),
  ].obs;
  var screeningIndex = 0.obs;

  nextScreening() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    checkResult(textEditingController.text);
    formKey.currentState!.reset();

    var lastIndex = screeningQuestions.length - 1;
    if(screeningIndex.value < lastIndex) {
      screeningIndex.value = screeningIndex.value + 1;
    } else {
      screeningComplete();
    }
  }

  screeningComplete() {
    Get.offNamed(EyeScreeningResultView.routeName, arguments: [
      {
        "screeningReport": MeasurementDTO(
          eyeScreening: [
            EyeScreening(
              eyeScreeningResult : EyeScreeningResult(
                  message: getResult()
              ),
              screenType: EyeScreeningTypeEnum.COLOR_BLIND_TEST.name,
            )
          ],
        )
      }
    ]);
  }

  String getImageAsset() {
    return "assets/images/measurement/${screeningQuestions[screeningIndex.value].image}.jpg";
  }

  checkResult(String result) {
    if(result.trim() == screeningQuestions[screeningIndex.value].name) {
      screeningQuestions[screeningIndex.value].value = 1;
      countRightAnswer++;
    } else {
      screeningQuestions[screeningIndex.value].value = 0;
      countWrongAnswer++;
    }

    if(countRightAnswer >= 10) {
      screeningComplete();
    }
    if(countWrongAnswer >=3) {
      screeningComplete();
    }
  }

  EyeScreeningHomeLogic getEyeScreeningHomeLogic() {
    return  Get.find<EyeScreeningHomeLogic>();
  }

  String getResult() {
    if(countRightAnswer >= 10) {
      return EyeScreeningColorBlindResultEnum.GOOD.name;
    }
    if(countWrongAnswer >= 3) {
      return EyeScreeningColorBlindResultEnum.BAD.name;
    }
    return EyeScreeningColorBlindResultEnum.BAD.name;
  }

  String?  validateNumber(String value) {
    if (value.trim().isEmpty) {
      return 'label_type_number_in_screen'.tr;
    }
    return null;
  }
}