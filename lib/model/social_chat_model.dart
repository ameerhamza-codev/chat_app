import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SocialChatModel{
  String id,senderId,mediaType,message,groupId,replyId,receiverId,messageType;
  bool isReply,forwarded,isRead;

  int dateTime;



  SocialChatModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        senderId = map['senderId']??"",
        mediaType = map['mediaType']??"",
        receiverId = map['receiverId']??"all",
        messageType = map['messageType']??MessageType.social,
        forwarded = map['forwarded']??false,
        isRead = map['isRead']??false,
        message = map['message']??"",
        groupId = map['groupId']??"",
        replyId = map['replyId']??"",
        isReply = map['isReply']??false,
        dateTime = map['dateTime']??"";




  SocialChatModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}