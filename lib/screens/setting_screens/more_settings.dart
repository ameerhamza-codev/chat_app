import 'package:chat_app/screens/announcement_screen.dart';
import 'package:chat_app/screens/image_viewer.dart';
import 'package:chat_app/screens/setting_screens/edit_profile.dart';
import 'package:chat_app/screens/setting_screens/profile.dart';
import 'package:chat_app/screens/setting_screens/referral.dart';
import 'package:chat_app/screens/setting_screens/report_screen.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/auth_api.dart';
import '../../provider/user_data_provider.dart';
import '../auth/login.dart';

class MoreSettings extends StatefulWidget {
  const MoreSettings({Key? key}) : super(key: key);

  @override
  State<MoreSettings> createState() => _MoreSettingsState();
}

class _MoreSettingsState extends State<MoreSettings> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        title: Text('Settings'),
      ),
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
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.confirm,
                    title: 'Delete Account',
                    text: 'Are you sure you want to delete your account? All your data will be lost',
                    onConfirmBtnTap: (){
                      AuthenticationApi authApi=AuthenticationApi();
                      authApi.verifyPhoneNumber(provider.userData!.mobile!, context, 3);

                    }
                );              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: <Widget>[
                    Text("Delete Account", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.delete, color: primaryColor),
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
                    Text("Change Number", style: TextStyle(color: textColor,fontSize: 16, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Icon(Icons.phone, color: primaryColor),
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
