import 'package:chat_app/screens/bottomnav_screens/chat_screen.dart';
import 'package:chat_app/screens/group_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_model_class.dart';
import '../../provider/user_data_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/group_tile.dart';

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
          /*Container(
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
          ),*/
          //14 groups
          GroupTile(
            title: provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", ""),
            reciverId: provider.userData!.subGroup3Code!,
          ),
          //if(provider.userData!.isAdmin)
          GroupTile(
            title: provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", ""),
            reciverId: provider.userData!.subGroup4Code!,
          ),

          //14 groups
          //mainGroup
          if(provider.userData!.country_main)
            GroupTile(
              title: '${provider.userData!.country} - ${provider.userData!.mainGroupCode!.replaceAll("${provider.userData!.mainGroupCode!} - ", "")}',
              reciverId: "${provider.userData!.country}${provider.userData!.mainGroupCode}",
            ),


          //subgroup1
          if(provider.userData!.country_sub1)
            GroupTile(
              title: '${provider.userData!.country} - ${provider.userData!.subGroup1!.replaceAll("${provider.userData!.subGroup1Code!} - ", "")}',
              reciverId: "${provider.userData!.country}${provider.userData!.subGroup1Code}",
            ),


          //subgroup2
          if(provider.userData!.country_sub2)
            GroupTile(
              title: '${provider.userData!.country} - ${provider.userData!.subGroup2!.replaceAll("${provider.userData!.subGroup2Code!} - ", "")}',
              reciverId: "${provider.userData!.country}${provider.userData!.subGroup2Code}",
            ),


          //subgroup3
          if(provider.userData!.country_sub3)
            GroupTile(
              title: '${provider.userData!.country} - ${provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")}',
              reciverId: "${provider.userData!.country}${provider.userData!.subGroup3Code}",
            ),



          //subgroup4
          if(provider.userData!.country_sub4)
            GroupTile(
              title: '${provider.userData!.country} - ${provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")}',
              reciverId: "${provider.userData!.country}${provider.userData!.subGroup4Code}",
            ),



          //occupation
          if(provider.userData!.country_occupation)
            GroupTile(
              title: '${provider.userData!.country} - ${provider.userData!.occupation!}',
              reciverId: "${provider.userData!.country}${provider.userData!.occupation}",
            ),
          if(provider.userData!.country_restype)
            GroupTile(
              title: '${provider.userData!.country} - ${provider.userData!.additionalResponsibility!}',
              reciverId: "${provider.userData!.country}${provider.userData!.additionalResponsibility}",
            ),

          //city groups
          if(provider.userData!.city_main)
            GroupTile(
              title: '${provider.userData!.location} - ${provider.userData!.mainGroupCode!.replaceAll("${provider.userData!.mainGroupCode!} - ", "")}',
              reciverId: "${provider.userData!.location}${provider.userData!.mainGroupCode}",
            ),
          if(provider.userData!.city_sub1)
            GroupTile(
              title: '${provider.userData!.location} - ${provider.userData!.subGroup1!.replaceAll("${provider.userData!.subGroup1Code!} - ", "")}',
              reciverId: "${provider.userData!.location}${provider.userData!.subGroup1Code}",
            ),
          if(provider.userData!.city_sub2)
            GroupTile(
              title: '${provider.userData!.location} - ${provider.userData!.subGroup2!.replaceAll("${provider.userData!.subGroup2Code!} - ", "")}',
              reciverId: "${provider.userData!.location}${provider.userData!.subGroup2Code}",
            ),
          if(provider.userData!.city_sub3)
            GroupTile(
              title: '${provider.userData!.location} - ${provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")}',
              reciverId: "${provider.userData!.location}${provider.userData!.subGroup3Code}",
            ),
          if(provider.userData!.city_sub4)
            GroupTile(
              title: '${provider.userData!.location} - ${provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")}',
              reciverId: "${provider.userData!.location}${provider.userData!.subGroup4Code}",
            ),
          if(provider.userData!.city_occupation)
            GroupTile(
              title: '${provider.userData!.location} - ${provider.userData!.occupation!}',
              reciverId: "${provider.userData!.location}${provider.userData!.occupation}",
            ),


          if(provider.userData!.city_restype)
            GroupTile(
              title: '${provider.userData!.location} - ${provider.userData!.additionalResponsibility!}',
              reciverId: "${provider.userData!.location}${provider.userData!.additionalResponsibility}",
            ),


        ],
      ),

    );
  }
}
