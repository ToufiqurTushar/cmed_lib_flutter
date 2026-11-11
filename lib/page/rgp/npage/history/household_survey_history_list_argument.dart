import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';

class HouseholdSurveyHistoryListArgument {
  HouseholdSurveyHistoryListArgument({
    this.date,
    this.householdId,
    this.userId,
    this.customer,
  });
  String? date;
  int? householdId;
  int? userId;
  CustomerDTO? customer;
}

