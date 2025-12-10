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
}
