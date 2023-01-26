import 'package:chat_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_data_provider.dart';
import '../login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: colorWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 30, color: primaryColor,),
            Consumer<UserDataProvider>(
              builder: (context,user,child){
                return Container(
                  color: primaryColor,
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.userData!.name!, style: TextStyle(color: colorWhite,fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(user.userData!.dob!, style: TextStyle(color: colorWhite,fontSize: 16, fontWeight: FontWeight.w300)),
                          Text(user.userData!.gender!, style: TextStyle(color: colorWhite,fontSize: 16, fontWeight: FontWeight.w300)),
                          // Text("View and edit profile", style: TextStyle(color: textColor)),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.userData!.profilePicture!),
                        radius:50,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                );
              },
            ),

            InkWell(
              onTap: (){},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Edit Profile", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.edit_note, color: primaryColor),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: (){
                
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Invite People", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.people, color: primaryColor),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () async{
                final user = FirebaseAuth.instance.currentUser;
                if (user!=null) {
                  await FirebaseAuth.instance.signOut();
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Logout", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.logout, color: primaryColor),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
          ],
        ),
      ),
    );
  }
}
