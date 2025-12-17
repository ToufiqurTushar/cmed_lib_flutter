class NagadMakePaymentResponseDto {
  NagadMakePaymentResponseDto({
    this.statusCode,
    this.statusMessage,
    this.cmedStatusCode,
    this.cmedStatusMessage,
    this.paymentID,
    this.nagadURL,
    this.callbackURL,
    this.successCallbackURL,
    this.failureCallbackURL,
    this.cancelledCallbackURL,
    this.amount,
    this.currency,
    this.intent,
    this.payerReference,
    this.customerMsisdn,
    this.transactionStatus,
    this.paymentCreateTime,
    this.merchantInvoiceNumber,});

  NagadMakePaymentResponseDto.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    cmedStatusCode = json['cmedStatusCode'];
    cmedStatusMessage = json['cmedStatusMessage'];
    paymentID = json['paymentID'];
    nagadURL = json['nagadURL'];
    callbackURL = json['callbackURL'];
    successCallbackURL = json['successCallbackURL'];
    failureCallbackURL = json['failureCallbackURL'];
    cancelledCallbackURL = json['cancelledCallbackURL'];
    amount = json['amount'];
    currency = json['currency'];
    intent = json['intent'];
    payerReference = json['payerReference'];
    customerMsisdn = json['customerMsisdn'];
    transactionStatus = json['transactionStatus'];
    paymentCreateTime = json['paymentCreateTime'];
    merchantInvoiceNumber = json['merchantInvoiceNumber'];
  }
  String? statusCode;
  String? statusMessage;
  String? cmedStatusCode;
  String? cmedStatusMessage;
  String? paymentID;
  String? nagadURL;
  String? callbackURL;
  String? successCallbackURL;
  String? failureCallbackURL;
  String? cancelledCallbackURL;
  double? amount;
  String? currency;
  String? intent;
  String? payerReference;
  String? customerMsisdn;
  String? transactionStatus;
  String? paymentCreateTime;
  String? merchantInvoiceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['statusMessage'] = statusMessage;
    map['cmedStatusCode'] = cmedStatusCode;
    map['cmedStatusMessage'] = cmedStatusMessage;
    map['paymentID'] = paymentID;
    map['nagadURL'] = nagadURL;
    map['callbackURL'] = callbackURL;
    map['successCallbackURL'] = successCallbackURL;
    map['failureCallbackURL'] = failureCallbackURL;
    map['cancelledCallbackURL'] = cancelledCallbackURL;
    map['amount'] = amount;
    map['currency'] = currency;
    map['intent'] = intent;
    map['payerReference'] = payerReference;
    map['customerMsisdn'] = customerMsisdn;
    map['transactionStatus'] = transactionStatus;
    map['paymentCreateTime'] = paymentCreateTime;
    map['merchantInvoiceNumber'] = merchantInvoiceNumber;
    return map;
  }

}