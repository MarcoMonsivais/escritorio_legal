import 'dart:convert';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:toktok_app/globals.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';
import 'package:toktok_app/helpers/user.dart';
import 'select_social.dart';


class GoogleLogin extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPage();
  }
}

class _AuthPage extends State<GoogleLogin> {
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

    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.blockSizeVertical * 100,
        width: SizeConfig.blockSizeHorizontal * 100,
        decoration: BoxDecoration(
          color: const Color(0xff000000),
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
                          )
                      ),
                      GestureDetector(
                          onTap: ((){
                            Navigator.of(context).pushNamed('/selectLanguage');
                          }),
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 8,
                                  left: SizeConfig.blockSizeHorizontal * 90
                              ),
                              child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.language,
                                      color: Colors.white,
                                    )
                                  ]
                              )
                          )
                      )
                    ]
                )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 10,
                          ),
                          child:  SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Container(
                                  child: Image(
                                    width: SizeConfig.blockSizeHorizontal * 80,
                                    height: SizeConfig.blockSizeVertical * 30,
                                    image: AssetImage('assets/img/logoblanco.png'),
                                  )
                              )
                          )
                      ),
                      Center(
                        child: Text(
                          "Inicia Sesión con google",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0
                          )
                        )
                      ),
                      SelectSocial()
                    ]
                  )
                )
              ]
            )
          ]
        )
      )
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

