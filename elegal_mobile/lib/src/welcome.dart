import 'dart:convert';
import 'dart:io' show Platform;

import 'package:e_legal/roles/admin/admin_page.dart';
import 'package:e_legal/roles/lawyer/lawyer_page.dart';
import 'package:e_legal/roles/lawyer/request_page.dart';
import 'package:e_legal/roles/users/history_page.dart';
import 'package:e_legal/src/receipt_page.dart';
import 'package:e_legal/wid/global_functions.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:e_legal/chat/chat.dart';
import 'package:url_launcher/url_launcher.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomeState();
  }
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {

  late Map<String, dynamic> paymentIntentData;
  late String monto;
  String SK = GlobalSK, PK = GlobalPK;

  bool activos = false, registered = false, laboralOp = false;

  bool newNotification = false;
  String nombreUser = '',
      phoneUser = '',
      descriptionUser = '',
      categoryUser = '',
      categoryOp = '';

  PageController _pvController = PageController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _descriptionController = TextEditingController();
  String titleAlert = '';

  List<ProblemList> problemUserList = [
    ProblemList(
        id: 'Laboral',
        description: 'Contrato a un trabajador, despidos, renuncias, etc.'),
    ProblemList(
        id: 'Penal',
        description:
            'Delitos: robo, fraude, homicidio, daños en propiedad ajena, etc.'),
    ProblemList(
        id: 'Civil',
        description: 'Contratos en general, compraventas entre particulares'),
    ProblemList(
        id: 'Mercantil',
        description: 'Títulos de crédito: pagarés, cheques, etc.'),
    ProblemList(
        id: 'Familiar',
        description: 'Juicios sucesorios, juicios de divorcio, etc.'),
    ProblemList(id: 'Otro', description: ''),
    ProblemList(id: 'Lo desconozco', description: ''),
  ];

  // List<ProblemList> locationUserList = [
  //   ProblemList(id: 'Aguascalientes', description: 'AGU'),
  //   ProblemList(id: 'Baja California', description: 'BCN'),
  //   ProblemList(id: 'Baja California Sur', description: 'BCS'),
  //   ProblemList(id: 'Campeche', description: 'CAM'),
  //   ProblemList(id: 'Chiapas', description: 'CHP'),
  //   ProblemList(id: 'Chihuahua', description: 'CHH'),
  //   ProblemList(id: 'Coahuila', description: 'COA'),
  //   ProblemList(id: 'Colima', description: 'COL'),
  //   ProblemList(id: 'Ciudad de México', description: 'DIF'),
  //   ProblemList(id: 'Durango', description: 'DUR'),
  //   ProblemList(id: 'Guanajuato', description: 'GUA'),
  //   ProblemList(id: 'Guerrero', description: 'GRO'),
  //   ProblemList(id: 'Hidalgo', description: 'HID'),
  //   ProblemList(id: 'Jalisco', description: 'JAL'),
  //   ProblemList(id: 'México', description: 'MEX'),
  //   ProblemList(id: 'Michoacán', description: 'MIC'),
  //   ProblemList(id: 'Morelos', description: 'MOR'),
  //   ProblemList(id: 'Nacional', description: 'NAC'),
  //   ProblemList(id: 'Nayarit', description: 'NAY'),
  //   ProblemList(id: 'Nuevo León', description: 'NLE'),
  //   ProblemList(id: 'Oaxaca', description: 'OAX'),
  //   ProblemList(id: 'Puebla', description: 'PUE'),
  //   ProblemList(id: 'Querétaro', description: 'QUE'),
  //   ProblemList(id: 'Quintana Roo', description: 'ROO'),
  //   ProblemList(id: 'San Luis Potosí', description: 'SLP'),
  //   ProblemList(id: 'Sinaloa', description: 'SIN'),
  //   ProblemList(id: 'Sonora', description: 'SON'),
  //   ProblemList(id: 'Tabasco', description: 'TAB'),
  //   ProblemList(id: 'Tamaulipas', description: 'TAM'),
  //   ProblemList(id: 'Tlaxcala', description: 'TLA'),
  //   ProblemList(id: 'Veracruz', description: 'VER'),
  //   ProblemList(id: 'Yucatán', description: 'YUC'),
  //   ProblemList(id: 'Zacatecas', description: 'ZAC'),
  // ];

  List<dynamic> entities = [];
  // String location = '';
  bool isReady = false;

  String showMessage = '0', titleMessage = '', descriptionMessage = '', versionMessage = '';

  late Future<QuerySnapshot> _getRooms;
  late Stream<DocumentSnapshot> _getUserInfo;
  late Stream<QuerySnapshot> _getRequest;

  late Future<QuerySnapshot> _getProducts;
  late Future<QuerySnapshot> _getPromos;

  @override
  void initState() {
    super.initState();

    _getPromos = FirebaseFirestore.instance
        .collection('e_legal')
        .doc('promos')
        .collection('list')
        .where('status', isEqualTo: 'active')
        .get();

    _getProducts = FirebaseFirestore.instance
        .collection('e_legal')
        .doc('products')
        .collection('list')
        .where('status', isEqualTo: 'active')
        .get();



    _getRooms = FirebaseFirestore.instance
        .collection('e_legal')
        .doc('conf')
        .collection('rooms')
        .where('status', isEqualTo: 'active')
        .get();

    _getUserInfo = FirebaseFirestore.instance
        .collection('e_legal')
        .doc('conf')
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    try {
      if (userId == '') {
        userId = FirebaseAuth.instance.currentUser!.uid;
      }

      Stripe.publishableKey = PK;

      FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms/', '/e_legal/conf/users/');

      FirebaseFirestore.instance
          .collection('e_legal')
          .doc('conf')
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {

            role = value['role'];

            if (role == 'agent') {

              entities = value['metadata']['entity'];
              print(entities);
            }

            setState(() {
              entities;
              role;
            });

        }).whenComplete((){

        _getRequest = FirebaseFirestore.instance
            .collection('requests')
            .where('status', isEqualTo: 'active')
            .where('category', whereIn: entities)
            .snapshots();

        setState(() {
          isReady = true;
        });
      });

    } catch (onError) {
      print(onError);
    }

    try {
      FirebaseFirestore.instance
          .collection('e_legal')
          .doc('conf')
          .collection('keys')
          .doc('global')
          .snapshots()
          .forEach((element) {
        showMessage = element['showMessage'];
        descriptionMessage = element['descriptionMessage'];
        titleMessage = element['titleMessage'];
        if (Platform.isAndroid) {
          versionMessage = element['version'];
        } else {
          versionMessage = element['iosVersion'];
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {});

    } catch (onerr) {
      print(onerr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: menuLateral(context),
      floatingActionButton: FloatingActionButton(
        child: role == 'agent'
            ? const Icon(Icons.home)
            : const Icon(Icons.message),
        backgroundColor: Colors.black,
        onPressed: () => role == 'agent'
            ? Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()))
            : Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage())),
      ),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [

              ///TODOS LOS CHATS LABEL
              StreamBuilder<DocumentSnapshot>(
                stream: _getUserInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const SizedBox.shrink();
                  }

                  if (snapshot.connectionState == ConnectionState.active) {
                    DocumentSnapshot ds = snapshot.data!;

                    role = ds['role'];
                    userId = ds.id;
                    userName = ds['firstName'] + ' ' + ds['lastName'];

                    if (role == 'agent') {
                      try {
                        userCedula = ds['cedula'];
                      } catch (on) {
                        userCedula = 'sin cedula';
                      }
                    }

                    if (!(ds['role'] == 'user')) {
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
                                onTap: () => _goto(ds['role']),
                                leading: _imageHeader(ds['role']),
                                title: const Text('Todos los chats',
                                    overflow: TextOverflow.ellipsis),
                                // trailing: Text('5'),
                              )));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }

                  return const Center(
                      child: CircularProgressIndicator());
                },
              ),

              role == 'agent' ? Column(
                children: [

                  ///OBTIENE REQUEST ACORDE AL ESTADO
                  isReady ?
                  StreamBuilder<QuerySnapshot>(
                    stream: _getRequest,
                    builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                                    clipBehavior: Clip.none,
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey,), borderRadius: const BorderRadius.all(Radius.circular(20))),
                                    child: ListTile(
                                        onTap: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestPage(ds.id),),),
                                        title: Text(
                                          'Código de chat: ' + ds.id,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11),
                                        ),
                                        subtitle: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                child: Image.network('https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/notification.png?alt=media&token=b4ed20cb-8f6d-4d8c-acc5-e181412d81ea'),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10,),
                                                  Text(
                                                    ds['name'],
                                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ))));

                              }),
                          );
                        }
                      }

                      return const SizedBox.shrink();
                    }): const SizedBox.shrink(),

                  ///OBTIENE CHATS
                  FutureBuilder<QuerySnapshot>(
                      future: _getRooms,
                      builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                            return SingleChildScrollView(
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                    String userChatId1, userChatId2;
                                    String nameChat;
                                    String theLawyer = '';

                                    try {
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

                                    } catch (onError) {
                                      print('Error Pagos: ' + onError.toString());
                                      userChatId1 = 'sin chats';
                                      userChatId2 = 'sin chats';
                                    }

                                    try {
                                      nameChat = ds['name'];
                                    } catch (onError) {
                                      nameChat =
                                      'Chat sin nombre';
                                    }

                                    if (userChatId1 == userId || userChatId2 == userId) {
                                      return Center(
                                        child: Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                                          clipBehavior: Clip.none,
                                          margin: const EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey,),
                                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                                          child: ListTile(
                                              onTap: () async {
                                                try {

                                                  FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms', '/e_legal/conf/users');

                                                  FirebaseChatCore.instance.room(ds.id).first.then((value) async {
                                                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(isHistory: false, room: value,),),);
                                                  });

                                                } catch (onError) {
                                                  print(
                                                      onError);
                                                }
                                              },
                                              subtitle: StreamBuilder<DocumentSnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('e_legal/conf/users').doc(theLawyer).snapshots(),
                                                  builder: (context, snapshot) {

                                                    switch(snapshot.connectionState){
                                                      case ConnectionState.active:
                                                        DocumentSnapshot ds2 = snapshot.data!;
                                                        print(ds2.id);
                                                        return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 50,
                                                                child: Padding(
                                                                    padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                                    child: CircleAvatar(
                                                                      backgroundImage: NetworkImage(
                                                                          ds2['imageUrl']
                                                                      ),)
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(height: 5,),
                                                                    Text(ds2['firstName'], style: const TextStyle(fontSize: 18, color: Colors.black),),
                                                                    const SizedBox(height: 5,),
                                                                    Text('Correo: ' + ds2['metadata.mail'], overflow: TextOverflow.fade, style: const TextStyle(fontSize: 18, color: Colors.black26),),
                                                                  ]),
                                                              )
                                                            ]);
                                                      default:
                                                        return const SizedBox(
                                                          width: 50,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                            child: CircularProgressIndicator(),
                                                          ),
                                                        );
                                                    }

                                                  }
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
                ],
              ) : Column(
                children: [

                  ///PRODUCTOS
                  FutureBuilder<QuerySnapshot>(
                    future: _getProducts,
                    builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {

                        if (snapshot.data!.docs.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {

                                DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                try {
                                  titleAlert =
                                      ds['alertTitle'];
                                } catch (onError) {
                                  titleAlert =
                                      'Cuentanos tu problema';
                                }

                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 15, top: 15, left: 5, right: 5),
                                    clipBehavior: Clip.none,
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey,),
                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: ListTile(
                                      onTap: () async => Alert(
                                            context:
                                                scaffoldKey
                                                    .currentContext!,
                                            content:
                                                SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.70,
                                              child:
                                                  PageView(
                                                controller:
                                                    _pvController,
                                                scrollDirection:
                                                    Axis.vertical,
                                                children: <
                                                    Widget>[
                                                  Stack(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                              width: MediaQuery.of(context).size.width * 0.85,
                                                              child: Text(
                                                                ds['alertTitle'],
                                                                style: const TextStyle(fontSize: 20),
                                                                textAlign: TextAlign.center,
                                                              )),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 130,
                                                            child: Image.network(ds['img']),
                                                          ),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          Text(
                                                            ds['headerdetails'],
                                                            style: const TextStyle(fontSize: 13),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            ds['details'],
                                                            style: const TextStyle(fontSize: 13),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SingleChildScrollView(
                                                    child:
                                                        Column(
                                                      children: [
                                                        const Text(
                                                          'Cuéntanos de tu problema',
                                                          style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const Text(
                                                          'Antes de iniciar, nos gustaría conocer sobre tu problema legal, ¿Consideras que tu asunto es sobre alguno de los siguientes temas?',
                                                          style: TextStyle(fontSize: 11, fontStyle: FontStyle.normal),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: FindDropdown<ProblemList>(
                                                            selectedItem: ProblemList(id: 'Categoria', description: 'Categoría'),
                                                            items: problemUserList,
                                                            showSearchBox: false,
                                                            onChanged: (ProblemList? data) => categoryOp = data!.id,
                                                            dropdownItemBuilder: (BuildContext context, ProblemList item, bool isSelected) {
                                                              return Container(
                                                                decoration: !isSelected
                                                                    ? null
                                                                    : BoxDecoration(
                                                                        border: Border.all(color: Theme.of(context).primaryColor),
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        color: Colors.white,
                                                                      ),
                                                                child: ListTile(
                                                                  selected: isSelected,
                                                                  title: Text(item.id),
                                                                  subtitle: Text(item.description),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const Text(
                                                          'Agrega detalles de tu problema',
                                                          style: TextStyle(fontSize: 11, fontStyle: FontStyle.normal),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.75,
                                                          child: TextField(
                                                            controller: _descriptionController,
                                                            maxLines: 4,
                                                            autocorrect: false,
                                                            decoration: const InputDecoration(
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(8),
                                                                ),
                                                              ),
                                                              labelText: 'Descripción',
                                                              labelStyle: TextStyle(color: Colors.black),
                                                            ),
                                                            keyboardType: TextInputType.text,
                                                            textCapitalization: TextCapitalization.sentences,
                                                            textInputAction: TextInputAction.next,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            buttons: [
                                              DialogButton(
                                                color: Colors.black,
                                                onPressed: () async {
                                                  if (_pvController.page?.toInt() == 0) {
                                                    _pvController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                                                    setState(() {
                                                      titleAlert = 'Cuentanos de tu problema';
                                                    });
                                                  } else {
                                                    if (categoryOp != '' && _descriptionController.text != '') {
                                                      Navigator.of(scaffoldKey.currentContext!).pop();

                                                      try {
                                                        await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                          nombreUser = value['firstName'] + ' ' + value['lastName'];
                                                          phoneUser = value['metadata']['phone'];
                                                        });
                                                      } catch (onerr) {
                                                        nombreUser = 'Dato Erroneo';
                                                        phoneUser = 'Dato Erroneo';
                                                        print('Error: ' + onerr.toString());
                                                      }

                                                      categoryUser = categoryOp;
                                                      descriptionUser = _descriptionController.text;

                                                      _descriptionController.clear();
                                                      categoryOp = '';

                                                      setState(() => monto = ds['price'] + '00');

                                                      makePayment(0);
                                                    } else {
                                                      showMyDialog('Hacen falta datos por llenar. Favor de revisarse', scaffoldKey.currentContext);
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  "ACEPTAR",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20
                                                  ),
                                                ),
                                              ),
                                            ]).show(),
                                      leading: Image.network(ds['img']),
                                      title: Text(ds['name'],overflow: TextOverflow.ellipsis),
                                      subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              ds['description'],
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          Text(
                                            '\$' + ds['price'],
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                      // trailing: Text('5'),
                                    )));
                              }),
                          );
                        }
                      }

                      if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),

                  ///PROMOCIONES
                  FutureBuilder<QuerySnapshot>(
                    future: _getPromos,
                    builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {

                        if (snapshot.data!.docs.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                  try {
                                    titleAlert = ds['alertTitle'];
                                  } catch (onError) {
                                    titleAlert = 'Cuentanos tu problema';
                                  }

                                  return Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 15, top: 15, left: 5, right: 5),
                                      clipBehavior: Clip.none,
                                      margin: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey,), borderRadius: const BorderRadius.all(Radius.circular(20))),
                                      child: Stack(
                                        children: [
                                          ListTile(
                                            onTap: () async => Alert(
                                                  context:
                                                      scaffoldKey
                                                          .currentContext!,
                                                  content:
                                                      SizedBox(
                                                    height:
                                                        MediaQuery.of(context).size.height * 0.50,
                                                    width:
                                                        MediaQuery.of(context).size.width * 0.70,
                                                    child:
                                                        PageView(
                                                      controller:
                                                          _pvController,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      children: <Widget>[
                                                        Stack(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                    width: MediaQuery.of(context).size.width * 0.85,
                                                                    child: Text(
                                                                      ds['alertTitle'],
                                                                      style: const TextStyle(fontSize: 20),
                                                                      textAlign: TextAlign.center,
                                                                    )),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                  height: 130,
                                                                  child: Image.network(ds['img']),
                                                                ),
                                                                const SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Text(
                                                                  ds['headerdetails'],
                                                                  style: const TextStyle(fontSize: 13),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  ds['details'],
                                                                  style: const TextStyle(fontSize: 13),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                'Cuéntanos de tu problema',
                                                                style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Antes de iniciar, nos gustaría conocer sobre tu problema legal, ¿Consideras que tu asunto es sobre alguno de los siguientes temas?',
                                                                style: TextStyle(fontSize: 11, fontStyle: FontStyle.normal),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: FindDropdown<ProblemList>(
                                                                  selectedItem: ProblemList(id: 'Categoria', description: 'Categoría'),
                                                                  items: problemUserList,
                                                                  showSearchBox: false,
                                                                  onChanged: (ProblemList? data) => categoryOp = data!.id,
                                                                  dropdownItemBuilder: (BuildContext context, ProblemList item, bool isSelected) {
                                                                    return Container(
                                                                      decoration: !isSelected
                                                                          ? null
                                                                          : BoxDecoration(
                                                                              border: Border.all(color: Theme.of(context).primaryColor),
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Colors.white,
                                                                            ),
                                                                      child: ListTile(
                                                                        selected: isSelected,
                                                                        title: Text(item.id),
                                                                        subtitle: Text(item.description),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              // const Text(
                                                              //   '¿De qué estado es tu caso?',
                                                              //   style: TextStyle(fontSize: 11, fontStyle: FontStyle.normal),
                                                              //   textAlign: TextAlign.center,
                                                              // ),
                                                              // Padding(
                                                              //   padding: const EdgeInsets.all(8.0),
                                                              //   child: FindDropdown<ProblemList>(
                                                              //     selectedItem: ProblemList(id: 'Estado', description: 'Estado'),
                                                              //     items: locationUserList,
                                                              //     showSearchBox: false,
                                                              //     onChanged: (ProblemList? data) => locationOp = data!.id,
                                                              //     dropdownItemBuilder: (BuildContext context, ProblemList item, bool isSelected) {
                                                              //       return Container(
                                                              //         decoration: !isSelected
                                                              //             ? null
                                                              //             : BoxDecoration(
                                                              //                 border: Border.all(color: Theme.of(context).primaryColor),
                                                              //                 borderRadius: BorderRadius.circular(5),
                                                              //                 color: Colors.white,
                                                              //               ),
                                                              //         child: ListTile(
                                                              //           selected: isSelected,
                                                              //           title: Text(item.id),
                                                              //           subtitle: Text(item.description),
                                                              //         ),
                                                              //       );
                                                              //     },
                                                              //   ),
                                                              // ),
                                                              // const SizedBox(
                                                              //   height: 10,
                                                              // ),
                                                              const Text(
                                                                'Agrega detalles de tu problema',
                                                                style: TextStyle(fontSize: 11, fontStyle: FontStyle.normal),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.75,
                                                                child: TextField(
                                                                  controller: _descriptionController,
                                                                  maxLines: 4,
                                                                  autocorrect: false,
                                                                  decoration: const InputDecoration(
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                                    ),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(8),
                                                                      ),
                                                                    ),
                                                                    labelText: 'Descripción',
                                                                    labelStyle: TextStyle(color: Colors.black),
                                                                  ),
                                                                  keyboardType: TextInputType.text,
                                                                  textCapitalization: TextCapitalization.sentences,
                                                                  textInputAction: TextInputAction.next,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  buttons: [
                                                    DialogButton(
                                                      color:
                                                          Colors.black,
                                                      onPressed:
                                                          () {
                                                        if (_pvController.page?.toInt() == 0) {
                                                          _pvController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                                                          setState(() {
                                                            titleAlert = 'Cuentanos de tu problema';
                                                          });
                                                        } else {
                                                          if (categoryOp != '' && _descriptionController.text != '') {
                                                            Navigator.of(scaffoldKey.currentContext!).pop();

                                                            try {
                                                              FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                                                nombreUser = value['firstName'] + ' ' + value['lastName'];
                                                                phoneUser = value['metadata']['phone'];
                                                              });
                                                            } catch (onerr) {
                                                              nombreUser = 'Dato Erroneo';
                                                              phoneUser = 'Dato Erroneo';
                                                              print('Error: ' + onerr.toString());
                                                            }

                                                            categoryUser = categoryOp;
                                                            descriptionUser = _descriptionController.text;

                                                            _descriptionController.clear();
                                                            categoryOp = '';

                                                            ///V2.03.01
                                                            setState(() => monto = ds['priceOriginal']);
                                                            makePayment(1);
                                                          } else {
                                                            showMyDialog('Hacen falta datos por llenar. Favor de revisarse', scaffoldKey.currentContext);
                                                          }
                                                        }
                                                      },
                                                      child:
                                                          const Text(
                                                        "ACEPTAR",
                                                        style: const TextStyle(color: Colors.white, fontSize: 20),
                                                      ),
                                                    ),
                                                  ]).show(),
                                            leading: Image.network(ds['img']),
                                            title: Text(ds['name'], overflow: TextOverflow.ellipsis),
                                            subtitle: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    ds['description'],
                                                    overflow:
                                                      TextOverflow.fade,
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      ds['price'],
                                                      style: const TextStyle(fontSize: 15, color: Colors.red)
                                                    ),
                                                    Text(
                                                      '\$' + ds['priceOriginal'],
                                                      style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough, color: Colors.blue)
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // trailing: Text(ds['priceOriginal']),
                                          ),
                                        ],
                                      )));
                                }),
                          );
                        }
                      }

                      if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),

                ],
              ),

              versionMessage != currentVer.replaceAll('.', '')
                ? Center(
                    child: Container(
                        padding: const EdgeInsets.only(
                            bottom: 15, top: 15, left: 5, right: 5),
                        clipBehavior: Clip.none,
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20))),
                        child: ListTile(
                          onTap: () async {
                            if (Platform.isAndroid) {
                              await launchUrl(Uri.parse(
                                  'https://play.google.com/store/apps/details?id=com.escritorioabogados.app'));
                            } else {
                              await launchUrl(Uri.parse(
                                  'https://apps.apple.com/mx/app/escritorio-legal/id6444263659'));
                            }
                          },
                          leading: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/upgrad.png?alt=media&token=1ddde2b1-a9e2-4392-8e66-9b72206003a4'),
                          title: const Text('¡Nueva actualización!',
                              overflow: TextOverflow.ellipsis),
                          subtitle: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'Descarga la nueva actualización de nuestra versión',
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          // trailing: Text('5'),
                        )))
                : const SizedBox.shrink(),

            ],
          )
        ),
      )
    );
  }

  _goto(role) {
    switch (role) {
      case 'admin':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminPage()));
        break;
      case 'agent':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LawyerPage()));
        break;
    }
  }

  _imageHeader(role) {
    switch (role) {
      case 'admin':
        return Image.network(
            'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185');
      case 'agent':
        return Image.network(
            'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185');
    }
  }

  Future<void> makePayment(promo) async {
    try {
      if (promo == 1) {
        print(nombreUser + '/' + phoneUser + '/' +  categoryUser + '/' +  descriptionUser);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Reciept('', 'GRATIS', nombreUser, phoneUser, categoryUser, descriptionUser)));
      } else {
        if (PK.isEmpty) {
          await FirebaseFirestore.instance
              .collection('e_legal')
              .doc('conf')
              .collection('keys')
              .doc('items')
              .get()
              .then((val) {
            SK = val.data()!['SK_STRIPE'];
            PK = val.data()!['PK_STRIPE'];
            Stripe.publishableKey = PK;
          });
        }

        String payId = '';
        paymentIntentData = await createPaymentIntent(monto.replaceAll('.', ''), 'MXN');

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['client_secret'],
            applePay: true,
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'MX',
            merchantDisplayName: 'E-Legal'));

        bool op = await displayPaymentSheet();

        op ? Navigator.push(context, MaterialPageRoute(builder: (context) => Reciept(payId, monto, nombreUser, phoneUser, categoryUser, descriptionUser))) : null;
      }
    } catch (e, s) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Error genera de cargo. PK: " +
                    SK.length.toString() +
                    ' SK: ' +
                    SK.length.toString() +
                    '\n\nCódigo: ' +
                    e.toString()),
              ));
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      return false;
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': monto.replaceAll(',', ''),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ' + SK,
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Error al cobrar. Ex: " + err.toString()),
              ));
    }
  }
}
