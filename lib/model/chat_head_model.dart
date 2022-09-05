import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatHeadModel{
  String id,user1,user2;
  int timestamp;



  ChatHeadModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        user1 = map['user1']??"",
        user2 = map['user2']??"",

        timestamp = map['timestamp']??DateTime.now().millisecondsSinceEpoch;




  ChatHeadModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}