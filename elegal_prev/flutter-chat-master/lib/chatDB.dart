import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ChatDBFireStore {
  static String getDocName() {
    //Changed this from users
    String dbUser = "users";
    return dbUser;
  }

  static Future<void> checkUserExists(User logInUser) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(getDocName())
        .where('userId', isEqualTo: logInUser.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      // Update data to server if new user
      await saveNewUser(logInUser);
    }
  }

  //Aqui agregaremos la llamada a nuestra api para sacar el userId de Escritorio Legal y agregarlo como campo a la colección (es diferente al userId de la sesión de firebase)
  static saveNewUser(User logInUser) {
    FirebaseFirestore.instance
        .collection(getDocName())
        .doc(logInUser.uid)
        .set({
      'nickname': logInUser.displayName,
      'photoUrl': logInUser.photoURL,
      'userId': logInUser.uid,
      'createdAt': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'chattingWith': null,
      'online': null
    });
  }

  static streamChatData() {
    FirebaseFirestore.instance.collection(ChatDBFireStore.getDocName()).snapshots();
  }

  static Future<void> makeUserOnline(User logInUser) async {
    // FirebaseDatabase.instance
    //     .reference()
    //     .child("/status/" + logInUser.uid)
    //     .onDisconnect()
    //     .set("offline");

    // FirebaseDatabase.instance
    //     .reference()
    //     .child("/status/" + logInUser.uid)
    //     .set("online");

    //Added this line so the user goes online
    // seems irrelevant but has to comply with how the code was
    FirebaseFirestore.instance.collection("users").doc(logInUser.uid).update(
        {"online": "online"});

  }

  static getUsersForChat(String uid) async {
    var prefs = await SharedPreferences.getInstance();
    List lawyerIds = List();
    List lawyersDocs = List();

    final response = await http.get(
        Uri.parse('https://nameless-coast-31577.herokuapp.com/api/users_lawyer_chats/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        }
    );

    var c = jsonDecode(response.body);
    print(c);
    for(var lawyer in c['data']) {
      print(lawyer['lawyer']['googleToken']);
        if(lawyer['lawyer']['googleToken'] != null)
          lawyerIds.add(lawyer['lawyer']['googleToken']);
        if(lawyer['user']['googleToken'] != null)
          lawyerIds.add(lawyer['user']['googleToken']);
    }
    lawyerIds = lawyerIds.toSet().toList();



    // var splitElement;

    // var test = await FirebaseFirestore.instance
    //     .collection('messages')
    //     .get().then((value) {
    //       value.docs.forEach((element) {
    //         if(element.id.contains(uid)) {
    //           splitElement = element.id.split("-");
    //           splitElement[0] == element.id ? lawyerIds.add(splitElement[0]) : lawyerIds.add(splitElement[1]);
    //         }
    //   });
    //       return lawyerIds;
    // });

    for(var element in lawyerIds) {
      var docs = await FirebaseFirestore.instance.collection("users").doc(element).get();
      lawyersDocs.add(docs);
    }

    return lawyersDocs;
  }
}
