import 'package:flutter/material.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/main.dart';

class SelectLanguage extends StatefulWidget{
  @override

    SelectLanguageState createState() => SelectLanguageState();
  }

class SelectLanguageState extends State<SelectLanguage> {
  String _selected;

  void onChanged(String value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', value);

    setState(() {
      _selected = value;

    });
    MyApp.setLocale(context, Locale(value));

  }

  List<Widget> makeRadios() {
    List<Widget> list = List<Widget>();

    list.add(RadioListTile(
        title: Text('Español'),
        value:'es',
        groupValue: _selected,
        onChanged: (String value){onChanged(value);}
        )
    );

    list.add(RadioListTile(
        title:Text('English'),
        value:'en',
        groupValue: _selected,
        onChanged: (String value){onChanged(value);}
        )
    );

    return list;
  }

  @override
  void initState() {
    super.initState();
    this._loadLanguage().then((language) {
      setState(() {
        this._selected = language;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).selectLanguage),
        ),
      body: Center(
        child: Column(
          children: makeRadios(),
        ),
      )
    );
  }

  _loadLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }
}
