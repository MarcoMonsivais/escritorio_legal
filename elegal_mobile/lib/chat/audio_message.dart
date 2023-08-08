import 'package:e_legal/rec/play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_l10n.dart';
import 'package:just_audio/just_audio.dart' as ja;

class AudioMessage extends StatelessWidget {

  final types.CustomMessage message;

  const AudioMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    // final _user = InheritedUser.of(context).user;
    // final _color = _user.id == message.author.id
    //     ? InheritedChatTheme.of(context).theme.sentMessageDocumentIconColor
    //     : InheritedChatTheme.of(context).theme.receivedMessageDocumentIconColor;

    ja.AudioSource audioSource = ja.AudioSource.uri(Uri.parse(message.metadata!['uri']));

    return Semantics(
      label: InheritedL10n.of(context).l10n.fileButtonAccessibilityLabel,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          InheritedChatTheme.of(context).theme.messageInsetsVertical,
          InheritedChatTheme.of(context).theme.messageInsetsVertical,
          InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
          InheritedChatTheme.of(context).theme.messageInsetsVertical,
        ),
        // color: Colors.red,
        // child: Text('Custom'),
        height: 60,
        width: 400,
        child: AudioPlayer(source: audioSource, onFinish: () { print('finish'); }, onDelete: () {  },),
      ),
    );
  }
}
