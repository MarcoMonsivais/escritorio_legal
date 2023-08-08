import 'package:flutter/material.dart';
import 'size_config.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';

class RightDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RightDrawer();
  }
}

class _RightDrawer extends State<RightDrawer> with TickerProviderStateMixin{
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.safeBlockVertical * 35,
      width: SizeConfig.safeBlockHorizontal * 75,
      decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1.0),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)
          )
      ),
      child: Stack(
        children: <Widget>[
          _isLoading ? Container(
            color: Colors.black12,
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.blockSizeVertical * 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : SizedBox(),
          Column(
            children: <Widget>[
              Container(
                    height: SizeConfig.blockSizeVertical * 15,
                    decoration: BoxDecoration(
                        color: Color(0xFF000000)
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.blockSizeVertical * 5,
                          height: SizeConfig.blockSizeHorizontal * 10,
                          margin: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 4
                          ),
                          child: Icon(Icons.settings, size: 45.0, color: Colors.white),
                        ),
                        SizedBox(width: SizeConfig.blockSizeHorizontal * 5.0),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 45.0,
                          child: Text(
                              AppLocalizations.of(context).settings,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                      ],
                    )
                ),
              SizedBox( height: SizeConfig.blockSizeVertical * 2),
              GestureDetector(
                onTap: ((){
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/transactionHistory');
                }),
                child: Container(
                  color: Colors.white,

                  width: SizeConfig.safeBlockHorizontal * 100,
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
                  child: Text('Transactions',
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/listCards');
                }),
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  width: SizeConfig.safeBlockHorizontal * 100,
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
                  child: Text(AppLocalizations.of(context).payment,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/userCode');
                }),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  width: SizeConfig.safeBlockHorizontal * 100,
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
                  child: Text('Referral Code',
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/selectLanguage');
                }),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 100,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
                  child: Text(AppLocalizations.of(context).language,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/terminos');
                }),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 100,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
                  child: Text(AppLocalizations.of(context).terminos,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  _logout();
                }),
                child: Container(
                  color: Colors.white,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
                  child: Text(AppLocalizations.of(context).logout,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

    final _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('access_token')} '
    };

    await http.get(
      Uri.parse('${Globals.BASE_API_URL}/users/auth/logout'),
      headers: _headers,
    );


    prefs.remove('access_token');
    prefs.remove('refresh_token');
    prefs.remove('userId');
    prefs.remove('paypalToken');
    prefs.remove('opp_token');
    prefs.setBool('showBanner', true);
    prefs.remove('selectedPaymentMethod');
    prefs.remove('selectedPayment');

    return Navigator.of(context).pushNamedAndRemoveUntil('/googleLogin', (Route<dynamic> route) => false);
  }

}