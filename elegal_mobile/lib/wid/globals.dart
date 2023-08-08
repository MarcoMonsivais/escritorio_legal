library global;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool logged = false, modeDebug = false;
String role = '',
    userId = '',
    userName = '',
    userCedula = '',
    imageProfileUrl = '';
//
// final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final navigatorKey = GlobalKey<NavigatorState>();

String GlobalPK = '', GlobalSK = '';

int loggedWith = 0;
//1 correo
//2 google
//3 facebook
//4 apple

Map<String, dynamic>? userFacebook;

bool fromNotification = false, reponseNotification = false;
String notificationGlobalId = '';
String chatGlobalId = '';

String OneSignalId = '0d781e5f-f216-4ba9-80b1-e2b525eed7c6';
String currentVer = '02.03.05';

class ProblemList {
  final String id;
  final String description;

  ProblemList({required this.id, required this.description});

  @override
  String toString() => id;

  @override
  operator ==(o) => o is ProblemList && o.id == id;

  @override
  int get hashCode => id.hashCode ^ id.hashCode;
}

class RequestItem {
  final String cateroy;
  final String description;
  final String name;
  final String phone;

  RequestItem(
      {required this.cateroy,
      required this.description,
      required this.name,
      required this.phone});
}
