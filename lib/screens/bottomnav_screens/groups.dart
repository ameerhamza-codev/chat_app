import 'package:chat_app/screens/group_chat.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupChatState();
}

class _GroupChatState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('GROUPS'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
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
                trailing: Icon(Icons.delete_forever, size: 20, color: Colors.red,),
                title: Text("XYZ Group"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  GroupChat()));
                },
              ),
            );
          }
      ),
    );
  }
}
