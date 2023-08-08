import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'app_localizations.dart';
import 'auth/cellphone_validation.dart';
import 'auth/request_cellphone.dart';
import 'auth/auth_page.dart';
import 'auth/request_mobile.dart';
import 'auth/select_social.dart';
import 'auth/google_only_login.dart';
import 'cards/add_payment_method.dart';
import 'cards/list_coupons.dart';
import 'cards/add_card.dart';
import 'cards/list_cards.dart';
import 'cards/register_opp.dart';
import 'cards/add_coupon.dart';
import 'helpers/webViewHelper.dart';
import 'helpers/select_language.dart';
import 'helpers/permissions.dart';
import 'main/payment_receipt.dart';
import 'main/successful_payment.dart';
import "main/welcome.dart";
import 'main/update_user_profile.dart';
import 'main/transaction_history.dart';
import 'main/user_code.dart';
import 'main/chat.dart';
import 'main/terminos.dart';
import 'tutorial_pages/main_tutorial_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat/screens/peer_info.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async  {
WidgetsFlutterBinding.ensureInitialized();
await FlutterDownloader.initialize(
    debug: false // optional: set false to disable printing logs to console
);
await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  final Widget child;
  MyApp({this.child});
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState state =
      context.findAncestorStateOfType();

    state.setNewLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();
  Locale locale;
  bool localeLoaded = false;
  String tokenLoaded;
  bool tutorialSeen = false;
//  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  setNewLocale(Locale newLocale){
    setState((){
      locale = newLocale;
    });
  }

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
    this._defineTutorialSeen();
    this._fetchToken().then((token){
      setState(() {
        this.tokenLoaded = token;
      });
    });

    // _locationPermission();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000)
    ));
    Widget _defaultHome = GoogleLogin();

    if(this.tokenLoaded != null){
      _defaultHome = Welcome();
    }
    if(!tutorialSeen)
      _defaultHome = MainTutorialPage();

    if (this.localeLoaded == false){
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if(this.locale == null) {
            this.locale = deviceLocale;
          }
          return this.locale;
        },
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: locale,
        key: key,
//        navigatorKey: navigatorKey,
        home: _defaultHome,
        supportedLocales: [Locale('es'), Locale('en')],
        onGenerateTitle: (BuildContext context) =>
        AppLocalizations.of(context).title,
//        title: 'TokTok',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Color(0xFF000000)
        ),
        routes: {
          '/addCard': (BuildContext context) => AddCard(),
          '/addCoupon': (BuildContext context) => AddCoupon(),
          '/addPaymentMethod': (BuildContext context) => AddPaymentMethod(),
          '/auth': (BuildContext context) => AuthPage(),
          '/cellphoneValidation': (BuildContext context) => CellphoneValidation(),
          '/chat': (BuildContext context) => Chat(),
          '/editProfile': (BuildContext context) => UpdateUserProfile(),
          '/googleLogin': (BuildContext context) => GoogleLogin(),
          '/listCards': (BuildContext context) => ListCards(),
          '/listCoupons': (BuildContext context) => ListCoupons(),
          '/peerInfo': (BuildContext context) => PeerInfo(),
          '/receipt': (BuildContext context) => PaymentReceipt(),
          '/registerOpp': (BuildContext context) => RegisterOpp(),
          '/requestCellphone' : (BuildContext context) => RequestCellphone(),
          '/requestMobile': (BuildContext context) => RequestMobile(),
          '/selectLanguage': (BuildContext context) => SelectLanguage(),
          '/selectSocial': (BuildContext context) => SelectSocial(),
          '/successfulPayment': (BuildContext context) => SuccessfulPayment(),
          '/transactionHistory': (BuildContext context) => TransactionHistory(),
          '/userCode': (BuildContext context) => UserCode(),
          '/webViewHelper': (BuildContext context) => MyWebView(),
          '/welcome': (BuildContext context) => Welcome(),
          '/terminos': (BuildContext context) => Terminos(),

        },
        //home: MyHomePage(title: 'TokTok Home Page'),
      );
    }
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if(prefs.getString('language_code') == null) {
      return null;
    }

    return Locale(prefs.getString('language_code'));
  }

  _fetchToken() async {
    var prefs = await SharedPreferences.getInstance();

    if(prefs.getString('access_token') == null) {
      return null;
    }

    return prefs.getString('access_token');
  }

  // _locationPermission(){
  //   PermissionsService().requestLocationPermission(
  //       onPermissionDenied: () {
  //         print('Permission has been denied');
  //       });
  // }

  _defineTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getBool("tutorialSeen") != null)
      this.tutorialSeen = prefs.getBool("tutorialSeen");
    else
      this.tutorialSeen = false;

  }


}
