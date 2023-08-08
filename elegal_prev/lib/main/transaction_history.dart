import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toktok_app/globals.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TransactionHistory();
  }

}

class _TransactionHistory extends State<TransactionHistory> {
  List establishments = [];
  bool _showBusiness = false;
  QuerySnapshot dataFromFireStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTransactions();
  }
  @override
  void dispose() {
    dataFromFireStore = null;
    establishments.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Choice _selectedChoice = choices[0]; // The app's "state".
    void _select(Choice choice) {
      // Causes the app to rebuild with the new _selectedChoice.
      setState(() {
        _selectedChoice = choice;
        if(_selectedChoice.type == 'business')
          _showBusiness = true;
        else
          _showBusiness = false;
      });
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Transactions'),
        actions: <Widget>[
          // action button
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(choice.icon),
                      SizedBox(width: 5.0),
                      Text(choice.title),
                    ],
                  )
                );
              }).toList();
            },
          ),
        ],
      ),
      body: !_showBusiness ? _loadTransactions() : _loadBusiness()
    );
  }

  Widget _loadTransactions() {
    return FutureBuilder(
      future: _getTransactions(),
      initialData: Center(child: Text('Loading...'),),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading...'));
        }
        return projectSnap.data == null ?
        Container(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 40, right: SizeConfig.blockSizeHorizontal * 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('You do not have any transaction yet')
              ],
            )
        ) : ListView.builder(
          shrinkWrap: true,
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image(
                        image: NetworkImage(projectSnap.data[index]['logo'] != null ? projectSnap.data[index]['logo'] : 'https://cdn2.iconfinder.com/data/icons/web/512/Broken_Link-512.png'),
                        height: 80.0,
                        width: 120.0,

                      ),
                      SizedBox(width: 15.0),
                      Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              width: SizeConfig.blockSizeHorizontal * 30,
                              height: 25,
                              child: Text(
                                projectSnap.data[index]['name'] != null ? projectSnap.data[index]['name'] : 'null',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),
                              )
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              width: SizeConfig.blockSizeHorizontal * 30,
                              height: 25,
                              child: Text(
                                projectSnap.data[index]['fecha'] != null ? projectSnap.data[index]['fecha'].toString() : 'null',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(width: 45.0),
                      Column(
                        children: <Widget>[
                          Container(
                            child: Text(projectSnap.data[index]['time'] != null ? '${projectSnap.data[index]['time'].toString()}' : 'time',),
                          ),
                          Container(
                            child: Text(
                                projectSnap.data[index]['amount'] != null ? '\$${projectSnap.data[index]['amount'].toString()}' : 'null',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22.0
                                )
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(height: 2.0, thickness: 1.0, color: Colors.blueGrey)
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _loadBusiness() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 20),decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('https://vectorforfree.com/wp-content/uploads/2019/04/BMW_Car_PNG_VectorForFree.jpg'), fit: BoxFit.fill)), width: SizeConfig.blockSizeHorizontal * 70, height: SizeConfig.blockSizeVertical * 20),
          Text('Welcome to Business', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800)),
          SizedBox(height: SizeConfig.blockSizeVertical*2),
          Text('Set your Business Profile preferences to get receipts in your work email, add a different payment method, simplify the surrender of expenses and more.', style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center,)
        ],
      ),
    );
  }

  Future _getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List newList;
    var helpMe = <Map> [];

    dataFromFireStore = await FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: prefs.getInt('userId'))
        .orderBy('date', descending: true)
        .get();

    if(dataFromFireStore.docs.isNotEmpty){
      dataFromFireStore.docs.forEach((json) {
        establishments.add(json.data()['establishmentId']);
      });
      newList = establishments.toSet().toList();

      final ids = newList.reduce((value, element) => value + ',' + element);

      final _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('access_token')} '
      };

      var establish = await http.post(
        Uri.parse('${Globals.BASE_API_URL}/establishments/getInfo'),
        headers: _headers,
        body: jsonEncode({'ids' : ids})
      );

      var establishInfo = jsonDecode(establish.body);

      dataFromFireStore.docs.forEach((trans) {
        var mapHelper = {};

        var date = trans.data()['date'].toDate();
        final f = DateFormat('HH:mm dd-MM-yyyy');

        mapHelper['fecha'] = f.format(date);
        mapHelper['amount'] = trans.data()['amount'];
        mapHelper['time'] = trans.data()['time'];

        for(var i = 0; i < newList.length; i++){
          if(trans.data()['establishmentId'] == establishInfo['data'][i]['establishmentId'].toString()){
            mapHelper['logo'] = establishInfo['data'][i]['logo'];
            mapHelper['name'] = establishInfo['data'][i]['name'];

            helpMe.add(mapHelper);

          }
        }


      });

      return helpMe;
      
    }
  }

}

class Choice {
  const Choice({this.title, this.icon, this.type});

  final String title;
  final IconData icon;
  final String type;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Personal', icon: Icons.directions_car, type: 'personal'),
  const Choice(title: 'Business', icon: Icons.business_center, type: 'business'),
];
