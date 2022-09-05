import 'package:cloud_firestore/cloud_firestore.dart';

class SubGroup3Model{
  String id,name,code,mainGroupCode,subGroup1Code,subGroup2Code;
  int codeCount;

  SubGroup3Model.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        mainGroupCode = map['mainGroupCode'],
        subGroup1Code = map['subGroup1Code'],
        subGroup2Code = map['subGroup2Code'],
        codeCount = map['codeCount']??1,
        code = map['code'];



  SubGroup3Model.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}