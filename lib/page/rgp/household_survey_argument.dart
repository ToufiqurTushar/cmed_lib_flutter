import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

import '../../survey/dto/survey_item_dto.dart';

class HouseholdSurveyArg {
  HouseholdSurveyArg({
    this.selectedSurvey,
    this.isFromHistory = false,
    required this.customer,
    this.selectedSurveyResult,
  });
  CustomerDTO customer;
  SurveyDto? selectedSurvey;
  bool isFromHistory = false;
  SurveyResultItemDto? selectedSurveyResult;

}

