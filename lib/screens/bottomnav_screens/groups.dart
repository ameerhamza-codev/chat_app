import 'package:chat_app/screens/bottomnav_screens/chat_screen.dart';
import 'package:chat_app/screens/group_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where("email",isEqualTo: provider.userData!.email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          print('user data ${snapshot.data!.docs.first.data()}');
          AppUser appUser=AppUser.fromMap(data, FirebaseAuth.instance.currentUser!.uid);
          return ListView(
            children: [



              //default groups

              if(appUser.city_restype && appUser.additionalResponsibility!='')
                GroupTile(
                  title: '${appUser.location} (${appUser.additionalResponsibility!})',
                  reciverId: "${appUser.location}${appUser.additionalResponsibility}",
                ),
              if(appUser.city_occupation)
                GroupTile(
                  title: '${appUser.location} (${appUser.occupation!})',
                  reciverId: "${appUser.location}${appUser.occupation}",
                ),

              if(appUser.city_sub4)
                GroupTile(
                  title: '${appUser.location} (${appUser.subGroup4!.replaceAll("${appUser.subGroup4Code!} - ", "")})',
                  reciverId: "${appUser.location}${appUser.subGroup4Code}",
                ),
              if(appUser.city_sub3)
                GroupTile(
                  title: '${appUser.location} (${appUser.subGroup3!.replaceAll("${appUser.subGroup3Code!} - ", "")})',
                  reciverId: "${appUser.location}${appUser.subGroup3Code}",
                ),

              //city groups
              if(appUser.city_sub2)
                GroupTile(
                  title: '${appUser.location} (${appUser.subGroup2!.replaceAll("${appUser.subGroup2Code!} - ", "")})',
                  reciverId: "${appUser.location}${appUser.subGroup2Code}",
                ),
              if(appUser.city_sub1)
                GroupTile(
                  title: '${appUser.location} (${appUser.subGroup1!.replaceAll("${appUser.subGroup1Code!} - ", "")})',
                  reciverId: "${appUser.location}${appUser.subGroup1Code}",
                ),
              if(appUser.city_main)
                GroupTile(
                  title: '${appUser.location} (${appUser.mainGroup!.replaceAll("${appUser.mainGroupCode!} - ", "")})',
                  reciverId: "${appUser.location}${appUser.mainGroupCode}",
                ),


              //reaming groups
              if(appUser.country_restype && appUser.additionalResponsibility!='')
                GroupTile(
                  title: '${appUser.country} (${appUser.additionalResponsibility!})',
                  reciverId: "${appUser.country}${appUser.additionalResponsibility}",
                ),

              //occupation
              if(appUser.country_occupation)
                GroupTile(
                  title: '${appUser.country} (${appUser.occupation!})',
                  reciverId: "${appUser.country}${appUser.occupation}",
                ),
              //subgroup4
              if(appUser.country_sub4)
                GroupTile(
                  title: '${appUser.country} (${appUser.subGroup4!.replaceAll("${appUser.subGroup4Code!} - ", "")})',
                  reciverId: "${appUser.country}${appUser.subGroup4Code}",
                ),
              //subgroup3
              if(appUser.country_sub3)
                GroupTile(
                  title: '${appUser.country} (${appUser.subGroup3!.replaceAll("${appUser.subGroup3Code!} - ", "")})',
                  reciverId: "${appUser.country}${appUser.subGroup3Code}",
                ),

              //subgroup2
              if(appUser.country_sub2)
                GroupTile(
                  title: '${appUser.country} (${appUser.subGroup2!.replaceAll("${appUser.subGroup2Code!} - ", "")})',
                  reciverId: "${appUser.country}${appUser.subGroup2Code}",
                ),
              //subgroup1
              if(appUser.country_sub1)
                GroupTile(
                  title: '${appUser.country} (${appUser.subGroup1!.replaceAll("${appUser.subGroup1Code!} - ", "")})',
                  reciverId: "${appUser.country}${appUser.subGroup1Code}",
                ),
              //mainGroup
              if(appUser.country_main)
                GroupTile(
                  title: '${appUser.country} (${appUser.mainGroup!.replaceAll("${appUser.mainGroupCode!} - ", "")})',
                  reciverId: "${appUser.country}${appUser.mainGroupCode}",
                ),


              //sub group 3 & 4
              /*  GroupTile(
            title: appUser.subGroup3!.replaceAll("${appUser.subGroup3Code!} - ", ""),
            reciverId: appUser.subGroup3Code!,
          ),
          //if(appUser.isAdmin)
          GroupTile(
            title: appUser.subGroup4!.replaceAll("${appUser.subGroup4Code!} - ", ""),
            reciverId: appUser.subGroup4Code!,
          ),*/























            ],
          );
        },
      ),


    );
  }
}
