enum SurveyTypeEnum {
  HEALTH_ASSESSMENT,
  AGENT_SUBSCRIPTION,
  HEALTHY_DAYS;
}

/// Condition types supported
enum FBConditionType {
  EQUALS,
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
  isNotNull,
}

FBConditionType fbConditionFromString(String? value) {
  return FBConditionType.values.firstWhere(
        (e) => e.name == value,
    orElse: () => FBConditionType.EQUALS, // default
  );
}

/// Logical combiner
enum FBConditionLogic { AND, OR }