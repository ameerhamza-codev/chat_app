import 'package:cloud_firestore/cloud_firestore.dart';

class AttributeModel{
  String id,name,code;
  int codeCount;

  AttributeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        codeCount = map['codeCount']??1,
        name = map['name'],
        code = map['code'];



  AttributeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}