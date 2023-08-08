import 'package:elegal/constants.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class Server {
  Future<String> createCheckout() async {
    print('Server');
    final auth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));
    final body = {
      'payment_method_types': ['card'],
      'line_items': [
        {
          'price': codeItem,
          'quantity': 1,
        }
      ],
      'mode': 'payment',
      'success_url': 'https://localhost:8080/#/success',
      'cancel_url': 'https://localhost:8080/#/cancel',
    };

    try {
      print('Server 2');
      final result = await Dio().post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      return result.data['id'];
    } on DioError catch (e, s) {
      print(e.response);
      rethrow;
    }
  }
}
