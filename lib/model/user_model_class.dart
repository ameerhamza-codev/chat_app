import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constants.dart';

class AppUser{
  String? userId,additionalResponsibility,additionalResponsibilityCode, country, displayName, dob, email, fatherName, gender,
         jobDescription, landline, location, mainGroup, mainGroupCode, mobile, name, occupation, password, res_type, status, token,
         subGroup1, subGroup1Code, subGroup2, subGroup2Code, subGroup3, subGroup3Code, subGroup4, subGroup4Code,profilePicture;
  int? createdAt;
  bool action, group, refer, subGroup1Representative, subGroup2Representative, subGroup3Representative, subGroup4Representative;
  bool expatriates,associatidWithAddRes;
  bool country_main;
  bool country_sub1;
  bool country_sub2;
  bool country_sub3;
  bool country_sub4;
  bool country_occupation;
  bool country_restype;
  bool city_main;
  bool city_sub1;
  bool city_sub2;
  bool city_sub3;
  bool city_sub4;
  bool city_occupation;
  bool city_restype;





  AppUser.fromMap(Map<String,dynamic> map,String key)
      : userId=key,
        additionalResponsibility=map['additionalResponsibility']??"",
        additionalResponsibilityCode=map['additionalResponsibilityCode']??"",
        country=map['country']??"",
        displayName=map['displayName']??"",
        dob=map['dob']??"",
        email=map['email']??"",
        fatherName=map['fatherName']??"",
        gender=map['gender']??"",
        jobDescription=map['jobDescription']??"",
        landline=map['landline']??"",
        location=map['location']??"",
        mainGroup=map['mainGroup']??"",
        mainGroupCode=map['mainGroupCode']??"",
        mobile=map['mobile']??"",
        name=map['name']??"",
        occupation=map['occupation']??"",
        password=map['password']??"",
        res_type=map['res_type']??"",
        status=map['status']??"",
        token=map['token']??"",
        subGroup1=map['subGroup1']??"",
        subGroup1Code=map['subGroup1Code']??"",
        subGroup2=map['subGroup2']??"",
        subGroup2Code=map['subGroup2Code']??"",
        subGroup3=map['subGroup3']??"",
        subGroup3Code=map['subGroup3Code']??"",
        subGroup4=map['subGroup4']??"",
        subGroup4Code=map['subGroup4Code']??"",
        createdAt=map['createdAt']??0,
        action=map['action']??false,
        group=map['group']??false,
        refer=map['refer']??false,
        profilePicture=map['profilePicture']??profileImage,
        subGroup1Representative=map['subGroup1Representative']??false,
        subGroup2Representative=map['subGroup2Representative']??false,
        subGroup3Representative=map['subGroup3Representative']??false,
        expatriates=map['expatriates']??true,
        country_main = map['country_main']??true,
        country_sub1 = map['country_sub1']??true,
        country_sub2 = map['country_sub2']??true,
        country_sub3 = map['country_sub3']??true,
        country_sub4 = map['country_sub4']??true,
        country_occupation = map['country_occupation']??true,
        country_restype = map['country_restype']??true,
        city_main = map['city_main']??true,
        city_sub1 = map['city_sub1']??true,
        city_sub2 = map['city_sub2']??true,
        city_sub3 = map['city_sub3']??true,
        city_sub4 = map['city_sub4']??true,
        city_occupation = map['city_occupation']??true,
        city_restype = map['city_restype']??true,
        associatidWithAddRes=map['associatidWithAddRes']??true,
        subGroup4Representative=map['subGroup4Representative']??false;




  AppUser.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}