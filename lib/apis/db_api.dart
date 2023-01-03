import 'package:chat_app/model/chat_head_model.dart';
import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model_class.dart';
import '../provider/user_data_provider.dart';
import '../utils/constants.dart';

class DBApi{


  static Future<List<ChatHeadModel>> getIndividualChats(BuildContext context)async{
    final provider = Provider.of<ChatProvider>(context, listen: false);
    provider.chatReset();
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

  static Future<List<SocialChatModel>> getUnreadMessageCount(BuildContext context,chatHeadId)async{
    List<SocialChatModel> chats=[];
    await FirebaseFirestore.instance.collection('social_chat').where("groupId",isEqualTo: chatHeadId)
        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        SocialChatModel model=SocialChatModel.fromMap(data, doc.reference.id);
        if(!model.isRead && model.senderId!=FirebaseAuth.instance.currentUser!.uid){
          chats.add(model);
        }
      });
    });
    print("chat length ${chats.length}");
    return chats;
  }
  static Future changeMessageToRead(BuildContext context,chatHeadId)async{
    await FirebaseFirestore.instance.collection('social_chat').where("groupId",isEqualTo: chatHeadId)
        .get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        SocialChatModel model=SocialChatModel.fromMap(data, doc.reference.id);
        if(!model.isRead){
          FirebaseFirestore.instance.collection('social_chat').doc(model.id).update({
            'isRead':true
          }).then((value){
            print('message ${model.id} is marked as read');
          });
        }
      });
    });
  }


  static Future<String> storeChat(BuildContext context,String message,String groupId,mediaType,reply,replyId,replyMessage,replyType,replyTimestamp,receiverId,messageType,forwarded,isRead)async{
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    var res=await FirebaseFirestore.instance.collection('social_chat').add({
      "senderId":FirebaseAuth.instance.currentUser!.uid,
      "senderProfilePic":provider.userData!.profilePicture,
      "receiverId":receiverId,
      "messageType":messageType,
      "forwarded":forwarded,
      "mediaType":mediaType,
      "isRead":isRead,
      "message":message,
      "groupId":groupId,
      "isReply":reply,
      "replyId":replyId,
      "replyMessage":replyMessage,
      "replyMediaType":replyType,
      "replyDateTime":replyTimestamp,
      "dateTime":DateTime.now().millisecondsSinceEpoch,
    });
    return res.id;
  }

  static Future<String> forwardMessage(SocialChatModel chat,receiverId,messageType)async{
    var res=await FirebaseFirestore.instance.collection('social_chat').add({
      "senderId":FirebaseAuth.instance.currentUser!.uid,
      "receiverId":receiverId,
      "messageType":messageType,
      "forwarded":true,
      "mediaType":chat.mediaType,
      "isRead":false,
      "message":chat.message,
      "groupId":receiverId,
      "isReply":false,
      "replyId":"",
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

  static Future getReplyChat(String id,BuildContext context)async{
    final provider = Provider.of<ChatProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('social_chat')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        provider.replyMessages.add(SocialChatModel.fromMap(data, documentSnapshot.reference.id));

      }
    });
  }
}

