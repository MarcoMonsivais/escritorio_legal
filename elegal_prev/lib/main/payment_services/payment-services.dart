import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fletgo_user_app/src/util/globlaVariables.dart';
// import 'package:fletgo_user_app/src/util/librarys_Variables.dart';
import 'package:flutter/foundation.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:toktok_app/util/globalVariables.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_test_51IN6GkChpML6DcZl8dbEpD01NFUe5wF1GxrPXGHyyOpBjHjHUgPABC6RFRamRNVvieqzK6pAspMU6aoR4kORaPDz00yyFTDpG0';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(
        StripeOptions(
          publishableKey: 'pk_test_51IN6GkChpML6DcZlQJIfBCnbzZk9FXIK5nxQgiiwSsB9jCX9MYtRfKFLCJIi0oNv5rPlUREx8bhHke1623RDG7Bk00EQsiT4d7',
          merchantId: 'tst',
          androidPayMode: 'tst',
        )
    );
  }

  static Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card)
      );
      var paymentIntent = await StripeService.createPaymentIntent(
          amount,
          currency
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static Future<StripeTransactionResponse> payWithNewCard(infoPayment paymentInfo, String orderId) async {
    try {

      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );

      var paymentIntent = await StripeService.createPaymentIntent(
          paymentInfo.amount.replaceAll('.', ''),
          paymentInfo.currency
      );

      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );

      paymentInfo.methodId = paymentMethod.id.toString();
      paymentInfo.intentId = paymentIntent.toString().substring(5,32);

      if (response.status == 'succeeded') {

        // final _auth = FirebaseAuth.instance;
        // final newUser = await _auth.currentUser();
        // String uuidUser = newUser.uid.toString();
        //
        // final uuidu = infoUser(
        //     uuidUser: uuidUser
        // );
        //
        // await Firestore.instance
        //     .collection('users')
        //     .document(uuidu.uuidUser)
        //     .collection('orders')
        //     .document(orderId)
        //     .updateData({
        //   'addOrderId': orderId,
        //   'addStatus': 'En espera',
        //   'detailPaymentInfo':  {
        //     'amount': paymentInfo.amount,
        //     'currency': paymentInfo.currency,
        //     'paymentIntent': paymentInfo.intentId,
        //     'paymentMethod': paymentInfo.methodId,
        //   }
        // });

        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {

      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
       // 'calculated_statement_descriptor': 'Escritorio Legal',
//        'receipt_email': 'correo de cliente',
        //customerId
//        'customer' : 'cus_IhvnCUTuLWXMrS'
      };

      var response = await http.post(
          Uri.parse(StripeService.paymentApiUrl),
          body: body,
          headers: StripeService.headers
      );

      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
