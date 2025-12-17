class CancelAgreementDto {
  CancelAgreementDto({
    this.statusCode,
    this.statusMessage,
    this.cmedStatusCode,
    this.cmedStatusMessage,
    this.paymentID,
    this.payerReference,
    this.agreementStatus,
    this.agreementCreateTime,
    this.agreementExecuteTime,
    this.agreementVoidTime,
    this.customerMsisdn,
    this.agreementID,});

  CancelAgreementDto.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    cmedStatusCode = json['cmedStatusCode'];
    cmedStatusMessage = json['cmedStatusMessage'];
    paymentID = json['paymentID'];
    payerReference = json['payerReference'];
    agreementStatus = json['agreementStatus'];
    agreementCreateTime = json['agreementCreateTime'];
    agreementExecuteTime = json['agreementExecuteTime'];
    agreementVoidTime = json['agreementVoidTime'];
    customerMsisdn = json['customerMsisdn'];
    agreementID = json['agreementID'];
  }
  String? statusCode;
  String? statusMessage;
  String? cmedStatusCode;
  String? cmedStatusMessage;
  String? paymentID;
  String? payerReference;
  String? agreementStatus;
  String? agreementCreateTime;
  String? agreementExecuteTime;
  String? agreementVoidTime;
  String? customerMsisdn;
  String? agreementID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['statusMessage'] = statusMessage;
    map['cmedStatusCode'] = cmedStatusCode;
    map['cmedStatusMessage'] = cmedStatusMessage;
    map['paymentID'] = paymentID;
    map['payerReference'] = payerReference;
    map['agreementStatus'] = agreementStatus;
    map['agreementCreateTime'] = agreementCreateTime;
    map['agreementExecuteTime'] = agreementExecuteTime;
    map['agreementVoidTime'] = agreementVoidTime;
    map['customerMsisdn'] = customerMsisdn;
    map['agreementID'] = agreementID;
    return map;
  }

}