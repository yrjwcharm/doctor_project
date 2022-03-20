import 'dart:convert';
import 'dart:io';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/make_prescription.dart';
import 'package:doctor_project/pages/my/write-case.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodChannel, PlatformException, rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

import '../../utils/svg_utils.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          '刘猛患者',
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: const ChatPage(),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  bool _isVoice = false;
  bool _isMore = false;
  double keyboardHeight = 270.0;
  bool _emojiState = false;
  FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _emojiState = false;
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void pickerImage(ImageSource source) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }


  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }
  void _goToHealthHutModular() async {
    const platform = const MethodChannel("flutterPrimordialBrige");
    bool result = false;
    try {
      result = await platform.invokeMethod("jumpToCallVideo"); //分析2
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      customBottomWidget: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 54.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration:  BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
              ),
              child: Row(
                children: <Widget>[
                  SvgUtil.svg('voice.svg'),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                      child: Container(
                          height: 33.0,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              color: ColorsUtil.hexStringColor('#f8f8f8'),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: TextField(
                            inputFormatters: [],
                            cursorColor: ColorsUtil.hexStringColor('#666666'),
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                hintText: '输入你想回复患者的话…',
                                hintStyle: GSYConstant.textStyle(
                                    fontSize: 13.0, color: '#999999')),
                          ))),
                  const SizedBox(
                    width: 21.0,
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            _emojiState = !_emojiState;
                            _isMore = false;
                          });
                        },
                        child:SvgUtil.svg('smile.svg'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _isMore = !_isMore;
                            _emojiState = false;
                          });
                        },
                        child: SvgUtil.svg('add_.svg'),)

                    ],
                  ),
                ],
              ),
            ),
           Offstage(
             offstage: !_isMore,
             child: Container(
               padding: const EdgeInsets.only(top: 11.0,bottom:10.0),
               child:Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap:(){
                          pickerImage(ImageSource.gallery);
                      },
                       child: SvgUtil.svg('picture.svg'),),
                      const SizedBox(height: 9.0,),
                      Text('相册',style: GSYConstant.textStyle(color: '#333333',fontSize: 12.0),)
                    ],
                  ),
                 Column(
                   children: <Widget>[
                     GestureDetector(
                       onTap: (){
                         pickerImage(ImageSource.camera);
                       },
                      child: SvgUtil.svg('camera.svg'),),
                     const SizedBox(height: 9.0,),

                     Text('拍摄',style: GSYConstant.textStyle(color: '#333333',fontSize: 12.0),)
                   ],
                 ),
                 Column(
                   children: <Widget>[
                     GestureDetector(
                       onTap: (){
                         _goToHealthHutModular();
                       },
                       child: SvgUtil.svg('rp.svg'),),
                     const SizedBox(height: 9.0,),
                     Text('视频通话',style: GSYConstant.textStyle(color: '#333333',fontSize: 12.0),)
                   ],
                 ),
                 Column(
                   children: <Widget>[
                     GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const MakePrescription()));
                       },
                      child: SvgUtil.svg('rp.svg'),),
                     const SizedBox(height: 9.0,),
                     Text('开处方',style: GSYConstant.textStyle(color: '#333333',fontSize: 12.0),)
                   ],
                 ),
                 Column(
                   children: <Widget>[
                     GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const WriteCase()));
                       },
                      child: SvgUtil.svg('case.svg'),),
                     const SizedBox(height: 9.0,),
                     Text('写病历',style: GSYConstant.textStyle(color: '#333333',fontSize: 12.0),)
                   ],
                 ),
                 // Column(
                 //   children: <Widget>[
                 //     GestureDetector(
                 //      child: SvgUtil.svg('words.svg'),),
                 //     const SizedBox(height: 9.0,),
                 //     Text('常用语',style: GSYConstant.textStyle(color: '#333333',fontSize: 12.0),)
                 //   ],
                 // ),
               ],
             ),)
           ),
            Offstage(
              offstage: !_emojiState,
              child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      // Do something when emoji is tapped
                    },
                    onBackspacePressed: () {
                      // Backspace-Button tapped logic
                      // Remove this line to also remove the button in the UI
                    },
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      initCategory: Category.RECENT,
                      bgColor: Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      progressIndicatorColor: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      noRecentsText: 'No Recents',
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  )),
            )
          ],
        ),
      ),
      emojiEnlargementBehavior: EmojiEnlargementBehavior.multi,
      showUserAvatars: true,
      showUserNames: true,
      messages: _messages,
      onAttachmentPressed: _handleAtachmentPressed,
      onMessageTap: _handleMessageTap,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: _handleSendPressed,
      user: _user,
    );
  }
}
