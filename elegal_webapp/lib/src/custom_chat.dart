import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegal/src/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_l10n.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_chat_ui/src/chat_l10n.dart';
import 'package:flutter_chat_ui/src/chat_theme.dart';
import 'package:flutter_chat_ui/src/conditional/conditional.dart';
import 'package:flutter_chat_ui/src/models/date_header.dart';
import 'package:flutter_chat_ui/src/models/emoji_enlargement_behavior.dart';
import 'package:flutter_chat_ui/src/models/message_spacer.dart';
import 'package:flutter_chat_ui/src/models/preview_image.dart';
import 'package:flutter_chat_ui/src/models/send_button_visibility_mode.dart';
import 'package:flutter_chat_ui/src/util.dart';
import 'package:flutter_chat_ui/src/widgets/chat_list.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_user.dart';
import 'package:flutter_chat_ui/src/widgets/input.dart';
import 'package:flutter_chat_ui/src/widgets/message.dart';

import 'package:just_audio/just_audio.dart' as ap;
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../helpers/global.dart';

class AudioRecorderChat extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorderChat({required this.onStop});

  @override
  _AudioRecorderChatState createState() => _AudioRecorderChatState();
}

class _AudioRecorderChatState extends State<AudioRecorderChat> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRecordStopControl(),
                const SizedBox(width: 20),
                _buildPauseResumeControl(),
                const SizedBox(width: 20),
                _buildText(),
              ],
            ),
            if (_amplitude != null) ...[
              const SizedBox(height: 40),
              Text('Current: ${_amplitude?.current ?? 0.0}'),
              Text('Max: ${_amplitude?.max ?? 0.0}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_isRecording || _isPaused) {
      icon = Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isRecording ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (!_isPaused) {
      icon = Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isPaused ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return const Text("Esperando para grabar");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();

    widget.onStop(path!);

    setState(() => _isRecording = false);
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
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
}

class CustomChat extends StatefulWidget {

  const CustomChat({
    Key? key,
    this.requestinfo,
    required this.isHistory,
    this.roomId,
    this.bubbleBuilder,
    this.customBottomWidget,
    this.customDateHeaderText,
    this.customMessageBuilder,
    this.dateFormat,
    this.dateHeaderThreshold = 900000,
    this.dateLocale,
    this.disableImageGallery,
    this.emojiEnlargementBehavior = EmojiEnlargementBehavior.multi,
    this.emptyState,
    this.fileMessageBuilder,
    this.groupMessagesThreshold = 60000,
    this.hideBackgroundOnEmojiMessages = true,
    this.imageMessageBuilder,
    this.isAttachmentUploading,
    this.isLastPage,
    this.l10n = const ChatL10nEn(),
    required this.messages,
    this.onAttachmentPressed,
    this.onAvatarTap,
    this.onBackgroundTap,
    this.onEndReached,
    this.onEndReachedThreshold,
    this.onMessageLongPress,
    this.onMessageStatusLongPress,
    this.onMessageStatusTap,
    this.onMessageTap,
    this.onPreviewDataFetched,
    required this.onSendPressed,
    this.onTextChanged,
    this.onTextFieldTap,
    this.scrollPhysics,
    this.sendButtonVisibilityMode = SendButtonVisibilityMode.editing,
    this.showUserAvatars = false,
    this.showUserNames = false,
    this.textMessageBuilder,
    this.theme = const DefaultChatTheme(),
    this.timeFormat,
    this.usePreviewData = true,
    required this.user,
  }) : super(key: key);

  final RequestItem? requestinfo;

  final bool isHistory;

  final String? roomId;

  final Widget Function(
      Widget child, {
      required types.Message message,
      required bool nextMessageInGroup,
      })? bubbleBuilder;

  final Widget? customBottomWidget;

  final String Function(DateTime)? customDateHeaderText;

  final Widget Function(types.CustomMessage, {required int messageWidth})?
  customMessageBuilder;

  final DateFormat? dateFormat;

  final int dateHeaderThreshold;

  final String? dateLocale;

  final bool? disableImageGallery;

  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  final Widget? emptyState;

  final Widget Function(types.FileMessage, {required int messageWidth})?
  fileMessageBuilder;

  final int groupMessagesThreshold;

  final bool hideBackgroundOnEmojiMessages;

  final Widget Function(types.ImageMessage, {required int messageWidth})?
  imageMessageBuilder;

  final bool? isAttachmentUploading;

  final bool? isLastPage;

  final ChatL10n l10n;

  final List<types.Message> messages;

  final void Function()? onAttachmentPressed;

  final void Function(types.User)? onAvatarTap;

  final void Function()? onBackgroundTap;

  final Future<void> Function()? onEndReached;

  final double? onEndReachedThreshold;

  final void Function(types.Message)? onMessageLongPress;

  final void Function(types.Message)? onMessageStatusLongPress;

  final void Function(types.Message)? onMessageStatusTap;

  final void Function(types.Message)? onMessageTap;

  final void Function(types.TextMessage, types.PreviewData)?
  onPreviewDataFetched;

  final void Function(types.PartialText) onSendPressed;

  final void Function(String)? onTextChanged;

  final void Function()? onTextFieldTap;

  final ScrollPhysics? scrollPhysics;

  final SendButtonVisibilityMode sendButtonVisibilityMode;

  final bool showUserAvatars;

  final bool showUserNames;

  final Widget Function(
      types.TextMessage, {
      required int messageWidth,
      required bool showName,
      })? textMessageBuilder;

  final ChatTheme theme;

  final DateFormat? timeFormat;

  final bool usePreviewData;

  final types.User user;

  @override
  _CustomChatState createState() => _CustomChatState();
}

class _CustomChatState extends State<CustomChat> {
  List<Object> _chatMessages = [];
  List<PreviewImage> _gallery = [];
  int _imageViewIndex = 0;
  bool _isImageViewVisible = false;

  bool isAud = false;
  bool showPlayer = false;
  ap.AudioSource? audioSource;

  @override
  void initState() {
    super.initState();
    showPlayer = false;
    didUpdateWidget(widget);
    print('customchat');
    try {
      if (widget.requestinfo!.name.isNotEmpty) {
        if (widget.requestinfo!.name != 'name') {

          SharedPreferences.getInstance().then((value) {

            FirebaseChatCore.instance.sendMessage(
              types.PartialText(text:
              '¡Hola, ' + widget.requestinfo!.name +
                  ', gracias por utilizar Escritorio Legal! Te atiende ' +
                  value.getString('lastUser')! + ' y estaré atendiendo tu caso de tipo ' +
                  widget.requestinfo!.cateroy +
                  '. De ser necesario, te contactaremos al número ' +
                  widget.requestinfo!.phone +
                  '. Esta es la última descripción que tenemos de tu caso, ¿te gustaría agregar información? Descripción: ' +
                  widget.requestinfo!.description
              ),
              widget.roomId!,
            );
          });


        }
      }
    } catch(onerror){
      print('FATAL CUSTOM BUILDER EMPTY: ' + onerror.toString());
    }


  }

  @override
  void didUpdateWidget(covariant CustomChat oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages.isNotEmpty) {
      final result = calculateChatMessages(
        widget.messages,
        widget.user,
        customDateHeaderText: widget.customDateHeaderText,
        dateFormat: widget.dateFormat,
        dateHeaderThreshold: widget.dateHeaderThreshold,
        dateLocale: widget.dateLocale,
        groupMessagesThreshold: widget.groupMessagesThreshold,
        showUserNames: widget.showUserNames,
        timeFormat: widget.timeFormat,
      );

      _chatMessages = result[0] as List<Object>;
      _gallery = result[1] as List<PreviewImage>;
    }
  }

  Widget _emptyStateBuilder() {
    return widget.emptyState ??
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Text(
            //widget.l10n.emptyChatPlaceholder
            'Sin mensajes aún en chat',
            style: widget.theme.emptyChatPlaceholderTextStyle,
            textAlign: TextAlign.center,
          ),
        );
  }

  Widget _imageGalleryBuilder() {
    return Dismissible(
      key: const Key('photo_view_gallery'),
      direction: DismissDirection.down,
      onDismissed: (direction) => _onCloseGalleryPressed(),
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            builder: (BuildContext context, int index) =>
                PhotoViewGalleryPageOptions(
                  imageProvider: Conditional().getProvider(_gallery[index].uri),
                ),
            itemCount: _gallery.length,
            loadingBuilder: (context, event) =>
                _imageGalleryLoadingBuilder(context, event),
            onPageChanged: _onPageChanged,
            pageController: PageController(initialPage: _imageViewIndex),
            scrollPhysics: const ClampingScrollPhysics(),
          ),
          Positioned(
            right: 16,
            top: 56,
            child: CloseButton(
              color: Colors.white,
              onPressed: _onCloseGalleryPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageGalleryLoadingBuilder(BuildContext context, ImageChunkEvent? event,) {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          value: event == null || event.expectedTotalBytes == null
              ? 0
              : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
        ),
      ),
    );
  }

  Widget _messageBuilder(Object object, BoxConstraints constraints) {

    if (object is DateHeader) {
      return Container(
        alignment: Alignment.center,
        margin: widget.theme.dateDividerMargin,
        child: Text(
          object.text,
          style: widget.theme.dateDividerTextStyle,
        ),
      );
    } else if (object is MessageSpacer) {
      return SizedBox(
        height: object.height,
      );
    } else {
      final map = object as Map<String, Object>;
      final message = map['message']! as types.Message;
      final _messageWidth =
          widget.showUserAvatars && message.author.id != widget.user.id
              ? min(constraints.maxWidth * 0.72, 440).floor()
              : min(constraints.maxWidth * 0.78, 440).floor();

      //Linea 192 de message.dart
      // return customMessageBuilder != null
      //     ? customMessageBuilder!(customMessage, messageWidth: messageWidth)
      //     : AudioMessage(message: customMessage);

      return Message(
        key: ValueKey(message.id),
        bubbleBuilder: widget.bubbleBuilder,
        customMessageBuilder: widget.customMessageBuilder,
        emojiEnlargementBehavior: widget.emojiEnlargementBehavior,
        fileMessageBuilder: widget.fileMessageBuilder,
        hideBackgroundOnEmojiMessages: widget.hideBackgroundOnEmojiMessages,
        imageMessageBuilder: widget.imageMessageBuilder,
        message: message,
        messageWidth: _messageWidth,
        onAvatarTap: widget.onAvatarTap,
        // onMessageLongPress: widget.onMessageLongPress,
        // onMessageStatusLongPress: widget.onMessageStatusLongPress,
        // onMessageStatusTap: widget.onMessageStatusTap,
        onMessageTap: (context,tappedMessage) {
          if (tappedMessage is types.ImageMessage && widget.disableImageGallery != true) {
            _onImagePressed(tappedMessage);
          }

          widget.onMessageTap?.call(tappedMessage);
        },
        onPreviewDataFetched: _onPreviewDataFetched,
        roundBorder: map['nextMessageInGroup'] == true,
        showAvatar: map['nextMessageInGroup'] == false,
        showName: map['showName'] == true,
        showStatus: map['showStatus'] == true,
        showUserAvatars: widget.showUserAvatars,
        textMessageBuilder: widget.textMessageBuilder,
        usePreviewData: widget.usePreviewData,
        ///requiered
        isTextMessageTextSelectable: true,
        previewTapOptions: PreviewTapOptions(),
      );

    }

  }

  void _onCloseGalleryPressed() {
    setState(() {
      _isImageViewVisible = false;
    });
  }

  void _onImagePressed(types.ImageMessage message) {
    setState(() {
      _imageViewIndex = _gallery.indexWhere(
            (element) => element.id == message.id && element.uri == message.uri,
      );
      _isImageViewVisible = true;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _imageViewIndex = index;
    });
  }

  void _onPreviewDataFetched(types.TextMessage message, types.PreviewData previewData,) {
    widget.onPreviewDataFetched?.call(message, previewData);
  }

  @override
  Widget build(BuildContext context) {
    print('inhert');
    return InheritedUser(
      user: widget.user,
      child: InheritedChatTheme(
        theme: widget.theme,
        child: InheritedL10n(
          l10n: widget.l10n,
          child: Stack(
            children: [
              Container(
                color: widget.theme.backgroundColor,
                child: Column(
                  children: [

                    Flexible(
                      child: widget.messages.isEmpty
                          ? SizedBox.expand(
                              child: _emptyStateBuilder(),
                            )
                            : GestureDetector(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  widget.onBackgroundTap?.call();
                                },
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) =>
                                    ChatList(
                                      isLastPage: widget.isLastPage,
                                      itemBuilder: (item, index) => _messageBuilder(item, constraints),
                                      items: _chatMessages,
                                      onEndReached: widget.onEndReached,
                                      onEndReachedThreshold: widget.onEndReachedThreshold,
                                      scrollPhysics: widget.scrollPhysics,
                                    ),
                        ),
                      ),
                    ),

                    FutureBuilder<DocumentSnapshot>(
                      future: widget.isHistory ?
                        FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('history').doc(widget.roomId).get() :
                        FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(widget.roomId).get(),
                      builder: (context, snapshot){

                        if(snapshot.connectionState == ConnectionState.done) {
                          DocumentSnapshot ds = snapshot.data!;
                            if (ds['status'] == 'active') {
                              //widget.customBottomWidget ??
                              return Row(children: [
                                Expanded(
                                    child: InputCustom(
                                  roomIdIn: widget.roomId,
                                  isAttachmentUploading: widget.isAttachmentUploading,
                                  onAttachmentPressed: widget.onAttachmentPressed,
                                  onSendPressed: widget.onSendPressed,
                                  onTextChanged: widget.onTextChanged,
                                  onTextFieldTap: widget.onTextFieldTap,
                                  sendButtonVisibilityMode: widget.sendButtonVisibilityMode,
                                )),
                              ]);
                            } else {
                              return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.98,
                                  height: 60,
                                  margin: const EdgeInsets.only(top: 6.0),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30.0)),
                                    color: Colors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Chat Inactivo\nEl periodo de tiempo de este chat ha caducado.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )));
                            }
                          }

                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const SizedBox.shrink();
                        }
                        
                        return const SizedBox.shrink();

                      }
                    ),

                  ],
                ),
              ),
              if (_isImageViewVisible) _imageGalleryBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
