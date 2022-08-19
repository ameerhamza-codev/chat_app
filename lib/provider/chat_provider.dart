import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';


class ChatProvider extends ChangeNotifier {
  bool _showSend=false;

  bool get showSend => _showSend;

  void setShowSend(bool value) {
    _showSend = value;
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
