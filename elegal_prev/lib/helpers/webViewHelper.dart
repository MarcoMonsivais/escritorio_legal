import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toktok_app/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({Key key, this.title, this.selectedUrl}) : super(key: key);

  final String title;
  final String selectedUrl;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyWebView();
  }

}

class _MyWebView extends State<MyWebView>{
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;

  var splitUrl;
  var splitCode;
  String code;

  @override
  void initState() {
    super.initState();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if(url.startsWith('https://www.toktokapp.com/?code')){
          splitUrl = url.split('=').map((String text) => text).toList();
          splitCode = splitUrl[1].split('&').map((String text) => text).toList();
          code = splitCode[0].toString();
          _initiateExchange(code);
        } else if(url.startsWith('https://www.toktokapp.com/?error')){
          Navigator.of(context).popAndPushNamed('/addPaymentMethod');

        }
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://www.sandbox.paypal.com/connect?flowEntry=static&client_id=ARGLmf8jH1zL4I5v5lERZbesX4xp10IX-y1SI55QvRiG3IA4CFgW7N0INMMXAaixFimBroxP8FXmjr7t&scope=openid profile email&redirect_uri=https://www.toktokapp.com/',
      appBar: AppBar(
        title: Text('PayPal Flutter'),
      ),
      withZoom: true,
      withLocalStorage: true,

    );
  }

  _initiateExchange(code) async {
    final prefs = await SharedPreferences.getInstance();
    final _headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ${Globals.PAYPAL_AUTH}'
    };
    String accessToken;
    String refreshToken;

    var firstStepMap = new Map();
    firstStepMap['grant_type'] = 'authorization_code';
    firstStepMap['code'] = code;


    final firstStep = await http.post(
        Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token'),
      headers: _headers,
      body: firstStepMap
    );

    var firstStepResponse = jsonDecode(firstStep.body);

    accessToken = firstStepResponse['access_token'];
    refreshToken = firstStepResponse['refresh_token'];

    var ppToken = new Map();
    ppToken['paypal_token'] = refreshToken;
    String paypToken = jsonEncode(ppToken);

    await http.put(
        Uri.parse('${Globals.BASE_API_URL}/users/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        },
        body:paypToken
    ).then((onValue){
      prefs.setString('paypalToken', refreshToken);
      Navigator.of(context).popAndPushNamed('/addPaymentMethod');
    });

  }


}
