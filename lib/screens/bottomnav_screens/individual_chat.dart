import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class IndividualChat extends StatefulWidget {
  const IndividualChat({Key? key}) : super(key: key);

  @override
  State<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('CHATS'),
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
                    backgroundImage: AssetImage('assets/images/profile_img.png'),
                  ),
                  trailing: Icon(Icons.delete_forever, size: 20, color: Colors.red,),
                  title: Text("Mary Jackson"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  Chat()));
                  },
              ),
            );
          }
          ),
    );
  }
}
