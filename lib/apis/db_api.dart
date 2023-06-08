import 'package:chat_app/model/chat_head_model.dart';
import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/model/sub_group_3_model.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/announcement_model.dart';
import '../model/user_model_class.dart';
import '../provider/user_data_provider.dart';
import '../utils/constants.dart';


String removeGenderSuffix(String inputString) {
  final List<String> genderSuffixes = ['Male', 'Female'];

  for (String suffix in genderSuffixes) {
    if (inputString.endsWith(suffix)) {
      return inputString.substring(0, inputString.length - suffix.length).trim();
    }
  }

  return inputString;
}

String checkIfGroupRepresentative(String groupId,AppUser user){
  String representative='';
  if(user.subGroup1Code==groupId){
    representative='subGroup1Code';
  }
  else if(user.subGroup2Code==groupId){
    representative='subGroup2Code';
  }
  else if(user.subGroup3Code==groupId){
    representative='subGroup3Code';
  }
  else if(user.subGroup4Code==groupId){
    representative='subGroup4Code';
  }
  return representative;
}

int getGroupCode(String groupId,AppUser user){
  int representative=0;
  if(user.subGroup1Code==groupId){
    representative=1;
  }
  else if(user.subGroup2Code==groupId){
    representative=2;
  }
  else if(user.subGroup3Code==groupId){
    representative=3;
  }
  else if(user.subGroup4Code==groupId){
    representative=4;
  }
  return representative;
}

class DBApi{

  static Future setAnnouncementStatus()async{
    int duration=48;
    await FirebaseFirestore.instance.collection('data').doc('deleteDuration').get().then((DocumentSnapshot documentSnapshot) async{
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        duration=int.parse(data['duration'].toString());
        print('delete duration $duration');

      }

    });
    await FirebaseFirestore.instance.collection('announcement').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        AnnouncementModel model=AnnouncementModel.fromMap(data,doc.reference.id);
        Duration difference = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(model.dateTime));
        if (difference.inHours >= duration) {
          print("The difference between the two dates is more than 24 hours.");
          FirebaseFirestore.instance.collection('announcement').doc(model.id).update({
            'disabled':true
          });
        }

      });
    });

  }
  static Future<bool> checkIfAnnouncementExists(BuildContext context,String id)async{
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    List<AnnouncementModel> announcements=[];
    print('announcement_id = $id${provider.userData!.gender}');
    await FirebaseFirestore.instance.collection('announcement')
        .where("groupId",isEqualTo: '$id${provider.userData!.gender}').where("disabled",isEqualTo: false)
        .orderBy('dateTime',descending: true).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        announcements.add(AnnouncementModel.fromMap(data, doc.reference.id));
      });
    });
    return announcements.isEmpty?false:true;
  }

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

  static Future<bool> getUnreadGroupMessage(BuildContext context,chatHeadId)async{
    bool hasUnreadMessages=false;
    await FirebaseFirestore.instance.collection('group_alert').doc('$chatHeadId-${FirebaseAuth.instance.currentUser!.uid}').get().then((DocumentSnapshot documentSnapshot) async{
      if (documentSnapshot.exists) {
        hasUnreadMessages=true;

      }

    });
    print("hasUnreadMessages $hasUnreadMessages");
    return hasUnreadMessages;
  }
  static Future<bool> getUnreadAnnouncement(BuildContext context,chatHeadId)async{
    bool hasUnreadMessages=false;
    await FirebaseFirestore.instance.collection('announcement_alert').doc('$chatHeadId-${FirebaseAuth.instance.currentUser!.uid}').get().then((DocumentSnapshot documentSnapshot) async{
      if (documentSnapshot.exists) {
        hasUnreadMessages=true;

      }

    });
    print("hasUnreadMessages $hasUnreadMessages");
    return hasUnreadMessages;
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

  static Future changeGroupMessageToRead(BuildContext context,chatHeadId)async{
    await FirebaseFirestore.instance.collection('group_alert').doc('$chatHeadId-${FirebaseAuth.instance.currentUser!.uid}').delete();
  }
  static Future changeAnnouncementToRead(BuildContext context,chatHeadId)async{
    await FirebaseFirestore.instance.collection('announcement_alert').doc('$chatHeadId-${FirebaseAuth.instance.currentUser!.uid}').delete();
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
    if(messageType==MessageType.group){
      await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('group_alert').doc('$groupId-${doc.reference.id}').set({
            "message":true,
          });
        });
      });
      await FirebaseFirestore.instance.collection('announcement').add({
        "senderId":FirebaseAuth.instance.currentUser!.uid,
        "senderProfilePic":provider.userData!.profilePicture,
        "receiverId":res.id,
        "messageType":messageType,
        "mediaType":mediaType,
        "isRead":isRead,
        "message":message,
        "disabled":false,
        "groupId":groupId,
        "infoGroup":'',
        "dateTime":DateTime.now().millisecondsSinceEpoch,
      });
      await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('announcement_alert').doc('$groupId-${doc.reference.id}').set({
            "message":true,
          });
        });
      });
      //String groupCode=checkIfGroupRepresentative(groupId, provider.userData!);
      int groupCode=getGroupCode(removeGenderSuffix(groupId), provider.userData!);
      if(groupCode>0){



        if(groupCode==1){
          await FirebaseFirestore.instance.collection('sub_group2').where('subGroup1Code',isEqualTo: removeGenderSuffix(groupId)).get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              SubGroup3Model model=SubGroup3Model.fromMap(data,doc.reference.id);
              FirebaseFirestore.instance.collection('announcement').add({
                "senderId":FirebaseAuth.instance.currentUser!.uid,
                "senderProfilePic":provider.userData!.profilePicture,
                "receiverId":res.id,
                "messageType":messageType,
                "mediaType":mediaType,
                "isRead":isRead,
                "message":message,
                "disabled":false,
                "groupId":groupId,
                "infoGroup":model.code,
                "dateTime":DateTime.now().millisecondsSinceEpoch,
              });
            });
          });

          await FirebaseFirestore.instance.collection('sub_group3').where('subGroup1Code',isEqualTo: removeGenderSuffix(groupId)).get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              SubGroup3Model model=SubGroup3Model.fromMap(data,doc.reference.id);
              FirebaseFirestore.instance.collection('announcement').add({
                "senderId":FirebaseAuth.instance.currentUser!.uid,
                "senderProfilePic":provider.userData!.profilePicture,
                "receiverId":res.id,
                "messageType":messageType,
                "mediaType":mediaType,
                "isRead":isRead,
                "disabled":false,
                "message":message,
                "groupId":groupId,
                "infoGroup":model.code,
                "dateTime":DateTime.now().millisecondsSinceEpoch,
              });
            });
          });

          await FirebaseFirestore.instance.collection('sub_group4').where('subGroup1Code',isEqualTo: removeGenderSuffix(groupId)).get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              SubGroup3Model model=SubGroup3Model.fromMap(data,doc.reference.id);
              FirebaseFirestore.instance.collection('announcement').add({
                "senderId":FirebaseAuth.instance.currentUser!.uid,
                "senderProfilePic":provider.userData!.profilePicture,
                "receiverId":res.id,
                "messageType":messageType,
                "mediaType":mediaType,
                "isRead":isRead,
                "disabled":false,
                "message":message,
                "groupId":groupId,
                "infoGroup":model.code,
                "dateTime":DateTime.now().millisecondsSinceEpoch,
              });
            });
          });
        }

        else if(groupCode==2){


          await FirebaseFirestore.instance.collection('sub_group3').where('subGroup2Code',isEqualTo: removeGenderSuffix(groupId)).get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              SubGroup3Model model=SubGroup3Model.fromMap(data,doc.reference.id);
              FirebaseFirestore.instance.collection('announcement').add({
                "senderId":FirebaseAuth.instance.currentUser!.uid,
                "senderProfilePic":provider.userData!.profilePicture,
                "receiverId":res.id,
                "disabled":false,
                "messageType":messageType,
                "mediaType":mediaType,
                "isRead":isRead,
                "message":message,
                "groupId":groupId,
                "infoGroup":model.code,
                "dateTime":DateTime.now().millisecondsSinceEpoch,
              });
            });
          });

          await FirebaseFirestore.instance.collection('sub_group4').where('subGroup2Code',isEqualTo: removeGenderSuffix(groupId)).get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              SubGroup3Model model=SubGroup3Model.fromMap(data,doc.reference.id);
              FirebaseFirestore.instance.collection('announcement').add({
                "senderId":FirebaseAuth.instance.currentUser!.uid,
                "senderProfilePic":provider.userData!.profilePicture,
                "receiverId":res.id,
                "messageType":messageType,
                "mediaType":mediaType,
                "isRead":isRead,
                "disabled":false,
                "message":message,
                "groupId":groupId,
                "infoGroup":model.code,
                "dateTime":DateTime.now().millisecondsSinceEpoch,
              });
            });
          });
        }

        else if(groupCode==3){

          await FirebaseFirestore.instance.collection('sub_group4').where('subGroup3Code',isEqualTo: removeGenderSuffix(groupId)).get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              SubGroup3Model model=SubGroup3Model.fromMap(data,doc.reference.id);
              FirebaseFirestore.instance.collection('announcement').add({
                "senderId":FirebaseAuth.instance.currentUser!.uid,
                "senderProfilePic":provider.userData!.profilePicture,
                "disabled":false,
                "receiverId":res.id,
                "messageType":messageType,
                "mediaType":mediaType,
                "isRead":isRead,
                "message":message,
                "groupId":groupId,
                "infoGroup":model.code,
                "dateTime":DateTime.now().millisecondsSinceEpoch,
              });
            });
          });
        }

      }
      
    }


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

