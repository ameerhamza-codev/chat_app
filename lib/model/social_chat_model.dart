import 'package:cloud_firestore/cloud_firestore.dart';
class SocialChatModel{
  String id,senderId,mediaType,message,groupId,replyId;
  bool isReply;
  int dateTime;



  SocialChatModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        senderId = map['senderId']??"",
        mediaType = map['mediaType']??"",
        message = map['message']??"",
        groupId = map['groupId']??"",
        replyId = map['replyId']??"",
        isReply = map['isReply']??false,
        dateTime = map['dateTime']??"";




  SocialChatModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}