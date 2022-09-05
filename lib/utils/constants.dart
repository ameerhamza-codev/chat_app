import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const primaryColor=Colors.blue;
const secondaryColor=Color(0xffFFFFFF);
const colorWhite=Color(0xffffffff);
const colorBlack=Color(0xff000000);
const textColor=Colors.blueGrey;
const backgroundColor= Color(0xffF8F8F8);
const meChatBubble= Color(0xffEFFFDE);
const meReplyChatBubble= Color(0xfff7ffee);

String prettyDuration(Duration d) {
  var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
  var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
  return min + ":" + sec;
}


const profileImage="https://firebasestorage.googleapis.com/v0/b/chat-app-2ea88.appspot.com/o/profile.png?alt=media&token=4ce57725-0113-48d9-a6f7-cea8f4e9f076";

class MediaType{
  static String plainText="Text";
  static String image="Image";
  static String audio="Audio";
  static String video="Video";
  static String document="Document";
}

class MessageType{
  static String social="Social";
  static String individual="Individual";
  static String group="Group";
}

String getId(ids,myId){
  String wantedId="";
  String user1 = ids.substring(0, ids.indexOf('_'));
  String user2 = ids.substring(ids.indexOf('_')+1);
  print("id1 : $user1, id2 : $user2");
  if(user1==myId){
    wantedId=user1;
  }
  if(user2==myId){
    wantedId=user2;
  }
  return wantedId;
}

String getRecieverId(ids){
  String wantedId="";
  String user1 = ids.substring(0, ids.indexOf('_'));
  String user2 = ids.substring(ids.indexOf('_')+1);
  print("id1 : $user1, id2 : $user2");
  if(user1==FirebaseAuth.instance.currentUser!.uid){
    wantedId=user2;
  }
  if(user2==FirebaseAuth.instance.currentUser!.uid){
    wantedId=user1;
  }
  return wantedId;
}

bool checkIfChatExists(ids,myId,otherId){
  bool id1Exists=false;
  bool id2Exists=false;
  String user1 = ids.substring(0, ids.indexOf('_'));
  String user2 = ids.substring(ids.indexOf('_')+1);
  if(user1==myId || user1==otherId){
    id1Exists=true;
  }
  if(user2==myId || user2==otherId){
    id2Exists=true;
  }

  return id1Exists && id2Exists?true:false;
}