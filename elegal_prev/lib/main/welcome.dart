import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toktok_app/helpers/left_drawer.dart';
import 'package:toktok_app/helpers/right_drawer.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:toktok_app/cards/payment_process.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';
import 'package:toktok_app/helpers/no_payment_alert.dart';
import 'package:toktok_app/main/payment_services/payment-services.dart';
import 'package:toktok_app/tutorial_pages/main_tutorial_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toktok_app/helpers/message.dart';
import 'package:toktok_app/cards/list_cards.dart';
import 'package:openpay_flutter/openpay_flutter.dart';
import 'package:toktok_app/util/globalVariables.dart';

class Welcome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _WelcomeState();
  }
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin{
  String barcode = "";
  String name = '';
  String email = '';
  String lastName = '';
  String profilePicture = 'https://www.uic.mx/posgrados/files/2018/05/default-user.png';
  FirebaseMessaging _firebaseMessaging;
  String gate;
  String establishmentId;
  DateTime date;
  String gateType;
  Timer _timer;
  Timer _timerHelper;
  Timer _forBanner;
  DateTime timeNow;
  DateTime elapsedTime;
  var elapsedTimeHelper = '';
  bool keepTimer = false;
  bool timerIsRunning = false;
  String sDuration = '00:00:00';
  String platformVersion;
  bool bannerUp = false;
  final PaymentProcess paymentProcess = PaymentProcess();
  int count = 0;
  bool canLoadMarkers;
  bool isPaymentInProcess = false;
  String selectedCard;
  final List<String> entries = <String>['A', 'B', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  /// Create a [AndroidNotificationChannel] for heads up notifications
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  @override
  initState() {
    super.initState();

    StripeService.init();

    _setBannerBool();

    firebaseCloudMessagingListeners();

    _getUser().then((onValue){
      if(bannerUp){
        _forBanner = Timer.periodic(Duration(seconds: 1), _timerBanner);
      }
      if(timerIsRunning){
        _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
      }
    });


    _getServices();
    _getCards().then((onValue){
      print(onValue);
      print("entro aqui");
    });
    print("prueba de print");
    print(_getServices());


  }

  @override
  void dispose() {
    if(_timer?.isActive)
      _timer.cancel();
    if(_timerHelper?.isActive)
      _timerHelper.cancel();
    if(_forBanner?.isActive)
      _forBanner.cancel();

    super.dispose();
  }






  void firebaseCloudMessagingListeners() {

    FirebaseMessaging.instance.getToken().then((token)async {



      final prefs = await SharedPreferences.getInstance();

      final _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('access_token')} '
      };

      var mapData = new Map();
      mapData['token'] = token;
      mapData['userId'] = prefs.getInt('userId');
      String json = jsonEncode(mapData);

      await http.post(
        Uri.parse('${Globals.BASE_API_URL}/users/firebaseToken'),
        headers: _headers,
        body: json
      );

    });



    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    });

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('on message $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print('on resume $message');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('on launch $message');
    //   },
    // );
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);


    // TODO: implement build

    return SafeArea(
        top: true,
        bottom: true,
        left: true,
        child: Scaffold(
          appBar: !bannerUp? AppBar(
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
            centerTitle: true,
            backgroundColor: Color(0xFF000000),
            title: Image(
              image: AssetImage('assets/img/navbarlogo.png'),
              width: 45.0,
            ),
            brightness: Brightness.dark,
          ) : null,
          drawer: Drawer(
            child: LeftDrawer(name: this.name, lastName: this.lastName, picture: this.profilePicture, email: this.email),
          ),
          endDrawer: Drawer(
            child: RightDrawer(),
          ),
          body: FutureBuilder(
            future: _getServices(),
            initialData: 'Loading',
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.waiting ) {
                print('project snapshot data is: ${projectSnap.data}');
                return Text('Loading...');
              }
              return ListView.builder(
                itemCount: projectSnap.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 20,
                                // height: SizeConfig.blockSizeVertical * 10,
                                margin: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 5
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: NetworkImage(
                                          projectSnap.data[index]['image'] !=
                                              null ? 'http://escritoriolegal.softcodersteam.com/'+projectSnap.data[index]['image']
                                              : 'https://escritoriolegal.com.mx/img/icon-1.png'
                                      ),
                                      height: 50.0,
                                      width: 70.0,
                                    ),
                                    SizedBox(height: 2.0),
                                    Text(
                                      projectSnap.data[index]['price'],
                                    )
                                  ],
                                ),
                              ),
                              onTap:(){
                                pay(projectSnap.data[index]);
                              }
                          ),
                          GestureDetector(
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 65,
                                // height: SizeConfig.blockSizeVertical * 10,
                                margin: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 5
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          projectSnap.data[index]['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600
                                          ),
                                        )
                                    ),
                                    Container(
                                        child: Text(
                                          projectSnap.data[index]['description'],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              onTap:() {
                                pay(projectSnap.data[index]);
                              }
                          )
                        ],
                      )
                    ],
                  );
              },
              );
            },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).pushNamed('/chat'),
            // onPressed: () => Navigator.push(context, MaterialPageRoute(
            //     builder: (context) =>
            //         MainTutorialPage())),
            tooltip: 'Chatea con un abogado',
            child: const Icon(Icons.chat, color: Colors.white),
            backgroundColor: Colors.black,
            splashColor: Colors.white,
          ),
//          floatingActionButton: showBanner == false ? FloatingActionButton(
//            onPressed: (){
//              Navigator.of(context).pushNamed('/receipt');
//            },
//            child: Icon(Icons.exit_to_app),
//            backgroundColor: Colors.redAccent,
//          ) : null,
        )
    );

  }



  Future pay(data) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('selectedPaymentMethod') == null) {
      // flutter defined function
      // showGeneralDialog(
      //   context: context,
      //   transitionBuilder: (context, a1, a2, widget) {

            // return Transform.scale(
            //     scale: a1.value,
            //     child: Opacity(
            //         opacity: a1.value,
            //         child: ElevatedButton(child: Text('Pago'), onPressed: (){
            //           print('pago');
            //           try {
            //
            //             infoPayment paymentInfo = new infoPayment(
            //                 amount: data['price'],
            //                 currency: 'MXN'
            //             );
            //
            //             payViaNewCard(context, paymentInfo, '');
            //           } catch(one){
            //             print(one.toString());
            //           }
            //         },)
            //     )
            // );
          // },
          // transitionDuration: Duration(milliseconds: 350),
          // // ignore: missing_return
          // pageBuilder: (context, animation1, animation2) {});


      infoPayment paymentInfo = new infoPayment(
          amount: data['price'],
          currency: 'MXN'
      );

      await payViaNewCard(context, paymentInfo, '');

      Navigator.of(context)
          .popAndPushNamed(
          '/successfulPayment',
          arguments: {
            "price": data['price'],
            "item": '',
            "holder": 'receipt.holderName',
            "card": 'receipt.cardThatPayed',
            "date": 'receipt.dateCreated'
          }
      );

      // setState(() => isPaymentInProcess = true);
      // date = new DateTime.now();
      // paymentProcess.performPayment(data['price'], prefs.getInt('userId'), sDuration, date).then((receipt) {
      //   // if (receipt.error != null) {
      //   //   showDialog(
      //   //     context: context,
      //   //     builder: (
      //   //         BuildContext context) {
      //   //       // return object of type Dialog
      //   //       return TokTokAlertDialog(
      //   //           "Payment Error",
      //   //           receipt.error,
      //   //           1
      //   //       );
      //   //     },
      //   //   );
      //   // } else {
      //     setState(() =>
      //     isPaymentInProcess = false);
      //     Navigator.of(context)
      //         .popAndPushNamed(
      //         '/successfulPayment',
      //         arguments: {
      //           "price": data['price'],
      //           "item": '',
      //           "holder": receipt
      //               .holderName,
      //           "card": receipt
      //               .cardThatPayed,
      //           "date": receipt.dateCreated
      //         }
      //     );
      //   // }
      // });


    } else{
      showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Info del servicio',
          transitionBuilder: (context, a1, a2, widget) {
            return StatefulBuilder(
              builder:(context, setState) {
                return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                        opacity: a1.value,
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: 150.0,
                              maxHeight: 350.0
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: SizeConfig.blockSizeVertical * 10,
                                    margin: EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                    ),
                                    child: Image(
                                        image: NetworkImage('http://escritoriolegal.softcodersteam.com/'+data['image']))
                                ),
                                Container(
                                    child: Text(
                                        data['name'],
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600
                                        ),
                                        textAlign: TextAlign.center
                                    )
                                ),
                                Container(
                                    constraints: BoxConstraints(
                                        maxHeight: 95
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.0
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 15.0
                                    ),
                                    child: SingleChildScrollView(
                                        child: Text(
                                            data['description'],
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center
                                        )
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.only(bottom: 35.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Text(
                                        "Al confirmar pagaras un total de "
                                            "\$${data['price']}",
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.center
                                    )
                                ),
                                !isPaymentInProcess ? Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      // width: SizeConfig.blockSizeHorizontal *
                                      //     35,
                                      height: SizeConfig.blockSizeVertical * 4,
                                      child: RaisedButton(
                                        child: new Text("Cancelar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        disabledColor: Color(0xFFE14300),
                                        color: Colors.redAccent,
                                        textColor: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      // width: SizeConfig.blockSizeHorizontal *
                                      //     33,
                                      height: SizeConfig.blockSizeVertical * 4,
                                      child: RaisedButton(
                                        child: Text("Pagar"),
                                        onPressed: () {
                                          setState(() =>
                                          isPaymentInProcess = true);
                                          date = new DateTime.now();
                                          paymentProcess.performPayment(
                                              data['price'], prefs.getInt('userId'),
                                              sDuration, date).then((receipt) {
                                            if (receipt.error != null) {
                                              showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  // return object of type Dialog
                                                  return TokTokAlertDialog(
                                                      "Payment Error",
                                                      receipt.error,
                                                      1
                                                  );
                                                },
                                              );
                                            } else {
                                              setState(() =>
                                              isPaymentInProcess = false);
                                              Navigator.of(context)
                                                  .popAndPushNamed(
                                                  '/successfulPayment',
                                                  arguments: {
                                                    "price": data['price'],
                                                    "item": data['name'],
                                                    "holder": receipt
                                                        .holderName,
                                                    "card": receipt
                                                        .cardThatPayed,
                                                    "date": receipt.dateCreated
                                                  }
                                              );
                                            }
                                          });
                                        },
                                        disabledColor: Color(0xFFE14300),
                                        color: Colors.green,
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ) : CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        )
                    )
                );
              });
          },
          transitionDuration: Duration(milliseconds: 250),
          // ignore: missing_return
          pageBuilder: (context, animation1, animation2) {});

    }
  }
  Future scan() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString('selectedPaymentMethod') == null) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TokTokAlertDialog(
              'No Payment Method',
              "It seems that you haven't selected a payment method, please do this so you can scan codes for the parking lot",
              1
          );
        },
      );
    } else {
      try {
        String barcode = await BarcodeScanner.scan();
        setState(() => this.barcode = barcode);
        if(barcode.startsWith('Establishment:')){
          var first = barcode.split(',');
          var establishmentHelper = first[0].toString();
          var establishmentHelper2 = establishmentHelper.split(':');
          establishmentId = establishmentHelper2[1];
          var gateHelper = first[1].toString();
          var gateHelper2 = gateHelper.split(':');
          gate = gateHelper2[1];
          var gateTypeHelper = first[2].toString();
          var gateTypeHelper2 = gateTypeHelper.split(':');
          gateType = gateTypeHelper2[1];
          date = new DateTime.now();


          var doorData = {
            'date': date,
            'establishmentId': establishmentId,
            'qrId': gate,
            'gateType': gateType,
            'userId': prefs.getInt('userId')
          };

          if(gateType == 'Entry' && timerIsRunning){
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return TokTokAlertDialog(
                    'Invalid Scan',
                    "It seems that you are trying to scan an entry code. Only exit QR codes are available for scanning at the moment",
                    1
                );
              },
            );
          }
          if(gateType == 'Exit' && !timerIsRunning){
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return TokTokAlertDialog(
                    'Invalid Scan',
                    "It seems that you are trying to scan an exit code. Only entry QR codes are available for scanning at the moment",
                    1
                );
              },
            );
          }

          if (gateType == 'Entry') {
            _addData(doorData, 'movements').then((onValue) {
              keepTimer = true;
              timerIsRunning = true;
              prefs.setString('entryTime', DateTime.now().toString());
              _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
            });
          } else if (gateType == 'Exit') {
            paymentProcess.performPayment(establishmentId, prefs.getInt('userId'), sDuration, date).then((receipt) {
              if(receipt.error != null){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return TokTokAlertDialog(
                        "Payment Error",
                        receipt.error,
                        1
                    );
                  },
                );
              } else {
                _timer.cancel();
                keepTimer = false;
                timerIsRunning = false;
                elapsedTimeHelper = '';
                _addData(doorData, 'movements').then((onValue) {
                  Navigator.of(context).pushNamed(
                      '/receipt', arguments: receipt);
                });
              }
            });
          }
        } else {
          // flutter defined function
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return TokTokAlertDialog(
                  "QR Error",
                  "We are sorry we couldn't read that QR. Please try again",
                  1
              );
            },
          );
        }
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
          setState(() {
            this.barcode = 'The user did not grant the camera permission!';
          });
        } else {
          setState(() => this.barcode = 'Unknown error: $e');
        }
      } on FormatException {
        setState(() =>
        this.barcode =
        'null (User returned using the "back"-button before scanning anything. Result)');
      } catch (e) {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }
  }

  payViaNewCard(BuildContext context,infoPayment paymentInfo,String orderId) async {
    try {
      ProgressDialog dialog = new ProgressDialog(context);
      dialog.style(
          message: 'Cargando información...'
      );
      await dialog.show();
      var response = await StripeService.payWithNewCard(
          paymentInfo,
          orderId
      );
      await dialog.hide();
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            duration: new Duration(
                milliseconds: response.success == true ? 1200 : 3000),
          )
      );

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => OrderSuccessPage()));
    }
    catch(onError){
print(onError.toString());
      // Navigator.push(context,MaterialPageRoute(builder: (context) => ErrorsPage(onError.toString(),'Error de pago')));
//  ErrorsPage(onError.toString(),'Error de pago');
    }
  }

  Future _getChatlist() async{
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('https://nameless-coast-31577.herokuapp.com/api/users_lawyer_chats/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        }
    );
    var c = jsonDecode(response.body);

    return c;
  }

  Future _getUser() async{
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString('entryTime') != null){
      timerIsRunning = true;
    } else {
      timerIsRunning = false;
    }

    final response = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/users/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        }
    );

    var c = (jsonDecode(response.body));


    setState(() {
      if(c['data']['name'] != null)
        name = '${c['data']['name']}';
      if(c['data']['name'] != null)
        lastName = '${c['data']['lastName']}';
      if(c['data']['photo'] != null)
        profilePicture = c['data']['photo'];
      if(c['data']['email'] != null)
        email = c['data']['email'];
      if(c['data']['open_pay_token'] != null)
        prefs.setString('opp_token', c['data']['open_pay_token']);
      if(c['data']['paypal_token'] != null)
        prefs.setString('paypalToken', c['data']['paypal_token']);
    });



    return true;
  }

   _getCards() async {
    platformVersion = await OpenpayAPI(Globals.MERCHANT_ID,Globals.PUBLIC_OP).deviceSessionId(Globals.MERCHANT_ID,Globals.PUBLIC_OP);
    final prefs = await SharedPreferences.getInstance();
    print("getcards");
    print(Globals.MERCHANT_ID);
    print(Globals.PUBLIC_OP);
    this.selectedCard = prefs.getString('selectedPayment');
    print(this.selectedCard);

    OpenpayAPI _opp = new OpenpayAPI(Globals.MERCHANT_ID, Globals.PUBLIC_OP);

    var result = await _opp.cardService.getCustomerCards(prefs.getString('opp_token'));
    //Aqui Colocar el codigo para que si existe una tarjeta la seleccione por default, pero desde que inicia sesión.
    return result;
  }


void getcardsprint(){
    _getCards().then((erg) => print(erg));
}

  Future _getServices() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/services'),
        headers: {
          'Authorization': 'Bearer ${prefs.getString('access_token')}',
          'Content-Type': 'application/json'
        }
    );

    var c = (jsonDecode(response.body));
    //print("hola");
    //print(c);
    return c['data'];
  }

  void _onTimeChange(Timer timer) async {
    final prefs = await SharedPreferences.getInstance();
    timeNow = DateTime.now();
    int hoursElapsed;
    int minutesElapsed;
    int secondsElapsed;
    sDuration='';

    var parsedDate = DateTime.parse(prefs.getString('entryTime'));

    setState(() {
      hoursElapsed = timeNow.difference(parsedDate).inHours;
      minutesElapsed = timeNow.difference(parsedDate).inMinutes.remainder(60);
      secondsElapsed = timeNow.difference(parsedDate).inSeconds.remainder(60);
      if(hoursElapsed>10 && minutesElapsed>10 && secondsElapsed>=10){ //101010
        sDuration = "$hoursElapsed:$minutesElapsed:$secondsElapsed";
      } else if (hoursElapsed>10 && minutesElapsed>10 && secondsElapsed<10){//101000
        sDuration = "$hoursElapsed:$minutesElapsed:0$secondsElapsed";
      } else if (hoursElapsed>10 && minutesElapsed<10 && secondsElapsed>=10){//100010
        sDuration = "$hoursElapsed:0$minutesElapsed:$secondsElapsed";
      } else if (hoursElapsed>10 && minutesElapsed<10 && secondsElapsed<10){//100000
        sDuration = "$hoursElapsed:0$minutesElapsed:0$secondsElapsed";
      } else if (hoursElapsed<10 && minutesElapsed<10 && secondsElapsed<10){//000000
        sDuration = "0$hoursElapsed:0$minutesElapsed:0$secondsElapsed";
      } else if (hoursElapsed<10 && minutesElapsed>10 && secondsElapsed>10){//001010
        sDuration = "0$hoursElapsed:$minutesElapsed:$secondsElapsed";
      } else if (hoursElapsed<10 && minutesElapsed>10 && secondsElapsed<10){//001000
        sDuration = "0$hoursElapsed:$minutesElapsed:0$secondsElapsed";
      } else if (hoursElapsed<10 && minutesElapsed<10 && secondsElapsed>=10){//000010
        sDuration = "0$hoursElapsed:0$minutesElapsed:$secondsElapsed";
     } else if (hoursElapsed<10 && minutesElapsed>10 && secondsElapsed>=10){//000010
        sDuration = "0$hoursElapsed:$minutesElapsed:$secondsElapsed";
      }

    });

  }

  Future<void> _addData (doorData, document) async {
    FirebaseFirestore.instance.collection(document).add(doorData).catchError((e){
      print(e);
    });
  }

  void _timerBanner(Timer timer) async {
    final prefs = await SharedPreferences.getInstance();
    if(timer.tick == 4){
      setState(() {
        prefs.setBool('showBanner', false);
       // bannerUp = prefs.getBool('showBanner');
        timer.cancel();
      });
    }
  }

  void _setBannerBool() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showBanner', true);
   // bannerUp = prefs.getBool('showBanner');
  }

}