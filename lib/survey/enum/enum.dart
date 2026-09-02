enum SurveyTypeEnum {
  HEALTH_ASSESSMENT,
  AGENT_SUBSCRIPTION,
  ANEMIA_ASSESSMENT,
  SOCIAL_PROTECTION,
  HEALTHY_DAYS,
  WELLNESS_RESPONSE;
}

/// Condition types supported
enum FBConditionType {
  equals,
  notEquals,
  contains,
  notInList,
  lessThan,
  greaterThan,
  lessOrEqual,
  greaterOrEqual,
  between,
  notBetween,
  isEmpty,
  isNotEmpty,
  isNull,
  isHidden,
  isNotNull;

  static FBConditionType fromString(String? value) {
    return FBConditionType.values.firstWhere(
          (e) => e.name.toLowerCase() == value?.toLowerCase(),
      orElse: () => FBConditionType.equals, // default
    );
  }
}



/// Logical combiner
enum FBConditionLogic { AND, OR }