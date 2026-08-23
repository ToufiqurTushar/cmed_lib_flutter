
import 'package:cmed_lib_flutter/survey/dto/survey_dto.dart';

import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class FamilyProfileArgument {
  FamilyProfileArgument({
      this.selectedSurvey,
      this.redirectToServiceSelectionView,
      this.isForFamilyMember,
      required this.customer,});
  CustomerDTO customer;
  SurveyDto? selectedSurvey;
  bool? redirectToServiceSelectionView;
  bool? isForFamilyMember;
}
