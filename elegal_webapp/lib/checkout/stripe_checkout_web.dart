@JS()
library stripe;

import 'package:flutter/material.dart';
import 'package:elegal/constants.dart';
import 'package:js/js.dart';

void redirectToCheckout(BuildContext _) async {
  try {
    print('code item: ' + codeItem);
    final stripe = Stripe(apiKey);
    stripe.redirectToCheckout(CheckoutOptions(
      lineItems: [
        LineItem(price: codeItem, quantity: 1),
      ],

      mode: 'payment',
      successUrl: 'https://escritoriolegal.com.mx/app/index.html#/success',
      cancelUrl: 'https://escritoriolegal.com.mx/app/index.html#/',
    ));
    } catch(onError){
    print('Stripe error: ' + onError.toString());
  }
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
