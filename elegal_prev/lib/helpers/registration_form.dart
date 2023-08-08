import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user.dart';
import 'package:toktok_app/app_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'size_config.dart';

class RegistrationForm extends StatefulWidget {
  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}

List<DropdownMenuItem<int>> listDrop = [];
int selected = 1;
void loadData() {
  listDrop = [];
  listDrop.add(new DropdownMenuItem(child: Text('Male'), value: 1));
  listDrop.add(new DropdownMenuItem(child: Text('Female'), value: 2));
}


class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  final line1 = TextEditingController();
  final line2 = TextEditingController();
  final state = TextEditingController();
  final postalCode = TextEditingController();
  var mapData = new Map();

  bool _isLoading = false;
  User newUser = new User();

  void _submitForm() async {
    final FormState form = _formKey.currentState;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

    if(!form.validate()){
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(backgroundColor: Colors.red,content: Text('Form is not valid! Please review and correct!'))));
      setState(() {
        _isLoading = false;
      });
      return null;

    } else {
      form.save();
      mapData['country_code'] = 'MX';
      String json = jsonEncode(mapData);

      final response = await http.post(
          Uri.parse('${Globals.BASE_API_URL}/openpay/addCustomer'),
          headers: Globals.HEADERS,
          body: json
    );

      print('cha cha');
      print(prefs.getString('access_token'));
      print(response.body);
      var c = jsonDecode(response.body);

      print(c);
      print("holiwis");
      print(c['token']);
      if(c['token'] != null){
        var oppToken = new Map();
        oppToken['open_pay_token'] = c['token'];
        String opToken = jsonEncode(oppToken);
        prefs.setString('opp_token', c['token']);
        await http.put(
            Uri.parse('${Globals.BASE_API_URL}/users/${prefs.getInt('userId')}'),
            headers: {
              'Authorization' : 'Bearer ${prefs.getString('access_token')}',
              'Content-Type' : 'application/json'
            },
            body:opToken
        ).then((onValue){
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).popAndPushNamed('/addCard');
        });

      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
    lastName.dispose();
    email.dispose();
    state.dispose();
    line1.dispose();
    line2.dispose();
    city.dispose();
    postalCode.dispose();
    super.dispose();

  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  @override

  Widget build(BuildContext context) {
    loadData();
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
//        child: Container(
//          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              _isLoading ? Container(
                color: Colors.black12,
                height: SizeConfig.blockSizeVertical * 90,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ) : SizedBox(),
              Container(
                padding: EdgeInsets.only(
                  top: 90.0,
                  left: 20.0,
                  right: 20.0
                ),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: name,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: AppLocalizations.of(context).name,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      validator: (value){
                        if(value.isEmpty) {
                          return AppLocalizations.of(context).validText;
                        }
                        return null;
                        },
                      onSaved: (val) => mapData['name'] = val,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                        controller: lastName,
                        textCapitalization: TextCapitalization.sentences,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: AppLocalizations.of(context).lastName,
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.all(Radius.circular(10)))
                        ),
                        validator: (value){
                          if(value.isEmpty) {
                            return AppLocalizations.of(context).validText;
                          }
                          return null;
                        },
                      onSaved: (val) => mapData['lastName'] = val,

                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: AppLocalizations.of(context).email,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return AppLocalizations.of(context).validEmailText;
                        }
                        if(!isValidEmail(value)){
                          return AppLocalizations.of(context).validEmail;
                        }
                        return null;
                        },
                      onSaved: (val) => mapData['email'] = val,

                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: city,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'City',
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return AppLocalizations.of(context).validText;
                        }
                        return null;
                      },
                      onSaved: (val) => mapData['city'] = val,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: state,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'State',
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return AppLocalizations.of(context).validText;
                        }
                        return null;
                      },
                      onSaved: (val) => mapData['state'] = val,

                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: line1,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Address Line 1',
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return AppLocalizations.of(context).validText;
                        }
                        return null;
                      },
                      onSaved: (val) => mapData['line1'] = val,

                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: line2,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Address Line 2',
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      validator: (value){
                        return null;
                      },
                      onSaved: (val) => mapData['line2'] = val,
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: postalCode,
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Postal Code',
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return AppLocalizations.of(context).validText;
                        }
                        return null;
                      },
                      onSaved: (val) => mapData['postal_code'] = val,
                    ),
                    SizedBox(height: 15.0),
                    _isLoading ? CircularProgressIndicator() : SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        splashColor: Colors.black,
                        onPressed: () {
                            _submitForm();
                        },
                        child: Text(AppLocalizations.of(context).submit),
                      ),
                    ),
                    SizedBox(height: 20.0)
                  ],
                ),
              )
            ],
//          ),
        ),
      ),
    );
  }
}