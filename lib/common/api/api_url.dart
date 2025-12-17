import 'package:cmed_lib_flutter/common/enum/payment_method_enum.dart';

class ApiUrl {
  static String getSurveyRulesUrl({required String surveyType}) {
    return "api/v1/survey/rules?type=$surveyType&page=0&size=100";
  }

  static String getHealthAssessmentSurveyUrl(int userId,{int fromDate = 0, int toDate = 0}) {
    if(fromDate != 0){
      return "api/v1/health/assessment?direction=DESC&from_date=$fromDate&to_date=$toDate&page=0&size=100&sort_by=id&user_id=$userId";
    }
    return "api/v1/health/assessment?direction=DESC&page=0&size=100&sort_by=id&user_id=$userId";
  }

  static String getHealthyDaysSurveyUrl(int userId,{int fromDate = 0, int toDate = 0}) {
    if(fromDate != 0){
      return "api/v1/healthy/days?direction=DESC&from_date=$fromDate&to_date=$toDate&page=0&size=100&sort_by=id&user_id=$userId";
    }
    return "api/v1/healthy/days?direction=DESC&page=0&size=100&sort_by=id&user_id=$userId";
  }

  static String getCheSurveySurveyUrl(int userId) {
    return "api/v1/healthy/days?direction=DESC&page=0&size=100&sort_by=id&user_id=$userId";
  }

  static String getCheSurveyUrl(int userId) {
    return "api/v1/agent/survey?direction=DESC&page=0&size=100&sort_by=id&user_id=$userId";
  }

  static String postSurveyUrl() {
    return "api/v1/survey/submit";
  }

  static String getCustomProfileByUserIdUrl(int? userId) {
    return "api/v6/user/$userId/profiles-custom";
  }
  static String previewMeasurementUrl() {
    return "api/v6/preview/measurements";
  }

  static String addMeasurementUrl() {
    return "api/v6/measurements";
  }

  static String getMeasurementsByTypeUrl(int userId, int page, int size, types, {order = 'ASC'}) {
    return "api/v6/measurements?userId=$userId&page=$page&size=$size&type_codes=$types";
  }
  static String getMeasurementReportFileUrl(userId, token, fromDate, toDate, measurementTypeCodes) {
    return "api/v7/measurements/report/download?from_date=$fromDate&measurement_type_code=$measurementTypeCodes&to_date=$toDate&user_id=$userId&access_token=$token";
  }
  //Agent
  static String getCurrentAgentProfile() {
    return "api/v6/agents/me";
  }

  static String getPaymentURL(
      {required PaymentMethodEnum paymentMethod, required String paymentUrlQueryPath}) {
    return "api/v1/agent/make/payment/with/${paymentMethod.name}?$paymentUrlQueryPath";
  }

}
