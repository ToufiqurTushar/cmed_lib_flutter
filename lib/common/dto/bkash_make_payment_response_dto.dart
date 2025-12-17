class BkashMakePaymentResponseDto {
  BkashMakePaymentResponseDto({
    this.statusCode,
    this.statusMessage,
    this.cmedStatusCode,
    this.cmedStatusMessage,
    this.paymentID,
    this.bkashURL,
    this.nagadURL,
    this.callbackURL,
    this.successCallbackURL,
    this.failureCallbackURL,
    this.cancelledCallbackURL,
    this.amount,
    this.currency,
    this.intent,
    this.payerReference,
    this.agreementID,
    this.paymentCreateTime,
    this.transactionStatus,
    this.merchantInvoiceNumber,});

  BkashMakePaymentResponseDto.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    cmedStatusCode = json['cmedStatusCode'];
    cmedStatusMessage = json['cmedStatusMessage'];
    paymentID = json['paymentID'];
    bkashURL = json['bkashURL'];
    nagadURL = json['nagadURL'];
    callbackURL = json['callbackURL'];
    successCallbackURL = json['successCallbackURL'];
    failureCallbackURL = json['failureCallbackURL'];
    cancelledCallbackURL = json['cancelledCallbackURL'];
    amount = json['amount'];
    currency = json['currency'];
    intent = json['intent'];
    payerReference = json['payerReference'];
    agreementID = json['agreementID'];
    paymentCreateTime = json['paymentCreateTime'];
    transactionStatus = json['transactionStatus'];
    merchantInvoiceNumber = json['merchantInvoiceNumber'];
  }
  String? statusCode;
  String? statusMessage;
  String? cmedStatusCode;
  String? cmedStatusMessage;
  String? paymentID;
  String? bkashURL;
  String? nagadURL;
  String? callbackURL;
  String? successCallbackURL;
  String? failureCallbackURL;
  String? cancelledCallbackURL;
  String? amount;
  String? currency;
  String? intent;
  String? payerReference;
  String? agreementID;
  String? paymentCreateTime;
  String? transactionStatus;
  String? merchantInvoiceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['statusMessage'] = statusMessage;
    map['cmedStatusCode'] = cmedStatusCode;
    map['cmedStatusMessage'] = cmedStatusMessage;
    map['paymentID'] = paymentID;
    map['bkashURL'] = bkashURL;
    map['nagadURL'] = nagadURL;
    map['callbackURL'] = callbackURL;
    map['successCallbackURL'] = successCallbackURL;
    map['failureCallbackURL'] = failureCallbackURL;
    map['cancelledCallbackURL'] = cancelledCallbackURL;
    map['amount'] = amount;
    map['currency'] = currency;
    map['intent'] = intent;
    map['payerReference'] = payerReference;
    map['agreementID'] = agreementID;
    map['paymentCreateTime'] = paymentCreateTime;
    map['transactionStatus'] = transactionStatus;
    map['merchantInvoiceNumber'] = merchantInvoiceNumber;
    return map;
  }

}