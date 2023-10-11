import 'package:flutter/cupertino.dart';

import '../model/user_model_class.dart';

class UserDataProvider extends ChangeNotifier {
  AppUser? userData;
  void setUserData(AppUser user) {
    userData = user;
    notifyListeners();
  }

  void setUserId(String id) {
    userData!.userId = id;
    notifyListeners();
  }
}