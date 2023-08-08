import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/src/welcome.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../wid/global_functions.dart';

class DetailChatPage extends StatefulWidget {

  const DetailChatPage({
    Key? key,
    required this.room,
  }) : super(key: key);

  final types.Room room;

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {

  final TextEditingController _nameController = TextEditingController();
  bool showImage = false;
  String urlImage = '', title = '';

  String otherUserImage = 'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185';
  String otherUserName = 'Cargando...';
  String otherUserDescription = 'Cargando...';

  @override
  void initState() {
    // TODO: implement initState
    widget.room.users.forEach((element) { 
      if(element.id != FirebaseAuth.instance.currentUser!.uid){

        try{
          otherUserDescription = element.metadata!['cedula'];
        } catch(err){
          otherUserDescription = '';
        }
        setState(() {
          otherUserImage = element.imageUrl!;
          otherUserName = element.firstName! + ' ' + element.lastName!;
          otherUserDescription;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(otherUserName),
      ),
      body: !showImage ?
      SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text('Imagenes', style: TextStyle(fontSize: 22,),),

                  const SizedBox(height: 5,),

                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('e_legal')
                        .doc('conf')
                        .collection('rooms')
                        .doc(widget.room.id)
                        .collection('messages').where('type', isEqualTo: 'image')
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                      if(snapshot.connectionState == ConnectionState.done) {
                        for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                          return snapshot.data == null
                              ? const Center(child: CircularProgressIndicator(),)
                              : CarouselSlider.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (BuildContext context, index, int) {
                                    for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                                      DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];
                                      return GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            urlImage = ds['uri'];
                                            showImage = true;
                                          });
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width / 4,
                                          child: Image.network(
                                            ds['uri'],
                                            fit: BoxFit.fill,
                                          )),
                                      );
                                    }
                                    return Container();
                                  },
                                  options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    viewportFraction: 0.3,
                                    initialPage: 1,
                                    height: 75,
                                    onPageChanged: (int i, carouselPageChangedReason) {

                                    }));
                        }
                      }

                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(),);
                      }

                      return const Text('Sin imagenes', style: TextStyle(fontSize: 19,),);

                    }
                  ),

                  const SizedBox(height: 10,),

                  const Text('Documentos', style: TextStyle(fontSize: 22,),),

                  const SizedBox(height: 5,),

                  FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('e_legal')
                          .doc('conf')
                          .collection('rooms')
                          .doc(widget.room.id)
                          .collection('messages').where('type', isEqualTo: 'file')
                          .get(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if(snapshot.connectionState == ConnectionState.done) {
                          for (var i = 0; i < snapshot.data!.docs.length; ++i) {

                            return snapshot.data == null
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                ) : CarouselSlider.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (BuildContext context, index, int) {
                                    for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                                      DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];
                                      return SizedBox(
                                        width: MediaQuery.of(context).size.width / 4,
                                        child: Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              const Icon(Icons.insert_drive_file),

                                              Expanded(
                                                child: TextButton(
                                                  child: Text(ds['name'].toString().substring(0,ds['name'].toString().length - 4)),
                                                  onPressed: () {

                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                  options: CarouselOptions(
                                      enableInfiniteScroll: false,
                                      viewportFraction: 0.3,
                                      initialPage: 1,
                                      height: 75,
                                      onPageChanged: (int i, carouselPageChangedReason) {

                                      }));

                          }
                        }

                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        }

                        return const Text('Sin documentos', style: TextStyle(fontSize: 19,),);

                      }
                  ),

                ],
              ),
            ),

            _lawyerView(),

          ],
        ),
      ) :
      Center(
        child: GestureDetector(
          onTap: (){
            setState(() {
              showImage = false;
              urlImage = '';
            });
          },
          child: Container(
            color: Colors.grey,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              width: 250,
              height: 250,
              child: PhotoView(
                imageProvider: NetworkImage(urlImage))
            ),
          ),
        ),
      )

    );
  }

  _lawyerView(){
    if(role == 'agent') {
      return Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 5, thickness: 5,),
            Text('ChatId: ' + widget.room.id, style: TextStyle(fontSize: 15),),
            const SizedBox(height: 5,),
            // const Text('Nombre del chat:'),
            // TextFormField(
            //   controller: _nameController,
            //   onEditingComplete: () async {
            //     await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).update({
            //       'name': _nameController.text
            //     }).whenComplete(() {
            //       setState(() {
            //
            //       });
            //     });
            //   },
            // ),

            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('e_legal')
                    .doc('conf')
                    .collection('rooms')
                    .doc(widget.room.id)
                    .collection('infoUser')
                    .where('status', isEqualTo: 'active')
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
                            for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                              DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // const Divider(height: 5, thickness: 5,),
                                  Text('Nombre: ' + ds['nombre']),
                                  Text('Categoria: ' + ds['categoria']),
                                  Text('Descripción: ' + ds['description']),
                                  Text('Teléfono: ' + ds['telefono']),
                                  // GestureDetector(
                                  //   onTap: () async {
                                  //
                                  //
                                  //
                                  //     // await FirebaseFirestore.instance
                                  //     //     .collection('e_legal')
                                  //     //     .doc('conf')
                                  //     //     .collection('rooms')
                                  //     //     .doc(widget.room.id).collection('infoUser')
                                  //     //     .doc(ds.id)
                                  //     //     .update({
                                  //     //   'status': 'inactive'
                                  //     // }).then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false));
                                  //   },
                                  //   child: Container(
                                  //     color: Colors.black,
                                  //     height: 20,
                                  //     width: 120,
                                  //     child: Text('Terminar caso', style: TextStyle(color: Colors.white),),),),
                                  const SizedBox(height: 5,),

                              ],);
                            }
                            return Container();
                          },

                        ),);
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    }

                    return const Text(
                      'Sin documentos', style: TextStyle(fontSize: 19,),);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  return const Text(
                    'Sin documentos', style: TextStyle(fontSize: 19,),);
                }
            ),

            const SizedBox(height: 5,),
            // TextButton(onPressed: () async {
            //
            //   await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).update({
            //     'status': 'inactive'
            //   }).then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false));
            //
            // },
            //   child: const Text('Terminar chat', style: TextStyle(color: Colors.black),)),
            const SizedBox(height: 5,),
            Center(
              child: GestureDetector(
                child: Container(
                  color: Colors.black,
                  height: 20,
                  width: 120,
                  child: const Center(child: Text('Finalizar chat', style: TextStyle(color: Colors.white),)),
                ),
                onTap: () async {

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Finalizando..."),
                    duration: Duration(milliseconds: 1000),
                  ));

                  var _firestore = FirebaseFirestore.instance;

                  String roomIdTest = widget.room.id;
                  String roomIdOrigin = widget.room.id;
                  print('obtiene rooms');
                  await _firestore
                      .collection('e_legal')
                      .doc('conf')
                      .collection('rooms')
                      .doc(roomIdOrigin)
                      .snapshots().first.then((value) async {
                    print('obtenido');
                    await _firestore
                        .collection('e_legal')
                        .doc('conf')
                        .collection('history')
                        .doc(roomIdTest).set({
                      'createdAt': value.data()!['createdAt'],
                      'imageUrl': value.data()!['imageUrl'],
                      'metadata': null,
                      'name': null,//value.data()!['name'],
                      'paymentId': null,//value.data()!['paymentId'],
                      'status': 'inactive',
                      'statusPayment': value.data()!['statusPayment'],
                      'type': value.data()!['type'],
                      'updatedAt': value.data()!['updatedAt'],
                      'userIds': value.data()!['userIds'],
                      'userRoles': null//value.data()!['userRoles'],
                    });
                  });

                  print('obtiene infoUser');
                  await _firestore
                      .collection('e_legal')
                      .doc('conf')
                      .collection('rooms')
                      .doc(roomIdOrigin)
                      .collection('infoUser')
                      .get().then((value) async {

                    value.docs.forEach((element) async {

                      print('obtenido');
                      await _firestore
                          .collection('e_legal')
                          .doc('conf')
                          .collection('history')
                          .doc(roomIdTest)
                          .collection('infoUser')
                          .doc(element.id).set({
                        'device': element.data()!['data'],
                        'lawyer': element.data()!['lawyer'],
                        'date': element.data()!['date'],
                        'user': element.data()!['user'],
                        'description': element.data()!['description'],
                        'status': element.data()!['status'],
                        'categoria': element.data()!['categoria'],
                        'telefono': element.data()!['telefono'],
                        'nombre': element.data()!['nombre'],
                      });
                      await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).collection('infoUser').doc(element.id).delete();

                    });

                  });

                  print('obtiene messgge');
                  await _firestore
                      .collection('e_legal')
                      .doc('conf')
                      .collection('rooms')
                      .doc(roomIdOrigin)
                      .collection('messages')
                      .get().then((value) async {

                    value.docs.forEach((mss) async {

                      switch(mss.data()['type']){
                        case 'text':
                          print('Mensaje tipo Text');
                          await _firestore
                              .collection('e_legal')
                              .doc('conf')
                              .collection('history')
                              .doc(roomIdTest)
                              .collection('messages')
                              .doc(mss.id).set({
                            'authorId': mss.data()['authorId'],
                            'createdAt': mss.data()['createdAt'],
                            'metadata': mss.data()['metadata'],
                            'previewData': mss.data()['previewData'],
                            'remoteId': mss.data()['remoteId'],
                            'roomId': mss.data()['roomId'],
                            'type': mss.data()['type'],
                            'updatedAt': mss.data()['updatedAt'],
                            'text': mss.data()['text'],
                            'status': mss.data()['status'],

                          });
                          break;
                        case 'custom':
                          print('Mensaje tipo Audio');
                          await _firestore
                              .collection('e_legal')
                              .doc('conf')
                              .collection('history')
                              .doc(roomIdTest)
                              .collection('messages')
                              .doc(mss.id).set({
                            'authorId': mss.data()['authorId'],
                            'createdAt': mss.data()['createdAt'],
                            'metadata': mss.data()['metadata'],
                            'mimeType': mss.data()['mimeType'],
                            'name': mss.data()['name'],
                            'uri': mss.data()['uri'],
                            'remoteId': mss.data()['remoteId'],
                            'roomId': mss.data()['roomId'],
                            'status': mss.data()['status'],
                            'type': mss.data()['type'],
                            'updatedAt': mss.data()['updatedAt'],
                          });
                          break;
                        case 'image':
                          print('Mensaje tipo image');
                          await _firestore
                              .collection('e_legal')
                              .doc('conf')
                              .collection('history')
                              .doc(roomIdTest)
                              .collection('messages')
                              .doc(mss.id).set({
                            'authorId': mss.data()['authorId'],
                            'createdAt': mss.data()['createdAt'],
                            'height': mss.data()['height'],
                            'metadata': mss.data()['metadata'],
                            'size': mss.data()['size'],
                            'width': mss.data()['width'],
                            'type': mss.data()['type'],
                            'updatedAt': mss.data()['updatedAt'],
                            'mimeType': mss.data()['mimeType'],
                            'name': mss.data()['name'],
                            'remoteId': mss.data()['remoteId'],
                            'roomId': mss.data()['roomId'],
                            'uri': mss.data()['uri'],
                            'status': mss.data()['status'],
                          });
                          break;
                        case 'file':
                          print('Mensaje tipo file');
                          await _firestore
                              .collection('e_legal')
                              .doc('conf')
                              .collection('history')
                              .doc(roomIdTest)
                              .collection('messages')
                              .doc(mss.id).set({
                            'authorId': mss.data()['authorId'],
                            'createdAt': mss.data()['createdAt'],
                            'metadata': mss.data()['metadata'],
                            'type': mss.data()['type'],
                            'size': mss.data()['size'],
                            'updatedAt': mss.data()['updatedAt'],
                            'mimeType': mss.data()['mimeType'],
                            'name': mss.data()['name'],
                            'remoteId': mss.data()['remoteId'],
                            'roomId': mss.data()['roomId'],
                            'uri': mss.data()['uri'],
                            'status': mss.data()['status'],
                          });
                          break;
                      }

                      await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).collection('messages').doc(mss.id).delete();
                    });

                  });

                  print('enviado correctamente a historial');

                  await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).delete().whenComplete(() => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false));

                  showMyDialog('El chat se ha enviado al historial correctamente', context);
                  // await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).update({
                  //   'status': 'inactive'
                  // }).then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false));


                },
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
  
}