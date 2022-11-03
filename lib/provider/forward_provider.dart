import 'dart:io';

import 'package:chat_app/model/social_chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/user_model_class.dart';


class ForwardProvider extends ChangeNotifier {

  List<AppUser> _usersList=[];
  List<String> _groupList=[];


  List<String> get groupList => _groupList;

  List<AppUser> get usersList => _usersList;

  void setUserList(value) {
    _usersList = value;
    notifyListeners();
  }

  bool checkSelectedUser(String value) {
    bool selected=false;
    _usersList.forEach((element) {
      if(element.userId==value){
        selected=true;
      }
    });
    return selected;
  }

  void addUserToList(value) {
    _usersList.add(value);
    notifyListeners();
  }

  void addGroupToList(value) {
    _groupList.add(value);
    notifyListeners();
  }
  void removeGroupFromList(String value) {
    _groupList.remove(value);

    notifyListeners();
  }
  void removeUserFromList(String value) {
    _usersList.removeWhere((element) => element.userId==value);

    notifyListeners();
  }
  void clearUserList() {
    _usersList.clear();
    notifyListeners();
  }

  void clearGroupList() {
    _groupList.clear();
    notifyListeners();
  }

  void forwardReset(){
    clearUserList();
    clearGroupList();
    notifyListeners();
  }


}
