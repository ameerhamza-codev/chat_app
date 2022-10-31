import 'package:chat_app/screens/bottomnav_screens/chat_screen.dart';
import 'package:chat_app/screens/group_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_model_class.dart';
import '../../provider/user_data_provider.dart';
import '../../utils/constants.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupChatState();
}

class _GroupChatState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('GROUPS'),
        automaticallyImplyLeading: false,
      ),
      body:ListView(
        children: [
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title: Text(provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, provider.userData!.subGroup3Code!)));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text(provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, provider.userData!.subGroup4Code!)));
              },
            ),
          ),
          //14 groups
          //mainGroup
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.country} - ${provider.userData!.mainGroupCode!.replaceAll("${provider.userData!.mainGroupCode!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.country}${provider.userData!.mainGroupCode}")));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.location} - ${provider.userData!.mainGroup!.replaceAll("${provider.userData!.mainGroupCode!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.location}${provider.userData!.mainGroupCode}")));
              },
            ),
          ),
          //subgroup1
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.country} - ${provider.userData!.subGroup1!.replaceAll("${provider.userData!.subGroup1Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.country}${provider.userData!.subGroup1Code}")));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.location} - ${provider.userData!.subGroup1!.replaceAll("${provider.userData!.subGroup1Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.location}${provider.userData!.subGroup1Code}")));
              },
            ),
          ),
          //subgroup2
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.country} - ${provider.userData!.subGroup2!.replaceAll("${provider.userData!.subGroup2Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.country}${provider.userData!.subGroup2Code}")));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.location} - ${provider.userData!.subGroup2!.replaceAll("${provider.userData!.subGroup2Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.location}${provider.userData!.subGroup2Code}")));
              },
            ),
          ),
          //subgroup3
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.country} - ${provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.country}${provider.userData!.subGroup3Code}")));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.location} - ${provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.location}${provider.userData!.subGroup3Code}")));
              },
            ),
          ),
          //subgroup4
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.country} - ${provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.country}${provider.userData!.subGroup4Code}")));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.location} - ${provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.location}${provider.userData!.subGroup4Code}")));
              },
            ),
          ),
          //occupation
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.country} - ${provider.userData!.occupation!}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.country}${provider.userData!.occupation}")));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.location} - ${provider.userData!.occupation!}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.location}${provider.userData!.occupation}")));
              },
            ),
          ),
          //addition responsibility
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.country} - ${provider.userData!.additionalResponsibility!}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.country}${provider.userData!.additionalResponsibility}")));
              },
            ),
          ),
          Container(
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
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              title:Text('${provider.userData!.location} - ${provider.userData!.additionalResponsibility!}'),
              //title: Text(provider.userData!.subGroup4!),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, "${provider.userData!.location}${provider.userData!.additionalResponsibility}")));
              },
            ),
          ),


        ],
      ),

    );
  }
}
