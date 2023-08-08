import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:e_legal/wid/global_functions.dart';

class LawyerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LawyerPageState();
  }
}

class _LawyerPageState extends State<LawyerPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menuLateral(context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF000000),
        title: GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: const Image(
            image: AssetImage('assets/img/navbarlogo.png'),
            width: 45.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Chats activos',
              style: TextStyle(fontSize: 26),
              textAlign: TextAlign.left,
            ),

            Center(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.85,
                child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('e_legal')
                        .doc('conf')
                        .collection('rooms')
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot<Object?>? ds =
                                      snapshot.data!.docs[index];

                                  String userChatId1, userChatId2;

                                  try {
                                    String mapPayment = ds['userIds']
                                        .toString()
                                        .replaceFirst('[', '');
                                    var _listPayment = mapPayment
                                        .split(',')
                                        .toList(); // .values.toList();
                                    userChatId1 = _listPayment[0];
                                    userChatId2 =
                                        _listPayment[1].replaceFirst(' ', '');
                                    userChatId2 =
                                        userChatId2.replaceAll(']', '');
                                  } catch (onError) {
                                    print('Error Pagos: ' + onError.toString());
                                    userChatId1 = 'sin chats';
                                    userChatId2 = 'sin chats';
                                  }

                                  if (userChatId1 ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid ||
                                      userChatId2 ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                    return Center(
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 15,
                                                top: 15,
                                                left: 5,
                                                right: 5),
                                            clipBehavior: Clip.none,
                                            margin: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: ListTile(
                                                onTap: () async {
                                                  try {
                                                    FirebaseChatCore
                                                            .instance.config =
                                                        const FirebaseChatCoreConfig(
                                                            'escritorio-legal',
                                                            '/e_legal/conf/rooms/',
                                                            '/e_legal/conf/users/');

                                                    FirebaseChatCore.instance
                                                        .room(ds.id)
                                                        .first
                                                        .then((value) async {
                                                      await Navigator.of(
                                                              context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatPage(
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
                                                title: Text(
                                                  'Código de chat: ' + ds.id,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 11),
                                                ),
                                                subtitle: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    StreamBuilder<
                                                            DocumentSnapshot>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'e_legal/conf/users')
                                                            .doc(userChatId2)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          switch (snapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                .active:
                                                              DocumentSnapshot
                                                                  ds = snapshot
                                                                      .data!;
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(ds[
                                                                          'imageUrl']),
                                                                ),
                                                              );
                                                            case ConnectionState
                                                                .waiting:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                            default:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                          }
                                                        }),
                                                    StreamBuilder<
                                                            DocumentSnapshot>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'e_legal/conf/users')
                                                            .doc(userChatId2)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          switch (snapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                .active:
                                                              DocumentSnapshot
                                                                  ds = snapshot
                                                                      .data!;
                                                              return Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      ds['firstName'] +
                                                                          ' ' +
                                                                          ds['lastName'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    Text(
                                                                      ds['metadata']
                                                                          [
                                                                          'mail'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.black26),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            case ConnectionState
                                                                .waiting:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                            default:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                          }
                                                        }),
                                                  ],
                                                ))));
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                          );
                        }
                      }

                      return const SizedBox.shrink();
                    }),
              ),
            ),

            const Text(
              'Chats inactivos',
              style: TextStyle(fontSize: 26),
              textAlign: TextAlign.left,
            ),

            Center(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.85,
                child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('e_legal')
                        .doc('conf')
                        .collection('history')
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot<Object?>? ds =
                                      snapshot.data!.docs[index];

                                  String userChatId1, userChatId2;

                                  try {
                                    String mapPayment = ds['userIds'].toString().replaceFirst('[', '');
                                    var _listPayment = mapPayment.split(',').toList(); // .values.toList();
                                    userChatId1 = _listPayment[0];
                                    userChatId2 = _listPayment[1].replaceFirst(' ', '');
                                    userChatId2 = userChatId2.replaceAll(']', '');
                                  } catch (onError) {
                                    print('Error Pagos: ' + onError.toString());
                                    userChatId1 = 'sin chats';
                                    userChatId2 = 'sin chats';
                                  }

                                  if (userChatId1 == FirebaseAuth.instance.currentUser!.uid ||userChatId2 ==FirebaseAuth.instance.currentUser!.uid) {
                                    return Center(
                                        child: Container(
                                            padding: const EdgeInsets.only(bottom: 15,top: 15,left: 5,right: 5),
                                            clipBehavior: Clip.none,
                                            margin: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                                            child: ListTile(
                                                onTap: () async {
                                                  try {
                                                    
                                                    FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal','/e_legal/conf/history/','/e_legal/conf/users/');

                                                    FirebaseChatCore.instance.room(ds.id).first.then((value) async {
                                                      await Navigator.of(context).push(
                                                        MaterialPageRoute(builder: (context) =>ChatPage(
                                                          isHistory: true,
                                                          room: value,
                                                          ),
                                                        ),
                                                      );
                                                    });

                                                  } catch (onError) {
                                                    print('Error on lawyer' + onError.toString());
                                                  }
                                                },
                                                title: Text(
                                                  'Código de chat: ' + ds.id,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 11),
                                                ),
                                                subtitle: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [ 
                                                    StreamBuilder<DocumentSnapshot>(
                                                        stream: FirebaseFirestore.instance
                                                            .collection('e_legal/conf/users')
                                                            .doc(userChatId2)
                                                            .snapshots(),
                                                        builder: (context,snapshot) {
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.active:
                                                              DocumentSnapshot ds = snapshot.data!;
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 8,bottom: 8,right: 8),
                                                                  child: Image.network(ds['imageUrl']),
                                                                ),
                                                              );
                                                            case ConnectionState.waiting:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                            default:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                          }
                                                        }),
                                                    StreamBuilder<DocumentSnapshot>(
                                                        stream: FirebaseFirestore.instance
                                                            .collection('e_legal/conf/users')
                                                            .doc(userChatId2)
                                                            .snapshots(),
                                                        builder: (context,snapshot) {
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.active:
                                                              DocumentSnapshot ds = snapshot.data!;
                                                              return Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      ds['firstName'] +
                                                                          ' ' +
                                                                          ds['lastName'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    Text(
                                                                      ds['metadata']
                                                                          [
                                                                          'mail'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.black26),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            case ConnectionState.waiting:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                            default:
                                                              return SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image
                                                                      .network(
                                                                          'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Frole-lawyer.png?alt=media&token=7892db20-bf6b-43c5-8d58-f11ab9709764'),
                                                                ),
                                                              );
                                                          }
                                                        }),
                                                  ],
                                                ))));
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                          );
                        }
                      }

                      return const SizedBox.shrink();
                    }),
              ),
            ),

            // const Text('Solicitudes', style: TextStyle(fontSize: 26), textAlign: TextAlign.left,),
            //
            // Center(
            //   child: Container(
            //     margin: const EdgeInsets.all(10.0),
            //     // height: MediaQuery.of(context).size.height * 0.85,
            //     width: MediaQuery.of(context).size.width * 0.85,
            //     // decoration: const BoxDecoration(
            //     //   color: Colors.white,
            //     //   borderRadius: BorderRadius.all(Radius.circular(40.0))
            //     // ),
            //     child: FutureBuilder<QuerySnapshot>(
            //       future: FirebaseFirestore.instance.collection('requests').get(),
            //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //
            //         if(snapshot.connectionState == ConnectionState.done) {
            //           for (var i = 0; i < snapshot.data!.docs.length; ++i) {
            //             print(snapshot.data!.docs.length);
            //             if(snapshot.data!.docs.length>0) {
            //                 return SingleChildScrollView(
            //                   child: ListView.builder(
            //                       physics: const NeverScrollableScrollPhysics(),
            //                       scrollDirection: Axis.vertical,
            //                       shrinkWrap: true,
            //                       itemCount: snapshot.data!.docs.length,
            //                       itemBuilder: (context, index) {
            //                         DocumentSnapshot<Object?>? ds =
            //                             snapshot.data!.docs[index];
            //
            //                         return Center(
            //                             child: Container(
            //                                 padding: const EdgeInsets.only(
            //                                     bottom: 15,
            //                                     top: 15,
            //                                     left: 5,
            //                                     right: 5),
            //                                 clipBehavior: Clip.none,
            //                                 margin: const EdgeInsets.all(4.0),
            //                                 decoration: const BoxDecoration(
            //                                     borderRadius: BorderRadius.all(
            //                                         Radius.circular(20))),
            //                                 child: ListTile(
            //                                   onTap: () async {
            //                                     print('selected request');
            //                                   },
            //                                   leading: Image.asset(
            //                                       'assets/request.png'),
            //                                   title: Text(ds['name'],
            //                                       overflow:
            //                                           TextOverflow.ellipsis),
            //                                   subtitle: Row(
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment
            //                                             .spaceEvenly,
            //                                     children: <Widget>[
            //                                       Expanded(
            //                                         child: Text(
            //                                           'Fecha de creación: ' +
            //                                               ds['date'],
            //                                           overflow:
            //                                               TextOverflow.fade,
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                   // trailing: Text('5'),
            //                                 )));
            //                       }),
            //                 );
            //               } else {
            //                 return const Text('Sin peticiones pendientes');
            //               }
            //             }
            //         }
            //
            //         if(snapshot.connectionState == ConnectionState.waiting){
            //           return const Center(child: CircularProgressIndicator());
            //         }
            //
            //         return const SizedBox.shrink();
            //
            //       }
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
