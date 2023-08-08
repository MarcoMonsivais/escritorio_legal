import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok_app/globals.dart';
import 'dart:convert';
import 'package:toktok_app/app_localizations.dart';

import 'package:toktok_app/helpers/size_config.dart';

class ListCoupons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).coupons),
      ),
      body: Container(
        child: projectWidget(),
      ),
    );
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: _getCoupons(),
      initialData: 'Loading',
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting ) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Text('Loading...');
        }
        return ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 3,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 15,
                      height: SizeConfig.blockSizeVertical * 10,
                      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                      child: Column(
                        children: <Widget>[
                          Image(
                            image: NetworkImage(projectSnap.data[index]['photo'] != null ? projectSnap.data[index]['photo'] : 'https://cdn2.iconfinder.com/data/icons/web/512/Broken_Link-512.png' ),
                            height: 50.0,
                            width: 70.0,
                          ),
                          Text(
                            projectSnap.data[index]['couponCode'],
                          )
                        ],
                      ),
                    ),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 65,
                        height: SizeConfig.blockSizeVertical * 10,
                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  projectSnap.data[index]['couponName'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                            ),
                            Container(
                                child: Text(
                                  projectSnap.data[index]['description'],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey
                                  ),
                                )
                            )
                          ],
                        ),
                    )
                  ],
                )
              ],
            );
          },
        );
      },
    );

  }

  Future _getCoupons() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/coupons/getCouponForUser/${prefs.getInt('userId')}'),
        headers: {
          'Authorization': 'Bearer ${prefs.getString('access_token')}',
          'Content-Type': 'application/json'
        }
    );

    var c = (jsonDecode(response.body));

    return c['data'];
  }

}