import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:elegal/perfil/perfil_page.dart';
import 'package:elegal/src/custom_chat.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HistoryPageState();
  }

}

class _HistoryPageState extends State<HistoryPage> {

  String titleAlert = '';
  String chatRoom = '';
  bool chatContainer = false;

  final TextEditingController _nameController = TextEditingController();
  bool showImage = false;
  String urlImage = '', title = '';

  bool _isAttachmentUploading = false;
  types.Room room = types.Room(id: 'id', type: types.RoomType.direct, users: []);

  bool isHistoryGlobal = false;

  final Map<String, String> listLawyer = {'id': 'name'};
  final Map<String, String> listCLawyer = {'id': 'cedula'};

  @override
  void initState(){
    _getCardLawyer();
    super.initState();
  }

  _getCardLawyer() async {
    await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').where('role', isEqualTo: 'agent').get().then((value) =>
      value.docs.forEach((element) {
        listLawyer.putIfAbsent(element.id, () => element.data()['firstName'] + ' ' + element.data()['lastName']);
        try{
          listCLawyer.putIfAbsent(element.id, () => element.data()['cedula'] );
        } catch(onerror){
          print('abogado sin cedula');
        }
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

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      room.id,
    );
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
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PerfilPage())),
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

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('Casos activos'),
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').get(),
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

                                                          FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/rooms', '/e_legal/conf/users');

                                                          await FirebaseChatCore.instance.room(ds.id).first.then((value) {
                                                            setState((){
                                                              room = value;
                                                              chatRoom = ds.id;
                                                              isHistoryGlobal = false;
                                                            });
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
                                                              child: Image.network('https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185'),
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
                                                                Text(listLawyer[userChatId1]!,
                                                                  style: const TextStyle(
                                                                      fontSize: 18,
                                                                      color: Colors.black26),),
                                                                Text(listCLawyer[userChatId1]!,
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

                        SizedBox(height: 60,),

                        Text('Casos cerrados'),
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('history').get(),
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

                                                            FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/history', '/e_legal/conf/users');

                                                            await FirebaseChatCore.instance.room(ds.id).first.then((value) {
                                                              setState((){
                                                                room = value;
                                                                chatRoom = ds.id;
                                                                isHistoryGlobal = true;
                                                              });
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
                                                                child: Image.network('https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185'),
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
                                                                  Text(listLawyer[userChatId1]!,
                                                                    style: const TextStyle(
                                                                        fontSize: 18,
                                                                        color: Colors.black26),),
                                                                  Text(listCLawyer[userChatId1]!,
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
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: _body(chatRoom),
                ),
              ],
            )),

        ],
      ),
    );
  }

  _body(chatRoom){
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
        child: Center(
          child: StreamBuilder<types.Room>(
            initialData: room,
            stream: FirebaseChatCore.instance.room(room.id),
            builder: (context, snapshot) {
              return StreamBuilder<List<types.Message>>(
                initialData: const [],
                stream: FirebaseChatCore.instance.messages(snapshot.data!),
                builder: (context, snapshot) {
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
                              }, icon: Icon(Icons.arrow_back, color: Colors.white,), iconSize: 22,) : SizedBox.shrink(),
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
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 15, top: 10),
                                  child: Text('Chateando con un abogado', style: TextStyle(color: Colors.white, fontSize: 20),),
                                ),
                              ),
                            ],
                          ),
                        ),

                        chatContainer ?
                            !showImage ?
                              Expanded(child: Column(
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

                                      ],
                                    ),
                                  ),

                                ],
                              )) :
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
                            isHistory: isHistoryGlobal,
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
          ))
      );
    }
  }

}