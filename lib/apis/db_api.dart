import 'package:chat_app/model/chat_head_model.dart';
import 'package:chat_app/model/social_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model_class.dart';
import '../utils/constants.dart';

class DBApi{


  static Future<List<ChatHeadModel>> getIndividualChats()async{
    List<ChatHeadModel> chats=[];
    await FirebaseFirestore.instance.collection('chat_head').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

        if(getId(doc.reference.id,FirebaseAuth.instance.currentUser!.uid)!=""){
          chats.add(ChatHeadModel.fromMap(data, doc.reference.id));
        }
      });
    });
    print("chat length ${chats.length}");
    return chats;
  }

  static Future<String> storeChat(String message,String groupId,mediaType,reply,replyId,receiverId,messageType,forwarded,isRead)async{
    var res=await FirebaseFirestore.instance.collection('social_chat').add({
      "senderId":FirebaseAuth.instance.currentUser!.uid,
      "receiverId":receiverId,
      "messageType":messageType,
      "forwarded":forwarded,
      "mediaType":mediaType,
      "isRead":isRead,
      "message":message,
      "groupId":groupId,
      "isReply":reply,
      "replyId":replyId,
      "dateTime":DateTime.now().millisecondsSinceEpoch,
    });
    return res.id;
  }

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

