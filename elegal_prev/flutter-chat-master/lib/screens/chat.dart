import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chatWidget.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

typedef _Fn = void Function();

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String currentUserId;
  static const String id = "chat";
  Chat(
      {Key key,
        @required this.currentUserId,
        @required this.peerId,
        @required this.peerAvatar,
        @required this.peerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0xFF000000),
        title: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                '/peerInfo',
                arguments: {
                  "name": peerName,
                  "peerAvatar": peerAvatar,
                  "peerId": peerId,
                  "ownId": currentUserId

                }
            ),
            child: Text(peerName)
        ),
        leading: null,
        brightness: Brightness.dark,
      ),
      body: new _ChatScreen(
        currentUserId: currentUserId,
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String currentUserId;

  _ChatScreen(
      {Key key,
        @required this.peerId,
        @required this.peerAvatar,
        @required this.currentUserId})
      : super(key: key);

  @override
  State createState() =>
      new _ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class _ChatScreenState extends State<_ChatScreen> {
  _ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;

  var listMessage;
  String groupChatId;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  // Audio Stuff
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInitiated = false;
  bool hasMicPermission = false;
  String _mPath = 'flutter_sound_example.aac';

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    
    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();

    // Audio Handler
    checkMicPermission().then((value) {
      setState(() => hasMicPermission = value);
      if(hasMicPermission) {
        openTheRecorder().then((value) {
          setState(() {
            _mRecorderIsInitiated = true;
          });
        });
      }
    });

  }

  @override
  void dispose() {
    // Dispose the audio elements
    _mRecorder.closeAudioSession();
    _mRecorder = null;

    super.dispose();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    id = widget.currentUserId ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage(int index) async {
    // final imagePicker = ImagePicker();
    //
    // var filePath = index == 0
    //     ? await imagePicker.getImage(source: ImageSource.gallery)
    //     : await imagePicker.getImage(source: ImageSource.camera);

    imageFile = index == 0
        ? await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    // imageFile = File(filePath.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);

    File compressedFile = await FlutterNativeImage.compressImage(imageFile.path,
        quality: 80, percentage: 90);

    UploadTask uploadTask = reference.putFile(compressedFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1, null);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  Future uploadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf', 'doc'],
    );

    if(result != null) {
      File file = File(result.files.single.path);

      // Upload the file to the Firestore
      // Then take the path reference to the message
      Reference storageReference =
      FirebaseStorage.instance.ref().child('Files/$groupChatId/${result.files.single.name}');

      final UploadTask uploadTask = storageReference.putFile(
          file, SettableMetadata(contentType: result.files.single.extension));
      uploadTask.then((value) async {
        var theUrl = await value.ref.getDownloadURL();

        onSendMessage(theUrl, 4, result.files.single.name);

      });

    } else {
      Fluttertoast.showToast(msg: 'File selection Cancelled');
    }
  }

  void onSendMessage(String content, int type, String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    // type: 0 = text, 1 = image, 2 = sticker, 3 = audio, 4 = file
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'fileName': fileName,
            'type': type
          },
        );
      });

       final _headers = {
         'Content-Type': 'application/json',
         'Authorization': 'Bearer ${prefs.getString('access_token')} '
       };
       Map notificationPayload = Map();
       if(type == 0 )
         notificationPayload['description '] = content;
       else if(type == 1)
         notificationPayload['description '] = "Image";
       else if(type == 3)
         notificationPayload['description '] = "Audio";
       else if(type == 4)
         notificationPayload["description"] = "File";

       String notificationJson = jsonEncode(notificationPayload);

       var sendNotification = await http.post(
           Uri.parse('https://nameless-coast-31577.herokuapp.com/api/notificacion/sendNotification/$peerId'),
           headers: _headers,
           body: notificationJson
       );
       print("Notification Sent: ");
       print(sendNotification.body);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              ChatWidget.widgetChatBuildListMessage(groupChatId, listMessage,
                  widget.currentUserId, peerAvatar, listScrollController),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.insert_drive_file),
                onPressed: () => uploadFile(),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: () => getImage(0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.camera_alt),
                onPressed: () => getImage(1),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          if(!_mRecorder.isRecording)
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0, null),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          !_mRecorder.isRecording ? Container(
            child: IconButton(
              onPressed: hasMicPermission ? getRecorderFn() : () => _openTheSession(),
              //color: Colors.white,
              //disabledColor: Colors.grey,
              icon: Icon(Icons.mic),
              color: primaryColor,
              enableFeedback: false,
            ),
          ) : Container(
            child: IconButton(
              icon: Icon(Icons.stop),
              onPressed: getRecorderFn(),
              color: primaryColor,
              enableFeedback: false,
            ),
          ) ,
          if(_mRecorder.isRecording)
            IconButton(
              onPressed: () => cancelRecorder(),
              //color: Colors.white,
              //disabledColor: Colors.grey,
              icon: Icon(Icons.delete_forever),
              color: primaryColor,
              enableFeedback: false,
            ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
          new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  ///
  /// From below this point the audio stuff is handled
  ///

  _openTheSession() {
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInitiated = true;
      });
    });

  }

  Future checkMicPermission() async {
    return await Permission.microphone.isGranted;
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openAudioSession();
    _mRecorderIsInitiated = true;
    setState(() => hasMicPermission = true);
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() async {
    _mPath = "${DateTime.now().millisecondsSinceEpoch.toString()}.aac";
    _mRecorder
        .startRecorder(
      toFile: _mPath,
      sampleRate: 44000,
      codec: Codec.aacADTS,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) {
      setState(() {});

      // Upload the audio file to the Firestore
      // Then take the path reference to the message
      Reference storageReference =
      FirebaseStorage.instance.ref().child('Recordings/$groupChatId/$_mPath');

      final UploadTask uploadTask = storageReference.putFile(
          File(value), SettableMetadata(contentType: 'audio/wav'));
      uploadTask.then((value) async {
        var theUrl = await value.ref.getDownloadURL();

        onSendMessage(theUrl, 3, null);
        print(value.ref.fullPath);
      });
    });
  }

  void cancelRecorder() async {
    await _mRecorder.stopRecorder();
      setState(() {});

  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    if (!_mRecorderIsInitiated)
      return null;
    return _mRecorder.isStopped ? record : stopRecorder;
  }

}
