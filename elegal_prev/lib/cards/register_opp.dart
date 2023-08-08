import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/registration_form.dart';

class RegisterOpp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterOpp();
  }

}

class _RegisterOpp extends State<RegisterOpp>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
        body:Container(
            child: SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Text(
                              'Información de facturación',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RegistrationForm()
                  ],
                ),
              ),
            )
        )
    );
  }

}