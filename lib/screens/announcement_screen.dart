import 'package:chat_app/model/announcement_model.dart';
import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/provider/user_data_provider.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/widgets/announecement_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/db_api.dart';
import '../../model/chat_head_model.dart';
import '../../model/user_model_class.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<QuerySnapshot>(
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
              if(appUser.additionalResponsibility!='')
                AnnouncementTile(
                  title: '${appUser.location} (${appUser.additionalResponsibility!})',
                  infoId: "${appUser.location}${appUser.additionalResponsibility}",
                ),

                AnnouncementTile(
                  title: '${appUser.location} (${appUser.occupation!})',
                  infoId: "${appUser.location}${appUser.occupation}",
                ),


                AnnouncementTile(
                  title: '${appUser.location} (${appUser.subGroup4!.replaceAll("${appUser.subGroup4Code!} - ", "")})',
                  infoId: "${appUser.location}${appUser.subGroup4Code}",
                ),

                AnnouncementTile(
                  title: '${appUser.location} (${appUser.subGroup3!.replaceAll("${appUser.subGroup3Code!} - ", "")})',
                  infoId: "${appUser.location}${appUser.subGroup3Code}",
                ),

              //city groups

                AnnouncementTile(
                  title: '${appUser.location} (${appUser.subGroup2!.replaceAll("${appUser.subGroup2Code!} - ", "")})',
                  infoId: "${appUser.location}${appUser.subGroup2Code}",
                ),

                AnnouncementTile(
                  title: '${appUser.location} (${appUser.subGroup1!.replaceAll("${appUser.subGroup1Code!} - ", "")})',
                  infoId: "${appUser.location}${appUser.subGroup1Code}",
                ),

                AnnouncementTile(
                  title: '${appUser.location} (${appUser.mainGroup!.replaceAll("${appUser.mainGroupCode!} - ", "")})',
                  infoId: "${appUser.location}${appUser.mainGroupCode}",
                ),


              //reaming groups
              if(appUser.additionalResponsibility!='')
                AnnouncementTile(
                  title: '${appUser.country} (${appUser.additionalResponsibility!})',
                  infoId: "${appUser.country}${appUser.additionalResponsibility}",
                ),

              //occupation

                AnnouncementTile(
                  title: '${appUser.country} (${appUser.occupation!})',
                  infoId: "${appUser.country}${appUser.occupation}",
                ),
              //subgroup4

                AnnouncementTile(
                  title: '${appUser.country} (${appUser.subGroup4!.replaceAll("${appUser.subGroup4Code!} - ", "")})',
                  infoId: "${appUser.country}${appUser.subGroup4Code}",
                ),
              //subgroup3

                AnnouncementTile(
                  title: '${appUser.country} (${appUser.subGroup3!.replaceAll("${appUser.subGroup3Code!} - ", "")})',
                  infoId: "${appUser.country}${appUser.subGroup3Code}",
                ),

              //subgroup2

                AnnouncementTile(
                  title: '${appUser.country} (${appUser.subGroup2!.replaceAll("${appUser.subGroup2Code!} - ", "")})',
                  infoId: "${appUser.country}${appUser.subGroup2Code}",
                ),
              //subgroup1

                AnnouncementTile(
                  title: '${appUser.country} (${appUser.subGroup1!.replaceAll("${appUser.subGroup1Code!} - ", "")})',
                  infoId: "${appUser.country}${appUser.subGroup1Code}",
                ),
              //mainGroup

                AnnouncementTile(
                  title: '${appUser.country} (${appUser.mainGroup!.replaceAll("${appUser.mainGroupCode!} - ", "")})',
                  infoId: "${appUser.country}${appUser.mainGroupCode}",
                ),

              /*AnnouncementTile(
                title: '${provider.userData!.subGroup2!.replaceAll("${provider.userData!.subGroup2Code!} - ", "")}',
                infoId: provider.userData!.subGroup2Code!,
              ),
              AnnouncementTile(
                title: '${provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")}',
                infoId: provider.userData!.subGroup3Code!,
              ),
              AnnouncementTile(
                title: '${provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")}',
                infoId: provider.userData!.subGroup4Code!,
              ),*/
            ],
          );
        },
      ),
    );
  }
}
