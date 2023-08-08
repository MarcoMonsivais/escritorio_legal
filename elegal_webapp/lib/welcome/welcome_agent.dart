import 'dart:convert';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegal/helpers/global_functions.dart';
import 'package:elegal/perfil/history_lawyer.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/global.dart';
import '../perfil/lawyer_profile.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import '../src/custom_chat.dart';
import 'package:just_audio/just_audio.dart';

class WelcomeAgent extends StatefulWidget{

  @override
  _WelcomeAgentState createState() => _WelcomeAgentState();

}

class _WelcomeAgentState extends State<WelcomeAgent> {

  bool isTapped = false;

  PageController pvcontroller = PageController();
  int optionPage = 0;

  String titleAlert = '';
  String chatRoom = '';
  String messageId = '';
  bool chatContainer = false;

  final TextEditingController _nameController = TextEditingController();
  bool showImage = false;
  String urlImage = '', title = '';
  String userChatName = '';

  bool _isAttachmentUploading = false;
  types.Room room = const types.Room(
    id: '',
    metadata: {'': ''},
    type: types.RoomType.direct,
    users: [types.User(id: '')],
  );
  late int swapOp = 0;
  int requestCount = 0;
  final Map<String, String> listUser = {'id': 'name'};
  final Map<String, String> listPhoneUser = {'id': 'phone'};
  final Map<String, String> listImgUser = {'id': 'img'};
  String uidUser = '', uidLawyer = '', clientName = '';
  late AudioPlayer player;

  String roomGlobalId = '';
  RequestItem ritem = RequestItem(
    name: 'name',
    cateroy: 'category',
    description: 'description',
    phone: 'phone',
  );

  String caseDescription = 'Cargando...';
  ///V20
  List<dynamic> entities = [];
  String location = '';
  String userId = '';

  @override
  void initState(){
    _getCardLawyer();
    player = AudioPlayer();

    if(userId == ''){
      userId = FirebaseAuth.instance.currentUser!.uid;
    }

    FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').get().then((value) => value.docs.forEach((element) {
      if(element.id==userId){

          entities = element.data()['metadata']['entity'];
          location = element.data()['metadata']['location'];


        setState(() {
          entities;
          location;
        });
      }
    }));
    super.initState();
  }

  _getCardLawyer() async {
    await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').where('role', isEqualTo: 'user').get().then((value) =>
        value.docs.forEach((element) {
          listUser.putIfAbsent(element.id, () => element.data()['firstName'] + ' ' + element.data()['lastName']);
          listPhoneUser.putIfAbsent(element.id, () => element.data()['metadata']['phone']);
          listImgUser.putIfAbsent(element.id, () => element.data()['imageUrl']);
        })
    );
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Foto', style: TextStyle(fontSize: 17, color: Colors.black),),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.picture_in_picture_alt, color: Colors.black,),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Archivo', style: TextStyle(fontSize: 17, color: Colors.black),),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.folder, color: Colors.black,),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Cancelar', style: TextStyle(fontSize: 17, color: Colors.red),),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.cancel, color: Colors.red,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {

    final result = await FilePickerWeb.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false
    );

    _setAttachmentUploading(true);

    Uint8List? imageData = result!.files.first.bytes;

    final size = imageData!.length;
    final name = result.files.first.name;

    try {
      final reference = FirebaseStorage.instance.ref('e_legal/conf/rooms/' + room.id + '/' + name);
      await reference.putData(imageData);
      final uri = await reference.getDownloadURL();

      final message = types.PartialFile(
        name: name,
        size: size,
        uri: uri,
        mimeType: 'application/pdf',
      );

      FirebaseChatCore.instance.sendMessage(
        message,
        room.id,
      );
      _setAttachmentUploading(false);
    } finally {
      _setAttachmentUploading(false);
    }

  }

  void _handleImageSelection() async {

    String path = '';

    final ImagePicker _picker = ImagePicker();

    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1440,
    );

    path = image!.path;

    _setAttachmentUploading(true);

    Uint8List imageData = await XFile(path).readAsBytes();

    final size = imageData.length;
    final name = image.name;

    try {
      final reference = FirebaseStorage.instance.ref('e_legal/conf/rooms/' + room.id + '/' + name);
      await reference.putData(imageData);
      final uri = await reference.getDownloadURL();

      final message = types.PartialImage(
        height: 0,
        name: name,
        size: size,
        uri: uri,
        width: 0,
      );

      FirebaseChatCore.instance.sendMessage(
        message,
        room.id,
      );
      _setAttachmentUploading(false);
    } finally {
      _setAttachmentUploading(false);
    }

  }

  void _handleMessageTap(types.Message message) async {
    // print('message tap ' + message.toString());

    try{
      if (message is types.FileMessage) {
        // print(message.uri);
        await launchUrl(Uri.parse(message.uri));
        // var localPath = message.uri;
        //
        // if (message.uri.startsWith('http')) {
        //   final client = http.Client();
        //   final request = await client.get(Uri.parse(message.uri));
        //   final bytes = request.bodyBytes;
        //   final documentsDir = (await getApplicationDocumentsDirectory()).path;
        //   localPath = '$documentsDir/${message.name}';
        //
        //   if (!i.File(localPath).existsSync()) {
        //     final file = i.File(localPath);
        //     await file.writeAsBytes(bytes);
        //   }
        // }
        //
        // await OpenFile.open(localPath);
      }
    } catch(onError){
      print(onError);
    }
  }

  void _handlePreviewDataFetched(types.TextMessage message, types.PreviewData previewData,) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, room.id);
  }

  void _handleSendPressed(types.PartialText message) async {

    FirebaseChatCore.instance.sendMessage(
      message,
      room.id,
    );

    String userDevice = '';
    String userUuid = '';

    await FirebaseFirestore.instance.collection('e_legal/conf/rooms/' + room.id + '/infoUser').get().then((value) {
      userDevice = value.docs.first.data()['device'];
      userUuid = value.docs.first.data()['user'];
    });

    if(userDevice=='0000000-0000-000-000-000000000000'){
      sendEmail(userUuid,userName);
    } else {
      await post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: <String, String>{
          'Content-Type':
          'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "app_id": '0d781e5f-f216-4ba9-80b1-e2b525eed7c6',
          "include_player_ids": [userDevice],
          "android_accent_color":"green",
          "small_icon": "icon",
          "headings": {"en":'Tienes una actualización de tu caso'},
          "contents": {"en":'Haz click para conocer los detalles'},
          "data": {
            "messageId":
            'response: ' +
                room.id,
          }
        }),
      );
    }

  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(children: [

        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState((){}),
                child: const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text('Escritorio Legal', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ),
              const SizedBox(width: 550,),
              GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryLawyerPage())), child: const Text('Historial de chats', style: TextStyle(color: Colors.white, fontSize: 16),)),
              GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LawyerPerfilPage())), child: const Text('Mi cuenta', style: TextStyle(color: Colors.white, fontSize: 16),)),
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

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    children: [

                      Center(
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('requests')
                                .where('location', isEqualTo: location)///GET LOCATION
                                .where('status', isEqualTo: 'active').snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              if(snapshot.connectionState == ConnectionState.active) {
                                for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                                  if(snapshot.data!.docs.length>0) {

                                    if(requestCount != snapshot.data!.docs.length){
                                      requestCount = snapshot.data!.docs.length;
                                      player.setAsset('assets/audio/noti.wav');
                                      player.play();
                                    }

                                    return SingleChildScrollView(
                                      primary: false,
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {

                                          DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];
                                          ///V20
                                          if(entities.contains(ds['category'])){
                                            return Center(
                                                child: Container(
                                                    padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
                                                    clipBehavior: Clip.none,
                                                    margin: const EdgeInsets.only(top: 8),
                                                    child: ListTile(
                                                        onTap: () async =>
                                                            setState(() {
                                                              swapOp = 2;
                                                              messageId = ds.id;
                                                            }),
                                                        title: Text('Código de petición: ' + ds.id,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(color: Colors.grey, fontSize: 11),),
                                                        subtitle: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 50,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                                                                child: Image.network('https://upload.wikimedia.org/wikipedia/commons/b/b1/Notifications_alert_badge_-_1_alert.svg'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(height: 10,),
                                                                  Text(ds['category'],
                                                                    style: const TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black),),
                                                                  Text(ds['name'],
                                                                    style: const TextStyle(
                                                                        fontSize: 18,
                                                                        color: Colors.black26),),
                                                                  Text(ds['date'].toString().substring(0, ds['date'].toString().indexOf(' ')),
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
                                            return const SizedBox.shrink();
                                          }


                                        }),
                                    );
                                  } else {
                                    return const Text('Sin peticiones pendientes');
                                  }
                                }
                              }

                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator());
                              }

                              return const SizedBox.shrink();

                            }
                          ),
                        ),
                      ),

                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').get(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                          if(snapshot.connectionState == ConnectionState.done) {
                            for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                              return SingleChildScrollView(
                                primary: false,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {

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
                                        userChatName = listUser[userChatId2]!;
                                        uidUser = userChatId1;
                                        uidLawyer = userChatId2;
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

                                                FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/rooms', '/e_legal/conf/users');

                                                types.User? lawyer;
                                                lawyer = types.User(
                                                  id: userChatId2,
                                                );

                                                room = await FirebaseChatCore.instance.createRoom(lawyer);

                                                setState((){
                                                  chatRoom = ds.id;
                                                  swapOp = 1;
                                                  clientName = listUser[userChatId2]!;
                                                });

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
                                                    child: Image.network(listImgUser[userChatId2]!),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(height: 10,),
                                                      Text(nameChat,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black),),
                                                      Text(listUser[userChatId2]!,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black26),),
                                                      Text(listPhoneUser[userChatId2]!,
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

                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(),);
                          }

                          return const SizedBox.shrink();

                        },
                      ),

                    ],
                  ),
                ),
              ),

              Flexible(
                flex: 3,
                child: _body(),
              ),

            ],
          )),

      ],),
    );
  }

  _body(){
    switch(swapOp){
      case 0:
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Center(
                child: Image.asset('assets/recibo_logo.png', height: 160,)
            )
        );
      case 1:
      if(chatRoom.toString().isEmpty){
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Center(
                child: Image.asset('assets/recibo_logo.png', height: 160,)
            )
        );
      } else {
        return Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<types.Room>(
            initialData: room,
            stream: FirebaseChatCore.instance.room(room.id),
            builder: (context, snapshot) {
              return StreamBuilder<List<types.Message>>(
                initialData: const [],
                stream: FirebaseChatCore.instance.messages(snapshot.data!),
                builder: (context, snapshot) {

                  roomGlobalId = room.id;

                  return SafeArea(
                    bottom: false,
                    child: Column(
                      children: [

                        Container(
                          width: double.infinity,
                          height: 45,
                          color: Colors.black,
                          child: Row(
                            children: [
                              chatContainer ? IconButton(onPressed: (){
                                setState((){
                                  chatContainer = false;
                                });
                              }, icon: const Icon(Icons.arrow_back, color: Colors.white,), iconSize: 22,) : SizedBox.shrink(),
                              GestureDetector(
                                onTap: (){
                                  if(chatContainer){
                                    setState((){
                                      chatContainer = true;
                                    });
                                  } else {
                                    setState((){
                                      chatContainer = true;
                                    });
                                  }

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, top: 10),
                                  child: Text('Chateando con ' + clientName, style: const TextStyle(color: Colors.white, fontSize: 20),),
                                ),
                              ),
                            ],
                          ),
                        ),

                        chatContainer ?
                          !showImage ?
                            Expanded(
                              child: Column(
                                children: [

                                  SizedBox(
                                    height: 150,
                                    child: Row(
                                      children: [

                                        Flexible(flex: 1, child: Container(child: Image.network(listImgUser[uidLawyer]!),)),
                                        Expanded(
                                          child: FutureBuilder<QuerySnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection('e_legal')
                                                  .doc('conf')
                                                  .collection('rooms')
                                                  .doc(room.id)
                                                  .collection('infoUser')
                                                  .where('status', isEqualTo: 'active')
                                                  .get(),
                                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                if (snapshot.connectionState == ConnectionState.done) {
                                                  for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                                                    return SingleChildScrollView(
                                                      primary: false,
                                                      child: ListView.builder(
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        scrollDirection: Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount: snapshot.data!.docs.length,
                                                        itemBuilder: (context, index) {
                                                          for (var i = 0; i < snapshot.data!.docs.length; ++i) {

                                                            DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];


                                                            return Column(
                                                              children: [

                                                                Container(
                                                                  height: 30,
                                                                  color: Colors.black,
                                                                  child: Center(
                                                                    child: GestureDetector(
                                                                      onDoubleTap: () => showMyDialog('Procesando', context),
                                                                      onTap: () async {

                                                                        var _firestore = FirebaseFirestore.instance;
                                                                        String roomIdTest = room.id;

                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                          content: Text("Terminando chat..."),
                                                                          duration: Duration(milliseconds: 300),
                                                                        ));

                                                                        await _firestore
                                                                            .collection('e_legal')
                                                                            .doc('conf')
                                                                            .collection('rooms')
                                                                            .doc( room.id)
                                                                            .snapshots().first.then((value) async {

                                                                          await _firestore
                                                                              .collection('e_legal')
                                                                              .doc('conf')
                                                                              .collection('history')
                                                                              .doc(roomIdTest).set({
                                                                            'createdAt': value.data()!['createdAt'],
                                                                            'imageUrl': value.data()!['imageUrl'],
                                                                            'metadata': null,
                                                                            'name': null,
                                                                            'paymentId': null,
                                                                            'status': 'inactive',//value.data()!['status'],
                                                                            'statusPayment': value.data()!['statusPayment'],
                                                                            'type': value.data()!['type'],
                                                                            'updatedAt': value.data()!['updatedAt'],
                                                                            'userIds': value.data()!['userIds'],
                                                                            'userRoles': null
                                                                          });

                                                                        }).whenComplete(() async {

                                                                          ///MUEVE INFORMACIÓN DE USUARIO
                                                                          await _firestore
                                                                              .collection('e_legal')
                                                                              .doc('conf')
                                                                              .collection('rooms')
                                                                              .doc( room.id)
                                                                              .collection('infoUser')
                                                                              .get().then((value) async {
                                                                            value.docs.forEach((element) async {

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

                                                                              await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(room.id).collection('infoUser').doc(element.id).delete();

                                                                            });
                                                                          });

                                                                          ///MUEVE MENSAJES
                                                                          await _firestore
                                                                              .collection('e_legal')
                                                                              .doc('conf')
                                                                              .collection('rooms')
                                                                              .doc( room.id)
                                                                              .collection('messages')
                                                                              .get().then((value) async {
                                                                            value.docs.forEach((mss) async {

                                                                              switch(mss.data()['type']){
                                                                                case 'text':
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

                                                                              await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(room.id).collection('messages').doc(mss.id).delete();

                                                                            });

                                                                          });

                                                                        });


                                                                        await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(room.id).delete().whenComplete(() => setState(() {
                                                                          swapOp = 0;
                                                                          room = const types.Room(
                                                                            id: '',
                                                                            metadata: {'': ''},
                                                                            type: types.RoomType.direct,
                                                                            users: [types.User(id: '')],
                                                                          );
                                                                        }));
                                                                        // await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('history').doc(room.id).update({'status': 'inactive'});

                                                                        showMyDialog('El chat se ha enviado al historial correctamente', context);

                                                                      },
                                                                      child: Text('Terminar caso', style: TextStyle(color: Colors.white),),),
                                                                  ),
                                                                ),

                                                              ],
                                                            );
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
                                        ),
                                        // Flexible(flex: 2, child: Text('Descripción: ' + caseDescription, textAlign: TextAlign.left,)),
                                      ],
                                    ),
                                  ),

                                  const Divider(height: 5,thickness: 5,),

                                  const SizedBox(height: 10,),

                                  const Text('Imagenes', style: TextStyle(fontSize: 22,),),

                                  const SizedBox(height: 5,),

                                  FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('e_legal')
                                          .doc('conf')
                                          .collection('rooms')
                                          .doc(room.id)
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
                                                          width: MediaQuery.of(context).size.width / 9,
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
                                          .doc(room.id)
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
                                                      width: MediaQuery.of(context).size.width / 9,
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


                              ],),
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
                              height: MediaQuery.of(context).size.height * 0.85,
                              width: MediaQuery.of(context).size.width,
                              child: SizedBox(
                                  width: 250,
                                  height: 250,
                                  child: PhotoView(
                                      imageProvider: NetworkImage(urlImage))
                              ),
                            ),
                          ),
                        ):
                        Expanded(
                          child: CustomChat(
                            requestinfo: ritem,
                            isHistory: false,
                            roomId: room.id,
                            isAttachmentUploading: _isAttachmentUploading,
                            messages: snapshot.data ?? [],
                            emptyState: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: const Text(
                                'Sin mensajes aún',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onAttachmentPressed: _handleAtachmentPressed,
                            onMessageTap: _handleMessageTap,
                            onPreviewDataFetched: _handlePreviewDataFetched,
                            onSendPressed: _handleSendPressed,
                            // onMessageLongPress: ,
                            user: types.User(id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',),
                            // customMessageBuilder: AudioMessage(message: customMessage),
                          ),
                        ),

                      ],
                    ),
                  );
                },
              );
            },
          )
        );
      }
      case 2:
        return Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            primary: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[

                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('requests')
                            .doc(messageId).delete().whenComplete(() => setState((){
                              swapOp = 0;
                              chatRoom = '';
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05
                        ),
                        child: const Image(
                          width: 100,
                          height: 120,
                          image: AssetImage('assets/request.png'),
                        )
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('requests')
                            .doc(messageId)
                            .snapshots(),
                        builder: (context, snapshot) {

                          if(snapshot.connectionState == ConnectionState.active) {
                            DocumentSnapshot ds = snapshot.data!;
                            if(ds.exists) {
                              return SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                                    Text(
                                      'Nueva solicitud de ' + ds['name'],
                                      style: const TextStyle(fontSize: 27),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                    Text(
                                      'ID: ' + ds.id,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                    Text(
                                      'Fecha: ' + ds['date'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                    Text(
                                      'Telefono: ' + ds['phone'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                    Text(
                                      'Categoría: ' + ds['category'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                    Text(
                                      'Descripción: ' + ds['description'],
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => setState((){
                                            swapOp = 0;
                                          }),
                                          child: Container(
                                            margin: const EdgeInsets.all(10.0),
                                            height: 50,
                                            width: MediaQuery.of(context).size.width * 0.20,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                                            ),
                                            child: const Center(
                                                child: Text(
                                                  'PASAR',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                        ),
                                        GestureDetector(
                                          onDoubleTap: () => showMyDialog('El caso se esta asignando', context),
                                          onTap: () async {
                                            try {

                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                content: Text("Asignando caso..."),
                                                duration: Duration(milliseconds: 300),
                                              ));

                                              FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('/e_legal/conf/rooms', '/e_legal/conf/users');

                                              types.User? lawyer;

                                              lawyer = types.User(
                                                id: ds['user'],
                                              );

                                              final roomtmp = await FirebaseChatCore.instance.createRoom(lawyer);

                                              await FirebaseFirestore.instance
                                                  .collection('e_legal')
                                                  .doc('conf')
                                                  .collection('rooms')
                                                  .doc(roomtmp.id)
                                                  .update({
                                                'status': 'active',
                                                'paymentId': '',
                                                'statusPayment': 'pagado',
                                                'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Ffolder-icon.png?alt=media&token=eda3575c-4a95-42ee-944d-e21ee7f4f869'
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection('e_legal')
                                                  .doc('conf')
                                                  .collection('rooms')
                                                  .doc(roomtmp.id)
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

                                              await post(
                                                Uri.parse(
                                                    'https://onesignal.com/api/v1/notifications'),
                                                headers: <String, String>{
                                                  'Content-Type':
                                                  'application/json; charset=UTF-8',
                                                },
                                                body: jsonEncode(<String, dynamic>{
                                                  "app_id":
                                                  '0d781e5f-f216-4ba9-80b1-e2b525eed7c6',
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
                                                    'desktop: ' +
                                                        roomtmp.id,
                                                  }
                                                }),
                                              ).whenComplete(() => print('notification creada'));

                                              sendEmail(ds['user'], FirebaseAuth.instance.currentUser!.displayName);

                                              FirebaseFirestore.instance
                                                  .collection('requests')
                                                  .doc(messageId)
                                                  .delete()
                                                  .then((value) => setState((){
                                                swapOp = 1;
                                                chatRoom = roomtmp.id;
                                                clientName = ds['name'];
                                                room = roomtmp;
                                                ritem = RequestItem(
                                                  name: ds['name'],
                                                  cateroy: ds['category'],
                                                  description: ds['description'],
                                                  phone: ds['phone'],
                                                );
                                              }));


                                            } catch (onError) {
                                              showMyDialog('Error code: ' + onError.toString(), context);
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10.0),
                                            height: 50,
                                            width: MediaQuery.of(context).size.width * 0.20,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                                            ),
                                            child: const Center(
                                                child: Text(
                                                  'TOMAR',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
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
          ),
        );
    }

  }

  Future sendEmail(uuid, lawyerName) async {
    print(2);
    print(uuid);
    String userMail = '';
    try{
      await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').doc(uuid).get().then((value) => userMail = value.data()!['metadata']['mail']);
    } catch(onError){
      userMail = 'marco_monsivais@hotmail.com';
      print(onError);
    }

    print(userMail);

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_nhvah1y';
    const templateId = 'template_wns7lb8';
    const userId = 'zoPGgRF3SqFSoy_Xu';
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},//This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user-email': userMail,
            'lawyer-name': lawyerName
          }
        }));
    return response.statusCode;
  }

}

