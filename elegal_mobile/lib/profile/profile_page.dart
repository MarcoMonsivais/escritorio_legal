import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/chat/chat.dart';
import 'package:e_legal/roles/users/history_page.dart';
import 'package:e_legal/src/receipt_page.dart';
import 'package:e_legal/wid/global_functions.dart';
import 'package:e_legal/wid/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:image_picker/image_picker.dart';

import '../wid/globals.dart';

class ProfilePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }

}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  late File _image;
  bool controlador = false;
  String cedula = 'Cédula';

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('e_legal')
            .doc('conf')
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }

          if(snapshot.connectionState == ConnectionState.active){

            DocumentSnapshot ds = snapshot.data!;

            if(role=='agent'){
              try{
                cedula = ds['cedula'];
              } catch (onerr){
                print('abogado sin cedula');
              }
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget> [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(20))),
                    child: Stack(
                      children: [
                        controlador ?
                        Image.file(_image):
                        Image.network(ds['imageUrl']),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: Container(
                                color: Colors.grey[500],
                                height: 20,
                                width: 120,
                                child: const Center(child: Text('Actualizar', style: TextStyle(color: Colors.white),)),
                              ),
                              onTap: () => _uploadFile(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('ID: ' + FirebaseAuth.instance.currentUser!.uid),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Nombre'),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      hintText: ds['firstName']
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text('Apellidos'),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _apellidoController,
                                  decoration: InputDecoration(
                                      hintText: ds['lastName']
                                  ),
                                ),
                              )
                            ],
                          ),
                          _isLawyer(),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            child: Container(
                              height: 40,
                              width: 400,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(10))),
                              child: const Center(child: Text('Guardar'),),
                            ),
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('e_legal')
                                  .doc('conf')
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid).update({
                                'firstName': ds['firstName'].toString().isEmpty
                                    ? _nameController.text
                                    : _nameController.text.isEmpty
                                    ? ds['firstName']
                                    : _nameController.text,
                                'lastName': ds['lastName'].toString().isEmpty
                                    ? _apellidoController.text
                                    : _apellidoController.text.isEmpty
                                    ? ds['lastName']
                                    : _apellidoController.text,
                              }).whenComplete(() => showMyDialog('Datos actualizados', context));

                              if(role=='agent'){
                                await FirebaseFirestore.instance
                                    .collection('e_legal')
                                    .doc('conf')
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'firstName': ds['firstName'].toString().isEmpty
                                      ? _nameController.text
                                      : _nameController.text.isEmpty
                                      ? ds['firstName']
                                      : _nameController.text,
                                  'lastName': ds['lastName'].toString().isEmpty
                                      ? _apellidoController.text
                                      : _apellidoController.text.isEmpty
                                      ? ds['lastName']
                                      : _apellidoController.text,
                                  'cedula': ds['cedula'].toString().isEmpty
                                      ? _cedulaController.text
                                      : _cedulaController.text.isEmpty
                                      ? ds['cedula']
                                      : _cedulaController.text,
                                });
                              }

                              _nameController.clear();
                              _apellidoController.clear();
                              Focus.of(context).unfocus();

                            },
                          )
                        ],
                      )
                  ),

                ],),
            );
          }

          return const Center(child: CircularProgressIndicator(),);


        },
      ),
    );
  }

  _uploadFile() async {
    try {

      print('************************************************');
      ImagePicker picker = ImagePicker();
      PickedFile pickedFile;

      pickedFile = (await picker.getImage(source: ImageSource.gallery,))!;

      _image = File(pickedFile.path);

      // setState(() {
      //   controlador = true;
      // });
      print(0);
      var ref = FirebaseFirestore.instance
          .collection('e_legal')
          .doc('conf')
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      print(ref.path);

      Reference storageReference = FirebaseStorage.instance.ref().child(ref.path);
      print('SR: ' + storageReference.fullPath);
      UploadTask uploadTask = storageReference.putFile(_image);
      print(1);
      await uploadTask.whenComplete(() => null);
      String returnURL;
      print(2);
      await storageReference.getDownloadURL().then((fileURL) {
        print(fileURL);

        ref.update({
          'imageUrl': fileURL
        });
        returnURL = fileURL;
        setState(() {
          controlador = true;
        });

        showMyDialog('Carga de foto exitosa', context);
      });
      // showMyDialog('Carga de foto exitosa', context);
      print('************************************************');
    }
    catch (onError) {
      print('upload error: ' + onError.toString());
    }
  }

  _isLawyer(){
    if(role=='agent') {
      return Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text('Cédula'),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  controller: _cedulaController,
                  decoration: InputDecoration(hintText: cedula),
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

}

