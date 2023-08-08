import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/src/custom_chat.dart';
import 'package:e_legal/src/document_chat.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.room,
    required this.isHistory,
    this.firstMessage,
    this.ritem,
  }) : super(key: key);

  final types.Room room;
  final bool isHistory;
  final String? firstMessage;
  final RequestItem? ritem;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAttachmentUploading = false;
  String nameChat = 'Chat';

  String otherUserImage = 'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/agent.webp?alt=media&token=61b2d886-912f-4358-8f17-427ff5aa2185';
  String otherUserName = 'Cargando...';
  String otherUserDescription = 'Cargando...';

  late Stream<types.Room> _getRoom;

  @override
  void initState() {
    widget.isHistory
        ? FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/history', '/e_legal/conf/users')
        : FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms', '/e_legal/conf/users');
    reponseNotification = false;

    _getRoom = FirebaseChatCore.instance.room(widget.room.id);

    widget.room.users.forEach((element) { 
      if(element.id != FirebaseAuth.instance.currentUser!.uid){

        FirebaseFirestore.instance.collection('e_legal/conf/users').doc(element.id).get().then((value){

          try{
            otherUserDescription =  'Cédula: ' + value['cedula'];
          } catch(err){
            otherUserDescription = 'Correo: ' + value['metadata.mail'];
          }
          
          setState(() {
            otherUserImage = element.imageUrl!;
            otherUserName = element.firstName!;
            otherUserDescription;
          });

        });

      }
    });

    super.initState();
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
                        child: Text(
                          'Foto',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.picture_in_picture_alt,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                        child: Text(
                          'Archivo',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.folder,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 17, color: Colors.red),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance
            .ref('e_legal/conf/rooms/' + widget.room.id + '/' + name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance
            .ref('e_legal/conf/rooms/' + widget.room.id + '/' + name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(types.TextMessage message,types.PreviewData previewData,) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) async {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );

    if (role == 'agent') {
      String userDevice = '';
      String userUuid = '';

      await FirebaseFirestore.instance
          .collection('e_legal/conf/rooms/' + widget.room.id + '/infoUser')
          .get()
          .then((value) {
        userDevice = value.docs.first.data()['device'];
        userUuid = value.docs.first.data()['user'];
      });

      if (userDevice == '0000000-0000-000-000-000000000000') {
        sendEmail(userUuid, userName);
      } else {
        await post(
          Uri.parse('https://onesignal.com/api/v1/notifications'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "app_id": OneSignalId,
            "include_player_ids": [userDevice],
            "android_accent_color": "green",
            "small_icon": "icon",
            "headings": {"en": 'Tienes una actualización de tu caso'},
            "contents": {"en": 'Haz click para conocer los detalles'},
            "data": {
              "messageId": 'response: ' + widget.room.id,
            }
          }),
        );
      }
    } else {
      String userDevice = '';
      String userUuid = '';
      String agentUuid = '';

      await FirebaseFirestore.instance
          .collection('e_legal/conf/rooms/' + widget.room.id + '/infoUser')
          .get()
          .then((value) {
        agentUuid = value.docs.last.data()['agent'];
      });

      await FirebaseFirestore.instance
          .collection('e_legal/conf/users/')
          .doc(agentUuid)
          .get()
          .then((value) {
        userDevice = value['metadata.device'];
      });

      if (userDevice == '0000000-0000-000-000-000000000000') {
        sendEmail(userUuid, userName);
      } else {
        await post(
          Uri.parse('https://onesignal.com/api/v1/notifications'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "app_id": OneSignalId,
            "include_player_ids": [userDevice],
            "android_accent_color": "green",
            "small_icon": "icon",
            "headings": {"en": 'Actualización de chat'},
            "contents": {"en": 'Haz click para conocer los detalles'},
            "data": {
              "messageId": 'response: ' + widget.room.id,
            }
          }),
        );
      }
    }
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailChatPage(
                                room: widget.room,
                              ))),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(otherUserImage),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(otherUserName),
                          Text(
                            otherUserDescription,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            GestureDetector(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/welcome', (Route<dynamic> route) => false),
                child: const Icon(Icons.home)),
          ],
        ),
      ),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: _getRoom,
        builder: (context, snapshot) {
          return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.active:
                  return SafeArea(
                    bottom: false,
                    child: CustomChat(
                      requestinfo: widget.ritem,
                      isHistory: widget.isHistory,
                      roomId: widget.room.id,
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
                      user: types.User(
                        id: FirebaseChatCore.instance.firebaseUser!.uid ?? '',
                      ),
                    ),
                  );
                default:
                  return const Center(child: CircularProgressIndicator(),);
              }
            },
          );
        },
      ),
    );
  }

  Future sendEmail(uuid, lawyerName) async {
    String userMail = '';
    try {
      await FirebaseFirestore.instance
          .collection('e_legal')
          .doc('conf')
          .collection('users')
          .doc(uuid)
          .get()
          .then((value) => userMail = value.data()!['metadata']['mail']);
    } catch (onError) {
      userMail = 'marco_monsivais@hotmail.com';
      print(onError);
    }

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_nhvah1y';
    const templateId = 'template_wns7lb8';
    const userId = 'zoPGgRF3SqFSoy_Xu';
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json'
        }, //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {'user-email': userMail, 'lawyer-name': lawyerName}
        }));
    return response.statusCode;
  }
}
