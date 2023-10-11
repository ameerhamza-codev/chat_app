import 'package:chat_app/model/chat_head_model.dart';
import 'package:chat_app/screens/announcement_screen.dart';
import 'package:chat_app/screens/bottomnav_screens/settings.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/screens/chat/individual_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/db_api.dart';
import '../../model/user_model_class.dart';
import '../../provider/user_data_provider.dart';
import '../../utils/constants.dart';
import '../chat/search_individual.dart';

class MainChat extends StatefulWidget {
  const MainChat({Key? key}) : super(key: key);

  @override
  _MainChatState createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(

                labelColor: colorWhite,
                indicatorColor: colorWhite,
                tabs: [
                  Tab(child:Icon(Icons.groups)),
                  Tab(child: Icon(Icons.person)),
                  Tab(child: Icon(Icons.more_vert_rounded)),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatScreen(MessageType.social,provider.userData!.mainGroupCode!),

            IndividualChat(),
            SettingsScreen()
            //AnnouncementScreen(),


          ],
        ),
      ),
    );
  }
}
