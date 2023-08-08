// import 'package:flutter/material.dart';
// import 'package:toktok_app/helpers/left_drawer.dart';
// import 'package:toktok_app/helpers/right_drawer.dart';
// import 'package:toktok_app/helpers/size_config.dart';
// import 'dart:async';
// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:toktok_app/globals.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:toktok_app/helpers/menu_profile.dart';
// import 'package:toktok_app/helpers/menu_settings.dart';
// import 'package:toktok_app/app_localizations.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:toktok_app/cards/payment_process.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:toktok_app/helpers/toktok_alert_dialog.dart';
// import 'package:toktok_app/helpers/left_drawer.dart';
//
// class Welcome extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _WelcomeState();
//   }
// }
//
// class _WelcomeState extends State<Welcome> with TickerProviderStateMixin{
//   String barcode = "";
//   String name = '';
//   String email = '';
//   String lastName = '';
//   String profilePicture = 'https://www.uic.mx/posgrados/files/2018/05/default-user.png';
//   Position position;
//   LatLng _center = LatLng(25.6684562,-100.3104893);
//   LatLng _newCameraPosition;
//   LatLng _verifyCoords;
//   Set<Marker> _markers = {};
//   Set<Marker> _markersHelper = {};
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   String gate;
//   String establishmentId;
//   DateTime date;
//   String gateType;
//   Timer _timer;
//   Timer _timerHelper;
//   Timer _forBanner;
//   DateTime timeNow;
//   DateTime elapsedTime;
//   var elapsedTimeHelper = '';
//   bool keepTimer = false;
//   bool timerIsRunning = false;
//   String sDuration = '00:00:00';
//   String platformVersion;
//   String _mapStyle;
//   bool bannerUp = false;
//   final PaymentProcess paymentProcess = PaymentProcess();
//   int count = 0;
//   bool canLoadMarkers;
//   final List<String> entries = <String>['A', 'B', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C'];
//   final List<int> colorCodes = <int>[600, 500, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
//
//   @override
//   initState() {
//     super.initState();
//
//     _setBannerBool();
//
//     firebaseCloudMessaging_Listeners();
//
//     _getUser().then((onValue){
//       if(bannerUp){
//         _forBanner = Timer.periodic(Duration(seconds: 1), _timerBanner);
//       }
//       if(timerIsRunning){
//         _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
//       }
//     });
//
//
//     rootBundle.loadString('assets/_mapStyle.txt').then((string) {
//       _mapStyle = string;
//     });
//     _getLocation();
//     _getServices();
//
//   }
//
//   @override
//   void dispose() {
//     if(_timer.isActive)
//       _timer.cancel();
//     if(_timerHelper.isActive)
//       _timerHelper.cancel();
//     if(_forBanner.isActive)
//       _forBanner.cancel();
//
//     super.dispose();
//   }
//
//   Completer<GoogleMapController> _controller = Completer();
//
// //  void _onCameraMove(CameraPosition position) async {
// //    this._center = position.target;
// //  }
//
//   void _fetchNewMarkers() async {
//    final GoogleMapController mapController = await _controller.future;
//    LatLngBounds bounds = await mapController.getVisibleRegion();
//    var centerLat = (bounds.southwest.latitude + bounds.northeast.latitude)/2;
//    var centerLng = (bounds.southwest.longitude + bounds.northeast.longitude)/2;
//
//    _newCameraPosition = LatLng(centerLat, centerLng);
//
//    if(_newCameraPosition != this._verifyCoords)
//      _getMarkers(_newCameraPosition);
//
//
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     controller.setMapStyle(_mapStyle);
//     _getMarkers(this._center);
//     _controller.complete(controller);
//
//
//   }
//
//   void firebaseCloudMessaging_Listeners() {
//
//     _firebaseMessaging.getToken().then((token)async {
//
//       final prefs = await SharedPreferences.getInstance();
//
//       final _headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${prefs.getString('access_token')} '
//       };
//
//       var mapData = new Map();
//       mapData['token'] = token;
//       mapData['userId'] = prefs.getInt('userId');
//       String json = jsonEncode(mapData);
//
//       await http.post(
//         '${Globals.BASE_API_URL}/users/firebaseToken',
//         headers: _headers,
//         body: json
//       );
//
//     });
//
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print('on message $message');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print('on resume $message');
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print('on launch $message');
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//
//
//     // TODO: implement build
//
//     return SafeArea(
//         top: true,
//         bottom: true,
//         left: true,
//         child: Scaffold(
//           appBar: !bannerUp? AppBar(
//             centerTitle: true,
//             backgroundColor: Color(0xFF000000),
//             title: Image(
//               image: AssetImage('assets/img/logorounded.png'),
//               width: 48.0,
//             ),
//             brightness: Brightness.dark,
//           ) : null,
//           drawer: Drawer(
//             child: LeftDrawer(name: this.name, lastName: this.lastName, picture: this.profilePicture, email: this.email),
//           ),
//           endDrawer: Drawer(
//             child: RightDrawer(),
//           ),
//           body: Builder(
//             //future: _getServices(),
//             builder: (context) => Stack(
//             children: <Widget>[
//               Stack(
//                 children: <Widget>[
//             ListView.separated(
//             padding: const EdgeInsets.all(8),
//             itemCount: entries.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                 height: 50,
//                 color: Colors.amber[colorCodes[index]],
//                 child: Center(child: Text('Entry ${entries[index]}')),
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) => const Divider(),
//           ),
//                   //GoogleMap(
//                     //onMapCreated: _onMapCreated,
// //                    onCameraMove: (newPosition) { _mapIdleSubscription?.cancel(); _mapIdleSubscription = Future.delayed(Duration(milliseconds: 150)) .asStream() .listen((_) => _onCameraIdle()); },
//                     //onCameraIdle: _fetchNewMarkers,
//                     //myLocationEnabled: true,
//                     //initialCameraPosition: CameraPosition(
//                       //target: this._center,
//                       //zoom: 15.0,
//                     //),
//                     //markers: this._markers,
//                   //),
// //                  !bannerUp ? Column(
// //                    crossAxisAlignment: CrossAxisAlignment.start,
// //                    mainAxisAlignment: MainAxisAlignment.start,
// //                    children: <Widget>[
// //                      MenuProfile(name: this.name, lastName: this.lastName, picture: this.profilePicture, email: this.email),
// //                      MenuSettings(),
// //                    ],
// //                  ) : SizedBox(),
//                   !bannerUp ? Container(
//                     child: timerIsRunning ? Padding(
//                       padding: EdgeInsets.only(
//                           top: SizeConfig.safeBlockVertical * 1,
//                           left: SizeConfig.safeBlockHorizontal * 30
//                       ),
//                       child: Stack(
//                         children: <Widget>[
//                           Container(
//                             width: SizeConfig.safeBlockHorizontal * 27,
//                             height: SizeConfig.safeBlockVertical * 5,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(Radius.circular(40.0)),
//                                 color: Colors.orange
//                             ),
//                             alignment: Alignment(0.0, 0.0),
//                             child: Text(
//                               sDuration,
//                               style: TextStyle(
//                                   fontSize: 22.0,
//                                   color: Colors.white
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ): SizedBox(),
//                   ) : SizedBox(),
//                   !bannerUp ? GestureDetector(
//                       child: Container(
//                         margin: EdgeInsets.only(
//                             top: SizeConfig.safeBlockVertical*80,
//                             left: SizeConfig.safeBlockHorizontal*39,
//                             right: SizeConfig.safeBlockHorizontal*39
//                         ),
//                         width: SizeConfig.blockSizeHorizontal*20,
//                         height: SizeConfig.blockSizeVertical*10,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                               image:AssetImage("assets/img/push_button.png"),
//                               fit:BoxFit.cover
//                           ),
//                           // button text
//                         ),
//                       ),onTap:(){
//                         scan();
//                       }
//                   ) : SizedBox(),
//                   bannerUp ? InkWell(
//                     onTap: (){
//                       _changeBannerState();
//                     },
//                     child: Container(
//                       color: Color(0xA1E18F00),
//                       width: SizeConfig.blockSizeHorizontal * 100,
//                       height: SizeConfig.blockSizeVertical * 100,
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(height: 20),
//                           Container(
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: SizeConfig.safeBlockHorizontal * 13,
//                             ),
//                             child: Image(
//                               width: SizeConfig.blockSizeHorizontal * 80,
//                               height: SizeConfig.blockSizeVertical * 30,
//                               image: AssetImage('assets/img/Logo_Squirrel_02.png'),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(
//                                 top: SizeConfig.safeBlockVertical* 1
//                             ),
//                             width: SizeConfig.blockSizeHorizontal* 25,
//                             height: SizeConfig.blockSizeVertical* 13,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                     image: new NetworkImage(profilePicture),
//                                     fit: BoxFit.cover
//                                 )
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(
//                                 top: 10.0
//                             ),
//                             child: Text(
//                               '${AppLocalizations.of(context).hello}, $name',
//                               style: TextStyle(
//                                   fontSize: 44.0,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700
//                               ),
//                             ),
//                           ),
//                           Container(
//                             child: Text(
//                               AppLocalizations.of(context).whereWeGoing,
//                               style: TextStyle(
//                                   fontSize: 16.0,
//                                   color: Colors.blueAccent
//                               ),
//                             ),
//                           ),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Container(
//                               margin: EdgeInsets.only(
//                                   top: SizeConfig.blockSizeVertical * 2,
//                                   left: SizeConfig.blockSizeHorizontal * 10
//                               ),
//                               width: SizeConfig.blockSizeHorizontal * 190,
// //                              height: SizeConfig.blockSizeVertical * 50,
//                               alignment: Alignment.topLeft,
// //                              child: Image(
// //                                image: AssetImage('assets/img/Group63_2@2x.png'),
// //                                alignment: Alignment.topLeft,
// //                              ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ): SizedBox()
//                 ],
//               )
//             ],
//           )
//           ),
//
// //          floatingActionButton: showBanner == false ? FloatingActionButton(
// //            onPressed: (){
// //              Navigator.of(context).pushNamed('/receipt');
// //            },
// //            child: Icon(Icons.exit_to_app),
// //            backgroundColor: Colors.redAccent,
// //          ) : null,
//         )
//     );
//
//   }
//
//   Future scan() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     if(prefs.getString('selectedPaymentMethod') == null) {
//       // flutter defined function
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return TokTokAlertDialog(
//               'No Payment Method',
//               "It seems that you haven't selected a payment method, please do this so you can scan codes for the parking lot",
//               1
//           );
//         },
//       );
//     } else {
//       try {
//         String barcode = await BarcodeScanner.scan();
//         setState(() => this.barcode = barcode);
//         if(barcode.startsWith('Establishment:')){
//           var first = barcode.split(',');
//           var establishmentHelper = first[0].toString();
//           var establishmentHelper2 = establishmentHelper.split(':');
//           establishmentId = establishmentHelper2[1];
//           var gateHelper = first[1].toString();
//           var gateHelper2 = gateHelper.split(':');
//           gate = gateHelper2[1];
//           var gateTypeHelper = first[2].toString();
//           var gateTypeHelper2 = gateTypeHelper.split(':');
//           gateType = gateTypeHelper2[1];
//           date = new DateTime.now();
//
//
//           var doorData = {
//             'date': date,
//             'establishmentId': establishmentId,
//             'qrId': gate,
//             'gateType': gateType,
//             'userId': prefs.getInt('userId')
//           };
//
//           if(gateType == 'Entry' && timerIsRunning){
//             return showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return TokTokAlertDialog(
//                     'Invalid Scan',
//                     "It seems that you are trying to scan an entry code. Only exit QR codes are available for scanning at the moment",
//                     1
//                 );
//               },
//             );
//           }
//           if(gateType == 'Exit' && !timerIsRunning){
//             return showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return TokTokAlertDialog(
//                     'Invalid Scan',
//                     "It seems that you are trying to scan an exit code. Only entry QR codes are available for scanning at the moment",
//                     1
//                 );
//               },
//             );
//           }
//
//           if (gateType == 'Entry') {
//             _addData(doorData, 'movements').then((onValue) {
//               keepTimer = true;
//               timerIsRunning = true;
//               prefs.setString('entryTime', DateTime.now().toString());
//               _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
//             });
//           } else if (gateType == 'Exit') {
//             paymentProcess.performPayment(establishmentId, prefs.getInt('userId'), sDuration, date).then((receipt) {
//               if(receipt.error != null){
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     // return object of type Dialog
//                     return TokTokAlertDialog(
//                         "Payment Error",
//                         receipt.error,
//                         1
//                     );
//                   },
//                 );
//               } else {
//                 _timer.cancel();
//                 keepTimer = false;
//                 timerIsRunning = false;
//                 elapsedTimeHelper = '';
//                 _addData(doorData, 'movements').then((onValue) {
//                   Navigator.of(context).pushNamed(
//                       '/receipt', arguments: receipt);
//                 });
//               }
//             });
//           }
//         } else {
//           // flutter defined function
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               // return object of type Dialog
//               return TokTokAlertDialog(
//                   "QR Error",
//                   "We are sorry we couldn't read that QR. Please try again",
//                   1
//               );
//             },
//           );
//         }
//       } on PlatformException catch (e) {
//         if (e.code == BarcodeScanner.CameraAccessDenied) {
//           setState(() {
//             this.barcode = 'The user did not grant the camera permission!';
//           });
//         } else {
//           setState(() => this.barcode = 'Unknown error: $e');
//         }
//       } on FormatException {
//         setState(() =>
//         this.barcode =
//         'null (User returned using the "back"-button before scanning anything. Result)');
//       } catch (e) {
//         setState(() => this.barcode = 'Unknown error: $e');
//       }
//     }
//   }
//
//   Future _getUser() async{
//     final prefs = await SharedPreferences.getInstance();
//
//     if(prefs.getString('entryTime') != null){
//       timerIsRunning = true;
//     } else {
//       timerIsRunning = false;
//     }
//
//     final response = await http.get(
//         '${Globals.BASE_API_URL}/users/${prefs.getInt('userId')}',
//         headers: {
//           'Authorization' : 'Bearer ${prefs.getString('access_token')}',
//           'Content-Type' : 'application/json'
//         }
//     );
//
//     var c = (jsonDecode(response.body));
//
//     setState(() {
//       if(c['data']['name'] != null)
//         name = '${c['data']['name']}';
//       if(c['data']['name'] != null)
//         lastName = '${c['data']['lastName']}';
//       if(c['data']['photo'] != null)
//         profilePicture = c['data']['photo'];
//       if(c['data']['email'] != null)
//         email = c['data']['email'];
//       if(c['data']['open_pay_token'] != null)
//         prefs.setString('opp_token', c['data']['open_pay_token']);
//       if(c['data']['paypal_token'] != null)
//         prefs.setString('paypalToken', c['data']['paypal_token']);
//     });
//
//     return true;
//   }
//
//   Future _getServices() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final response = await http.get(
//         '${Globals.BASE_API_URL}/services',
//         headers: {
//           'Authorization': 'Bearer ${prefs.getString('access_token')}',
//           'Content-Type': 'application/json'
//         }
//     );
//
//     var c = (jsonDecode(response.body));
//     print("hola");
//     print(c);
//     return c['data'];
//   }
//
//   Future _getLocation() async{
//     position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     final CameraPosition newPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 15,
//       tilt: 20,
//       bearing: 15
//     );
//
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
//
//   }
//
//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
//   }
//
//   _getMarkers(location) async {
//     position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     this._center = LatLng(position.latitude, position.longitude);
//
//     final prefs = await SharedPreferences.getInstance();
//     final _headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${prefs.getString('access_token')} '
//     };
//
//     var mapData = new Map();
//     mapData['distance'] = 5;
//     mapData['lat'] = location.latitude;
//     mapData['lng'] = location.longitude;
//     String json = jsonEncode(mapData);
//
//     final response = await http.post(
//         '${Globals.BASE_API_URL}/establishments/nearPlaces',
//         headers: _headers,
//         body: json
//     );
//
//     var c = jsonDecode(response.body);
//     var places = c;
//     final Uint8List markerIcon = await getBytesFromAsset('assets/img/toktokPin.png', 125);
//
//     for(var i=0; i < places.length; i++){
//       try {
//         var markerVerification = _markersHelper.firstWhere((Marker marker) =>
//         marker.markerId == MarkerId(places[i]['establishmentId'].toString()));
//         if (markerVerification.markerId.value == null){
//           _markersHelper.add(Marker(
//               markerId: MarkerId(places[i]['establishmentId'].toString()),
//               position: LatLng(double.parse(places[i]['lat']), double.parse(places[i]['lon'])),
//               infoWindow: InfoWindow(
//                 title: places[i]['name'],
//                 snippet: places[i]['address'],
//               ),
//               icon: BitmapDescriptor.fromBytes(markerIcon)
//           ));
//         }
//       } catch (e){
//         _markersHelper.add(Marker(
//             markerId: MarkerId(places[i]['establishmentId'].toString()),
//             position: LatLng(double.parse(places[i]['lat']), double.parse(places[i]['lon'])),
//             infoWindow: InfoWindow(
//               title: places[i]['name'],
//               snippet: places[i]['address'],
//             ),
//             icon: BitmapDescriptor.fromBytes(markerIcon)
//         ));
//       }
//     }
//
//     setState(() {
//       this._verifyCoords = location;
//       _markers = _markersHelper;
//     });
//   }
//
//   void _onTimeChange(Timer timer) async {
//     final prefs = await SharedPreferences.getInstance();
//     timeNow = DateTime.now();
//     int hoursElapsed;
//     int minutesElapsed;
//     int secondsElapsed;
//     sDuration='';
//
//     var parsedDate = DateTime.parse(prefs.getString('entryTime'));
//
//     setState(() {
//       hoursElapsed = timeNow.difference(parsedDate).inHours;
//       minutesElapsed = timeNow.difference(parsedDate).inMinutes.remainder(60);
//       secondsElapsed = timeNow.difference(parsedDate).inSeconds.remainder(60);
//       if(hoursElapsed>10 && minutesElapsed>10 && secondsElapsed>=10){ //101010
//         sDuration = "$hoursElapsed:$minutesElapsed:$secondsElapsed";
//       } else if (hoursElapsed>10 && minutesElapsed>10 && secondsElapsed<10){//101000
//         sDuration = "$hoursElapsed:$minutesElapsed:0$secondsElapsed";
//       } else if (hoursElapsed>10 && minutesElapsed<10 && secondsElapsed>=10){//100010
//         sDuration = "$hoursElapsed:0$minutesElapsed:$secondsElapsed";
//       } else if (hoursElapsed>10 && minutesElapsed<10 && secondsElapsed<10){//100000
//         sDuration = "$hoursElapsed:0$minutesElapsed:0$secondsElapsed";
//       } else if (hoursElapsed<10 && minutesElapsed<10 && secondsElapsed<10){//000000
//         sDuration = "0$hoursElapsed:0$minutesElapsed:0$secondsElapsed";
//       } else if (hoursElapsed<10 && minutesElapsed>10 && secondsElapsed>10){//001010
//         sDuration = "0$hoursElapsed:$minutesElapsed:$secondsElapsed";
//       } else if (hoursElapsed<10 && minutesElapsed>10 && secondsElapsed<10){//001000
//         sDuration = "0$hoursElapsed:$minutesElapsed:0$secondsElapsed";
//       } else if (hoursElapsed<10 && minutesElapsed<10 && secondsElapsed>=10){//000010
//         sDuration = "0$hoursElapsed:0$minutesElapsed:$secondsElapsed";
//       } else if (hoursElapsed<10 && minutesElapsed>10 && secondsElapsed>=10){//000010
//         sDuration = "0$hoursElapsed:$minutesElapsed:$secondsElapsed";
//       }
//
//     });
//
//   }
//
//   Future<void> _addData (doorData, document) async {
//     Firestore.instance.collection(document).add(doorData).catchError((e){
//       print(e);
//     });
//   }
//
//   void _timerBanner(Timer timer) async {
//     final prefs = await SharedPreferences.getInstance();
//     if(timer.tick == 4){
//       setState(() {
//         prefs.setBool('showBanner', false);
//        // bannerUp = prefs.getBool('showBanner');
//         timer.cancel();
//       });
//     }
//   }
//
//   void _setBannerBool() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('showBanner', true);
//    // bannerUp = prefs.getBool('showBanner');
//   }
//
//   void _changeBannerState() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('showBanner', false);
//
//     setState(() async {
//     //  bannerUp = prefs.getBool('showBanner');
//     });
//   }
//
// }