import 'package:cloud_firestore/cloud_firestore.dart';

class OccupationModel{
  String id,name,code,type;
 int codeCount;

  OccupationModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        codeCount = map['codeCount']??1,
        type = map['type'],
        code = map['code'];



  OccupationModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}