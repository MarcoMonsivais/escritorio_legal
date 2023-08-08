import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:toktok_app/helpers/code_validation_service.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';
import 'dart:convert';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';

class CellphoneValidation extends StatefulWidget {
  @override
  CellphoneValidationState createState() => CellphoneValidationState();

}


Code newCode = new Code();

class CellphoneValidationState extends State<CellphoneValidation> {
  bool _isLoading = false;
  FocusNode _zeroInputFocusNode;
  FocusNode _firstInputFocusNode;
  FocusNode _secondInputFocusNode;
  FocusNode _thirdInputFocusNode;
  final TextEditingController _zeroInput = new TextEditingController();
  final TextEditingController _firstInput = new TextEditingController();
  final TextEditingController _secondInput = new TextEditingController();
  final TextEditingController _thirdInput = new TextEditingController();
  String field1;
  String field2;
  String field3;
  String field4;
  Timer _timer;
  int _start = 15;
  bool canRequest;
  bool oneTimeMessage = false;
  int addMargin = 0;
  String number;

  Future validateCode() async {
    newCode.code = '$field1$field2$field3$field4';
    if(newCode.code.length == 4) {
      setState(() {
        _isLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      newCode.cellphone = this.number;
      newCode.code = '$field1$field2$field3$field4';

      var codeValidationService = new CodeService();
      codeValidationService.createCodeValidation(newCode)
          .then((value) {
        if (value.error == '') {
          _isLoading = false;
          prefs.setString('access_token', value.tokenAccessToken);
          prefs.setString('refresh_token', value.tokenRefreshToken);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/welcome', (Route<dynamic> route) => false);
        } else {
          print(value);
          print('/////////');
          print(value.error);
          setState(() {
            _isLoading = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return TokTokAlertDialog(
                    'Incorrect Code',
                    'The code you entred is incorrect. Please verify',
                    1
                );
              }).then((value){
                field1 = '';
                field2 = '';
                field3 = '';
                field4 = '';
                _zeroInput.clear();
                _firstInput.clear();
                _secondInput.clear();
                _thirdInput.clear();
                FocusScope.of(context).requestFocus(_zeroInputFocusNode);

          });
        }
      });
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            canRequest = true;
            oneTimeMessage = true;
            addMargin = 3;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
    if (_start == 0) {
      canRequest = true;
    }
  }

  @override
  void initState() {
    super.initState();
    this._start = 15;
    this.canRequest = false;
    _zeroInputFocusNode = FocusNode();
    _firstInputFocusNode = FocusNode();
    _secondInputFocusNode = FocusNode();
    _thirdInputFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => startTimer());

  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _zeroInputFocusNode.dispose();
    _firstInputFocusNode.dispose();
    _secondInputFocusNode.dispose();
    _thirdInputFocusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.number = ModalRoute.of(context).settings.arguments;

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
            ) : SizedBox(),
            oneTimeMessage ? Container(
              margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 2,
                left: SizeConfig.blockSizeHorizontal * 5,
              ),
              child:
              RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context).fourDigitCode,
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                  children: <TextSpan> [
                    TextSpan(
                      text: '+${this.number}.',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                        color: Colors.black
                      )
                    ),
                    TextSpan(
                        text: ' ${AppLocalizations.of(context).correctMobile}',
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.orangeAccent
                        )
                    )
                  ]
                )
              )
            ) : Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 2,
                    left: SizeConfig.blockSizeHorizontal * 5
                ),

                child: RichText(
                    text: TextSpan(
                        text: '${AppLocalizations.of(context).fourDigitCode} ',
                        style: TextStyle(fontSize: 22.0, color: Colors.black),
                        children: <TextSpan> [
                          TextSpan(
                              text: '+$number.',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black
                              )
                          ),
                        ]
                    )
                )
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * (15 + addMargin),
                left: SizeConfig.blockSizeHorizontal * 5
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 10,
                    child: TextField(
                      controller: _zeroInput,
                      focusNode: _zeroInputFocusNode,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black, fontSize: 24.0),
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: UnderlineInputBorder(

                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: ((val) {
                        field1 = val;
                        if (int.parse(val) != double.nan){
                          FocusScope.of(context).requestFocus(_firstInputFocusNode);
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 10,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _firstInput,
                      focusNode: _firstInputFocusNode,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black, fontSize: 24.0),
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: ((val) {
                        field2 = val;
                        if (int.parse(val) != double.nan){
                          FocusScope.of(context).requestFocus(_secondInputFocusNode);
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 10,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _secondInput,
                      focusNode: _secondInputFocusNode,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black, fontSize: 24.0),
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey),
                        counterText: '',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: ((val) {
                        field3 = val;
                        if (int.parse(val) != double.nan){
                          FocusScope.of(context).requestFocus(_thirdInputFocusNode);
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 10,
                    child: TextField(
                        textAlign: TextAlign.center,
                        controller: _thirdInput,
                        focusNode: _thirdInputFocusNode,
                        style: TextStyle(color: Colors.black, fontSize: 24.0),
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.grey),
                          counterText: '',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      onEditingComplete: _isLoading ? null : validateCode,
                      onChanged: ((value){
                        if(value != '') {
                          field4 = value;
                          validateCode();
                        }
                      }),
                    ),
                  )
                ],
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
                          child: canRequest ? InkWell(
                            onTap: resendCode,
                            child: Text(
                              AppLocalizations.of(context).requestAnotherCode,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16.0
                              ),
                            ),
                          ) :
                          Text(
                            "${AppLocalizations.of(context).resendAnother}$_start",
                            style: TextStyle(
                                fontSize: 16.0
                            )
                          ),
                        ),
                        InkWell(
                          onTap: _isLoading ? null : validateCode,
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 20,
                              height: SizeConfig.blockSizeVertical * 7,
                              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                              decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0,10.0), blurRadius: 20.0, spreadRadius: 0.1)]),
                              child: Icon(Icons.arrow_forward, size: 30.0, color: Colors.white),
                            )
                        )
                      ],
                    )
                ),
//                SizedBox(height: SizeConfig.blockSizeVertical * 5)
              ],
            ),
          ]
      ),
    );
  }

  resendCode() async{
    canRequest = false;
    _start = 15;
    startTimer();

    final response = await http.get(
      Uri.parse('${Globals.BASE_API_URL}/users/${this.number}/requestcode'),
      headers: Globals.HEADERS,
    );

    var c = jsonDecode(response.body);

    print(c['code']);

  }
}