import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:country_pickers/country.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';
import 'package:toktok_app/helpers/user.dart';

class AuthPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> {
  String cellNumber;
  var countryCode = '52';
  bool isButtonPressed = false;
  String number;
  String _language = '';
  SocialUser socialUser = SocialUser();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLanguage();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController numberController = TextEditingController();

    SizeConfig().init(context);
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: SizeConfig.blockSizeVertical * 100,
        width: SizeConfig.blockSizeHorizontal * 100,
        decoration: BoxDecoration(
          color: const Color(0xff000000),
          //image: DecorationImage(
            //image: AssetImage("assets/img/pluma.jpg"),
            //fit: BoxFit.cover,
          //),
        ),
        child: Stack(
          children: <Widget>[
           Container(
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 5,
                              left: SizeConfig.blockSizeHorizontal * 5
                          ),
                          width: SizeConfig.blockSizeHorizontal * 160,
                          height: SizeConfig.blockSizeVertical * 100,
//                         child: Image(
//                           image: AssetImage('assets/img/Group63.png'),
//                         ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ((){
                          Navigator.of(context).pushNamed('/selectLanguage');
                        }),
                        child: Container(
//                          height: 35.0,
//                          color: Colors.red,
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8, left: SizeConfig.blockSizeHorizontal * 90),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.language,
                                color: Colors.white,
                              ),
//                              SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
//                              Text(
//                                _language,
//                                style: TextStyle(
//                                    color: Colors.white
//                                ),
//                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
           ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                      //color: Color(0xFF000000)
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 10,
                            left: SizeConfig.blockSizeHorizontal * 0
                        ),
                        child:  SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.safeBlockHorizontal * 8,
                                  top: SizeConfig.safeBlockVertical * 0
                              ),
                              child: Image(
                                width: SizeConfig.blockSizeHorizontal * 80,
                                height: SizeConfig.blockSizeVertical * 30,
                                image: AssetImage('assets/img/logoblanco.png'),
                              ),
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 0,
                            left: SizeConfig.blockSizeHorizontal * 5
                        ),
                        child: Text(AppLocalizations.of(context).getParked,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 21.0,
                            color: Colors.white
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5,
                            top: SizeConfig.blockSizeVertical * 2,
                            bottom: SizeConfig.safeBlockVertical * 2
                        ),
                        child: Row(
                            children: <Widget>[
                              CountryPickerDropdown(
                                initialValue: 'mx',
                                itemBuilder: _buildDropdownItem,
                                  onValuePicked: (Country country) {
                                    countryCode = country.phoneCode;
                                  }
                              ),
                              Container(
                                  width: SizeConfig.blockSizeHorizontal * 63.5,
                                  child: TextField(
                                    onChanged: (String value) {
                                      setState(() {
                                        cellNumber = value;
                                        numberController.text = value;
                                      });
                                    },
                                    style: TextStyle(color: Colors.black),
                                    textInputAction: TextInputAction.none,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: AppLocalizations.of(context).enterMobile,
                                        hintStyle: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(0.0),
                                          ),
                                        )
                                    ),
                                  )
                              )
                            ]
                        ),
                      ),
                      Container(
                          width: SizeConfig.safeBlockHorizontal * 90,
                          margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                          child: RaisedButton(
                            color: Color(0xff054575),
                            disabledColor: Color(0xff054575),
                            textColor: Colors.white,
                            onPressed: isButtonPressed ? null : () async {
                              setState(() {
                                isButtonPressed = true;

                              });
                              var helper = await _verifyNumber();
                              if(helper == false){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TokTokAlertDialog(
                                        'Number Error',
                                        'Please verify the number you entered',
                                        1
                                    );
                                  },
                                );
                              }
                              },
                            child: Text(
                              'LETS GO',
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            AppLocalizations.of(context).orConnectSocial,
                            style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w700),
                          ),
                        ),
                        onTap: (){
                          Navigator.of(context).pushNamed("/selectSocial");
                          },
                      ),
                      Container(
                        child: TextField(readOnly: true,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _verifyNumber() async{
    if(cellNumber == null){
      setState(() {
        isButtonPressed = false;
      });
      return false;
    }
    if(cellNumber.length == 10){
      setState(() {
        isButtonPressed = true;
      });
      number = '$countryCode$cellNumber';
      codeValidation();
    } else if (cellNumber.length < 10 || cellNumber.length > 10){
      setState(() {
        isButtonPressed = false;
      });
      return false;
    }
  }

  Future codeValidation() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isButtonPressed = false;
    });

    try{
      final verifyNumber = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/users/verifyUserExistsByCellphone/$number'),
        headers: Globals.HEADERS,
      );

      var vn = jsonDecode(verifyNumber.body);

      if(vn['error'] == null){
        final response = await http.get(
          Uri.parse('${Globals.BASE_API_URL}/users/$number/requestcode'),
          headers: Globals.HEADERS,
        );

        var c = jsonDecode(response.body);
        print(c['code']);
        setState(() {
          isButtonPressed = false;
        });

        prefs.setInt('userId', c['userId']);

        return Navigator.of(context).pushNamed('/cellphoneValidation', arguments: number);
      } else {
        socialUser.cellphone = cellNumber;
        return Navigator.of(context).pushNamed('/requestCellphone', arguments: socialUser);
      }

    } catch (e){
      print(e);
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return TokTokAlertDialog(
              'Number Error',
              'Please verify the number you entered',
              1
          );
        },
      );
    }

  }

  Widget _buildDropdownItem(Country country) => Container(
    width: SizeConfig.blockSizeHorizontal * 22,
    color: Colors.white,
    padding: const EdgeInsets.only(
        left: 5,
        top: 14,
        bottom: 14,
        right: 0
    ),
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Flexible(
          child: Text("+${country.phoneCode}"),
        )
      ],
    ),
  );

  Future _setLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    _language = prefs.getString('language_code');
    if(_language == null) {
     setState(() {
       return _language = 'EN';
     });
    } else {
      setState(() {
        return _language;
      });
    }

  }

}

