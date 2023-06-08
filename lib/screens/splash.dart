import 'dart:async';
import 'package:chat_app/apis/db_api.dart';
import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/screens/navigator/bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_data_provider.dart';
import '../utils/constants.dart';
import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 3 ;


  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var duration = Duration(seconds: splashDelay);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async{
    await DBApi.setAnnouncementStatus();
    if(FirebaseAuth.instance.currentUser!=null){
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {
          print("user exists");
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          AppUser user=AppUser.fromMap(data,documentSnapshot.reference.id);
          print("user ${user.userId} ${user.status}");
          if(user.status=="Pending"){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));

          }
          else if(user.status=="Blocked"){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
          }

          else if(user.status=="Active"){
            final provider = Provider.of<UserDataProvider>(context, listen: false);
            provider.setUserData(user);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));




          }
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
        }

      });
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));

    }

  }

  @override
  Widget build(BuildContext context) {
    Size _size= MediaQuery.of(context).size;

    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: colorWhite,
      body: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        child:Image.asset('assets/images/splash.png',height: _size.width> 756 ?_size.height: height,width: width,fit: _size.width> 756 ? BoxFit.fitHeight: BoxFit.cover,),

      ),
    );
  }
}

