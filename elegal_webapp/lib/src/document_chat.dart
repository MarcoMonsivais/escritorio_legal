import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegal/welcome/welcome.dart';
// import 'package:elegal/helpers/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    try{
      title = widget.room.name!;
    } catch (onError) {
      title = 'Documentos de chat';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title),
      ),
      body: !showImage ?
      SingleChildScrollView(
        child: Column(
          children: [

            Center(child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185',
              height: 150,),),

            const Divider(height: 5,thickness: 5,),

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
    // if(role == 'agent') {
      return Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 5, thickness: 5,),
            Text('ChatId: ' + widget.room.id, style: TextStyle(fontSize: 15),),
            const SizedBox(height: 5,),
            const Text('Nombre del chat:'),
            TextFormField(
              controller: _nameController,
              onEditingComplete: () async {
                await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).update({
                  'name': _nameController.text
                }).whenComplete(() {
                  setState(() {

                  });
                });
              },
            ),

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
                                  const Divider(height: 5, thickness: 5,),
                                  Text('Nombre: ' + ds['nombre']),
                                  Text('Categoria: ' + ds['categoria']),
                                  Text('Descripción: ' + ds['description']),
                                  Text('Teléfono: ' + ds['telefono']),
                                  GestureDetector(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('e_legal')
                                          .doc('conf')
                                          .collection('rooms')
                                          .doc(widget.room.id).collection('infoUser')
                                          .doc(ds.id)
                                          .update({
                                        'status': 'inactive'
                                      }).then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false));
                                    },
                                    child: Container(
                                      color: Colors.black,
                                      height: 20,
                                      width: 120,
                                      child: Text('Terminar caso', style: TextStyle(color: Colors.white),),),),
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

                  await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.room.id).update({
                    'status': 'inactive'
                  }).then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false));


                },
              ),
            ),
          ],
        ),
      );
    // } else {
    //   return const SizedBox.shrink();
    // }
  }
  
}