import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AnnouncementModel{
  String id,senderId,mediaType,receiverId,message,groupId,messageType,senderProfilePic;
  bool isRead;

  String infoGroup;


  int dateTime;




  AnnouncementModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        senderId = map['senderId']??"",
        senderProfilePic = map['senderProfilePic']??"",
        mediaType = map['mediaType']??"",
        infoGroup = map['infoGroup']??"",
        receiverId = map['receiverId']??"all",
        messageType = map['messageType']??MessageType.social,
        isRead = map['isRead']??false,
        message = map['message']??"",
        groupId = map['groupId']??"",
        dateTime = map['dateTime']??0;




  AnnouncementModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}