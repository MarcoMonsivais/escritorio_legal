import 'package:flutter_chat/chatData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chatWidget.dart';

class Chat extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  State<StatefulWidget> createState() {
    return _Chat();
  }
}

class _Chat extends State<Chat> {
  @override
  void initState() {
    super.initState();
    ChatData.init("Chatea con un abogado",context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ChatWidget.getAppBar(),
        backgroundColor: Colors.white,
        body: ChatWidget.widgetWelcomeScreen(context));
  }
}