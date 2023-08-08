import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegal/perfil/lawyer_profile.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elegal/helpers/global_functions.dart';
import 'package:elegal/src/custom_chat.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';


class AdminPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdminPageState();
  }

}

class _AdminPageState extends State<AdminPage> {


  String chatRoom = '';
  bool chatContainer = false;

  final TextEditingController _nameController = TextEditingController();
  bool showImage = false;
  String urlImage = '', title = '';

  bool _isAttachmentUploading = false;

  types.Room room = const types.Room(
      id: '',
      imageUrl: '',
      type: types.RoomType.direct,
      users: []
  );

void updateList(String value){

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(child:
          Column(
            children: [
Text("Buscar usuario", style: TextStyle(color: Colors.black, fontSize: 22.0,
),
),
              SizedBox(height: 20.0,),
              TextField( decoration: InputDecoration(filled: true, fillColor: Colors.white24, border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
                hintText: "ID",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.black,
              ),
              ),
              SizedBox(height: 20.0,),


              ///agregar introducir texto y cambiar los valores del where de cada consulta
              ///irasema > usuario en auth > uuid > guardar variable

              Text('Chats Activos'),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms')
                    .orderBy('createdAt', descending: true) .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {




                  if(snapshot.connectionState == ConnectionState.done) {

                    for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                      return SingleChildScrollView(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {

                              if(snapshot.connectionState == ConnectionState.done){

                                DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                  return Center(
                                      child: Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                                          clipBehavior: Clip.none,
                                          margin: const EdgeInsets.only(top: 8),
                                          child: ListTile(
                                              onTap: () async {
                                                try {

                                                  // FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/rooms', '/e_legal/conf/users');
                                                  //
                                                  // await Fireba
                                                  // seChatCore.instance.room(ds.id).first.then((value) {
                                                  //   print(value.id);
                                                  //   setState((){
                                                  //     room = value;
                                                  //     chatRoom = ds.id;
                                                  //   });
                                                  // });

                                                } catch(onError){
                                                  print(onError);

                                                }
                                              },
                                              title: Text('Código de chat: ' + ds.id,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11),),
                                              subtitle: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                      child: Image.network('https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),

                                                        Text('abogado',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black),),
                                                        Text('user',
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black26),),
                                                        Text('list',
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black26),),

                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                          )));





                              }


                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator(),);
                              }

                              return const SizedBox.shrink();

                            }),
                      );
                    }
                  }

                  if(snapshot.hasError){
                    return const SizedBox.shrink();
                  }

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }


                  return const SizedBox.shrink();

                },
              ),


              Text('chats inactivos'),
          FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('history')

                    .orderBy('createdAt', descending: true) .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if(snapshot.connectionState == ConnectionState.done) {
                    for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                      return SingleChildScrollView(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {

                              if(snapshot.connectionState == ConnectionState.done){

                                DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];





                                  return Center(
                                      child: Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                                          clipBehavior: Clip.none,
                                          margin: const EdgeInsets.only(top: 8),
                                          child: ListTile(
                                              onTap: () async {
                                                try {

                                                  // FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/history', '/e_legal/conf/users');
                                                  //
                                                  // await FirebaseChatCore.instance.room(ds.id).first.then((value) {
                                                  //   print(value.id);
                                                  //   setState((){
                                                  //     room = value;
                                                  //     chatRoom = ds.id;
                                                  //   });
                                                  // });

                                                } catch(onError){
                                                  print(onError);
                                                }
                                              },
                                              title: Text('Código de chat: ' + ds.id,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11),),
                                              subtitle: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                      child: Image.network('https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),
                                                        Text('abogado',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black),),
                                                        Text('user',
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black26),),
                                                        Text('list',
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black26),),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                          )));


                              }

                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator(),);
                              }

                              return const SizedBox.shrink();

                            }),
                      );
                    }
                  }

                  if(snapshot.hasError){
                    return const SizedBox.shrink();
                  }

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  return const SizedBox.shrink();

                },
              ),




              Text('Usuarios'),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users')
                    .orderBy('createdAt', descending: true) .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if(snapshot.connectionState == ConnectionState.done) {
                    for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                      return SingleChildScrollView(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {

                              if(snapshot.connectionState == ConnectionState.done){

                                DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                String userChatId1, userChatId2, nameChat;

                                try
                                {
                                  String mapPayment = ds['userIds'].toString().replaceFirst('[', '');
                                  var _listPayment = mapPayment.split(',').toList(); // .values.toList();
                                  userChatId1 = _listPayment[0];
                                  userChatId2 = _listPayment[1].replaceFirst(' ', '');
                                  userChatId2 =  userChatId2.replaceAll(']', '');
                                } catch(onError) {
                                  print('Error Pagos: ' + onError.toString());
                                  userChatId1 = 'sin chats';
                                  userChatId2 = 'sin chats';
                                }

                                if(userChatId1 == FirebaseAuth.instance.currentUser!.uid || userChatId2 == FirebaseAuth.instance.currentUser!.uid) {

                                  try{
                                    nameChat = ds['name'];
                                  } catch(onError) {
                                    nameChat = 'Chat sin nombre';
                                  }

                                  return Center(
                                      child: Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                                          clipBehavior: Clip.none,
                                          margin: const EdgeInsets.only(top: 8),
                                          child: ListTile(
                                              onTap: () async {
                                                try {

                                                  // FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/history', '/e_legal/conf/users');
                                                  //
                                                  // await FirebaseChatCore.instance.room(ds.id).first.then((value) {
                                                  //   print(value.id);
                                                  //   setState((){
                                                  //     room = value;
                                                  //     chatRoom = ds.id;
                                                  //   });
                                                  // });

                                                } catch(onError){
                                                  print(onError);
                                                }
                                              },
                                              title: Text('Código de chat: ' + ds.id,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11),),
                                              subtitle: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                      child: Image.network('https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),
                                                        Text('abogado',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black),),
                                                        Text('user',
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black26),),
                                                        Text('list',
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black26),),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                          )));

                                } else {
                                  return SizedBox.shrink();

                                }

                              }

                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator(),);
                              }

                              return const SizedBox.shrink();

                            }),
                      );
                    }
                  }

                  if(snapshot.hasError){
                    return const SizedBox.shrink();
                  }

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  return const SizedBox.shrink();

                },

              ),
              // Flexible(
              //   flex: 3,
              //   child: _body(chatRoom),
              // ),
            ],
          ),),
      )
    );
  }
  // _body(chatRoom){
  //   if(chatRoom.toString().isEmpty){
  //     return SizedBox(
  //         width: MediaQuery.of(context).size.width * 0.70,
  //         child: Center(
  //             child: Image.asset('assets/recibo_logo.png', height: 160,)
  //         )
  //     );
  //   } else {
  //     FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/history', '/e_legal/conf/users');
  //     print('ROOM BUILD: ' + room.id);
  //     return Container(
  //         color: Colors.white,
  //         width: MediaQuery.of(context).size.width,
  //   child: Center(
  //   child: StreamBuilder<types.Room>(
  //   initialData: room,
  //   stream: FirebaseChatCore.instance.room(room.id),
  //   builder: (context, snapshot) {
  //   print('roomid');
  //   return StreamBuilder<List<types.Message>>(
  //   initialData: const [],
  //   stream: FirebaseChatCore.instance.messages(snapshot.data!),
  //   builder: (context, snapshot) {
  //   print('room');
  //   return SafeArea(
  //   bottom: false,
  //   child: Column(
  //   children: [
  //
  //   Container(
  //   width: double.infinity,
  //   height: 45,
  //   color: Colors.black,
  //   child: Row(
  //   children: [
  //   chatContainer ? IconButton(onPressed: (){
  //   setState((){
  //   chatContainer = false;
  //   });
  //   }, icon: Icon(Icons.arrow_back, color: Colors.white,), iconSize: 22,) : SizedBox.shrink(),
  //   GestureDetector(
  //   onTap: (){
  //   if(chatContainer){
  //   setState((){
  //   chatContainer = true;
  //   });
  //   } else {
  //   setState((){
  //   chatContainer = true;
  //   });
  //   }
  //
  //   },
  //   child: const Padding(
  //   padding: EdgeInsets.only(left: 15, top: 10),
  //   child: Text('Chateando con un abogado', style: TextStyle(color: Colors.white, fontSize: 20),),
  //     ),
  //     ),
  //
  //     ],
  //     ),
  //     ),
  //   ],
  //   ),
  //     );
  //   },
  //   );
  //   },
  //   ))
  //     );
  //   }
  // }

}

