import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import 'package:cmed_lib_flutter/page/rgp/dto/HouseholdSurveyContexDto.dart';
import '../../survey/dto/survey_item_dto.dart';

class HouseholdSurveyArg {
  HouseholdSurveyArg({
    this.selectedSurvey,
    this.isFromHistory = false,
    required this.customer,
    this.selectedSurveyResult,
    this.historyItem,
    this.historyContextDto,
  });
  CustomerDTO customer;
  SurveyDto? selectedSurvey;
  bool isFromHistory = false;
  SurveyResultItemDto? selectedSurveyResult;
  dynamic historyItem;
  HouseholdSurveyContexDto? historyContextDto;
}

