import 'package:chat_app/provider/forward_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_data_provider.dart';
import '../screens/bottomnav_screens/chat_screen.dart';
import '../utils/constants.dart';

class GroupTile extends StatelessWidget {
  String title,reciverId;


  GroupTile({required this.title, required this.reciverId});

  @override
  Widget build(BuildContext context) {
    final forward = Provider.of<ForwardProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide( color: textColor.shade100),
        ),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: textColor,
          minRadius: 20.0,
          maxRadius: 20.0,
          backgroundImage: AssetImage('assets/images/group_img.png'),
        ),
        trailing: Icon(forward.groupList.contains(reciverId)?Icons.check_circle:Icons.arrow_forward_ios_rounded,color: forward.groupList.contains(reciverId)?primaryColor:Colors.grey, size: 15),
        title: Text(title),
        onTap: (){
          final provider = Provider.of<UserDataProvider>(context, listen: false);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, '$reciverId${provider.userData!.gender}')));

        },
      ),
    );
  }
}
