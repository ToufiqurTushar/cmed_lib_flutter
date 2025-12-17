class BkashPaymentCompleteResponseDto {
  BkashPaymentCompleteResponseDto({
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
      this.agreementID, 
      this.trxID, 
      this.amount, 
      this.currency, 
      this.intent, 
      this.transactionStatus, 
      this.paymentExecuteTime, 
      this.merchantInvoiceNumber,});

  BkashPaymentCompleteResponseDto.fromJson(dynamic json) {
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
    trxID = json['trxID'];
    amount = json['amount'];
    currency = json['currency'];
    intent = json['intent'];
    transactionStatus = json['transactionStatus'];
    paymentExecuteTime = json['paymentExecuteTime'];
    merchantInvoiceNumber = json['merchantInvoiceNumber'];
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
  String? trxID;
  String? amount;
  String? currency;
  String? intent;
  String? transactionStatus;
  String? paymentExecuteTime;
  String? merchantInvoiceNumber;

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
    map['trxID'] = trxID;
    map['amount'] = amount;
    map['currency'] = currency;
    map['intent'] = intent;
    map['transactionStatus'] = transactionStatus;
    map['paymentExecuteTime'] = paymentExecuteTime;
    map['merchantInvoiceNumber'] = merchantInvoiceNumber;
    return map;
  }

}