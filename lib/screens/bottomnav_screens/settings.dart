import 'package:chat_app/screens/announcement_screen.dart';
import 'package:chat_app/screens/image_viewer.dart';
import 'package:chat_app/screens/setting_screens/edit_profile.dart';
import 'package:chat_app/screens/setting_screens/more_settings.dart';
import 'package:chat_app/screens/setting_screens/profile.dart';
import 'package:chat_app/screens/setting_screens/referral.dart';
import 'package:chat_app/screens/setting_screens/report_screen.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_data_provider.dart';
import '../auth/login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: colorWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            /*Consumer<UserDataProvider>(
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
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewImage(user.userData!.profilePicture!)));

                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.userData!.profilePicture!),
                          radius:50,
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                );
              },
            ),*/
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Profile", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.person_sharp, color: primaryColor),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AnnouncementScreen()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Announcements", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.announcement, color: primaryColor),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MoreSettings()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Settings", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.settings, color: primaryColor),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ReportScreen()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Report Abuse", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.report, color: primaryColor),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            if(provider.userData!.refer)
             InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Referal()));
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
