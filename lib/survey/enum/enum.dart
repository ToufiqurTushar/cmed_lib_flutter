enum SurveyTypeEnum {
  HEALTH_ASSESSMENT,
  AGENT_SUBSCRIPTION,
  SOCIAL_PROTECTION,
  HEALTHY_DAYS;
}

/// Condition types supported
enum FBConditionType {
  equal,
  notEquals,
  inList,
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
          (e) => e.name == value,
      orElse: () => FBConditionType.equal, // default
    );
  }
}



/// Logical combiner
enum FBConditionLogic { AND, OR }