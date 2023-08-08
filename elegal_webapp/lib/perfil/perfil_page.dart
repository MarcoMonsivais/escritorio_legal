import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/global_functions.dart';
import 'dart:io';

class PerfilPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PerfilPageState();
  }

}

class _PerfilPageState extends State<PerfilPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  late File _image;
  bool controlador = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [

          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('Escritorio Legal', style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                ),
                const SizedBox(width: 550,),
                GestureDetector(
                    onTap: () => setState((){}),
                    child: const Text('Mi cuenta', style: TextStyle(color: Colors.white, fontSize: 16),)),
                GestureDetector(
                  onTap: () => logout(context),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Text('Cerrar sesión', style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: StreamBuilder<DocumentSnapshot>(
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
                                  onTap: () => _handleImageSelection(ds.reference),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
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
                            // _isLawyer(),
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
          ),),

        ],
      ),
    );
  }

  void _handleImageSelection(DocumentReference dsReference) async {
    String path = '';

    final ImagePicker _picker = ImagePicker();

    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1440,
    );

    path = image!.path;

    Uint8List imageData = await XFile(path).readAsBytes();

    final size = imageData.length;
    final name = image.name;

    try {
      final reference = FirebaseStorage.instance.ref('e_legal/conf/users/' +
          FirebaseAuth.instance.currentUser!.uid +
          '/' +
          name);
      await reference.putData(imageData);
      final uri = await reference.getDownloadURL();

      dsReference.update({"imageUrl": uri});
    } catch (onerror) {
      print(onerror);
    }
  }

}