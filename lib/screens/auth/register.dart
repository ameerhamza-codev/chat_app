import 'package:chat_app/model/invited_user_model.dart';
import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../apis/auth_api.dart';
import '../../model/attributes_model.dart';
import '../../model/main_group_model.dart';
import '../../model/occupation_model.dart';
import '../../provider/user_data_provider.dart';
import '../navigator/bottom_navbar.dart';

class Register extends StatefulWidget {
  final InvitedUserModel invitedUser;
  const Register({Key? key, required this.invitedUser}) : super(key: key);
  
  @override
  RegisterState createState() => new RegisterState();
}


class RegisterState extends State<Register> {

  final TextEditingController groupNameController = new TextEditingController();
  final TextEditingController groupCodeController = new TextEditingController();
  final TextEditingController subGroupName1Controller = new TextEditingController();
  final TextEditingController subGroupCode1Controller = new TextEditingController();
  final TextEditingController subGroupName2Controller = new TextEditingController();
  final TextEditingController subGroupCode2Controller = new TextEditingController();
  final TextEditingController subGroupName3Controller = new TextEditingController();
  final TextEditingController subGroupCode3Controller = new TextEditingController();
  final TextEditingController subGroupName4Controller = new TextEditingController();
  final TextEditingController subGroupCode4Controller = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController genderController = new TextEditingController();
  final TextEditingController addRespController = new TextEditingController();



  var _dobController=TextEditingController();
  var _landlineController=TextEditingController();
  var _fatherNameController=TextEditingController();
  var _passwordController=TextEditingController();
  var _confirmPasswordController=TextEditingController();

  var _occupationController=TextEditingController();
  var _jobdesController=TextEditingController();

  var _displayController=TextEditingController();
  var _companyController=TextEditingController();
  var _countryController=TextEditingController();
  var _locationController=TextEditingController();

  bool expatriates=true;
  bool additionalResponsibilityRequired=true;
  bool active=false;
  bool groupCode=false;
  bool sub1Representative=false;
  bool sub2Representative=false;
  bool sub3Representative=false;
  bool sub4Representative=false;

  String phone='+92';


  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.invitedUser.mainGroup.toString();
    groupCodeController.text = widget.invitedUser.mainGroupCode.toString();
    subGroupName1Controller.text = widget.invitedUser.subGroup1.toString();
    subGroupCode1Controller.text = widget.invitedUser.subGroup1Code.toString();
    subGroupName2Controller.text = widget.invitedUser.subGroup2.toString();
    subGroupCode2Controller.text = widget.invitedUser.subGroup2Code.toString();
    subGroupName3Controller.text = widget.invitedUser.subGroup3.toString();
    subGroupCode3Controller.text = widget.invitedUser.subGroup3Code.toString();
    subGroupName4Controller.text = widget.invitedUser.subGroup4.toString();
    subGroupCode4Controller.text = widget.invitedUser.subGroup4Code.toString();
    nameController.text = widget.invitedUser.name.toString();
    emailController.text = widget.invitedUser.email.toString();
    phoneController.text = widget.invitedUser.mobile.toString();
    genderController.text = widget.invitedUser.gender.toString();
    addRespController.text = widget.invitedUser.additionalResponsibility.toString();
    //addRespTypeController.text = widget.invitedUser.additionalResponsibilityCode.toString();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool _isObscure = true;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: const Text('REGISTER'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10,color: primaryColor,),
                      const Text(" GROUP INFORMATION", style: TextStyle(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 750,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          TextField(
                            maxLines: 1,
                            enabled: false,
                            controller: groupNameController,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'GROUP NAME'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: groupCodeController,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'GROUP CODE'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupName1Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 1 NAME'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupCode1Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 1 CODE'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupName2Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 2 NAME'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupCode2Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 2 CODE'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupName3Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 3 NAME'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupCode3Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 3 CODE'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupName4Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 4 NAME'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: subGroupCode4Controller,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'SUB-GROUP 4 CODE'),
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10,color: primaryColor,),
                      const Text(" BASIC INFORMATION", style: TextStyle(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 300,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          TextField(
                            maxLines: 1,
                            enabled: false,
                            controller: nameController,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'NAME'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: emailController,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'EMAIL'),
                          ),
                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: phoneController,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'PHONE NUMBER'),
                          ),

                          const Divider(thickness: 1, color: textColor,),
                          TextField(maxLines: 1,
                            enabled: false,
                            controller: genderController,
                            decoration: InputDecoration( border: InputBorder.none,labelText: 'GENDER'),
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10,color: primaryColor,),
                      const Text(" PERSONAL INFORMATION", style: TextStyle(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("DISPLAY NAME", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                        controller: _displayController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("FATHER NAME", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                        controller: _fatherNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("DOB", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                        readOnly: true,
                        controller: _dobController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onTap: ()async{
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1960, 1),
                              lastDate: DateTime.now());
                          if (picked != null) {
                            setState(() {
                              final f = DateFormat('dd-MM-yyyy');
                              _dobController.text = f.format(picked);
                            });
                          }
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text("JOB DESCRIPTION", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                        controller: _jobdesController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return StatefulBuilder(
                                  builder: (context,setState){
                                    return Dialog(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      insetAnimationDuration: const Duration(seconds: 1),
                                      insetAnimationCurve: Curves.fastOutSlowIn,
                                      elevation: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width*0.3,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 50,
                                              margin: const EdgeInsets.all(10),
                                              child: TypeAheadField(
                                                textFieldConfiguration: TextFieldConfiguration(


                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.all(15),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      borderSide: const BorderSide(
                                                        color: Colors.transparent,
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      borderSide: const BorderSide(
                                                          color: Colors.transparent,
                                                          width: 0.5
                                                      ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      borderSide: const BorderSide(
                                                        color: Colors.transparent,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    hintText: 'Search',
                                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  ),
                                                ),
                                                noItemsFoundBuilder: (context) {
                                                  return const ListTile(
                                                    leading: Icon(Icons.error),
                                                    title: Text("No Data Found"),
                                                  );
                                                },
                                                suggestionsCallback: (pattern) async {

                                                  List<MainGroupModel> search=[];
                                                  await FirebaseFirestore.instance
                                                      .collection('job_description')
                                                      .get()
                                                      .then((QuerySnapshot querySnapshot) {
                                                    querySnapshot.docs.forEach((doc) {
                                                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                                      MainGroupModel model=MainGroupModel.fromMap(data, doc.reference.id);
                                                      if (model.code.contains(pattern))
                                                        search.add(model);
                                                    });
                                                  });

                                                  return search;
                                                },
                                                itemBuilder: (context, MainGroupModel suggestion) {
                                                  return ListTile(
                                                    leading: const Icon(Icons.people),
                                                    title: Text(suggestion.name),
                                                    subtitle: Text(suggestion.code),
                                                  );
                                                },
                                                onSuggestionSelected: (MainGroupModel suggestion) {
                                                  _jobdesController.text=suggestion.name;
                                                  Navigator.pop(context);

                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance.collection('job_description').snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Column(
                                                        children: [
                                                          Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                          const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (snapshot.data!.size==0){
                                                    return const Center(
                                                        child: Text("No Data Added",style: TextStyle(color: Colors.black))
                                                    );

                                                  }

                                                  return ListView(
                                                    shrinkWrap: true,
                                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 15.0),
                                                        child: ListTile(
                                                          onTap: (){
                                                            setState(() {
                                                              _jobdesController.text="${data['name']}";
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                          leading: const Icon(Icons.people),
                                                          title: Text("${data['name']}",style: const TextStyle(color: Colors.black),),
                                                          subtitle: Text("${data['code']}",style: const TextStyle(color: Colors.black),),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          );
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text("COMPANY NAME", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                        controller: _companyController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //oc
                  Text("OCCUPATION", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(maxLines: 1, keyboardType: TextInputType.text,
                        controller: _occupationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return StatefulBuilder(
                                  builder: (context,setState){
                                    return Dialog(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      insetAnimationDuration: const Duration(seconds: 1),
                                      insetAnimationCurve: Curves.fastOutSlowIn,
                                      elevation: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width*0.3,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 50,
                                              margin: const EdgeInsets.all(10),
                                              child: TypeAheadField(
                                                textFieldConfiguration: TextFieldConfiguration(


                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.all(15),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      borderSide: const BorderSide(
                                                        color: Colors.transparent,
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      borderSide: const BorderSide(
                                                          color: Colors.transparent,
                                                          width: 0.5
                                                      ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      borderSide: const BorderSide(
                                                        color: Colors.transparent,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    hintText: 'Search',
                                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  ),
                                                ),
                                                noItemsFoundBuilder: (context) {
                                                  return const ListTile(
                                                    leading: Icon(Icons.error),
                                                    title: Text("No Data Found"),
                                                  );
                                                },
                                                suggestionsCallback: (pattern) async {

                                                  List<OccupationModel> search=[];
                                                  await FirebaseFirestore.instance
                                                      .collection('occupation')
                                                      .get()
                                                      .then((QuerySnapshot querySnapshot) {
                                                    querySnapshot.docs.forEach((doc) {
                                                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                                      OccupationModel model=OccupationModel.fromMap(data, doc.reference.id);
                                                      if (model.code.contains(pattern))
                                                        search.add(model);
                                                    });
                                                  });

                                                  return search;
                                                },
                                                itemBuilder: (context, OccupationModel suggestion) {
                                                  return ListTile(
                                                    leading: const Icon(Icons.people),
                                                    title: Text(suggestion.name),
                                                    subtitle: Text(suggestion.code),
                                                  );
                                                },
                                                onSuggestionSelected: (OccupationModel suggestion) {
                                                  _occupationController.text=suggestion.name;
                                                  Navigator.pop(context);

                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance.collection('occupation').snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Column(
                                                        children: [
                                                          Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                          const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (snapshot.data!.size==0){
                                                    return const Center(
                                                        child: Text("No Data Added",style: TextStyle(color: Colors.black))
                                                    );

                                                  }

                                                  return ListView(
                                                    shrinkWrap: true,
                                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 15.0),
                                                        child: ListTile(
                                                          onTap: (){
                                                            setState(() {
                                                              _occupationController.text="${data['name']}";
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                          leading: const Icon(Icons.people),
                                                          title: Text("${data['name']}",style: const TextStyle(color: Colors.black),),
                                                          subtitle: Text("${data['code']}",style: const TextStyle(color: Colors.black),),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          );
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("ADDITIONAL RESPONSIBILITIES", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(enabled: false, maxLines: 1, keyboardType: TextInputType.text, controller: addRespController,
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),
                  /*const SizedBox(height: 20),
                  Text("ADD. RES. TYPE", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(enabled: false, maxLines: 1, keyboardType: TextInputType.text, controller: addRespTypeController,

                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 20),
                  Text("LANDLINE", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(maxLines: 1, keyboardType: TextInputType.phone,
                        controller: _landlineController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: expatriates,
                    onChanged: (value){
                      setState(() {
                        expatriates = value!;
                      });
                    },
                    title: const Text("Expatriates", style: TextStyle(color: textColor)),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 20),
                  if(expatriates)
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("CITY", style: TextStyle(color: textColor)),
                            Container(height: 5),
                            Card(
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(0), elevation: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: <Widget>[
                                    Container(width: 15),
                                    Expanded(
                                      child: TextFormField(maxLines: 1,
                                        controller: _locationController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: (){
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return StatefulBuilder(
                                                  builder: (context,setState){
                                                    return Dialog(
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                      ),
                                                      insetAnimationDuration: const Duration(seconds: 1),
                                                      insetAnimationCurve: Curves.fastOutSlowIn,
                                                      elevation: 2,
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        width: MediaQuery.of(context).size.width*0.3,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              margin: const EdgeInsets.all(10),
                                                              child: TypeAheadField(
                                                                textFieldConfiguration: TextFieldConfiguration(


                                                                  decoration: InputDecoration(
                                                                    contentPadding: const EdgeInsets.all(15),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(7.0),
                                                                      borderSide: const BorderSide(
                                                                        color: Colors.transparent,
                                                                      ),
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(7.0),
                                                                      borderSide: const BorderSide(
                                                                          color: Colors.transparent,
                                                                          width: 0.5
                                                                      ),
                                                                    ),
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(7.0),
                                                                      borderSide: const BorderSide(
                                                                        color: Colors.transparent,
                                                                        width: 0.5,
                                                                      ),
                                                                    ),
                                                                    filled: true,
                                                                    fillColor: Colors.grey[200],
                                                                    hintText: 'Search',
                                                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                  ),
                                                                ),
                                                                noItemsFoundBuilder: (context) {
                                                                  return const ListTile(
                                                                    leading: Icon(Icons.error),
                                                                    title: Text("No Data Found"),
                                                                  );
                                                                },
                                                                suggestionsCallback: (pattern) async {

                                                                  List<AttributeModel> search=[];
                                                                  await FirebaseFirestore.instance
                                                                      .collection('location')
                                                                      .get()
                                                                      .then((QuerySnapshot querySnapshot) {
                                                                    querySnapshot.docs.forEach((doc) {
                                                                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                                                      AttributeModel model=AttributeModel.fromMap(data, doc.reference.id);
                                                                      if (model.code.contains(pattern))
                                                                        search.add(model);
                                                                    });
                                                                  });

                                                                  return search;
                                                                },
                                                                itemBuilder: (context, AttributeModel suggestion) {
                                                                  return ListTile(
                                                                    leading: const Icon(Icons.people),
                                                                    title: Text(suggestion.name),
                                                                    subtitle: Text(suggestion.code),
                                                                  );
                                                                },
                                                                onSuggestionSelected: (AttributeModel suggestion) {
                                                                  _locationController.text=suggestion.name;
                                                                  Navigator.pop(context);

                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: StreamBuilder<QuerySnapshot>(
                                                                stream: FirebaseFirestore.instance.collection('location').snapshots(),
                                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                  if (snapshot.hasError) {
                                                                    return Center(
                                                                      child: Column(
                                                                        children: [
                                                                          Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                                          const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                                        ],
                                                                      ),
                                                                    );
                                                                  }

                                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                                    return const Center(
                                                                      child: CircularProgressIndicator(),
                                                                    );
                                                                  }
                                                                  if (snapshot.data!.size==0){
                                                                    return const Center(
                                                                        child: Text("No Data Added",style: TextStyle(color: Colors.black))
                                                                    );

                                                                  }

                                                                  return new ListView(
                                                                    shrinkWrap: true,
                                                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                                      return new Padding(
                                                                        padding: const EdgeInsets.only(top: 15.0),
                                                                        child: ListTile(
                                                                          onTap: (){
                                                                            setState(() {
                                                                              _locationController.text="${data['name']}";
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          leading: const Icon(Icons.people),
                                                                          title: Text("${data['name']}",style: const TextStyle(color: Colors.black),),
                                                                          subtitle: Text("${data['code']}",style: const TextStyle(color: Colors.black),),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                          );
                                        },
                                        decoration: InputDecoration(

                                          contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("COUNTRY", style: TextStyle(color: textColor)),
                            Container(height: 5),
                            Card(
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(0), elevation: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(maxLines: 1,
                                  controller: _countryController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return StatefulBuilder(
                                            builder: (context,setState){
                                              return Dialog(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                insetAnimationDuration: const Duration(seconds: 1),
                                                insetAnimationCurve: Curves.fastOutSlowIn,
                                                elevation: 2,
                                                child: Container(
                                                  padding: const EdgeInsets.all(10),
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        margin: const EdgeInsets.all(10),
                                                        child: TypeAheadField(
                                                          textFieldConfiguration: TextFieldConfiguration(


                                                            decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.all(15),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(7.0),
                                                                borderSide: const BorderSide(
                                                                  color: Colors.transparent,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(7.0),
                                                                borderSide: const BorderSide(
                                                                    color: Colors.transparent,
                                                                    width: 0.5
                                                                ),
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(7.0),
                                                                borderSide: const BorderSide(
                                                                  color: Colors.transparent,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              filled: true,
                                                              fillColor: Colors.grey[200],
                                                              hintText: 'Search',
                                                              // If  you are using latest version of flutter then lable text and hint text shown like this
                                                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                            ),
                                                          ),
                                                          noItemsFoundBuilder: (context) {
                                                            return const ListTile(
                                                              leading: Icon(Icons.error),
                                                              title: Text("No Data Found"),
                                                            );
                                                          },
                                                          suggestionsCallback: (pattern) async {

                                                            List<AttributeModel> search=[];
                                                            await FirebaseFirestore.instance
                                                                .collection('country')
                                                                .get()
                                                                .then((QuerySnapshot querySnapshot) {
                                                              querySnapshot.docs.forEach((doc) {
                                                                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                                                AttributeModel model=AttributeModel.fromMap(data, doc.reference.id);
                                                                if (model.code.contains(pattern))
                                                                  search.add(model);
                                                              });
                                                            });

                                                            return search;
                                                          },
                                                          itemBuilder: (context, AttributeModel suggestion) {
                                                            return ListTile(
                                                              leading: const Icon(Icons.people),
                                                              title: Text(suggestion.name),
                                                              subtitle: Text(suggestion.code),
                                                            );
                                                          },
                                                          onSuggestionSelected: (AttributeModel suggestion) {
                                                            _countryController.text=suggestion.name;
                                                            Navigator.pop(context);

                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder<QuerySnapshot>(
                                                          stream: FirebaseFirestore.instance.collection('country').snapshots(),
                                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                            if (snapshot.hasError) {
                                                              return Center(
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                                    const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                                  ],
                                                                ),
                                                              );
                                                            }

                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return const Center(
                                                                child: CircularProgressIndicator(),
                                                              );
                                                            }
                                                            if (snapshot.data!.size==0){
                                                              return const Center(
                                                                  child: Text("No Data Added",style: TextStyle(color: Colors.black))
                                                              );

                                                            }

                                                            return new ListView(
                                                              shrinkWrap: true,
                                                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                                return new Padding(
                                                                  padding: const EdgeInsets.only(top: 15.0),
                                                                  child: ListTile(
                                                                    onTap: (){
                                                                      setState(() {
                                                                        _countryController.text="${data['name']}";
                                                                      });
                                                                      Navigator.pop(context);
                                                                    },
                                                                    leading: const Icon(Icons.people),
                                                                    title: Text("${data['name']}",style: const TextStyle(color: Colors.black),),
                                                                    subtitle: Text("${data['code']}",style: const TextStyle(color: Colors.black),),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                    );
                                  },
                                  decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("PASSWORD", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        obscureText: _isObscure,
                        maxLines: 1, keyboardType: TextInputType.text,
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("CONFIRM PASSWORD", style: TextStyle(color: textColor)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        obscureText: _isObscure,
                        validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                        controller: _confirmPasswordController,
                        maxLines: 1, keyboardType: TextInputType.text,
                        decoration: InputDecoration( contentPadding: EdgeInsets.all(-12),border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3),),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0), elevation: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),

                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          CheckboxListTile(
                            value: active,
                            onChanged: (value){
                              setState(() {
                                active = value!;
                              });
                            },
                            title: const Text("Active",style: TextStyle(color: textColor)),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          CheckboxListTile(
                            value: groupCode,
                            onChanged: (value){
                              setState(() {
                                groupCode = value!;
                              });
                            },
                            title: const Text("Group Code",style: TextStyle(color: textColor)),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          CheckboxListTile(
                            value: sub1Representative,
                            onChanged: (value){
                              setState(() {
                                sub1Representative = value!;
                              });
                            },
                            title: const Text("Sub Group 1 Representative",style: TextStyle(color: textColor)),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          CheckboxListTile(
                            value: sub2Representative,
                            onChanged: (value){
                              setState(() {
                                sub2Representative = value!;
                              });
                            },
                            title: const Text("Sub Group 2 Representative",style: TextStyle(color: textColor)),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          CheckboxListTile(
                            value: sub3Representative,
                            onChanged: (value){
                              setState(() {
                                sub3Representative = value!;
                              });
                            },
                            title: const Text("Sub Group 3 Representative",style: TextStyle(color: textColor)),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          CheckboxListTile(
                            value: sub4Representative,
                            onChanged: (value){
                              setState(() {
                                sub4Representative = value!;
                              });
                            },
                            title: const Text("Sub Group 4 Representative",style: TextStyle(color: textColor)),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity, height: 45,
                    child: ElevatedButton(
                      child: Text("SUBMIT", style: TextStyle(color: Colors.white)),
                      onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          Map<String,dynamic> userData={

                            "email":emailController.text,
                            "password":_passwordController.text,
                            "name":widget.invitedUser.name,
                            "displayName":_displayController.text,
                            "fatherName":_fatherNameController.text,
                            "dob":_dobController.text,
                            "landline":_landlineController.text,
                            "mobile":widget.invitedUser.mobile,
                            "occupation":_occupationController.text,
                            "jobDescription":_jobdesController.text,
                            "additionalResponsibility":widget.invitedUser.additionalResponsibility,
                            "companyName":_companyController.text,
                            "gender":widget.invitedUser.gender,
                            "country":_countryController.text,
                            "additionalResponsibilityCode":widget.invitedUser.additionalResponsibilityCode,
                            "location":_locationController.text,
                            "mainGroup":widget.invitedUser.mainGroup,
                            "mainGroupCode":widget.invitedUser.mainGroupCode,
                            "subGroup1":widget.invitedUser.subGroup1,
                            "subGroup1Representative":sub1Representative,
                            "subGroup1Code":widget.invitedUser.subGroup1Code,
                            "subGroup2":widget.invitedUser.subGroup2,
                            "subGroup2Representative":sub2Representative,
                            "subGroup2Code":widget.invitedUser.subGroup2Code,
                            "subGroup3":widget.invitedUser.subGroup3,
                            "subGroup3Representative":sub3Representative,
                            "subGroup3Code":widget.invitedUser.subGroup3Code,
                            "subGroup4":widget.invitedUser.subGroup4,
                            "subGroup4Representative":sub4Representative,
                            "subGroup4Code":widget.invitedUser.subGroup4Code,
                            "group":groupCode,
                            "action":active,
                            "refer":widget.invitedUser.referer,
                            "expatriates":expatriates,
                            "additionalResponsibilityRequired":additionalResponsibilityRequired,
                            "status":"Active",
                            "createdAt":DateTime.now().millisecondsSinceEpoch,
                            "token":"",
                            "country_main":false,
                            "country_sub1":false,
                            "country_sub2":false,
                            "country_sub3":false,
                            "country_sub4":false,
                            "country_occupation":false,
                            "country_restype":false,
                            "city_main":false,
                            "city_sub1":false,
                            "city_sub2":false,
                            "city_sub3":true,
                            "city_sub4":true,
                            "city_occupation":true,
                            "city_restype":true,

                          };
                          final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: 'Please Wait',barrierDismissible: true);
                          final provider = Provider.of<UserDataProvider>(context, listen: false);
                          AppUser model=AppUser.fromMap(
                              userData,
                              ''
                          );
                          provider.setUserData(model);
                          AuthenticationApi authApi=AuthenticationApi();
                          bool exists=false;
                          await FirebaseFirestore.instance.collection('users').where("mobile",isEqualTo: widget.invitedUser.mobile).get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                              exists=true;
                            });
                          });
                          pr.close();
                          if(exists){
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: 'User already registered',
                            );
                          }
                          else{
                            authApi.verifyPhoneNumber(widget.invitedUser.mobile, context, 0);

                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

