import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'chatDB.dart';
import 'chatData.dart';
import 'constants.dart';
import 'screens/chat.dart';
import 'screens/zoomImage.dart';
import 'package:flutter_sound/public/ui/sound_player_ui.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_platform_interface.dart';
// import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'custom_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';


class ChatWidget {
  static Widget userListStack(String currentUserId, List lawyerList, BuildContext context) {
    print("Chat Widget Document List: ");
    print(lawyerList.length);
    return Stack(
      children: <Widget>[
        // List
        Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(ChatDBFireStore.getDocName())
                .snapshots(),
            builder: (context, snapshot) {
              if (lawyerList.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) => userListbuildItem(
                        context, currentUserId, lawyerList[index]),
                  itemCount: lawyerList.length,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  static Widget userListbuildItem(
      BuildContext context, String currentUserId, DocumentSnapshot document) {
    //print('firebase ' + document['userId']);
    //print(currentUserId);
    if (document['userId'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? widgetShowImages(document['photoUrl'], 50)
                    : Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: colorPrimaryDark,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Abogado: ${document['nickname']}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 10.0,
                  minWidth: 10.0,
                  maxHeight: 30.0,
                  maxWidth: 30.0,
                ),
                child: new DecoratedBox(
                  decoration: new BoxDecoration(
                      color: document['online'] == 'online'
                          ? Colors.greenAccent
                          : Colors.transparent),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                      currentUserId: currentUserId,
                      peerId: document.id,
                      peerName: document['nickname'],
                      peerAvatar: document['photoUrl'],
                    )));
          },
          color: viewBg,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  static Widget widgetLoginScreen(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.message,
                    color: Colors.greenAccent,
                  ),
                  height: 25.0,
                ),
                Text(
                  ChatData.appName,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
          Center(
            child: FlatButton(
                onPressed: () => ChatData.authUser(context),
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                color: Color(0xffdd4b39),
                highlightColor: Color(0xffff7f7f),
                splashColor: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
          ),
        ],
      ),
    );
  }

  static Widget getAppBar() {
    return AppBar(
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
      title: Image(
        image: AssetImage('assets/img/logorounded.png'),
        width: 48.0,
      ),
      brightness: Brightness.dark,
    );
  }

  static Widget widgetWelcomeScreen(BuildContext context) {
    return Center(
      child: Container(
          child: Text(
            ChatData.appName,
            style: TextStyle(fontSize: 28),
          )),
    );
  }

  static Widget widgetFullPhoto(BuildContext context, String url) {
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }

  static Widget widgetChatBuildItem(BuildContext context, var listMessage,
      String id, int index, DocumentSnapshot document, String peerAvatar) {
    if (document['idFrom'] == id) {
      return Row(
        children: <Widget>[
          if(document["type"] == 0) //text
            chatText(document['content'], id, listMessage, index, true)
          else if(document["type"] == 1) // image
            chatImage(context, id, listMessage, document['content'], index, true)
          else if(document["type"] == 3) // audio
            chatAudio(context, id, listMessage, document['content'], index, true)
          else if(document["type"] == 4) // file
            chatFile(context, id, listMessage, document['content'], index, true, document['fileName'])
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ChatData.isLastMessageLeft(listMessage, id, index)
                    ? Material(
                  child: widgetShowImages(peerAvatar, 35),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                )
                    : Container(width: 35.0),
                if(document["type"] == 0) //text
                  chatText(document['content'], id, listMessage, index, false)
                else if(document["type"] == 1) // image
                  chatImage(context, id, listMessage, document['content'], index, false)
                else if(document["type"] == 3) // audio
                  chatAudio(context, id, listMessage, document['content'], index, false)
                else if(document["type"] == 4) // file
                  chatFile(context, id, listMessage, document['content'], index, false, document["fileName"])
              ],
            ),

            // Time
            ChatData.isLastMessageLeft(listMessage, id, index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: greyColor,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  static Widget widgetChatBuildListMessage(groupChatId, listMessage,
      currentUserId, peerAvatar, listScrollController) {
    return Flexible(
      child: groupChatId == ''
          ? Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor)));
          } else {
            listMessage = snapshot.data.docs;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  ChatWidget.widgetChatBuildItem(
                      context,
                      listMessage,
                      currentUserId,
                      index,
                      snapshot.data.docs[index],
                      peerAvatar),
              itemCount: snapshot.data.docs.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  static Widget chatText(String chatContent, String id, var listMessage,
      int index, bool logUserMsg) {
    return Container(
      child: Text(
        chatContent,
        style: TextStyle(color: logUserMsg ? primaryColor : Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration(
          color: logUserMsg ? greyColor2 : primaryColor,
          borderRadius: BorderRadius.circular(8.0)),
      margin: logUserMsg
          ? EdgeInsets.only(
          bottom: ChatData.isLastMessageRight(listMessage, id, index)
              ? 20.0
              : 10.0,
          right: 10.0)
          : EdgeInsets.only(left: 10.0),
    );
  }

  static Widget chatImage(BuildContext context, String id, var listMessage,
      String chatContent, int index, bool logUserMsg) {
    return Container(
      child: FlatButton(
        child: Material(
          child: widgetShowImages(chatContent, 50),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ZoomImage(url: chatContent)));
        },
        padding: EdgeInsets.all(0),
      ),
      margin: logUserMsg
          ? EdgeInsets.only(
          bottom: ChatData.isLastMessageRight(listMessage, id, index)
              ? 20.0
              : 10.0,
          right: 10.0)
          : EdgeInsets.only(left: 10.0),

    );
  }

  static Widget chatAudio(BuildContext context, String id, var listMessage,
      String chatContent, int index, bool logUserMsg) {
    return Container(
      width: 300,
      height: 50,
      child: CustomSoundPlayerUI.fromLoader(
          (_) => createAssetTrack(chatContent),
        showTitle: false,
        audioFocus: AudioFocus.requestFocusAndDuckOthers,
        backgroundColor: logUserMsg ? greyColor2 : primaryColor,
        iconColor: logUserMsg ? primaryColor : Colors.white,
        textStyle: TextStyle(color: logUserMsg ? primaryColor : Colors.white),
        sliderThemeData: SliderThemeData(
          activeTrackColor: logUserMsg ? primaryColor : Colors.white,
          activeTickMarkColor: logUserMsg ? primaryColor : Colors.white,
          inactiveTrackColor: Colors.grey,
          thumbColor: logUserMsg ? primaryColor : Colors.white,
        ),
      ),
      margin: logUserMsg
          ? EdgeInsets.only(
          bottom: ChatData.isLastMessageRight(listMessage, id, index)
              ? 20.0
              : 10.0,
          right: 10.0)
          : EdgeInsets.only(left: 10.0),
    );
  }

  static Widget chatFile(BuildContext context, String id, var listMessage,
      String chatContent, int index, bool logUserMsg, String fileName) {
    return Container(
      width: 250,
      height: 50,
      child: GestureDetector(
        onTap: () => downloadFile(chatContent, fileName),
        child: Row(
          children: [
            Container(margin: EdgeInsets.symmetric(horizontal: 10), height: 45, child: Icon(Icons.insert_drive_file_rounded)),
            if(chatContent.contains(".pdf"))
              Flexible(child: RichText(overflow: TextOverflow.ellipsis, text: TextSpan(text: fileName, style: TextStyle(color: logUserMsg ? primaryColor : Colors.white))))
            else if(chatContent.contains(".docx") || chatContent.contains(".DOCX"))
              Flexible(child: RichText(overflow: TextOverflow.ellipsis, text: TextSpan(text: fileName, style: TextStyle(color: logUserMsg ? primaryColor : Colors.white))))
            else if(chatContent.contains(".doc")|| chatContent.contains(".DOC"))
              Flexible(child: RichText(overflow: TextOverflow.ellipsis, text: TextSpan(text: fileName, style: TextStyle(color: logUserMsg ? primaryColor : Colors.white))))
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(
          color: logUserMsg ? greyColor2 : primaryColor,
          borderRadius: BorderRadius.circular(8.0)),
      margin: logUserMsg
          ? EdgeInsets.only(
          bottom: ChatData.isLastMessageRight(listMessage, id, index)
              ? 20.0
              : 10.0,
          right: 10.0)
          : EdgeInsets.only(left: 10.0),
    );
  }

  static downloadFile(String url, String fileName) async {
    FlutterDownloader.registerCallback(downloadingCallBack);
    String dir = (await getExternalStorageDirectory()).path;

    bool permission = await _checkPermission();

    bool fileExists = await File("$dir/$fileName").exists();

    if(fileExists) {
      print("$dir/$fileName");
      print(fileName);
      OpenFile.open("$dir/$fileName");
    } else {
      if (permission) {
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: dir,
          showNotification: true,
          fileName: fileName,
          // show download progress in status bar (for Android)
          openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        );
        Fluttertoast.showToast(
            msg: "Download Complete");
      } else {
        Fluttertoast.showToast(
            msg: "Please provide permission to download files");
      }
    }

  }

  static downloadingCallBack(id, status, progress){
    print(id);
    print(progress);
  }

  static _checkPermission() async {
    final status = await Permission.storage.request();

    if(status.isGranted) {
      return true;
    } else {
      print("Permission denied");
      return false;
    }

  }


  static Future<Track> createAssetTrack(String url) async {
    Track track;
    var dataBuffer =
    (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    track = Track(
      dataBuffer: dataBuffer,
      codec: Codec.aacADTS,
    );

    track.trackTitle = 'Audio playback.';
    track.trackAuthor = 'By eLegal';

    if (kIsWeb)
      track.albumArtAsset = null;
    else if (Platform.isIOS)
      track.albumArtAsset = 'assets/icon/logo_fetchup';
    else if (Platform.isAndroid)
      track.albumArtAsset = 'assets/icon/logo_fetchup.png';

    return track;
  }

  // Show Images from network
  static Widget widgetShowImages(String imageUrl, double imageSize) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: imageSize,
      width: imageSize,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Widget widgetShowText(
      String text, dynamic textSize, dynamic textColor) {
    return Text(
      '$text',
      style: TextStyle(
          color: (textColor == '') ? Colors.white70 : textColor,
          fontSize: textSize == '' ? 14.0 : textSize),
    );
  }

  findUserChats() {
    List<String> _lawyers = new List();

    return _lawyers;

  }
}
