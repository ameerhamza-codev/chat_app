import 'package:chat_app/provider/forward_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apis/db_api.dart';
import '../provider/user_data_provider.dart';
import '../screens/chat/chat_screen.dart';
import '../utils/constants.dart';


class GroupTile extends StatefulWidget {
  String title,reciverId;


  GroupTile({required this.title, required this.reciverId});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
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

        trailing: forward.groupList.contains(widget.reciverId)?
        Icon(Icons.check_circle,color: primaryColor,size: 15)
            :
        SizedBox(
          height: 25,
          width: 25,
          child: FutureBuilder<bool>(
              future: DBApi.getUnreadGroupMessage(context,'${widget.reciverId}${provider.userData!.gender}'),
              builder: (context, AsyncSnapshot<bool> unreadsnap) {
                if (unreadsnap.connectionState == ConnectionState.waiting) {
                  return Container(height: 5,width: 5,);
                }
                else {
                  if (unreadsnap.hasError) {
                    print("error ${unreadsnap.error}");
                    return Icon(Icons.error,size: 25,);
                  }



                  else {
                    if(unreadsnap.data!=null){
                      return unreadsnap.data!?Icon(Icons.circle,color: primaryColor,size: 10,):Container(height: 6,width: 5,);
                    }
                    else{
                      return Container(height: 6,width: 5,);
                    }


                  }
                }
              }
          ),
        ),
        title: Text(widget.title),
        onTap: (){
          print('id ${widget.reciverId}-${FirebaseAuth.instance.currentUser!.uid}');
           DBApi.changeGroupMessageToRead(context, '${widget.reciverId}${provider.userData!.gender}');

          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, '${widget.reciverId}${provider.userData!.gender}')));

        },
      ),
    );
  }
}

