import 'package:chat_app/model/user_model_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../utils/constants.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var _topicController=TextEditingController();
  var _descriptionController=TextEditingController();
  AppUser? selectedUser;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Abuse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              SizedBox(height: 20,),
              if(selectedUser==null)
                TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(


                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Search user by name',
                    fillColor: Colors.white,
                    filled: true,

                  ),
                ),
                noItemsFoundBuilder: (context) {
                  return ListTile(
                    leading: Icon(Icons.error),
                    title: Text("No Group Found"),
                  );
                },
                suggestionsCallback: (pattern) async {

                  List<AppUser> search=[];
                  await FirebaseFirestore.instance
                      .collection('users')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                      AppUser model=AppUser.fromMap(data, doc.reference.id);
                      if ("${model.name}".contains(pattern))
                        search.add(model);
                    });
                  });

                  return search;
                },
                itemBuilder: (context, AppUser suggestion) {
                  return ListTile(
                    leading: Icon(Icons.people),
                    title: Text("${suggestion.name}"),
                    subtitle: Text(suggestion.email!),
                  );
                },
                onSuggestionSelected: (AppUser suggestion) {
                  selectedUser=suggestion;

                },
              )
              else
                Card(
                  child: ListTile(
                    title: Text(selectedUser!.name!),
                    subtitle: Text(selectedUser!.email!),
                    trailing: IconButton(
                      onPressed: (){
                        setState(() {
                          selectedUser=null;
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
              SizedBox(height: 20,),
              TextFormField(

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  return null;
                },
                controller: _topicController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Topic of your report',
                  fillColor: Colors.white,
                  filled: true,

                ),
              ),
              SizedBox(height: 20,),
              TextFormField(

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  return null;
                },
                maxLines: 8,
                minLines: 8,
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Write any details here...',
                  fillColor: colorWhite,
                  filled: true,

                ),
              ),

              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: ()async{
                      if(selectedUser==null){
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: "Please select a user",
                        );
                      }
                      else{
                        if(_formKey.currentState!.validate()){
                          final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: 'Please Wait',barrierDismissible: false);

                          Map<String,dynamic> userData={
                            "abuser_id":selectedUser!.userId,
                            "reporter_id":FirebaseAuth.instance.currentUser!.uid,
                            "topic":_topicController.text,
                            "report":_descriptionController.text,
                            "status":"Pending",
                            "createdAt":DateTime.now().millisecondsSinceEpoch,

                          };
                          await FirebaseFirestore.instance.collection('reports').add(userData)
                          .then((value){
                            pr.close();
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: "Report submitted",
                              onConfirmBtnTap: (){
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            );
                          }).onError((error, stackTrace){
                            pr.close();
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: "Error ${error.toString()}",
                            );
                          });
                        }
                      }

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(20,10,20,10),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text("Send Report",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color:Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
