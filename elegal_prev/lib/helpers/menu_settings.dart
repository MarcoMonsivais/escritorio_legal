import 'package:flutter/material.dart';
import 'size_config.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';

class MenuSettings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MenuSettings();
  }
}

class _MenuSettings extends State<MenuSettings> with TickerProviderStateMixin{
  Animation animationToRight;
  AnimationController animationController;
  bool toggleConfig = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    animationToRight = Tween(begin: SizeConfig.safeBlockHorizontal * 1, end: SizeConfig.safeBlockHorizontal * 25).animate(CurvedAnimation(
        parent: animationController, curve: Curves.ease));

    animationController.forward();

    // TODO: implement build
    return toggleConfig ? AnimatedContainer(
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      margin: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical* 4,
      ),
      height: SizeConfig.safeBlockVertical * 35,
      width: toggleConfig ? SizeConfig.safeBlockHorizontal * 75 : 0,
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
          )
          : SizedBox(),
          Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                    height: SizeConfig.blockSizeVertical * 7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0)
                        ),
                        color: Color.fromRGBO(39, 70, 115, 1.0)
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.blockSizeVertical * 5,
                          height: SizeConfig.blockSizeHorizontal * 10,
                          margin: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 4
                          ),
                          child: Icon(Icons.settings, size: 45.0, color: Colors.orange),
                        ),
                        SizedBox(width: SizeConfig.blockSizeHorizontal * 5.0),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 45.0,
                          child: Text(
                              AppLocalizations.of(context).settings,
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1.0, color: Colors.orange),

                          ),
                          child: Icon(
                            Icons.chevron_left,
                            size: 22.0,
                            color: Colors.orange,
                          ),
                        )
                      ],
                    )
                ),
                onTap: ((){
                  setState(() {
                    this.toggleConfig = false;
                  });
                }),
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: ((){
                  setState(() {
                    this.toggleConfig = false;
                  });
                  Navigator.of(context).pushNamed('/transactionHistory');
                }),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 100,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Transactions',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  setState(() {
                    this.toggleConfig = false;
                  });
                  Navigator.of(context).pushNamed('/listCards');
                }),
                child: Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: SizeConfig.safeBlockHorizontal * 100,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(AppLocalizations.of(context).payment,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  setState(() {
                    this.toggleConfig = false;
                  });
                  Navigator.of(context).pushNamed('/userCode');
                }),
                child: Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: SizeConfig.safeBlockHorizontal * 100,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Referral Code',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ((){
                  setState(() {
                    this.toggleConfig = false;
                  });
                  Navigator.of(context).pushNamed('/selectLanguage');
                }),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 100,
                  margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(AppLocalizations.of(context).language,
                    style: TextStyle(
                      fontSize: 18.0,
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
                  width: SizeConfig.safeBlockHorizontal * 100,
                  margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(AppLocalizations.of(context).logout,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ) : Container(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 5,
        ),

        child: GestureDetector(
            onTap: ((){
              setState(() {
                this.toggleConfig = true;
              });
            }),
            child: Stack(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*15,
                  height: SizeConfig.blockSizeVertical*5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)
                    ),
                    color: Color.fromRGBO(39, 70, 115, 1.0),
                  ),
                ),
                Container(
                  width: SizeConfig.blockSizeVertical*7,
                  height: SizeConfig.blockSizeHorizontal*8,
                  child: Icon(
                    Icons.settings,
                    size: 45.0,
                    color: Colors.orange,
                  ),
                ),
              ],
            )
        )
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