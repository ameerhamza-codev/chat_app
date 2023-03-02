import 'package:cloud_firestore/cloud_firestore.dart';

class MainGroupModel{
  String id,name,code;


  MainGroupModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        code = map['code'];



  MainGroupModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}