import 'dart:io';

import 'package:chat_app/model/social_chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';


class ChatProvider extends ChangeNotifier {
  bool _showSend=false;
  bool _reply=false;
  bool _options=false;
  SocialChatModel? _selectedModel;
  List<SocialChatModel> _selectedList=[];


  List<SocialChatModel> get selectedList => _selectedList;

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

  bool showDelete() {
    bool _showDelete=true;
    _selectedList.forEach((element) {
      if(element.senderId!=FirebaseAuth.instance.currentUser!.uid){
        _showDelete=false;
      }
    });
    return _showDelete;
  }

  void setSelectedList(value) {
    _selectedList = value;
    notifyListeners();
  }

  void addSelectedList(value) {
    _selectedList.add(value);
    notifyListeners();
  }
  void removeSelectedList(value) {
    _selectedList.remove(value);
    notifyListeners();
  }
  void clearSelectedList() {
    _selectedList.clear();
    notifyListeners();
  }

  void setOptions(bool value) {
    _options = value;
    notifyListeners();
  }

  ChatProvider(){
    initRecorder();
  }
  void chatReset(){
    setOptions(false);
    setReply(false);
    setSelectedModel(null);
    selectedList.clear();
    notifyListeners();
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
