import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showMyDialog(string, context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('E-Legal'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(string),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

logout(context) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('logged', 'yes');

  await FirebaseAuth.instance.signOut().whenComplete(() =>
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/', (Route<dynamic> route) => false));
}
