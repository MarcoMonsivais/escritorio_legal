import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/roles/admin/admin_page.dart';
import 'package:e_legal/roles/lawyer/request_page.dart';
import 'package:e_legal/src/main_tutorial.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:flutter/material.dart';
import 'package:e_legal/profile/profile_page.dart';
import 'package:e_legal/roles/users/history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_legal/src/waiting_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

menuLateral(context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const UserAccountsDrawerHeader(
          accountName: Text('¡Bienvenido!'),
          accountEmail: Text('Escritorio legal. Tus abogados de confianza'),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        Ink(
          child: ListTile(
            title: const Text(
              "Inicio",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () async => Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcome', (Route<dynamic> route) => false),
          ),
        ),
        ListTile(
          title: const Text("Perfil"),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage())),
        ),
        role == "user"
            ? ListTile(
                title: const Text("Historial de chats"),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryPage())),
              )
            : const SizedBox.shrink(),
        ListTile(
          title: const Text("Cerrar sesión"),
          onTap: () async {
            try {
              print(loggedWith);
              try {
                print('update device: try');
                await FirebaseFirestore.instance
                    .collection('e_legal')
                    .doc('conf')
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({'metadata.device': ''});
              } catch (onE) {
                print(onE);
                // showMyDialog('Tu dispositivo no pudo actualizarse', context);
              }

              switch (loggedWith) {
                ///CORREO
                case 1:
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('logged');

                  await FirebaseAuth.instance.signOut().whenComplete(() =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false));
                  break;

                ///GOOGLE
                case 2:
                  print('cerrando sesion....');
                  FacebookAuth.instance.logOut();
                  print('sesion de google cerrada....');

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('logged');

                  await FirebaseAuth.instance.signOut().whenComplete(() =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false));
                  break;

                ///FACEBOOK
                case 3:
                  print('cerrando sesion....');
                  FacebookAuth.instance.logOut();
                  print('sesion de facebook cerrada....');

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('logged');

                  await FacebookAuth.instance.logOut().whenComplete(() =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false));
                  break;

                ///APPLE
                case 4:
                  print('cerrando sesion....');
                  FacebookAuth.instance.logOut();
                  print('sesion de facebook cerrada....');

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('logged');

                  await FacebookAuth.instance.logOut().whenComplete(() =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false));
                  break;

                ///CORREO
                default:
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('logged');

                  await FirebaseAuth.instance.signOut().whenComplete(() =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false));
                  break;
              }
            } catch (onError) {
              showMyDialog(
                  'Sesión cerrada pero se identifico un problema. No es necesario hacer nada: ' +
                      onError.toString(),
                  context);
            }
          },
        ),
        GestureDetector(
          onTap: () => _delAccount(context),
          child: const ListTile(
            title: Text(
              "Eliminar cuenta",
              style: TextStyle(color: Colors.red, fontSize: 10),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _Confirmation(context),
          child: ListTile(
            title: Text(
              "Version " + currentVer,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        _debug(context),
        role == 'admin'
            ? ListTile(
                title: const Text("ADMIN"),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminPage())),
              )
            : const SizedBox.shrink(),
      ],
    ),
  );
}

Future<void> _Confirmation(context) async {
  final TextEditingController _confirmationController2 =
      new TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Escribe la contraseña'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                controller: _confirmationController2,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    if (_confirmationController2.text == 'MDEV') {
                      modeDebug = true;
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

_debug(context) {
  Map<String, dynamic>? _userData;
  String? device;

  if (modeDebug) {
    return Column(
      children: [
        Divider(
          height: 5,
          thickness: 5,
        ),
        ListTile(
          title: const Text("REQUEST"),
          onTap: () async {
            try {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Creando peticion..."),
                duration: Duration(milliseconds: 500),
              ));

              List<String> devices = [];
              String notificationId = '';

              await FirebaseFirestore.instance
                  .collection('e_legal')
                  .doc('conf')
                  .collection('users')

                  ///V2.02.25
                  .where('role', isEqualTo: 'agent')
                  .where('metadata.location', isEqualTo: 'GDL')

                  ///V2.02.25
                  .snapshots()
                  .forEach((element) async {
                for (var i = 0; i < element.docs.length; ++i) {
                  DocumentSnapshot ds = element.docs[i];
                  List<dynamic> entities = ds['metadata.entity'];
                  if (entities.contains('Penal')) {
                    if (ds['metadata.device'].toString().isNotEmpty &&
                        ds['metadata.device'].toString().length >= 22) {
                      devices.add(ds['metadata.device']);
                    }
                  }
                }

                var device = await OneSignal.shared.getDeviceState();

                await FirebaseFirestore.instance.collection('requests').add({
                  'date': DateTime.now().toString(),
                  'name': 'Marco Prueba',
                  'phone': '8115778979',

                  ///V2.02.25
                  'category': 'Penal',
                  'location': 'Chiapas',

                  ///V2.02.25
                  'description': 'ESTA ES UNA PRUEBA NO RESPONDER',
                  'user': FirebaseAuth.instance.currentUser?.uid,
                  'device': device?.userId,
                  'status': 'active'
                }).then((value) => notificationId = value.id);

                await post(
                  Uri.parse('https://onesignal.com/api/v1/notifications'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    "app_id": OneSignalId,
                    "include_player_ids": devices.toSet().toList(),
                    "android_accent_color": "green",
                    "small_icon": "icon",
                    "headings": {"en": 'Nueva solicitud'},
                    "contents": {"en": 'Presiona para ver los detalles'},
                    "data": {
                      "messageId": 'solicitud:' + notificationId,
                    }
                  }),
                ).whenComplete(() => print('notification creada: ' +
                    devices.toSet().toList().toString() +
                    ' / ' +
                    notificationId));

                // await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WaitingPage()), (Route<dynamic> route) => false);
              });
            } catch (onError) {
              print(onError);
            }
          },
        ),
        ListTile(
          title: const Text("DEVICE"),
          onTap: () async {
            var device = await OneSignal.shared.getDeviceState();
            print('THIS DEVICE:');
            print(device?.userId);

            showMyDialog(device?.userId, context);
          },
        ),
        ListTile(
          title: const Text("WAI"),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => WaitingPage())),
        ),
        ListTile(
          title: const Text('role'),
          onTap: () => showMyDialog('role: ' + role, context),
        ),
        // ListTile(
        //   title: const Text("request"),
        //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RequestPage('N2PgdOdNaeH3DZbmarks'))),
        // ),
        ListTile(
          title: const Text("FB LOGIN"),
          onTap: () async {
            try {
              FocusScope.of(context).unfocus();
              final userData;
              print('0');
              // final LoginResult result = await FacebookAuth.instance.login().onError((error, stackTrace) {
              //   throw UnimplementedError();
              // });
              // final LoginResult result = await FacebookAuth.instance.expressLogin();
              // final facebookSignIn = FacebookLogin();
              // facebookSignIn.loginBehavior = FacebookLoginBehavior.webOnly;
              final LoginResult result = await FacebookAuth.instance.login();
              print('Token: ' + result.accessToken!.token);
              print('1');
              final AuthCredential facebookCredential =
                  FacebookAuthProvider.credential(result.accessToken!.token);
              print('2');
              final usercredential = await FirebaseAuth.instance
                  .signInWithCredential(facebookCredential);
              loggedWith = 3;
              print('3: ' + loggedWith.toString());
              userData = await FacebookAuth.instance.getUserData();
              print('4');
              _userData = userData;
              userFacebook = _userData;
              print(_userData);

              print('5');

              bool uidd = FirebaseAuth.instance.currentUser!.uid.isNotEmpty;
              String uidString = FirebaseAuth.instance.currentUser!.uid;

              print(uidd);
              print(uidString);
              //UPDATE DEVICE
              if (uidd) {
                var getdevice = await OneSignal.shared.getDeviceState();
                device = getdevice?.userId;
                // errDevice = device!;

                print('update device: ' + device!);
                await FirebaseFirestore.instance
                    .collection('e_legal')
                    .doc('conf')
                    .collection('users')
                    .doc(uidString)
                    .update({'metadata.device': device}).catchError(
                        (onError) async {
                  print(onError);
                  switch (onError
                      .toString()
                      .substring(1, onError.toString().indexOf(']'))) {
                    case 'firebase_auth/wrong-password':
                      showMyDialog(
                          'Contraseña incorrecta.\nPorfavor revisa tu contraseña',
                          context);
                      break;
                    case 'cloud_firestore/not-found':
                      print('Usuario no existe');
                      await FirebaseChatCore.instance
                          .createUserInFirestore(
                        types.User(
                          firstName: userFacebook!['name'].toString().substring(
                              0, userFacebook!['name'].toString().indexOf(' ')),
                          id: FirebaseAuth.instance.currentUser!.uid,
                          role: types.Role.user,
                          metadata: {'phone': '', 'device': device},
                          imageUrl: userFacebook!['picture']['data']['url'],
                          lastName: userFacebook!['name'].toString().substring(
                              userFacebook!['name'].toString().indexOf(' '),
                              userFacebook!['name'].toString().length),
                        ),
                      )
                          .whenComplete(() async {
                        loggedWith = 3;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('logged', 'yes');
                        print('final');
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/welcome', (Route<dynamic> route) => false);
                      });
                      break;
                    default:
                      break;
                  }
                });
              }

              loggedWith = 3;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('logged', 'yes');
              print('final');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/welcome', (Route<dynamic> route) => false);
            } catch (e) {
              print('Error: $e'); // Prints 401.

              FirebaseFirestore.instance.collection('bugs').add({
                'date': DateTime.now().toString(),
                'bug': e.toString(),
                'page': 'login with facebook',
                'device': device!
              });

              if (e.toString() != 'Null check operator used on a null value') {
                print('err1');
                switch (e.toString().substring(1, e.toString().indexOf(']'))) {
                  case 'firebase_auth/wrong-password':
                    showMyDialog(
                        'Contraseña incorrecta.\nPorfavor revisa tu contraseña',
                        context);
                    break;
                  // case 'cloud_firestore/not-found':
                  //   showMyDialog(
                  //       'Usuario no identificado\nSi es la primera vez que ingresas, accede a la sección registrar',
                  //       context);
                  //   break;
                  default:
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                        content: Text(
                            'Revisa tu cuenta y tu contraseña.\nCódigo de error: ' +
                                e.toString()
                            // e.toString(),
                            ),
                        title: const Text('Error de autentificación'),
                      ),
                    );
                    break;
                }
              } else {
                print('err2');
                showMyDialog(
                    'Versión de android incompatible\n Intenta ingresar con tu correo',
                    context);
              }
            }
          },
        ),
        ListTile(
          title: const Text("NOTI"),
          onTap: () async {
            try {
              List<String> devices = [];

              await FirebaseFirestore.instance
                  .collection('e_legal')
                  .doc('conf')
                  .collection('users')
                  .snapshots()
                  .forEach((element) async {
                if (devices.length == 0) {
                  for (var i = 0; i < element.docs.length; ++i) {
                    DocumentSnapshot ds = element.docs[i];
                    if (ds['role'] == 'agent') {
                      // print('-----------------');
                      // print(ds.id);
                      // print(ds['firstName']);
                      devices.add(ds['metadata.device']);
                    }
                  }

                  // print('Lista de abogados' + devices.toString());
                  // print('sin duplicados');
                  // print(devices.toSet().toList());
                  //
                  // var device = await OneSignal.shared.getDeviceState();
                  // print('THIS DEVICE:');
                  // print(device?.userId);
                  //
                  // String? tstdevice = device?.userId;
                  //
                  // devices.add(tstdevice!);

                  //ENVIAR NOTIFICACION A ABOGADOS
                  await post(
                    Uri.parse('https://onesignal.com/api/v1/notifications'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      "app_id": OneSignalId,
                      "include_player_ids": devices.toSet().toList(),
                      "android_accent_color": "green",
                      "small_icon": "icon",
                      "headings": {"en": 'Nueva solicitud'},
                      "contents": {"en": 'Presiona para ver los detalles'},
                      "data": {"messageId": 'Notificacion de abogados'}
                    }),
                  ).whenComplete(() => print('not creada'));

                  // var abogado = Random();
                  // int abogadoIndice = abogado.nextInt(typeList.length);
                  //
                  // print(abogadoIndice.toString() + ' ' + 'abogado: ' + typeList[abogadoIndice]);
                  //
                  // types.User? lawyer;
                  //
                  // lawyer = types.User(
                  //     id: typeList[abogadoIndice],
                  //     // imageUrl: 'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Ffolder-icon.png?alt=media&token=eda3575c-4a95-42ee-944d-e21ee7f4f869'
                  // );
                  //
                  // final room = await FirebaseChatCore.instance.createRoom(lawyer);
                  //
                  // await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(room.id)
                  //     .update({
                  //       'status': 'active',
                  //       'paymentId': widget.payId,
                  //       'statusPayment': 'pagado',
                  //       'imageUrl' : 'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Ffolder-icon.png?alt=media&token=eda3575c-4a95-42ee-944d-e21ee7f4f869'
                  //     });

                  // await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(room.id).collection('infoUser').add({
                  //   'nombre': widget.nombreUser,
                  //   'telefono': widget.telefonoUser,
                  //   'categoria': widget.categoryUser,
                  //   'description': widget.descriptionUser
                  // });

                  //CREAR NOTIFICACIÓN LOCAL
                  // AwesomeNotifications().createNotification(
                  //   schedule: NotificationCalendar.fromDate(date: DateTime.now().add(const Duration(seconds: 5))),
                  //   // schedule: NotificationCalendar.fromDate(date: DateTime.now()),
                  //   content: NotificationContent(
                  //     id: 1,
                  //     channelKey: 'basic_channel',
                  //     title: '¡Tu abogado ha sido asignado!',
                  //     body: 'Tu asesoría ha iniciado',
                  //     wakeUpScreen: true,
                  //     category: NotificationCategory.Message,
                  //     autoDismissible: false,
                  //     hideLargeIconOnExpand: true,
                  //   ),
                  //   // actionButtons: [
                  //   //   NotificationActionButton(
                  //   //       key: 'REPLY',
                  //   //       label: '¿Qué almorzarás hoy?',
                  //   //       enabled: true,
                  //   //       buttonType: ActionButtonType.InputField,
                  //   //       icon: 'asset://assets/icon-app.png'
                  //   //   )
                  //   // ],
                  // ).whenComplete(() => print('creada 1'));
                  print('finalizado');
                  // await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  //     WaitingPage()), (Route<dynamic> route) => false);
                }
              });
            } catch (onError) {
              print(onError);
            }
          },
        ),
        ListTile(
          title: const Text("¿Cómo usar?"),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainTutorialPage())),
        ),
      ],
    );
  } else {
    return SizedBox.shrink();
  }
}

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

_delAccount(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          '¿Realmente quieres eliminar tu cuenta?',
          textAlign: TextAlign.center,
        ),
        /* content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                controller: _confirmationController2,
              ),
            ],
          ),
        ), */
        actions: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('SI'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('e_legal')
                        .doc('conf')
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .delete();

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('logged');

                    await FirebaseAuth.instance.currentUser!
                        .delete()
                        .whenComplete(() => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false));
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
