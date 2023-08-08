import 'package:flutter/material.dart';
import 'package:flutter_chat/chatDB.dart';
import 'package:toktok_app/globals.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:toktok_app/helpers/user.dart' as ela;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';
import 'package:openpay_flutter/openpay_flutter.dart';

class SelectSocial extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectSocial();
  }

}

class _SelectSocial extends State<SelectSocial>{
  var fbLogin = FacebookLogin();
  ela.SocialUser socialUser = ela.SocialUser();
  bool isLoggedIn = false;
  var profileData;
  bool _isLoading = false;
  var cellNumber;
  var countryCode = '52';
  String platformVersion;
  List cards;
  String selectedCard;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future signInWithGoogle() async{
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount == null)
      return false;

    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;
    ChatDBFireStore.checkUserExists(user);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    //final FirebaseUser currentUser = await _auth.currentUser();
    //assert(user.uid == currentUser.uid);

    var tokenCheck = await http.get(Uri.parse('${Globals.BASE_API_URL}/users/tokencheck/${user.uid}/google'),
        headers: Globals.HEADERS);

print('${Globals.BASE_API_URL}/users/tokencheck/${user.uid}/google');
print(tokenCheck.toString());
print('/////////////////');
print(tokenCheck.body.toString());
print('--------------------');
print(tokenCheck.statusCode);
    var answer = jsonDecode(tokenCheck.body);
    print(user);
    if(answer['error'] == 'Does not exists any user with the specified identificator'){
      socialUser.email = user.email;
      socialUser.socialToken = user.uid;
      socialUser.image = user.photoURL;
      socialUser.network = 'google';

      var parts = user.displayName.split(" ");
      print(parts[0] + ' ' + parts[1]);
      if(parts.length == 2){
        socialUser.name = parts[0];
        socialUser.lastName = parts[1];

      } else if(parts.length == 3) {
        socialUser.name = parts[0] + ' ' + parts[1];
        socialUser.lastName = parts[2];
      } else if(parts.length == 4){
        socialUser.name = parts[0] + ' ' + parts[1];
        socialUser.lastName = parts[2] + ' ' + parts[3];
      }

      return socialUser;
    } else {
      var mapData = new Map();
      mapData['client_id'] = Globals.CLIENT;
      mapData['client_secret'] = Globals.SECRET;
      mapData['grant_type'] = 'social';
      mapData['email'] = user.email;
      mapData['network'] = 'google';
      mapData['token'] = user.uid;
      mapData['scope'] = 'super-admin';
      String json = jsonEncode(mapData);

      final response = await http.post(
          Uri.parse('${Globals.BASE_API_URL}/oauth/token'),
          headers: Globals.HEADERS,
          body: json
      );
      var c = jsonDecode(response.body);

      prefs.setString('access_token', c['access_token']);
      prefs.setString('refresh_token', c['refresh_token']);
      prefs.setInt('userId', answer['userId']);
      this._getCards();
      return Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

    }


  }

  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  void onLoginStatusChanged(bool isLoggedIn, String social, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });

    if(this.profileData != null){
      socialUser.email = this.profileData['email'];
      socialUser.name = this.profileData['first_name'];
      socialUser.lastName = this.profileData['last_name'];
      socialUser.image = this.profileData['picture']['data']['url'];
      socialUser.network = social;
      socialUser.socialToken = this.profileData['id'];
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed('/requestCellphone', arguments: socialUser);

    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return //Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   iconTheme: IconThemeData(color: Colors.black),
      //   elevation: 0.0,
      // ),
      //body:
    Stack(
        children: <Widget>[
          _isLoading ? Container(
            color: Colors.black12,
            margin: EdgeInsets.symmetric(vertical: 45.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : SizedBox(),
          // Container(
          //   height: SizeConfig.blockSizeVertical * 5,
          //   width: SizeConfig.blockSizeHorizontal * 100,
          //   margin: EdgeInsets.only(
          //       top: SizeConfig.blockSizeVertical * 1,
          //       left: SizeConfig.blockSizeHorizontal * 5
          //   ),
          //   child: Text(
          //     AppLocalizations.of(context).chooseAccount,
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 26.0,
          //         fontWeight: FontWeight.w400
          //     ),
          //   ),
          // ),
          !_isLoading ? Container(
            margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 5,
                left: SizeConfig.blockSizeHorizontal * 5
            ),
            child: GestureDetector(
                child:  Image(
                  image: AssetImage('assets/img/google.png'),
                  width: 85.0,
                ),
                onTap: () {
                  signInWithGoogle().then((user) {
                    setState(() {
                      _isLoading = false;
                    });
                    if(user == false){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TokTokAlertDialog(
                                'Cancelled by User',
                                'Please grant permission requested to Google in order to login',
                                1
                            );
                          }
                          );
                    } else {
                      Navigator.of(context).pushNamed('/requestCellphone', arguments: user);
                    }
                  });
                }
            ),

//             child: Column(
// //              mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 // Row(
//                 //   children: <Widget>[
//                 //     Image(
//                 //       image: AssetImage('assets/img/facebook.png'), width: SizeConfig.blockSizeHorizontal * 6, height: SizeConfig.blockSizeVertical * 6,
//                 //     ),
//                 //     SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
//                 //     InkWell(
//                 //       child: Text('Facebook', style: TextStyle(fontSize: 16.0)),
//                 //       onTap: () => initiateFacebookLogin(),
//                 //     )
//                 //   ],
//                 // ),
//                 Row(
//                   children: <Widget>[
//                     Image(
//                       image: AssetImage('assets/img/google.png'), width: SizeConfig.blockSizeHorizontal * 6, height: SizeConfig.blockSizeVertical * 6,
//                     ),
//                     SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
//                     InkWell(
//                       child: Text('Google', style: TextStyle(fontSize: 16.0)),
//                       onTap: () {
//                         signInWithGoogle().then((user) {
//                           setState(() {
//                             _isLoading = false;
//                           });
//                           if(user == false){
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return TokTokAlertDialog(
//                                     'Cancelled by User',
//                                     'Please grant permission requested to Google in order to login',
//                                     1
//                                 );
//                               }
//                             );
//                           } else {
//                             Navigator.of(context).pushNamed('/requestCellphone', arguments: user);
//                           }
//                         });
//                       }
//                     )
//                   ]
//                 ),
//                 // Container(
//                 //   margin: EdgeInsets.only(
//                 //       top: SizeConfig.blockSizeVertical * 5
//                 //   ),
//                 //   child: Text(AppLocalizations.of(context).socialDisclaimer),
//                 // )
//               ],
//             ),
          ) : SizedBox()
        ],
    //  ),
    );
  }

  void initiateFacebookLogin() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();

    var facebookLoginResult =
    await fbLogin.logIn(['email', 'public_profile']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TokTokAlertDialog(
                'Facebook Error',
                facebookLoginResult.errorMessage,
                1
            );
          },
        );
        onLoginStatusChanged(false, '');
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TokTokAlertDialog(
                'Cancelled by User',
                'Please grant permission requested to Facebook in order to login',
                1
            );
          },
        );
        onLoginStatusChanged(false, '');
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult
                .accessToken.token}'));

        var profile = jsonDecode(graphResponse.body);
        profile['token'] = facebookLoginResult.accessToken.token;

        var tokenCheck = await http.get(Uri.parse('${Globals.BASE_API_URL}/users/tokencheck/${profile['id']}/facebook'),
            headers: Globals.HEADERS);

        var answer = jsonDecode(tokenCheck.body);

        if(answer['error'] == 'Does not exists any user with the specified identificator'){
          onLoginStatusChanged(true,  'facebook', profileData: profile);
        } else {
          var mapData = new Map();
          mapData['client_id'] = Globals.CLIENT;
          mapData['client_secret'] = Globals.SECRET;
          mapData['grant_type'] = 'social';
          mapData['email'] = profile['email'];
          mapData['network'] = 'facebook';
          mapData['token'] = profile['id'];
          mapData['scope'] = 'super-admin';
          String json = jsonEncode(mapData);

          final response = await http.post(
              Uri.parse('${Globals.BASE_API_URL}/oauth/token'),
              headers: Globals.HEADERS,
              body: json
          );
          var c = jsonDecode(response.body);

          prefs.setString('access_token', c['access_token']);
          prefs.setString('refresh_token', c['refresh_token']);
          prefs.setInt('userId', answer['userId']);
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
        }

        break;
    }
  }

  Future _getCards() async {
    platformVersion = await OpenpayAPI(Globals.MERCHANT_ID,Globals.PUBLIC_OP).deviceSessionId(Globals.MERCHANT_ID,Globals.PUBLIC_OP);
    final prefs = await SharedPreferences.getInstance();
    print("getcards");
    print(Globals.MERCHANT_ID);
    print(Globals.PUBLIC_OP);
    this.selectedCard = prefs.getString('selectedPayment');

    OpenpayAPI _opp = new OpenpayAPI(Globals.MERCHANT_ID, Globals.PUBLIC_OP);

    var result = await _opp.cardService.getCustomerCards(prefs.getString('opp_token'));
    print(result);
    //Aqui Colocar el codigo para que si existe una tarjeta la seleccione por default, pero desde que inicia sesión.
    return result;

  }

}