
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';

import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class UserManagementArgument {
  UserManagementArgument({
      this.selectedSurvey,
   });
  SurveyDto? selectedSurvey;
}