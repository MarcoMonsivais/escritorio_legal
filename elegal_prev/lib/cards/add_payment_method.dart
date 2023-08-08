import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddPaymentMethod extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPaymentMethod();
  }
}

class _AddPaymentMethod extends State<AddPaymentMethod>{

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addPaymentMethod),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
              onTap: ((){
                checkOppToken();
              }),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 5, right: SizeConfig.safeBlockHorizontal * 4),
                  child: Icon(Icons.credit_card, size: 28.0),
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
                  child: Text(
                    AppLocalizations.of(context).creditOrDebit,
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                )
              ],
            )
          ),
          SizedBox(height: 15.0),
          GestureDetector(
              onTap: ((){
                Navigator.of(context).popAndPushNamed('/webViewHelper');

              }),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 4),

                    width: SizeConfig.blockSizeHorizontal * 8,
                    height: SizeConfig.safeBlockVertical * 8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/paypal-logo.png'),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  Text(
                    'PayPal',
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  checkOppToken() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString('opp_token') != null){
      Navigator.of(context).pushNamed('/addCard');
    } else {
      Navigator.of(context).pushNamed('/registerOpp');
    }

  }

}