
import 'package:chat_app/screens/bottomnav_screens/chat_screen.dart';
import 'package:chat_app/screens/bottomnav_screens/groups.dart';
import 'package:chat_app/screens/bottomnav_screens/main_chat.dart';
import 'package:chat_app/screens/bottomnav_screens/settings.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class BottomNavBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavBar>{

  int _currentIndex = 0;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();
    _children = const [
       MainChat(),
       Groups(),
       Settings()
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Material(
        elevation: 10,
        child: Container(
          height: AppBar().preferredSize.height,
          color: primaryColor.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: (){
                  onTabTapped(0);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.chat,size: 30,color: _currentIndex==0?primaryColor:textColor),
                    Text("Chats", style: TextStyle(color: _currentIndex==0?primaryColor:textColor),)
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  onTabTapped(1);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.group,size: 30,color: _currentIndex==1?primaryColor:textColor),
                    Text("Groups", style: TextStyle(color: _currentIndex==1?primaryColor:textColor),)
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  onTabTapped(2);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.settings,size: 30,color: _currentIndex==2?primaryColor:textColor),
                    Text("Settings", style: TextStyle(color: _currentIndex==2?primaryColor:textColor),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _children[_currentIndex],
    );
  }
}