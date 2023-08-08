import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'zoomImage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';
import 'dart:convert';

class PeerInfo extends StatefulWidget {
  @override
  _PeerInfoState createState() => _PeerInfoState();
}

class _PeerInfoState extends State<PeerInfo> {
  String groupChatId = "";
  List images = [];
  bool imagesLoaded = false;
  List docs = [];
  List docContent = [];
  bool docsLoaded = false;
  String path = '';

  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadingCallBack);
    getPath();
    //_getUser();
  }

  static downloadingCallBack(id, status, progress){
    print(id);
    print(progress);
  }

  getPath() async {
    path = (await getExternalStorageDirectory()).path;
  }

  Future _getUser(peerId) async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/users/getUserByEmail/$peerId'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        }
    );
    var c = (jsonDecode(response.body));
    print('aqui tb');
    print(c['data']['cellphone']);
    //return c;
  }

  @override
  Widget build(BuildContext context) {
    final Map peerInfo = ModalRoute.of(context).settings.arguments;
    print('aqui');
    _getUser(peerInfo["peerId"]);
    if (peerInfo["ownId"].hashCode <= peerInfo["peerId"].hashCode) {
      groupChatId = '${peerInfo["ownId"]}-${peerInfo["peerId"]}';
      getMediaFromConversation(groupChatId);

    } else {
      groupChatId = '${peerInfo["peerId"]}-${peerInfo["ownId"]}';
      getMediaFromConversation(groupChatId);
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.black26,
              child: Image(
                  image: NetworkImage(peerInfo['peerAvatar']),
                  fit: BoxFit.fitHeight
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 25.0
              ),
              child: Text(
                "Archivos y Documentos",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16.0
                ),
              ),
            ),
            imagesLoaded ?
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ZoomImage(url: images[index]))
                            );
                          },
                          child: Image(
                              width: 85.0,
                              fit: BoxFit.cover,
                              image: NetworkImage(images[index])
                          )
                      ),
                    );
                  }
              ),
            ) : SizedBox(),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: 25.0,
                  horizontal: 25.0
              ),
              child: Text(
                "Documents",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.0
                ),
              ),
            ),
            docsLoaded ?
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      width: 80,
                      margin: EdgeInsets.only(right: 25.0),
                      child: GestureDetector(
                        onTap: () {
                          isFileDownloaded(
                              "$path/${docs[index]}",
                              docContent[index],
                              docs[index]
                          );
                          },
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              child: Icon(
                                Icons.insert_drive_file
                              ),
                            ),
                            Flexible(
                              child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  text: TextSpan(
                                      text: docs[index],
                                    style: TextStyle(
                                      color: Colors.black
                                    )
                                  )
                              ),
                            )
                            // Container(
                            //   width: 80,
                            //   child: Text(docs[index])
                            // )
                          ]
                        )
                      ),
                    );
                  }
              )
            ) : SizedBox(),
          ]
        )
      )
    );
  }

  getMediaFromConversation(String chat) async {

    var documentReference = await FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .get();

    documentReference.docs.forEach((element) {
     if(element.data()['type'] == 1)
       images.add(element.data()['content']);
     else if(element.data()["type"] == 4) {
       docContent.add(element.data()["content"]);
       docs.add(element.data()["fileName"]);
      }
    });

    images.toSet().toList();
    docs.toSet().toList();
    docContent.toSet().toList();

    if (!imagesLoaded && !docsLoaded)
      setState(() {
        imagesLoaded = true;
        docsLoaded = true;
      });


  }

  isFileDownloaded(String downloaded, String url, String _fileName) async {
    OpenFile.open(downloaded).then((value) async {
          if(value.message.startsWith("the")) {
            bool permission = await _checkPermission();
            if (permission) {
              await FlutterDownloader.enqueue(
                url: url,
                savedDir: path,
                showNotification: true,
                fileName: _fileName,
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
    });
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

}
