import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{
  String? userId,additionalResponsibility,additionalResponsibilityCode, country, displayName, dob, email, fatherName, gender,
         jobDescription, landline, location, mainGroup, mainGroupCode, mobile, name, occupation, password, res_type, status, token,
         subGroup1, subGroup1Code, subGroup2, subGroup2Code, subGroup3, subGroup3Code, subGroup4, subGroup4Code;
  int? createdAt;
  bool? action, group, refer, subGroup1Representative, subGroup2Representative, subGroup3Representative, subGroup4Representative;


  AppUser.name(
      this.userId,
      this.additionalResponsibility,
      this.additionalResponsibilityCode,
      this.country,
      this.displayName,
      this.dob,
      this.email,
      this.fatherName,
      this.gender,
      this.jobDescription,
      this.landline,
      this.location,
      this.mainGroup,
      this.mainGroupCode,
      this.mobile,
      this.name,
      this.occupation,
      this.password,
      this.res_type,
      this.status,
      this.token,
      this.subGroup1,
      this.subGroup1Code,
      this.subGroup2,
      this.subGroup2Code,
      this.subGroup3,
      this.subGroup3Code,
      this.subGroup4,
      this.subGroup4Code,
      this.createdAt,
      this.action,
      this.group,
      this.refer,
      this.subGroup1Representative,
      this.subGroup2Representative,
      this.subGroup3Representative,
      this.subGroup4Representative);


  AppUser.fromMap(Map<String,dynamic> map,String key)
      : userId=key,
        additionalResponsibility=map['additionalResponsibility'],
        additionalResponsibilityCode=map['additionalResponsibilityCode'],
        country=map['country'],
        displayName=map['displayName'],
        dob=map['dob'],
        email=map['email'],
        fatherName=map['fatherName'],
        gender=map['gender'],
        jobDescription=map['jobDescription'],
        landline=map['landline'],
        location=map['location'],
        mainGroup=map['mainGroup'],
        mainGroupCode=map['mainGroupCode'],
        mobile=map['mobile'],
        name=map['name'],
        occupation=map['occupation'],
        password=map['password'],
        res_type=map['res_type'],
        status=map['status'],
        token=map['token'],
        subGroup1=map['subGroup1'],
        subGroup1Code=map['subGroup1Code'],
        subGroup2=map['subGroup2'],
        subGroup2Code=map['subGroup2Code'],
        subGroup3=map['subGroup3'],
        subGroup3Code=map['subGroup3Code'],
        subGroup4=map['subGroup4'],
        subGroup4Code=map['subGroup4Code'],
        createdAt=map['createdAt'],
        action=map['action'],
        group=map['group'],
        refer=map['refer'],
        subGroup1Representative=map['subGroup1Representative'],
        subGroup2Representative=map['subGroup2Representative'],
        subGroup3Representative=map['subGroup3Representative'],
        subGroup4Representative=map['subGroup4Representative'];




  AppUser.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}