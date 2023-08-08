import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:country_pickers/country.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RequestMobile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RequestMobile();
  }
}

class _RequestMobile extends State<RequestMobile> with SingleTickerProviderStateMixin{
  String cellNumber;
  Animation animationToTop, animationToRight;
  AnimationController animationController;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 1), vsync: this);

    animationToTop = Tween(begin: SizeConfig.safeBlockVertical * 80, end: SizeConfig.safeBlockVertical * 7).animate(CurvedAnimation(
      parent: animationController, curve: Curves.ease
    ));

    animationToRight = Tween(begin: SizeConfig.safeBlockHorizontal * 10, end: SizeConfig.safeBlockHorizontal * 5).animate(CurvedAnimation(
        parent: animationController, curve: Curves.ease));

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController numberController = TextEditingController();

    // TODO: implement build
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Builder(
          builder: (context) =>
              Stack(
                  children: <Widget>[
                    Container(
                      height: SizeConfig.blockSizeVertical * 5,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 1,
                          left: SizeConfig.blockSizeHorizontal * 5
                      ),
                      child: Text(
                        AppLocalizations.of(context).pleaseMobileNumber,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical * 60,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      margin: EdgeInsets.only(
                          left: animationToRight.value,
                          top: animationToTop.value
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                              child: CountryPickerDropdown(
                                initialValue: 'mx',
                                itemBuilder: _buildDropdownItem,
                              ),
                            ),
                            Flexible(
                                child: TextField(
                                  onChanged: (String value) {
                                    setState(() {
                                      cellNumber = value;
                                      numberController.text = value;
                                    });
                                    },
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context).enterMobile,
                                    hintStyle: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey
                                    ),
                                  ),
                                )
                            ),
                          ]
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 62,
                                  child: Text(AppLocalizations.of(context).smsDisclaimer, style: TextStyle(fontSize: 16)),
                                ),
                                InkWell(
                                  onTap: isButtonPressed ? null : () async {
                                    var helper = await _verifyNumber();
                                    if(helper == false){
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Verify Number"),
                                            backgroundColor: Colors.red,
                                          )
                                      );
                                    }
                                    },
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 20,
                                    height: SizeConfig.blockSizeVertical * 7,
                                    margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                                    decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0,10.0), blurRadius: 20.0, spreadRadius: 0.1)]),
                                    child: Icon(Icons.arrow_forward, size: 30.0, color: Colors.white),
                                  ),
                                )
                              ],
                            )
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 5,
                        )
                      ],
                    ),
                  ]
              )
        )
      );
      }
      );
  }
  
  Future _verifyNumber() async{
    if(cellNumber.length == 10){
      isButtonPressed = true;
      cellNumber = '52$cellNumber';
      codeValidation();
    } else if(cellNumber.length == 12){
      isButtonPressed = true;
      codeValidation();
    } else if (cellNumber.length < 10){
      isButtonPressed = false;
      return false;
    }
  }

  Future codeValidation() async {

    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse('${Globals.BASE_API_URL}/users/$cellNumber/requestcode'),
      headers: Globals.HEADERS,
    );

    var c = jsonDecode(response.body);

    print(c['code']);

    prefs.setInt('userId', c['userId']);


    return Navigator.of(context).pushNamed('/cellphoneValidation', arguments: cellNumber);

  }

  Widget _buildDropdownItem(Country country) => Container(
    width: 110.0,
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Flexible(
          child: Text("+${country.phoneCode}(${country.isoCode})"),
        )
      ],
    ),
  );

}