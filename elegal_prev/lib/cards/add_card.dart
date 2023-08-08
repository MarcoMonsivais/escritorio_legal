import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'dart:async';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:flutter/services.dart';
import 'package:openpay_flutter/model/customer.dart';
import 'package:openpay_flutter/openpay_flutter.dart';
import 'package:openpay_flutter/model/card.dart' as CreditCard;
import 'package:toktok_app/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';

class AddCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddCardState();
  }

}

class _AddCardState extends State<AddCard>{
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool _isLoading = false;
  String platformVersion;
  String _platformVersion = 'Unknown';
  CreditCard.Card _card = new CreditCard.Card();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

      platformVersion = await OpenpayAPI(Globals.MERCHANT_ID,Globals.PUBLIC_OP).deviceSessionId(Globals.MERCHANT_ID,Globals.PUBLIC_OP);

      Map<String, String> filters = {
        "externalId": "103706956058001336318",
        "offset": "0",
        "limit": "1"
      };

      OpenpayAPI _opp = new OpenpayAPI(Globals.MERCHANT_ID, Globals.PUBLIC_OP);
      _opp.customerService.getList(Customer(), filters: filters).then((data){
        print(data);
      }).catchError((error){
        print(error);
      });

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Card'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _isLoading ? Container(
              height: SizeConfig.blockSizeVertical * 89.2,
              color: Colors.black12,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ) : SizedBox(),
            Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: CreditCardForm(
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.orange,
                  disabledColor: Colors.orange,
                  textColor: Colors.white,
                  child: Text('Save'),
                  onPressed: _isLoading ? null : _addCard,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future _addCard() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    print(Globals.MERCHANT_ID);
    try {
      var parts = expiryDate.split('/');
      _card.card_number = cardNumber.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      _card.holder_name = cardHolderName;
      _card.expiration_year = parts[1];
      _card.expiration_month = parts[0];
      _card.cvv2 = cvvCode;
      _card.device_session_id = platformVersion;
      _card.customer_id = prefs.getString('opp_token');
    } catch (e){
      setState(() {
        _isLoading = false;
      });
      return _showAlert('No values', 'Please fill all values');
    }

    OpenpayAPI _opp = new OpenpayAPI(Globals.MERCHANT_ID, Globals.PUBLIC_OP);

    final cardCreated = await _opp.cardService.createCard(_card).catchError((e){
      var error = e.toString();
      print("wacha el error");
      print(Globals.MERCHANT_ID);
      print(Globals.PUBLIC_OP);
      print(error);
      var parts = error.split('description":');
      parts = parts[1].split(',');
      setState(() {
        _isLoading = false;
      });
      if(parts[0] == '"holder_name is required')
        return _showAlert('Holder Name', 'The holder name is required');
      else if(parts[0] == '"The expiration date has already passed"')
        return _showAlert('Expiration Date', 'The expiration date has alrady passed. Please verify');
      else if(parts[0].startsWith('"expiration_month'))
        return _showAlert('Expiration Month', 'The expiration month is invalid. Please verify');
      else if(parts[0] == '"card_number length is invalid"')
        return _showAlert('Card Number', 'The card number length is invalid. Please verify');
      else if(parts[0] == '"The CVV2 security code is required"')
        return _showAlert('Security Code', 'The CVV2 security code is invalid. Please verify');
      else if(parts[0] == '"cvv2 length must be 3 digits"')
        return _showAlert('Security Code', 'The CVV2 security code must be 3 digits. Please verify');
      else if(parts[0] == '"cvv2 length must be 4 digits"')
        return _showAlert('Security Code', 'The CVV2 security code must be 4 digits. Please verify');
      else if(parts[0] == '"The card was declined"')
        return _showAlert('Card Declined', 'The card was declined. Please verify all the information. If the information is correct then call your banking provide for more information on why it was declined');
      else if(parts[0] == '"The card number verification digit is invalid"')
        return _showAlert('Security Code', 'The CVV2 security code is invalid. Please verify');
      else
       return _showAlert('Unexpected Error', 'Sorry it seems that you have found and unexpected error. We are working hard so you not having to found them');

    });

    setState(() {
      if(prefs.getString('selectedPayment') == null) {
        prefs.setString('selectedPayment', cardCreated.id);
        prefs.setString('selectedPaymentMethod', 'openpay');
      }
      _isLoading = false;
    });
    int count = 0;
    return Navigator.of(context).popUntil((_) => count++ >= 2);

  }

  _showAlert(title, message){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TokTokAlertDialog(
            title,
            message,
            1
        );
      },
    );

  }
}