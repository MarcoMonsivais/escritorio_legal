import 'package:flutter/material.dart';
import 'package:openpay_flutter/openpay_flutter.dart';
import 'package:toktok_app/globals.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/app_localizations.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';

class ListCards extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListCardsState();
  }

}

class _ListCardsState extends State<ListCards> {
  String platformVersion;
  List cards;
  int couponCount = 0;
  String selectedCard;
  bool hasPayPal = false;
  bool _hasCoupons = false;
  String payPalEmail = '';
  String ppRefresh;

  @override
  void initState() {
    super.initState();
    _getCoupons();
    _getPayPal();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).payment),
        ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 2,
                  left: SizeConfig.blockSizeHorizontal * 5
                ),
                child: Text(
                  AppLocalizations.of(context).paymentMethods,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 1.0,
                  left: 5.0
                ),
//            height: SizeConfig.safeBlockVertical * 30,
                child: projectWidget(),
              ),
              hasPayPal ? Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/img/paypal-logo.png'),
                      height: 50.0,
                      width: 70.0,

                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10.0),
                        width: SizeConfig.blockSizeHorizontal * 67,
                        height: 25,
                        child: Text(
                          payPalEmail,
                          style: TextStyle(
                              fontWeight: FontWeight.w600
                          ),
                        )
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    GestureDetector(
                      onTap: ((){
                        _addSelectedPayment(ppRefresh, 'paypal');
                      }),
                      child: Icon(
                        Icons.check,
                        color: ppRefresh == this.selectedCard ? Colors.green : Colors.grey,
                      ),
                    )
                  ]
              ): SizedBox(),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)
                    )
                ),
                padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5),
                width: SizeConfig.blockSizeHorizontal * 100,
                child: GestureDetector(
                  onTap: ((){
                    Navigator.of(context).pushNamed('/addPaymentMethod');
                  }),
                  child: Text(
                    AppLocalizations.of(context).addPaymentMethod,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 1.9,
                        color: Colors.blueAccent
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Text(
                  AppLocalizations.of(context).coupons,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              GestureDetector(
                onTap: (_hasCoupons ? (){
                  Navigator.of(context).pushNamed('/listCoupons');
                } : null),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 10,
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                      child: Icon(Icons.card_giftcard),
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 80,
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),

                      child: Text(
                          AppLocalizations.of(context).coupons
                      ),
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 10,
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),

                      child: Text(
                        this.couponCount.toString(),
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: ((){Navigator.of(context).pushNamed('/addCoupon');}),
                child: Container(
                  padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5),
                  width: SizeConfig.blockSizeHorizontal * 100,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  child: Text(
                    'Add Coupon',
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 1.9,
                      color: Colors.blueAccent
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Future _getCards() async {
    platformVersion = await OpenpayAPI(Globals.MERCHANT_ID,Globals.PUBLIC_OP).deviceSessionId(Globals.MERCHANT_ID,Globals.PUBLIC_OP);
    final prefs = await SharedPreferences.getInstance();
    print("getcards");
    print(Globals.MERCHANT_ID);
    print(Globals.PUBLIC_OP);
    this.selectedCard = prefs.getString('selectedPayment');
    print(this.selectedCard);

    OpenpayAPI _opp = new OpenpayAPI(Globals.MERCHANT_ID, Globals.PUBLIC_OP);

    var result = await _opp.cardService.getCustomerCards(prefs.getString('opp_token'));
    //Aqui Colocar el codigo para que si existe una tarjeta la seleccione por default, pero desde que inicia sesión.
    return result;

  }

  _getCoupons() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/coupons/getCouponForUser/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        }
    );

    var c = (jsonDecode(response.body));

    setState(() {
      this.couponCount = c['data'].length;
      if(this.couponCount > 0)
        _hasCoupons = true;
    });
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: _getCards(),
      initialData: 'Loading...',
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }
        return projectSnap.data == null ?
        Container(
          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 40, right: SizeConfig.blockSizeHorizontal * 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You haven\'t added a Card Payment Method')
            ],
          )
        ) : ListView.builder(
          shrinkWrap: true,
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image(
                        image: AssetImage('assets/img/${projectSnap.data[index].brand}-logo.png'),
                      height: 50.0,
                      width: 70.0,

                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      width: SizeConfig.blockSizeHorizontal * 60,
                      height: 25,
                      child: Text(
                        '••••${projectSnap.data[index].card_number.toString().substring(projectSnap.data[index].card_number.toString().length - 4 )}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ),
                    GestureDetector(
                      onTap: ((){
                        _deleteCard(projectSnap.data[index]);
                      }),
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      )
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    GestureDetector(
                      onTap: ((){
                        _addSelectedPayment(projectSnap.data[index].id, 'openpay');
                      }),
                      child: Icon(
                        Icons.check,
                        color: projectSnap.data[index].id == this.selectedCard ? Colors.green : Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        );
      },
    );

  }

  _deleteCard(cardId) async {
    platformVersion = await OpenpayAPI(Globals.MERCHANT_ID,Globals.PUBLIC_OP).deviceSessionId(Globals.MERCHANT_ID,Globals.PUBLIC_OP);
    final prefs = await SharedPreferences.getInstance();

    if(cardId == prefs.getString('selectedPayment')){
      prefs.remove('selectedPayment');
    }
//
    OpenpayAPI _opp = new OpenpayAPI(Globals.MERCHANT_ID, Globals.PUBLIC_OP);
//
    var result = await _opp.cardService.removeCard(cardId);
    if(result){
      showDialog(context: context, builder: (BuildContext context) {return TokTokAlertDialog(
              'Card Deleted',
              'The card has been deleted',
              1
          );
      });


      setState(() {
        _getCards();
      });
    }
    return result;
  }

  _addSelectedPayment(cardId, method) async {
    final prefs = await SharedPreferences.getInstance();


    prefs.remove('selectedPayment');
    prefs.remove('selectedPaymentMethod');


    setState(() {
      prefs.setString('selectedPayment', cardId);
      prefs.setString('selectedPaymentMethod', method);
      this.selectedCard = prefs.getString('selectedPayment');
    });
  }

  Future _getPayPal() async {
    final prefs = await SharedPreferences.getInstance();
    final _headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ${Globals.PAYPAL_AUTH}'
    };

    print(prefs.getString('paypalToken'));
    if (prefs.getString('paypalToken') != null){
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

      var getPPUser = await http.get(
        Uri.parse('https://api.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=paypalv1.1'),
        headers: _headersPP,
      );
      var ppUser = jsonDecode(getPPUser.body);

      payPalEmail = ppUser['emails'][0]['value'];
      setState(() {
        hasPayPal = true;
      });

    }



  }

}