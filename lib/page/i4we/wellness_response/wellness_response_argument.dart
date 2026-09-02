
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';

import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class WellnessResponseArgument {
  WellnessResponseArgument({
      this.date,
      this.selectedSurvey,
      this.redirectToServiceSelectionView
  });
  SurveyDto? selectedSurvey;
  String? date;
  bool? redirectToServiceSelectionView;
}