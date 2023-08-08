import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_legal/roles/lawyer/lawyer_page.dart';
import 'package:e_legal/roles/lawyer/request_page.dart';
import 'package:e_legal/roles/users/history_page.dart';
import 'package:e_legal/src/main_tutorial.dart';
import 'package:e_legal/src/waiting_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_legal/auth/register.dart';
import 'package:e_legal/src/welcome.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:e_legal/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(OneSignalId);

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print('NOTIFICACION RECIBIDA setNotificationOpenedHandler');
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    print('NOTIFICACION RECIBIDA setNotificationWillShowInForegroundHandler');
  });

  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    try {
      print('NOTIFICACION RECIBIDA setNotificationOpenedHandler');

      if (result.notification.additionalData!['messageId'].toString().substring(0,result.notification.additionalData!['messageId'].toString().indexOf(':')) =='solicitud') {
        fromNotification = true; 
        notificationGlobalId = result.notification.additionalData!['messageId'].toString().substring(result.notification.additionalData!['messageId'].toString().indexOf(':') +1,result.notification.additionalData!['messageId'].toString().length);

        navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => RequestPage(notificationGlobalId)));
      }

      if (result.notification.additionalData!['messageId'].toString().substring(0,result.notification.additionalData!['messageId'].toString().indexOf(':')) =='response') {
        reponseNotification = true;
        chatGlobalId = result.notification.additionalData!['messageId'].toString().substring(result.notification.additionalData!['messageId'].toString().indexOf(':') +1,result.notification.additionalData!['messageId'].toString().length);

        FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms/', '/e_legal/conf/users/');

        FirebaseChatCore.instance.room(chatGlobalId.replaceAll(' ', '')).first.then((value) async {
          await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ChatPage(isHistory: false, room: value)));
        });
      }

      if (result.notification.additionalData!['messageId'].toString().substring(0,result.notification.additionalData!['messageId'].toString().indexOf(':')) =='desktop') {
        print('*****************NOTIFICACITON***************');

        chatGlobalId = result.notification.additionalData!['messageId'].toString().substring(result.notification.additionalData!['messageId'].toString().indexOf(':') +1,result.notification.additionalData!['messageId'].toString().length);

        print(chatGlobalId);

        FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms/', '/e_legal/conf/users/');

        FirebaseChatCore.instance.room(chatGlobalId.replaceAll(' ', '')).first.then((value) async {
          print(value.id);
          await navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ChatPage(isHistory: false, room: value)));
        });
      }

    } catch (onerror) {
      print('---------------------------------');
      print('err setNotificationOpenedHandler: ' + onerror.toString());
      print('---------------------------------');
    }
  });

  // OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
  //   // Will be called whenever the permission changes
  //   // (ie. user taps Allow on the permission prompt in iOS)
  // });
  //
  // OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
  //   // Will be called whenever the subscription changes
  //   // (ie. user gets registered with OneSignal and gets a user ID)
  // });
  //
  // OneSignal.shared.setEmailSubscriptionObserver(
  //     (OSEmailSubscriptionStateChanges emailChanges) {
  //   // Will be called whenever then user's email subscription changes
  //   // (ie. OneSignal.setEmail(email) is called and the user gets registered
  // });

  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      navigatorKey: navigatorKey,
      routes: {
        '/home': (BuildContext context) => const MyHomePage(),
        '/login': (BuildContext context) => Login(),
        '/welcome': (BuildContext context) => Welcome(),
        // '/test': (BuildContext context) => WaitingPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
        name: 'escritorio-legal',
        options: const FirebaseOptions(
            apiKey: 'AIzaSyCTxKyldDgJeNLVLUdmV14R-7uFY5V2mII',
            appId: '1:811756378024:ios:3bd4f968c02811025c2f9d',
            messagingSenderId: '811756378024',
            projectId: 'escritorio-legal'));

    FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms/', '/e_legal/conf/users/');

    prefs = await SharedPreferences.getInstance();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  try {

                    FirebaseFirestore.instance
                        .collection('e_legal')
                        .doc('conf')
                        .collection('keys')
                        .doc('items')
                        .get()
                        .then((val) async {
                      GlobalSK = val.data()!['SK_STRIPE'];
                      GlobalPK = val.data()!['PK_STRIPE'];
                    });

                    String? loggedBefore;

                    try {
                      loggedBefore = prefs?.getString('logged');
                      print('Logged Before: ' + loggedBefore!);
                    } catch (onError) {
                      loggedBefore = '';
                    }

                    if (snapshot.connectionState != ConnectionState.active) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (loggedBefore == '') {
                      return MainTutorialPage();
                    } else {
                      return Welcome();
                    }
                  } catch (e) {
                    return Text(e.toString());
                  }
                });
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
