import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_legal/wid/global_functions.dart';
import 'package:e_legal/src/welcome.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RequestPage extends StatefulWidget{

  final String messageId;

  RequestPage(this.messageId);

  @override
  State<StatefulWidget> createState() {
    return _RequestPageState();
  }

}

class _RequestPageState extends State<RequestPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawer: menuLateral(context),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF000000),
          title: GestureDetector(
            onTap: (){
              setState(() {

              });
            },
            child: const Image(
              image: AssetImage('assets/img/navbarlogo.png'),
              width: 45.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05
                    ),
                    child: const Image(
                      width: 130,
                      height: 150,
                      image: AssetImage('assets/request.png'),
                    )
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,// * 0.85,
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0))
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .doc(widget.messageId)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if(snapshot.connectionState == ConnectionState.active) {
                            DocumentSnapshot ds = snapshot.data!;
                            if(ds.exists) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Text(
                                      'Nueva solicitud de \n' + ds['name'],
                                      style: const TextStyle(fontSize: 27),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    Text(
                                      'ID: ' + ds.id,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    Text(
                                      'Fecha: ' + ds['date'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    Text(
                                      'Telefono: ' + ds['phone'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    Text(
                                      'Categoría: ' + ds['category'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    Text(
                                      'Descripción: ' + ds['description'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Welcome()),
                                                    (Route<dynamic> route) =>
                                                        false),
                                            child: Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                height: 45,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.40,
                                                decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0))),
                                                child: const Center(
                                                    child: Text(
                                                  'PASAR',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              try {

                                                int progress = 0;

                                                ProgressDialog pd = ProgressDialog(context: context);

                                                pd.show(
                                                  hideValue: true,
                                                  max: 30,
                                                  msg: 'Asignando caso...',
                                                  progressBgColor: Colors.transparent,
                                                );

                                                fromNotification = false;
                                                notificationGlobalId = '';

                                                types.User? lawyer;
                                                lawyer = types.User(
                                                  id: ds['user'],
                                                );

                                                FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms/', '/e_legal/conf/users/');

                                                final room = await FirebaseChatCore.instance.createRoom(lawyer);

                                                print('registro en firebase de chat');
                                                await FirebaseFirestore.instance
                                                    .collection('e_legal')
                                                    .doc('conf')
                                                    .collection('rooms')
                                                    .doc(room.id)
                                                    .update({
                                                  'status': 'active',
                                                  'paymentId': '',
                                                  'statusPayment': 'pagado',
                                                  'imageUrl':
                                                  'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Ffolder-icon.png?alt=media&token=eda3575c-4a95-42ee-944d-e21ee7f4f869'
                                                });

                                                print('progress $progress');
                                                progress = progress + 10;
                                                pd.update(value: progress, msg: 'Guardando información...' );
                                                await Future.delayed(const Duration(milliseconds: 1500));

                                                print('reigstro de infoUser');
                                                await FirebaseFirestore.instance
                                                    .collection('e_legal')
                                                    .doc('conf')
                                                    .collection('rooms')
                                                    .doc(room.id)
                                                    .collection('infoUser')
                                                    .add({
                                                  'nombre': ds['name'],
                                                  'telefono': ds['phone'],
                                                  'categoria': ds['category'],
                                                  'description': ds['description'],
                                                  'user': ds['user'],
                                                  'device': ds['device'],
                                                  'lawyer': FirebaseAuth.instance.currentUser!.uid,
                                                  'date': DateTime.now().toString(),
                                                  'status': 'active'
                                                });

                                                print('progress $progress');
                                                progress = progress + 10;
                                                pd.update(value: progress, msg: 'Notificando a cliente' );
                                                await Future.delayed(const Duration(milliseconds: 1500));

                                                print('envio de notificacion');
                                                await post(
                                                  Uri.parse('https://onesignal.com/api/v1/notifications'),
                                                  headers: <String, String>{
                                                    'Content-Type':
                                                    'application/json; charset=UTF-8',
                                                  },
                                                  body: jsonEncode(<String,dynamic>{
                                                    "app_id": OneSignalId,
                                                    "include_player_ids": [
                                                      ds['device']
                                                    ],
                                                    "android_accent_color":
                                                    "green",
                                                    "small_icon": "icon",
                                                    "headings": {
                                                      "en":
                                                      '$userName ha respondido a tu caso'
                                                    },
                                                    "contents": {
                                                      "en":
                                                      'Presiona para comenzar tu asesoría'
                                                    },
                                                    "data": {
                                                      "messageId":
                                                      'response: ' +
                                                          room.id,
                                                    }
                                                  }),
                                                ).whenComplete(() => print('notification creada'));

                                                print('progress $progress');
                                                progress = progress + 10;
                                                pd.update(value: progress, msg: 'Casi listo...' );
                                                // await Future.delayed(const Duration(milliseconds: 1500));

                                                print('eliminacion de request');
                                                print('Nombre: ' + ds['name']);
                                                print('Nombre: ' + ds['name']);
                                                FirebaseFirestore.instance
                                                    .collection('requests')
                                                    .doc(widget.messageId)
                                                    .delete()
                                                    .then((value) => Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => ChatPage(
                                                        isHistory: false,
                                                        room: room,
                                                        ritem: RequestItem(
                                                          name: ds['name'],
                                                          cateroy: ds['category'],
                                                          description: ds['description'],
                                                          phone: ds['phone'],
                                                        )
                                                    )), (Route<dynamic> route) => false));

                                              } catch (onError) {
                                                showMyDialog('Dispositivo de prueba: ' + onError.toString(), context);
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(10.0),
                                              height: 45,
                                              width: MediaQuery.of(context).size.width * 0.40,
                                              decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                              child: const Center(
                                                  child: Text(
                                                'TOMAR',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Center(child: Text('Esta solicitud ya ha sido tomada'),);
                            }
                          }

                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }

                      return const Center(child: CircularProgressIndicator(),);

                    }
                  )
                ),

              ]
          ),
        )
    );
  }


}