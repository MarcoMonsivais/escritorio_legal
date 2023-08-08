import 'package:flutter/material.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/globals.dart';

class SideDrawer extends StatefulWidget{
  @override

    SideDrawerState createState() => SideDrawerState();
}

class SideDrawerState extends State<SideDrawer>{

  openLanguages(){
    Navigator.of(context).pushNamed("/selectLanguage");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('TokTok'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ExpansionTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).settings),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                          left: 25.0,
                        )
                    ),
                    Icon(Icons.language),
                    SizedBox(width: 20.0),
                    InkWell(
                      child: Text(AppLocalizations.of(context).language),
                      onTap: openLanguages,
                    )
                  ],
                )
              ]
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).logout),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();

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

    return Navigator.of(context).pushNamedAndRemoveUntil('/googleLogin', (Route<dynamic> route) => false);
  }

}


