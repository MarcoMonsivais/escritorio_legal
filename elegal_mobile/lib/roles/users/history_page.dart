import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/chat/chat.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:e_legal/wid/global_functions.dart';

class HistoryPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }

}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menuLateral(context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF000000),
        title: const Image(
          image: AssetImage('assets/img/navbarlogo.png'),
          width: 45.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {

          });
        },
        tooltip: 'Actualiza el historial aquí',
        backgroundColor: Colors.black,
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: SingleChildScrollView(
              child: Column(
                children: [

                  const Text('Chats activos', style: TextStyle(fontSize: 26), textAlign: TextAlign.left,),

                  FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('e_legal')
                          .doc('conf')
                          .collection('rooms')
                          .get(),
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

                                    String userChatId1, userChatId2;
                                    String theLawyer = '';

                                    try
                                    {
                                      String mapPayment = ds['userIds'].toString().replaceFirst('[', '');
                                      var _listPayment = mapPayment.split(',').toList(); // .values.toList();
                                      userChatId1 = _listPayment[0];
                                      userChatId2 = _listPayment[1].replaceFirst(' ', '');
                                      userChatId2 =  userChatId2.replaceAll(']', '');

                                      if(userChatId1 != FirebaseAuth.instance.currentUser!.uid){
                                        theLawyer = userChatId1;
                                      } else {
                                        theLawyer = userChatId2;
                                      }

                                    } catch(onError) {
                                      print('Error Pagos: ' + onError.toString());
                                      userChatId1 = 'sin chats';
                                      userChatId2 = 'sin chats';
                                    }

                                    if(userChatId1 == FirebaseAuth.instance.currentUser!.uid || userChatId2 == FirebaseAuth.instance.currentUser!.uid) {

                                    return Center(
                                        child: Container(
                                            padding: const EdgeInsets.only(bottom: 5,top: 5,left: 5,right: 5),
                                            clipBehavior: Clip.none,
                                            margin: const EdgeInsets.only(top: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,),
                                              borderRadius: const BorderRadius.all(Radius.circular(20))
                                            ),
                                            child: ListTile(
                                                onTap: () async {
                                                  try {

                                                    FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal','/e_legal/conf/rooms', '/e_legal/conf/users');

                                                    FirebaseChatCore.instance.room(ds.id).first.then((value) async {
                                                      await Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => ChatPage(
                                                            isHistory: false,
                                                            room: value,
                                                          ),
                                                        ),
                                                      );
                                                    });

                                                  } catch (onError) {
                                                    print(onError);
                                                  }
                                                },
                                                //COPIAR CODIGO
                                                title: Text(
                                                  'Código de chat: ' + ds.id,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 11),
                                                    ),
                                                subtitle: StreamBuilder<DocumentSnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('e_legal/conf/users').doc(theLawyer).snapshots(),
                                                  builder: (context, snapshot) {

                                                    switch(snapshot.connectionState){
                                                      case ConnectionState.active:
                                                        DocumentSnapshot ds = snapshot.data!;
                                                        print(ds.id);
                                                        return Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 50,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                                child: CircleAvatar(
                                                                  backgroundImage: NetworkImage(
                                                                  ds['imageUrl']
                                                                ),)
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const SizedBox(height: 10,),
                                                                Text(ds['firstName'], style: const TextStyle(fontSize: 18, color: Colors.black),),
                                                                Text('Cédula: ' + ds['cedula'], style: const TextStyle(fontSize: 18, color: Colors.black26),),
                                                            ])
                                                        ]);
                                                      default:
                                                        return SizedBox(
                                                          width: 50,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                            child: Image.network('https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                          ),
                                                        );
                                                    }

                                                  }
                                                )
                                        
                                            )));

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

                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator(),);
                        }

                        return const SizedBox.shrink();

                      }
                  ),

                  const Text('Chats inactivos', style: TextStyle(fontSize: 26), textAlign: TextAlign.left,),

                  FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('e_legal')
                          .doc('conf')
                          .collection('history')
                          .get(),
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

                                    String userChatId1, userChatId2;
                                    String theLawyer = '';

                                    try
                                    {
                                      String mapPayment = ds['userIds'].toString().replaceFirst('[', '');
                                      var _listPayment = mapPayment.split(',').toList(); // .values.toList();
                                      userChatId1 = _listPayment[0];
                                      userChatId2 = _listPayment[1].replaceFirst(' ', '');
                                      userChatId2 =  userChatId2.replaceAll(']', '');
                                      
                                      if(userChatId1 != FirebaseAuth.instance.currentUser!.uid){
                                        theLawyer = userChatId1;
                                      } else {
                                        theLawyer = userChatId2;
                                      }

                                    } catch(onError) {
                                      print('Error Pagos: ' + onError.toString());
                                      userChatId1 = 'sin chats';
                                      userChatId2 = 'sin chats';
                                    }

                                    if(userChatId1 == FirebaseAuth.instance.currentUser!.uid || userChatId2 == FirebaseAuth.instance.currentUser!.uid) {

                                      return Center(
                                        child: Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                                          clipBehavior: Clip.none,
                                          margin: const EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,),
                                              borderRadius: const BorderRadius
                                                  .all(
                                                  Radius.circular(20))
                                          ),
                                          child: ListTile(
                                            onTap: () async {
                                              try {

                                                FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal','/e_legal/conf/history', '/e_legal/conf/users');

                                                FirebaseChatCore.instance.room(ds.id).first.then((value) async {
                                                  await Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => ChatPage(
                                                        isHistory: true,
                                                        room: value,
                                                      ),
                                                    ),
                                                  );
                                                });

                                              } catch (onError) {
                                                print(onError);
                                              }
                                            },
                                            title: Text(
                                              'Código de chat: ' + ds.id,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: Colors.grey, fontSize: 11),),
                                            subtitle: StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance.collection('e_legal/conf/users').doc(theLawyer).snapshots(),
                                              builder: (context, snapshot) {

                                                switch(snapshot.connectionState){
                                                  case ConnectionState.active:
                                                    DocumentSnapshot ds = snapshot.data!;
                                                    return Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                            child: CircleAvatar(
                                                              backgroundImage: NetworkImage(
                                                              ds['imageUrl']
                                                            ),)
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const SizedBox(height: 10,),
                                                            Text(ds['firstName'], style: const TextStyle(fontSize: 18, color: Colors.black),),
                                                            Text('Cédula: ' + ds['cedula'], style: const TextStyle(fontSize: 18, color: Colors.black26),),
                                                        ])
                                                    ]);
                                                  default:
                                                    return SizedBox(
                                                      width: 50,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                        child: Image.network('https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                      ),
                                                    );
                                                }

                                              }
                                            )
                                        
                                        )));

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

                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator(),);
                        }

                        return const SizedBox.shrink();

                      }
                  ),

                ],
              ),
            ),
      ),
    );
  }

}