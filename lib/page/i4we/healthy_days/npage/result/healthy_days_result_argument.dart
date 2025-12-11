import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';

import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class HealthyDaysResultArgument {
  HealthyDaysResultArgument({
      this.isFromHistory,
      this.selectedSurveyResult,
       this.selectedSurvey,});
  bool? isFromHistory;
  SurveyResultItemDto? selectedSurveyResult;
  SurveyDto? selectedSurvey;
}