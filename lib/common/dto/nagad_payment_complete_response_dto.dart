class NagadPaymentCompleteResponseDto {
  NagadPaymentCompleteResponseDto({
    this.statusSuccess,
    this.statusMessage});

  NagadPaymentCompleteResponseDto.fromJson(dynamic json) {
    statusSuccess = json['statusSuccess']??false;
    statusMessage = json['statusMessage'];
  }

  String? statusMessage;
  bool? statusSuccess;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusSuccess'] = statusSuccess??false;
    map['statusMessage'] = statusMessage;
    return map;
  }

}