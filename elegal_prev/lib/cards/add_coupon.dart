import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toktok_app/globals.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';


class AddCoupon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddCoupon();
  }
}

class _AddCoupon extends State<AddCoupon>{
  String couponCode;
  QuerySnapshot dataFromFireStore;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Redeem Coupon'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: TextField(
              onChanged: ((value){
                setState(() {
                  this.couponCode = value;
                });
              }),
            ),
          ),
          Container(
            child: RaisedButton(
              child: Text('Submit'),
              onPressed: _redeemCode,
            ),
          )
        ]
      ),
    );
  }

  _redeemCode() async {
    final prefs = await SharedPreferences.getInstance();

    if(this.couponCode.length < 1) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return TokTokAlertDialog(
              'Invalid Coupon',
              "It seems you have introduced an invalid coupon. Please try again.",
              1
          );
        },
      );
    }

//    dataFromFireStore = await Firestore.instance.collection('transactions').where('userId', isEqualTo: prefs.getInt('userId')).getDocuments();

    if(dataFromFireStore.docs.isEmpty){
      var mapData = new Map();
      mapData['claimer'] = prefs.getInt('userId');
      mapData['code'] = this.couponCode;
      String json = jsonEncode(mapData);

      final response = await http.post(
        Uri.parse('${Globals.BASE_API_URL}/coupons/redeemCoupon'),
          headers: {
            'Authorization' : 'Bearer ${prefs.getString('access_token')}',
            'Content-Type' : 'application/json'
          },
        body: json,
      );

      var c = (jsonDecode(response.body));

      if(c['error'] != 'User already has redeemed this type of coupon'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TokTokAlertDialog(
                'Coupon Added',
                "The coupon has been correctly applied. Enjoy parking with us.",
                2
            );
          },
        ).then((onValue){
          return Navigator.of(context).popAndPushNamed('/listCoupons');
        });
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return TokTokAlertDialog(
                'Invalid Coupon',
                "Please verify the coupon code you are trying to use.",
                1
            );
          },
        );
      }

    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return TokTokAlertDialog(
              'Invalid Coupon',
              "This type of coupon is only available for a new user without a previous transaction",
              1
          );
        },
      );
    }
  }

}