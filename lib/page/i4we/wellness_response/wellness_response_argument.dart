
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';

import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class WellnessResponseArgument {
  WellnessResponseArgument({
      this.date,
      this.selectedSurvey,
      this.surveyResultItemDto,
      this.isFromHistory,
      this.redirectToServiceSelectionView
  });
  SurveyDto? selectedSurvey;
  SurveyResultItemDto? surveyResultItemDto;
  String? date;
  bool? redirectToServiceSelectionView;
  bool? isFromHistory;
}