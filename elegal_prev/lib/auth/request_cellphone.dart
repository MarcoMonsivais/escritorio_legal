import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toktok_app/helpers/user.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:toktok_app/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';


class RequestCellphone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RequestCellphoneState();
  }

}

class RequestCellphoneState extends State<RequestCellphone>{
  var cellNumber;
  var countryCode = '52';
  bool isButtonPressed = false;
  bool _isLoading = false;
  bool _hasEmail = true;
  bool _newUser = false;
  String userName;
  String userLastName;
  String userEmail;
  SocialUser socialUser = SocialUser();

  Future saveSocial(String cell, SocialUser profile) async{
    final prefs = await SharedPreferences.getInstance();

    String number = '$countryCode$cellNumber';

//    prefs.setString('user_number', number);
//
//    var oppMapData = new Map();
//    oppMapData['name'] = profile.name;
//    oppMapData['lastName'] = profile.lastName;
//    oppMapData['email'] = profile.email;
//    oppMapData['phone_number'] = number;
//    oppMapData['city'] = 'Monterrey';
//    oppMapData['line1'] = 'Fake Street 1';
//    oppMapData['state'] = 'Nuevo Leon';
//    oppMapData['country_code'] = 'MX';
//    oppMapData['postal_code'] = 'MX';
//
//    String jsonOpp = jsonEncode(oppMapData);
//
//    final oppResponse = await http.post(
//      '${Globals.BASE_API_URL}/openpay/addCustomer',
//      headers: Globals.HEADERS,
//      body: jsonOpp,
//    );
//
//    var oppToken = jsonDecode(oppResponse.body);
//    oppToken = oppToken['token'];

    var mapData = new Map();
    mapData['name'] = profile.name;
    mapData['lastName'] = profile.lastName;
    mapData['email'] = profile.email;
    mapData['image'] = profile.image;
    mapData['network'] = profile.network;
    mapData['token'] = profile.socialToken;
    mapData['cellphone'] = number;
    mapData['open_pay_token'] = null;

    String json = jsonEncode(mapData);

    final response = await http.post(
      Uri.parse('${Globals.BASE_API_URL}/users/social/requestCode'),
      headers: Globals.HEADERS,
      body: json,
    );

    if(response.statusCode != 200){
      var errorArray = response.body.split('DETAIL:  ');
      if(errorArray[1].startsWith('Key (email)')){
        setState(() {
          isButtonPressed = false;
          _isLoading = false;
        });

        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return TokTokAlertDialog(
                'Validation Error',
                'Email exists, cellphone number don\'t match',
                1
            );
          },
        );
      }
      setState(() {
        isButtonPressed = false;
        _isLoading = false;
      });
      return null;
    }

    Map getResponse = jsonDecode(response.body);

    print(getResponse['code']);

    prefs.setInt('userId', getResponse['userId']);

    setState(() {
      isButtonPressed = false;
      _isLoading = false;
    });

    return Navigator.of(context).pushNamed('/cellphoneValidation', arguments: number);
  }

  Future createUser(String cell, SocialUser profile) async{
    final prefs = await SharedPreferences.getInstance();
    String number = '$countryCode$cellNumber';

    var mapData = new Map();
    mapData['name'] = profile.name;
    mapData['lastName'] = profile.lastName;
    mapData['email'] = profile.email;
    mapData['open_pay_token'] = null;
    mapData['cellphone'] = number;

    String json = jsonEncode(mapData);

    try {
      final response = await http.post(
          Uri.parse('${Globals.BASE_API_URL}/users/requestcode/newUser'),
        headers: Globals.HEADERS,
        body: json
      ).then((onValue) async {
        var c = jsonDecode(onValue.body);


        if (c['code'] != null) {
          print(c['code']);

          prefs.setInt('userId', c['userId']);

          Navigator.of(context).pushNamed(
              '/cellphoneValidation', arguments: number);
        }
      });
    } catch (e){
      print(e);
//      return showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return TokTokAlertDialog(
//              'Error',
//              'Error while processing the information. Please try again',
//              1
//          );
//        },
//      );
    }

  }

  Country _selectedDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('52');

  Country _selectedFilteredDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('52');

  Country _selectedCupertinoCountry =
  CountryPickerUtils.getCountryByIsoCode('mx');

  Country _selectedFilteredCupertinoCountry =
  CountryPickerUtils.getCountryByIsoCode('MX');

  @override
  void dispose() {
    // TODO: implement dispose
    socialUser.name = null;
    socialUser.lastName = null;
    socialUser.email = null;
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    socialUser = ModalRoute.of(context).settings.arguments;
    userName = socialUser.name;
    userLastName = socialUser.lastName;
    userEmail = socialUser.email;


    String userNumber = socialUser.cellphone;
    if(userEmail == null) {
      _hasEmail = false;
      _newUser = true;
    }
    if(userNumber != null)
      cellNumber = userNumber;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Stack(
        children:<Widget>[
          _isLoading ? Container(
            color: Colors.black12,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : Container(
            height: SizeConfig.blockSizeVertical * 7,
            width: SizeConfig.blockSizeHorizontal * 100,
            margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1,
                left: SizeConfig.blockSizeHorizontal * 5
            ),
            child: Text(
              'Confirm your information',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26.0,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          Container(
            height: SizeConfig.blockSizeVertical * 74,
            margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 10,
                left: SizeConfig.blockSizeHorizontal * 5
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: TextField(
                                controller: TextEditingController(text: socialUser.name),
                                decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                                    ),
                                    labelText: 'First',
                                    labelStyle: TextStyle(
                                        fontSize: 16.0
                                    )
                                ),
                                style: TextStyle(
                                    fontSize: 20.0
                                ),
                                onChanged: (String value){
//                                  setState(() {
                                    socialUser.name = value;
//                                  });
                                },
                              )
                          ),
                          Flexible(
                            child: TextField(
                              controller: TextEditingController(text: socialUser.lastName),
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  labelText: 'Last',
                                  labelStyle: TextStyle(
                                    fontSize: 16.0,
                                  )
                              ),
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                              onChanged: (String value){
//                                setState(() {
                                  socialUser.lastName = value;
//                                });
                              },
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 2,
                      ),
                      child:TextField(
                        readOnly: _hasEmail,
                        controller: TextEditingController(text: socialUser.email),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.0),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                fontSize: 16.0
                            )
                        ),
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                        onChanged: (String value){
//                          setState(() {
                            socialUser.email = value;
//                            _hasEmail = false;
//                          });
                        },
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 2
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                          child: CountryPickerDropdown(
                            initialValue: 'mx',
                            itemBuilder: _buildDropdownItem,
                            onValuePicked: (Country country) {
                              countryCode = country.phoneCode;
                            },
                          ),
                        ),
                        Flexible(
                          child: TextField(
                            style: TextStyle(color: Colors.black, fontSize: 20.0),
                            maxLength: 10,
                            textInputAction: TextInputAction.none,
                            controller: TextEditingController(text: userNumber),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                counterText: '',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                                ),
                                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                                labelText: AppLocalizations.of(context).cellphoneNumber
                            ),
                            onChanged: (String value) {
//                              setState(() {
                                cellNumber = value;
//                              });
                            },

                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 62,
                          child: RichText(
                              text: TextSpan(
                                  text: 'By continuing, I confirm that I have read and agree to the ',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black
                                  ),
                                  children: <TextSpan> [
                                    TextSpan(
                                        text: 'Terms & Conditions ',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.blueAccent
                                        ),
                                      recognizer: TapGestureRecognizer()..onTap = (){
                                          launch('https://www.toktokapp.com/termsandconds.html');
                                      }
                                    ),
                                    TextSpan(
                                        text: 'and ',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black
                                        )
                                    ),
                                    TextSpan(
                                        text: 'Privacy Policy.',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.blueAccent
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = (){
                                          launch('https://www.toktokapp.com/privacypolicy.html');
                                        }
                                    )
                                  ]
                              )
                          ),
                        ),
                        InkWell(
                          onTap: isButtonPressed ? null : () async {
                            setState(() {
                              isButtonPressed = true;

                            });
                            var helper = await _verifyNumber(socialUser);
                            if(helper == false){
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
                ],
              ),
            ),
          ),
        ],
      )
    );
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

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 8.0),
      Text("+${country.phoneCode}"),
      SizedBox(width: 8.0),
      Flexible(child: Text(country.name))
    ],
  );

  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem)),
  );

  void _openCupertinoCountryPicker() => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CountryPickerCupertino(
          pickerSheetHeight: 300.0,
          onValuePicked: (Country country) =>
              setState(() => _selectedCupertinoCountry = country),
        );
      }
  );

  Future _verifyNumber(profile) async{
    print(_newUser);
    setState(() {
      _isLoading = true;
    });
    print(cellNumber);
    if(cellNumber == null){
      setState(() {
        isButtonPressed = false;
        _isLoading = false;
      });
      return false;
    }
    if(cellNumber.length == 10){
      setState(() {
        isButtonPressed = true;
      });
      if(!_newUser)
        saveSocial(cellNumber, profile);
      else
        createUser(cellNumber, profile);

    } else if (cellNumber.length < 10){
      setState(() {
        isButtonPressed = false;
        _isLoading = false;
      });
      return false;
    }
  }

}
