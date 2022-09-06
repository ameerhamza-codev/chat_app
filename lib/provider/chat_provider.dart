import 'dart:io';

import 'package:chat_app/model/social_chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';


class ChatProvider extends ChangeNotifier {
  bool _showSend=false;
  bool _reply=false;
  bool _options=false;
  SocialChatModel? _selectedModel;


  bool get showSend => _showSend;
  bool get options => _options;

  get selectedModel => _selectedModel;

  bool get reply => _reply;

  void setShowSend(bool value) {
    _showSend = value;
    notifyListeners();
  }

  void setReply(bool value) {
    _reply = value;
    if(!_reply)
      setSelectedModel(null);
    notifyListeners();
  }
  void setSelectedModel(value) {
    _selectedModel = value;
    notifyListeners();
  }

  void setOptions(bool value) {
    _options = value;
    if(!_options)
      setSelectedModel(null);
    notifyListeners();
  }

  ChatProvider(){
    initRecorder();
  }
  bool isRecordReady=false;
  final recorder=FlutterSoundRecorder();

  Future record()async{
    await recorder.startRecorder(toFile: 'audio');
    notifyListeners();

  }
  Future<File> stop()async{
    final path=await recorder.stopRecorder();
    notifyListeners();
    print("file path : $path");
    return File(path!);
  }
  Future initRecorder() async{
    final status= await Permission.microphone.request();
    if(status!=PermissionStatus.granted){
      throw 'permission not granted';
    }
    await recorder.openRecorder();
    isRecordReady=true;
    notifyListeners();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));

  }
}
