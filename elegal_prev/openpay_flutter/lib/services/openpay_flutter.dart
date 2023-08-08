library openpay_flutter;

import 'package:flutter/services.dart';
import 'package:openpay_flutter/services/card_service.dart';
import 'package:openpay_flutter/services/customer_service.dart';
import 'package:openpay_flutter/services/payments_service.dart';
import 'package:openpay_flutter/utils/openpay_client.dart';

/// A Calculator.
class OpenpayAPI {
  String _merchantId;
  String _privateKey;
  bool _production = false;
  OpenPayClient _client;

  static const MethodChannel _channel = const MethodChannel('openpay_flutter');

  CustomerService customerService;
  CardService cardService;
  PaymentService payService;

  OpenpayAPI(this._merchantId, this._privateKey, {production = false}) {
    this._production = production;
    _client = OpenPayClient(_merchantId, _privateKey);
    customerService = CustomerService(_client);
    cardService = CardService(_client);
    payService = PaymentService(_client);
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> deviceSessionId(String merchantId, String privateKey) async {
    if (this._production) {
      final String version =
          await _channel.invokeMethod('getDeviceSessionId', <String, dynamic>{
        '_merchantId': merchantId,
        '_privateKey': privateKey,
      });
      return version;
    } else {
      return "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f";
    }
  }

  static Future<bool> validateCard(String cvv, String cardNumber) async {
    final bool version =
        await _channel.invokeMethod('validateCardCVV', <String, dynamic>{
      'cvv': cvv,
      'cardNumber': cardNumber,
    });
    print("validate returned");
    return version;
  }
}

/* 
class OpenpayFlutter {
  static const MethodChannel _channel = const MethodChannel('openpay_flutter');

  

  //getDeviceSessionId
}
 */
