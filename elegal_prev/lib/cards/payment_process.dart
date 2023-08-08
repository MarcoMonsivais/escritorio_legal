import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/globals.dart';
import 'package:openpay_flutter/openpay_flutter.dart';
import 'package:openpay_flutter/model/payment.dart';
import 'package:toktok_app/helpers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentProcess {
  DateTime timeNow;
  String platformVersion;

  Future<Receipt>performPayment(establishmentId, userId, sDuration, date) async {
    final prefs = await SharedPreferences.getInstance();
    platformVersion = await OpenpayAPI(Globals.MERCHANT_ID,Globals.PUBLIC_OP).deviceSessionId(Globals.MERCHANT_ID,Globals.PUBLIC_OP);
    timeNow = DateTime.now();
    Receipt returnReceipt = Receipt();

    //var parsedDate = DateTime.parse(prefs.getString('entryTime'));
    //int hoursElapsed = timeNow.difference(parsedDate).inHours;
    //int minutesElapsed = timeNow.difference(parsedDate).inMinutes.remainder(60);
    double total;
    double fee;

    final _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('access_token')} '
    };

    // final coupon = await http.get(
    //   '${Globals.BASE_API_URL}/coupons/getCouponForUser/$userId',
    //   headers: _headers,
    //
    // );
    //
    // var c = jsonDecode(coupon.body);
    //
    //
    //
    // if(c['data'].length >= 1){ //If a coupon is found we execute with it
    //   print("entra cupon");
    //
    //   int descuento = int.parse(c['data'][0]['discount']);
    //   int couponId = c['data'][0]['couponId'];
    //   String couponCode = c['data'][0]['couponCode'];
    //
    //   var mapDataUsedCoupon = new Map();
    //   mapDataUsedCoupon['userId'] = userId;
    //   mapDataUsedCoupon['couponId'] = couponId;
    //   String jsonUsedCoupon = jsonEncode(mapDataUsedCoupon);
    //
    //
    //   await http.post(
    //       '${Globals.BASE_API_URL}/coupons/usedCoupon',
    //       headers: _headers,
    //       body: jsonUsedCoupon
    //   );
    //
    //   var toCalculatePayment = new Map();
    //   toCalculatePayment['establishmentId'] = establishmentId;
    //   toCalculatePayment['discount'] = descuento;
    //  // toCalculatePayment['hours'] = hoursElapsed;
    // //  toCalculatePayment['minutes'] = minutesElapsed;
    //
    //   String jsonCalculatePayment = jsonEncode(toCalculatePayment);
    //
    //   final calculatedPayment = await http.post(
    //       '${Globals.BASE_API_URL}/establishments/calculatePayment',
    //       headers: _headers,
    //       body: jsonCalculatePayment
    //   );
    //
    //   var grandtotal = jsonDecode(calculatedPayment.body);
    //   if(grandtotal['error'] != null){
    //     returnReceipt.error =  grandtotal['error'].toString();
    //     return returnReceipt;
    //   }
    //   total = grandtotal['total'].toDouble();
    //   fee = 5.0;//grandtotal['fee'].toDouble();
    //
    //   //Here we make the distinction of what type of payment it is
    //   if(prefs.getString('selectedPaymentMethod') == 'openpay') {
    //     returnReceipt = await _payWithOpenPay(total, grandtotal['oppToken'], sDuration, establishmentId, userId, fee, grandtotal['oppToken'], couponId);
    //
    //   } else if(prefs.getString('selectedPaymentMethod') == 'paypal') {
    //     returnReceipt = await _payWithPaypal(total, grandtotal['oppToken'], sDuration, establishmentId, userId, fee, couponId);
    //   }
    //
    // } else { //No coupon was found so we add that as a 0
      var toCalculatePayment = new Map();
      toCalculatePayment['establishmentId'] = establishmentId;
      toCalculatePayment['discount'] = 0;
      toCalculatePayment['hours'] = 3;
      toCalculatePayment['total'] = establishmentId;
      //toCalculatePayment['minutes'] = minutesElapsed;
      String jsonCalculatePayment = jsonEncode(toCalculatePayment);

      final calculatedPayment = await http.post(
          Uri.parse('${Globals.BASE_API_URL}/establishments/calculatePayment'),
          headers: _headers,
          body: jsonCalculatePayment 
      );

      var grandtotal = jsonDecode(calculatedPayment.body);
      if(grandtotal['error'] != null){
        returnReceipt.error =  grandtotal['error'].toString();
        return returnReceipt;
      }
      total = grandtotal['total'].toDouble();
      fee = 5.0;//grandtotal['fee'].toDouble();

      //Here we make the distinction of what type of payment it is
      if(prefs.getString('selectedPaymentMethod') == 'openpay') {
        returnReceipt = await _payWithOpenPay(total, grandtotal['oppToken'], sDuration, establishmentId, userId, fee, grandtotal['oppToken'], '');

      } else if(prefs.getString('selectedPaymentMethod') == 'paypal') {
        returnReceipt = await _payWithPaypal(total, grandtotal['oppToken'], sDuration, establishmentId, userId, fee, '');
      }

    //}
    return returnReceipt;
  }

  Future<void> _addData (doorData, document) async {
    FirebaseFirestore.instance.collection(document).add(doorData).catchError((e){
      print(e);
    });
  }

  Future _payWithOpenPay(total, receiver, sDuration, establishmentId, userId, fee, establishmentOpp, couponId) async {
    final prefs = await SharedPreferences.getInstance();
    DateTime date;
    Receipt receipt = Receipt();

    Payment pp = Payment();
    pp.amount = total;
    pp.source_id = prefs.getString('selectedPayment');
    pp.method = "card";
    pp.description = "Tokenizacion cargo directo";
    pp.device_session_id = platformVersion;

    if(total != 0){
      OpenpayAPI _opp = new OpenpayAPI(Globals.MERCHANT_ID, Globals.PUBLIC_OP);
      try {
        await _opp.payService.performPayment(prefs.getString('opp_token'), pp).then((
            onValue) {
          var feeCharge = new Map();
          feeCharge['total'] = total;
          feeCharge['fee'] = fee;
          feeCharge['payer'] = prefs.getString('opp_token');
          feeCharge['receiver'] = establishmentOpp;
          String jsonFeeCharge = jsonEncode(feeCharge);

          receipt.cardThatPayed = onValue['card']['card_number'];
          receipt.holderName = onValue['card']['holder_name'];
          receipt.dateCreated = onValue['creation_date'];
        });
      } catch (e){
        print('ya la cagaste');
        print(e);
      } finally {
        receipt.total = total;
        receipt.discount = 0;
        receipt.time = sDuration;

        receipt.fee = fee;

        date = new DateTime.now();
        var transactionData = {
          'date': date,
          'establishmentId': establishmentId,
          'userId': userId,
          'paymentMethod': prefs.getString('selectedPaymentMethod'),
          'amount': total,
          'coupon': couponId,
          'time': sDuration
        };

        _addData(transactionData, 'transactions');


        prefs.remove('entryTime');

        return receipt;
      }

    }


  }

  _payWithPaypal(total, receiver, sDuration, establishmentId, userId, fee, couponId) async {
    final prefs = await SharedPreferences.getInstance();
    final _headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ${Globals.PAYPAL_AUTH}'
    };
    String ppRefresh;
    DateTime date;

    if (prefs.getString('paypalToken') != null) {
      ppRefresh = prefs.getString('paypalToken');
      String token;
      var firstStepMap = new Map();
      firstStepMap['grant_type'] = 'refresh_token';
      firstStepMap['refresh_token'] = ppRefresh;

      var getPPToken = await http.post(
          Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token'),
          headers: _headers,
          body: firstStepMap
      );
      var res = jsonDecode(getPPToken.body);
      token = res['access_token'];

      final _headersPP = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      //Perform Paypal transaction

      var getPPUser = await http.get(
        Uri.parse('https://api.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=paypalv1.1'),
        headers: _headersPP,
      );
      var ppUser = jsonDecode(getPPUser.body);

      var createorderMap = new Map();
      var amountToPay = new Map();
      amountToPay['currency_code'] = 'MXN';
      amountToPay['value'] = total;
      createorderMap['intent'] = 'CAPTURE';
      createorderMap['purchase_units'] = [{'amount': amountToPay }];

      var createOrder = await http.post(
          Uri.parse('https://api.sandbox.paypal.com/v1/payments/payment'),
        headers: _headersPP,
        body: jsonEncode({
          "intent": "sale",
          "payer": {
          "payment_method": "paypal"
          },
          "transactions": [
            {
              "amount": {
                "total": total,
                "currency": "MXN",
              },
            }
          ],
          "redirect_urls": {
            "return_url": "https://example.com/return",
            "cancel_url": "https://example.com/cancel"
          }
        })
      );

      var orderResponse = jsonDecode(createOrder.body);
      print(orderResponse);

      if(orderResponse['state'] == 'approved') {
        Receipt receipt = Receipt();
        receipt.total = total;
        receipt.discount = 0;
        receipt.time = sDuration;

        receipt.fee = fee;

        date = new DateTime.now();
        var transactionData = {
          'date': date,
          'establishmentId': establishmentId,
          'userId': userId,
          'paymentMethod': prefs.getString('selectedPaymentMethod'),
          'amount': total,
          'coupon': couponId,
          'time': sDuration
        };

        _addData(transactionData, 'transactions');

        prefs.remove('entryTime');

        return receipt;
      }

//      String order = orderResponse['id'];
//
//      //With the order ID we can authorize the payment
//      var authorizeOrder = await http.post(
//          'https://api.sandbox.paypal.com/v1/payments/orders/$order/authorize',
//          headers: _headersPP,
//          body: jsonEncode({
//            'amount': {
//              'total': total,
//              'currency': 'MXN'
//            }
//          })
//      );
//
//      print('autorizacion');
//      print(authorizeOrder.body);

      //Now that we have the order ID we can perform the charge
//      print(order);
//
//      var performPayPalCharge = await http.post(
//        'https://api.sandbox.paypal.com/v2/checkout/orders/$order/capture',
//        headers: _headersPP,
//        body: jsonEncode({
//          'payer': ppUser
//        })
//      );
//
//      print(performPayPalCharge.body);
//      var payPalCharge = jsonDecode(performPayPalCharge.body);


    }
  }

}