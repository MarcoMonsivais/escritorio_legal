 import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SuccessfulPayment extends StatefulWidget {
  @override
  _SuccessfulPaymentState createState() => _SuccessfulPaymentState();
}

class _SuccessfulPaymentState extends State<SuccessfulPayment> {
  SharedPreferences prefs;

  @override
  void initState() {
    _loadPreferences().then((_){
      _assignLawyer();
    });
    super.initState();
  }

  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  _assignLawyer() async {
    Map data = new Map();
    data['user_id'] = prefs.getInt('userId');
    String json = jsonEncode(data);

    try {
      await http.post(Uri.parse("${Globals
          .BASE_API_URL}/users_lawyer_chats"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('access_token')} '},
          body: json
      );

      // var assignedResponse = jsonDecode(assigned.body);
      // print(assignedResponse['data']['user']);
      // print(assignedResponse['data']['lawyer']);
      // print(assignedResponse['data']);
      //
      //
      // _createChatUserLawyer(assignedResponse['data']['user']['googleToken'], assignedResponse['data']['lawyer']['googleToken']);

    } catch(e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 100,
          height: SizeConfig.safeBlockVertical * 100,
          padding: EdgeInsets.only(top: 35.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.green[200],
                  child: Icon(Icons.done, color: Colors.green[700], size: 50.0),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                  child: Text(
                    "Pago exitoso",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  )
                ),
                Container(
                  child: Text(
                    "El monto de tu pago es por la cantidad:",
                    style: TextStyle(fontSize: 18.0),
                  )
                ),
                Container(
                  color: Colors.deepPurple[50],
                  width: SizeConfig.safeBlockHorizontal * 80,
                  padding: EdgeInsets.symmetric(
                    horizontal: 35.0,
                    vertical: 30.0
                  ),
                  margin: EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      Text(
                        "\$${args["price"]}",
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        args["item"],
                        style: TextStyle(fontSize: 18.0),
                      )
                    ]
                  )
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("From"),
                      Text(convertToTitleCase(args['holder']))
                    ]
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 25.0),
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment Method", style: TextStyle(color: Colors.grey)),
                      Text(args['card'], style: TextStyle(color: Colors.grey))
                    ]
                  )
                ),
                Divider(),
                Container(
                    margin: EdgeInsets.only(top: 15.0),
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("To"),
                          Text("CLABE")
                        ]
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 25.0),
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment Method", style: TextStyle(color: Colors.grey)),
                          Text("Visa 4digits", style: TextStyle(color: Colors.grey))
                        ]
                    )
                ),
                Divider(),
                Container(
                    margin: EdgeInsets.only(top: 15.0),
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date"),
                          Text('formatDate(args[date])')
                        ]
                    )
                ),
                Container(
                    width: SizeConfig.safeBlockHorizontal * 100,
                    margin: EdgeInsets.only(top: 15.0, bottom: 25.0),
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: Container(
                        child: Text(
                            'formatHour(args[date])',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.right
                        )
                    )
                ),
                Container(
                  width: 250.0,
                  height: 45.0,
                  margin: EdgeInsets.symmetric(vertical: 0.0),
                  child: RaisedButton(
                    onPressed: () => Navigator.of(context).popAndPushNamed("/chat"),
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text("Continuar")
                  )
                ),
                Container(
                  child: Text(
                      "¿Necesitas Ayuda?",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                      )
                  )
                )
              ]
            ),
          )
        )
      )
    );
  }

  formatDate(String date) {
    var sdf = DateFormat("dd/MM/yyyy");
    return sdf.format(DateTime.parse(date)) ?? 0;
  }

  formatHour(String date) {
    var sdf = DateFormat("HH:mm a");
    return sdf.format(DateTime.parse(date)) ?? 0;
  }

  String convertToTitleCase(String text) {
    if (text == null) {
      return null;
    }

    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = text.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
   //   final String firstLetter = word.substring(0, 1);
      //final String firstLetter = word.substring(0, 1).toUpperCase();
     // final String remainingLetters = word.substring(1);

      //return '$firstLetter$remainingLetters';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }

  // void _createChatUserLawyer(String user, String lawyer) {
  //   print("Creacion del documento: ");
  //   print(user);
  //   print(lawyer);
  //   String groupChatId = "";
  //   if (user.hashCode <= lawyer.hashCode) {
  //     groupChatId = '$user-$lawyer';
  //   } else {
  //     groupChatId = '$lawyer-$user';
  //   }
  //   if(user != null && lawyer != null) {
  //     FirebaseFirestore.instance
  //         .collection('messages')
  //         .doc(groupChatId)
  //         .set({
  //       'ignoreThis':
  //           'Be Ignored this just serves the purpose of the collection being created'
  //     });
  //   }
  // }

}
