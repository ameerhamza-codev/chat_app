import 'package:flutter/material.dart';

const primaryColor=Colors.blue;
const secondaryColor=Color(0xffFFFFFF);
const colorWhite=Color(0xffffffff);
const colorBlack=Color(0xff000000);
const textColor=Colors.blueGrey;
const backgroundColor= Color(0xffF8F8F8);
const meChatBubble= Color(0xffEFFFDE);

String prettyDuration(Duration d) {
  var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
  var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
  return min + ":" + sec;
}


const profileImage="https://firebasestorage.googleapis.com/v0/b/chat-app-2ea88.appspot.com/o/profile.png?alt=media&token=4ce57725-0113-48d9-a6f7-cea8f4e9f076";