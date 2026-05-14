class TokenVerifyResponse {
  TokenVerifyResponse({
      this.verificationRequired, 
      this.verificationMode, 
      this.nextAction, 
      this.tokenMedia,
      this.expiresInSeconds,
      this.message,});

  TokenVerifyResponse.fromJson(dynamic json) {
    verificationRequired = json['verificationRequired'];
    verificationMode = json['verificationMode'];
    nextAction = json['nextAction'];
    tokenMedia = json['tokenMedia'];
    expiresInSeconds = json['expiresInSeconds'];
    message = json['message'];
  }
  bool? verificationRequired;
  String? verificationMode;
  String? nextAction;
  String? tokenMedia;
  num? expiresInSeconds;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['verificationRequired'] = verificationRequired;
    map['verificationMode'] = verificationMode;
    map['nextAction'] = nextAction;
    map['tokenMedia'] = tokenMedia;
    map['expiresInSeconds'] = expiresInSeconds;
    map['message'] = message;
    return map;
  }

}