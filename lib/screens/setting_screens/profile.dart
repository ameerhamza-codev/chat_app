import 'dart:io';

import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../model/attributes_model.dart';
import '../../model/main_group_model.dart';
import '../../model/occupation_model.dart';
import '../../provider/user_data_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserDataProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              SizedBox(height: 30,),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(provider.userData!.profilePicture!),
                        fit: BoxFit.cover
                    )
                ),
              ),
              ListTile(
                title: Text("Basic Information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              ),
              ListTile(
                title: Text("Email"),
                trailing: Text(provider.userData!.email!),
              ),
              ListTile(
                title: Text("Name"),
                trailing: Text(provider.userData!.name!),

              ),
              ListTile(
                title: Text("Display Name"),
                trailing: Text(provider.userData!.displayName!),

              ),
              ListTile(
                title: Text("Father Name"),
                trailing: Text(provider.userData!.fatherName!),

              ),
              ListTile(
                title: Text("Mobile Number"),
                trailing: Text(provider.userData!.mobile!),

              ),

              ListTile(
                title: Text("Landline Number"),
                trailing: Text(provider.userData!.landline!),

              ),
              ListTile(
                title: Text("Gender"),
                trailing: Text(provider.userData!.gender!),

              ),
              ListTile(
                title: Text("Date Of Birth"),
                trailing: Text(provider.userData!.dob!),

              ),

              ListTile(
                title: Text("City"),
                trailing: Text(provider.userData!.location!),

              ),

              ListTile(
                title: Text("Country"),
                trailing: Text(provider.userData!.country!),

              ),

              ListTile(
                title: Text("Occupation"),
                trailing: Text(provider.userData!.occupation!),

              ),

              ListTile(
                title: Text("Job Description"),
                trailing: Text(provider.userData!.jobDescription!),

              ),

              ListTile(
                title: Text("Group Information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              ),
              ListTile(
                title: Text("Main Group"),
                trailing: Text(provider.userData!.mainGroup!),

              ),
              ListTile(
                title: Text("Sub Group 1"),
                trailing: Text(provider.userData!.subGroup1!),

              ),
              ListTile(
                title: Text("Sub Group 2"),
                trailing: Text(provider.userData!.subGroup2!),

              ),
              ListTile(
                title: Text("Sub Group 3"),
                trailing: Text(provider.userData!.subGroup3!),

              ),
              ListTile(
                title: Text("Sub Group 4"),
                trailing: Text(provider.userData!.subGroup4!),

              ),
            ],
          );
        },
      ),
    );
  }
}
