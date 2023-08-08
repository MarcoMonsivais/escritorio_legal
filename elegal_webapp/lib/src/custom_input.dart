// import 'package:elegal/rec/play.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:elegal/helpers/global_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_ui/src/models/send_button_visibility_mode.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/src/widgets/attachment_button.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_l10n.dart';
import 'package:flutter_chat_ui/src/widgets/send_button.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:io' as i;
import 'dart:html' as h;

class NewLineIntentCustom extends Intent {
  const NewLineIntentCustom();
}

class SendMessageIntentCustom extends Intent {
  const SendMessageIntentCustom();
}

class InputCustom extends StatefulWidget {

  const InputCustom({
    Key? key,
    this.roomIdIn,
    this.isAttachmentUploading,
    this.onAttachmentPressed,
    required this.onSendPressed,
    this.onTextChanged,
    this.onTextFieldTap,
    required this.sendButtonVisibilityMode,
  }) : super(key: key);

  final String? roomIdIn;

  final void Function()? onAttachmentPressed;

  final bool? isAttachmentUploading;

  final void Function(types.PartialText) onSendPressed;

  final void Function(String)? onTextChanged;

  final void Function()? onTextFieldTap;

  final SendButtonVisibilityMode sendButtonVisibilityMode;

  @override
  _InputCustomState createState() => _InputCustomState();
}

class _InputCustomState extends State<InputCustom> {

  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;

  final _inputFocusNode = FocusNode();
  bool _sendButtonVisible = false;
  final _textController = TextEditingController();

  bool showPlayer = false;
  bool reproductor = false;
  late ap.AudioSource audioSource;

  late final String minutes;
  late final String seconds;

  @override
  void initState() {

    // path = '';

    super.initState();

    if (widget.sendButtonVisibilityMode == SendButtonVisibilityMode.editing) {
      _sendButtonVisible = _textController.text.trim() != '';
      _textController.addListener(_handleTextControllerChange);
    } else {
      _sendButtonVisible = true;
    }
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  String _formatNumberGlobal(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  void _handleSendPressed() {
    final trimmedText = _textController.text.trim();
    if (trimmedText != '') {
      final _partialText = types.PartialText(text: trimmedText);
      widget.onSendPressed(_partialText);
      _textController.clear();
    }
  }

  void _handleTextControllerChange() {
    setState(() {
      _sendButtonVisible = _textController.text.trim() != '';
    });
  }

  Widget _leftWidget() {
    if (widget.isAttachmentUploading == true) {
      return Container(
        height: 24,
        margin: const EdgeInsets.only(right: 16),
        width: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            InheritedChatTheme.of(context).theme.inputTextColor,
          ),
        ),
      );
    } else {
      return AttachmentButton(onPressed: widget.onAttachmentPressed);
    }
  }

  Widget _buildTimer() {
    final String minutes = _formatNumberGlobal(_recordDuration ~/ 60);
    final String seconds = _formatNumberGlobal(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.red),
    );
  }

  void _startTimerCustom() {

    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
          _amplitude = await _audioRecorder.getAmplitude();
          setState(() {});
        });
  }

  _sendAudio(String path) async {

    try {

      Uint8List imageData = await XFile(path).readAsBytes();

      final reference = FirebaseStorage.instance.ref('e_legal/conf/rooms/' + widget.roomIdIn! + '/' + DateTime.now().hour.toString() + DateTime.now().minute.toString() + DateTime.now().second.toString()  + '.m4a');
      await reference.putData(imageData);
      final uri = await reference.getDownloadURL();

      final message = types.PartialCustom(
          metadata: {
            'mimeType': 'audio/m4a',
            'name': 'voicenote',
            'uri' : uri
          }
      );

      FirebaseChatCore.instance.sendMessage(
        message,
        widget.roomIdIn!,
      );


    } catch (onError){


      print(onError);
    }

  }

  @override
  Widget build(BuildContext context) {
    final _query = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => _inputFocusNode.requestFocus(),
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const SendMessageIntentCustom(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.alt):
          const NewLineIntentCustom(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.shift):
          const NewLineIntentCustom(),
        },
        child: Actions(
          actions: {
            SendMessageIntent: CallbackAction<SendMessageIntent>(
              onInvoke: (SendMessageIntent intent) => _handleSendPressed(),
            ),
            NewLineIntent: CallbackAction<NewLineIntent>(
              onInvoke: (NewLineIntent intent) {
                final _newValue = '${_textController.text}\r\n';
                _textController.value = TextEditingValue(
                  text: _newValue,
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: _newValue.length),
                  ),
                );
              },
            ),
          },
          child: Focus(
            autofocus: false,
            child: Material(
              borderRadius: InheritedChatTheme.of(context).theme.inputBorderRadius,
              color: InheritedChatTheme.of(context).theme.inputBackgroundColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  24 + _query.padding.left,
                  20,
                  24 + _query.padding.right,
                  20 + _query.viewInsets.bottom + _query.padding.bottom,
                ),
                child: !reproductor ?
                Row(
                  children: [
                    if (widget.onAttachmentPressed != null) _leftWidget(),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        cursorColor: InheritedChatTheme.of(context).theme.inputTextCursorColor,
                        decoration: InheritedChatTheme.of(context).theme.inputTextDecoration.copyWith(
                          hintStyle: InheritedChatTheme.of(context).theme.inputTextStyle.copyWith(color: InheritedChatTheme.of(context).theme.inputTextColor.withOpacity(0.5),),
                          hintText: 'Escribe un mensaje aquí',
                        ),
                        focusNode: _inputFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: widget.onTextChanged,
                        onTap: widget.onTextFieldTap,
                        style: InheritedChatTheme.of(context).theme.inputTextStyle.copyWith(color: InheritedChatTheme.of(context).theme.inputTextColor,),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (await _audioRecorder.hasPermission()) {

                            await _audioRecorder.start();

                            bool isRecording = await _audioRecorder.isRecording();

                            setState(() {
                              _isRecording = isRecording;
                              _recordDuration = 0;
                              reproductor = true;
                            });

                            _startTimerCustom();

                          }
                        },
                        child: Icon(Icons.mic, color: Colors.white, size: 30)),
                    Visibility(
                      visible: _sendButtonVisible,
                      child: SendButton(
                        onPressed: _handleSendPressed,
                      ),
                    ),
                  ],
                ):
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {

                        setState(() {
                          _isPaused = false;
                          reproductor = false;
                        });
                      },
                      child: Icon(Icons.delete, color: Colors.red, size: 30),
                    ),
                    const SizedBox(width: 10,),
                    _buildTimer(),
                    const SizedBox(width: 20,),
                    if (_amplitude != null) ...[
                      const SizedBox(height: 40),
                      //Grabando y pausa
                      Expanded(child: Text(
                        _isPaused ?
                        'Pausa' : 'Grabando...'
                        , style: const TextStyle(color: Colors.red),)),
                      // Text('Current: ${_amplitude?.current ?? 0.0}', style: TextStyle(color: Colors.white),),
                      // Text('Max: ${_amplitude?.max ?? 0.0}', style: TextStyle(color: Colors.white)),
                    ],
                    const SizedBox(width: 10,),
                    !_isPaused ?
                      GestureDetector(
                        onTap: () async {

                          _timer?.cancel();
                          _ampTimer?.cancel();
                          await _audioRecorder.pause();

                          setState(() => _isPaused = true);
                        },
                        child: const Icon(Icons.pause, color: Colors.red, size: 30) ,
                      ):
                      GestureDetector(
                        onTap: () async {

                          _startTimerCustom();
                          await _audioRecorder.resume();

                          setState(() => _isPaused = false);
                        },
                        child: const Icon(Icons.play_arrow, color: Colors.red, size: 30) ,
                      ),
                    GestureDetector(
                      onTap: () async {
                        try
                        {
                          _timer?.cancel();
                          _ampTimer?.cancel();

                          String? path2 = await _audioRecorder.stop();
                          audioSource = ap.AudioSource.uri(Uri.parse(path2!));

                          _sendAudio(path2);

                          setState(() {
                            _isPaused = false;
                            reproductor = false;
                          });
                        } catch(onError){
                          print('Err: ' + onError.toString());
                        }
                      },
                      child: const Icon(Icons.check, color: Colors.blue, size: 30) ,
                    )
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

}
