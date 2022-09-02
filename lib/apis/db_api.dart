import 'package:chat_app/model/social_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model_class.dart';

class DBApi{

  static Future<AppUser> getUserData(String id)async{
    AppUser? request;
    await FirebaseFirestore.instance.collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        request= AppUser.fromMap(data, documentSnapshot.reference.id);
      }
      else{
        print("no user found $id");
      }
    });
    return request!;
  }

  static Future<SocialChatModel> getSocialChat(String id)async{
    SocialChatModel? model;
    await FirebaseFirestore.instance.collection('social_chat')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        model= SocialChatModel.fromMap(data, documentSnapshot.reference.id);
      }
      else{
        print("no user found $id");
      }
    });
    return model!;
  }
}