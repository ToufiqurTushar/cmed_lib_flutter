
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';

import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class HealthyDaysArgument {
  HealthyDaysArgument({
      this.date,
      this.selectedSurvey,});
  SurveyDto? selectedSurvey;
  String? date;
}