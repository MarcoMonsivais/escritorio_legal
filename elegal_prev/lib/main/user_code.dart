import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/globals.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';



class UserCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserCode();
  }
}

class _UserCode extends State<UserCode> {
  String userCode = '';
  final userCodeKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userCodeKey,
      appBar: AppBar(
        title: Text('Referral Code'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 5,
              left: SizeConfig.blockSizeHorizontal * 3
            ),
            child: Text(
              'Your invite code',
              style: TextStyle(
                color: Colors.grey,
                fontSize: SizeConfig.blockSizeVertical * 1.5
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Clipboard.setData(new ClipboardData(text: this.userCode));
              userCodeKey.currentState.showSnackBar(
                  SnackBar(content: Text("Copied to Clipboard"),));
            },
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 90,
              height: SizeConfig.blockSizeVertical * 5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0
                )
              ),
              margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 1,
                  left: SizeConfig.blockSizeHorizontal * 3
              ),
              child: Row(
                children: <Widget>[
                  Container(
                      width: SizeConfig.blockSizeHorizontal * 70,
                      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                      child: Text(
                        this.userCode,
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2
                        )
                      )
                  ),
                  Container(
                    child: Text(
                      'Copy',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: SizeConfig.blockSizeVertical * 2
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1,
                left: SizeConfig.blockSizeHorizontal * 3
            ),
            width: SizeConfig.blockSizeHorizontal * 90,
            child: RaisedButton(
              color: Colors.orange,
              onPressed: ((){
                _shareCode();
              }),
              child: Text(
                  'Share',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical * 3,
                  color: Colors.white
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _shareCode() async {
    print('asdhaskj');
    final RenderBox box = context.findRenderObject();
    Share.share(
        'Here is my TokTok code: ${this.userCode}, use it to get a parking discount. Enjoy!',
        subject: 'subject',
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) &
        box.size
    );

  }

  _getUserInfo () async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/users/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        }
    );

    var c = (jsonDecode(response.body));

    setState(() {
      this.userCode = c['data']['coupon_code'];
    });
  }

}