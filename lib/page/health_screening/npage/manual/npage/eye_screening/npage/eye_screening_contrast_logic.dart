import 'dart:ui';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/widget/app_dialog.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/enum/eye_screening_type_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/eye_screening_home_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_result_view.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../repository/screening_report_repository.dart';


class EyeScreeningContrastLogic extends BaseLogic {

  final ScreeningReportRepository repository;
  EyeScreeningContrastLogic({required this.repository});

  var screeningQuestions = <MasterDataDTO>[
    MasterDataDTO(labelEn: "H", image: "#000000", number: 0.0 ),
    MasterDataDTO(labelEn: "S", image: "#000000", number: 0.0 ),
    MasterDataDTO(labelEn: "Z", image: "#000000", number: 0.0 ),
    MasterDataDTO(labelEn: "D", image: "#8f9094", number: 0.15 ),
    MasterDataDTO(labelEn: "S", image: "#8f9094", number: 0.15 ),
    MasterDataDTO(labelEn: "N", image: "#8f9094", number: 0.15 ),

    MasterDataDTO(labelEn: "C", image: "#b1b2b6", number: 0.3 ),
    MasterDataDTO(labelEn: "K", image: "#b1b2b6", number: 0.3 ),
    MasterDataDTO(labelEn: "R", image: "#b1b2b6", number: 0.3 ),
    MasterDataDTO(labelEn: "Z", image: "#cdcdcf", number: 0.45 ),
    MasterDataDTO(labelEn: "V", image: "#cdcdcf", number: 0.45 ),
    MasterDataDTO(labelEn: "R", image: "#cdcdcf", number: 0.45 ),

    MasterDataDTO(labelEn: "N", image: "#dbdcde", number: 0.6 ),
    MasterDataDTO(labelEn: "D", image: "#dbdcde", number: 0.6 ),
    MasterDataDTO(labelEn: "C", image: "#dbdcde", number: 0.6 ),
    MasterDataDTO(labelEn: "O", image: "#e7e8ea", number: 0.75 ),
    MasterDataDTO(labelEn: "S", image: "#e7e8ea", number: 0.75 ),
    MasterDataDTO(labelEn: "K", image: "#e7e8ea", number: 0.75 ),

    MasterDataDTO(labelEn: "O", image: "#efefef", number: 0.9 ),
    MasterDataDTO(labelEn: "Z", image: "#efefef", number: 0.9 ),
    MasterDataDTO(labelEn: "K", image: "#efefef", number: 0.9 ),
    MasterDataDTO(labelEn: "V", image: "#f3f3f5", number: 1.05 ),
    MasterDataDTO(labelEn: "H", image: "#f3f3f5", number: 1.05 ),
    MasterDataDTO(labelEn: "Z", image: "#f3f3f5", number: 1.05 ),

    MasterDataDTO(labelEn: "N", image: "#efefef", number: 1.2 ),
    MasterDataDTO(labelEn: "H", image: "#efefef", number: 1.2 ),
    MasterDataDTO(labelEn: "O", image: "#efefef", number: 1.2 ),
    MasterDataDTO(labelEn: "N", image: "#f2f2f4", number: 1.35 ),
    MasterDataDTO(labelEn: "R", image: "#f2f2f4", number: 1.35 ),
    MasterDataDTO(labelEn: "D", image: "#f2f2f4", number: 1.35 ),

    MasterDataDTO(labelEn: "V", image: "#f6f6f6", number: 1.5 ),
    MasterDataDTO(labelEn: "R", image: "#f6f6f6", number: 1.5 ),
    MasterDataDTO(labelEn: "C", image: "#f6f6f6", number: 1.5 ),
    MasterDataDTO(labelEn: "O", image: "#f8f8f8", number: 1.65 ),
    MasterDataDTO(labelEn: "V", image: "#f8f8f8", number: 1.65 ),
    MasterDataDTO(labelEn: "H", image: "#f8f8f8", number: 1.65 ),

    MasterDataDTO(labelEn: "C", image: "#fafafa", number: 1.8 ),
    MasterDataDTO(labelEn: "D", image: "#fafafa", number: 1.8 ),
    MasterDataDTO(labelEn: "S", image: "#fafafa", number: 1.8 ),
    MasterDataDTO(labelEn: "N", image: "#fbfbfb", number: 1.95 ),
    MasterDataDTO(labelEn: "D", image: "#fbfbfb", number: 1.95 ),
    MasterDataDTO(labelEn: "C", image: "#fbfbfb", number: 1.95 ),

    MasterDataDTO(labelEn: "K", image: "#fcfcfc", number: 2.1 ),
    MasterDataDTO(labelEn: "V", image: "#fcfcfc", number: 2.1 ),
    MasterDataDTO(labelEn: "Z", image: "#fcfcfc", number: 2.1 ),
    MasterDataDTO(labelEn: "O", image: "#fefefe", number: 2.25 ),
    MasterDataDTO(labelEn: "H", image: "#fefefe", number: 2.25 ),
    MasterDataDTO(labelEn: "R", image: "#fefefe", number: 2.25 )
  ].obs;

  nextScreening({MasterDataDTO? result}) {
    Get.offNamed(EyeScreeningResultView.routeName, arguments: [
      {
        "screeningReport": MeasurementDTO(
          eyeScreening: [
            EyeScreening(
              eyeScreeningResult : EyeScreeningResult(
                message: result?.number.toString(),
              ),
              screenType: EyeScreeningTypeEnum.CONTRAST_TEST.name,
            )
          ],
        )
      }
    ]);
  }

  EyeScreeningHomeLogic getEyeScreeningHomeLogic() {
    return  Get.find<EyeScreeningHomeLogic>();
  }

  String getLabel(int index) {
    return screeningQuestions[index].labelEn??'';
  }

  Color getColor(int index) {
    String hexColor = screeningQuestions[index].image??'#000000';
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void onReady() {
    super.onReady();
    AppDialogs.showSingleButtonDialog('info_color_contrast1'.tr, positiveButtonText: 'label_continue'.tr, cancelable: false, onButtonClick: () async {});
  }
}