import 'package:cloud_firestore/cloud_firestore.dart';

class InvitedUserModel{
  String id,name,email,mobile,gender,invitationCode,mainGroup,mainGroupCode,subGroup1,subGroup1Code,subGroup2Code,subGroup2,
      subGroup3Code,subGroup3,subGroup4Code,subGroup4,additionalResponsibility,additionalResponsibilityCode;
  bool referer;
  //String res_type;

  InvitedUserModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name']??'',
        mobile = map['mobile']??'',
        gender = map['gender']??'',
        invitationCode = map['invitationCode']??'',
        referer = map['referer']??'',
        mainGroup = map['mainGroup']??'',
        subGroup1 = map['subGroup1']??'',
        subGroup2 = map['subGroup2']??'',
        subGroup3 = map['subGroup3']??'',
        //res_type = map['res_type']??"",
        additionalResponsibilityCode = map['additionalResponsibilityCode']??"",
        additionalResponsibility = map['additionalResponsibility']??"",
        subGroup4 = map['subGroup4']??'',
        mainGroupCode = map['mainGroupCode']??'',
        subGroup1Code = map['subGroup1Code']??'',
        subGroup2Code = map['subGroup2Code']??'',
        subGroup3Code = map['subGroup3Code']??'',
        subGroup4Code = map['subGroup4Code']??'',
        email = map['email']??'';



  InvitedUserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}