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

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _changeController=TextEditingController();
  List<String> list = <String>['Male', 'Female'];
  String dropdownValue = 'Male';
  String photoUrl="";
  Future uploadImageToFirebase(BuildContext context,File image) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: 'Please Wait',barrierDismissible: false);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value)async {
      photoUrl=value;
      print("value $value");
      setState(() {
        pr.close();
      });
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "profilePicture":photoUrl,
      }).then((val) {
        final provider = Provider.of<UserDataProvider>(context, listen: false);

        AppUser user = provider.userData!;
        user.profilePicture=photoUrl;
        provider.setUserData(user);
        //Navigator.pop(context);
        //Navigator.pop(context);
      });
    }).onError((error, stackTrace){
      pr.close();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: error.toString(),
      );
    });
  }

  _chooseGallery() async{
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value){
      if(value!=null){
        uploadImageToFirebase(context,File(value.path)).whenComplete(() => Navigator.pop(context));
      }

    });

  }

  _choosecamera() async{
    await ImagePicker().pickImage(source: ImageSource.camera).then((value){
      if(value!=null){
        uploadImageToFirebase(context,File(value.path)).whenComplete(() => Navigator.pop(context));
      }

    });
  }
  _logoModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.cloud_upload),
                    title: const Text('Upload file'),
                    onTap: () {
                      _chooseGallery();
                    }),
                
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a photo'),
                    onTap: () => {
                      _choosecamera()
                    },
                  ),
              ],
            ),
          );
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserDataProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Account",style: TextStyle(color: Colors.grey,fontSize: 18),),
              ),
              Divider(color: Colors.grey,),
              ListTile(
                onTap: (){
                  _logoModalBottomSheet(context);
                },
                title: Text("Account Photo"),
                trailing: provider.userData!.profilePicture==""?CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ):Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(provider.userData!.profilePicture!),
                          fit: BoxFit.cover
                      )
                  ),
                ),

              ),
              ListTile(
                  title: Text("Email"),
                  subtitle: Text(provider.userData!.email!),
              ),
              ListTile(
                title: Text("Name"),
                subtitle: Text(provider.userData!.name!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.name!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Name'),
                          content:  TextFormField(
                            controller: _changeController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Name',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'name':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.name=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              ListTile(
                title: Text("Display Name"),
                subtitle: Text(provider.userData!.displayName!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.displayName!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Display Name'),
                          content:  TextFormField(
                            controller: _changeController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Display Name',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'displayName':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.displayName=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              ListTile(
                title: Text("Father Name"),
                subtitle: Text(provider.userData!.fatherName!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.fatherName!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Father Name'),
                          content:  TextFormField(
                            controller: _changeController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Father Name',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'fatherName':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.fatherName=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              ListTile(
                title: Text("Mobile Number"),
                subtitle: Text(provider.userData!.mobile!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.mobile!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Mobile Number'),
                          content:  TextFormField(
                            controller: _changeController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Mobile Number',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'mobile':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.mobile=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),

              ListTile(
                title: Text("Landline Number"),
                subtitle: Text(provider.userData!.landline!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.landline!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Landline Number'),
                          content:  TextFormField(
                            controller: _changeController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Landline Number',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'landline':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.landline=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              ListTile(
                title: Text("Gender"),
                subtitle: Text(provider.userData!.gender!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text="";
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Gender'),
                          content:  StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return Container(
                                padding: EdgeInsets.only(left: 5,right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border:Border.all(color: primaryColor)
                                ),
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'gender':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.gender=dropdownValue;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              ListTile(
                title: Text("Date Of Birth"),
                subtitle: Text(provider.userData!.dob!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.dob!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Date Of Birth'),
                          content:  TextFormField(
                            controller: _changeController,
                            readOnly: true,
                            onTap: ()async{
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1960, 1),
                                  lastDate: DateTime.now());
                              if (picked != null) {
                                setState(() {
                                  final f = new DateFormat('dd-MM-yyyy');
                                  _changeController.text = f.format(picked);
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Set Date Of Birth',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'dob':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.dob=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),

              ListTile(
                title: Text("City"),
                subtitle: Text(provider.userData!.location!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.location!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set City'),
                          content:  TextFormField(
                            controller: _changeController,
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
                                                      _changeController.text=suggestion.name;
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
                                                                  _changeController.text="${data['name']}";
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
                              border: const OutlineInputBorder(),
                              hintText: 'Set City',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'location':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.location=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),

              ListTile(
                title: Text("Country"),
                subtitle: Text(provider.userData!.country!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.country!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Country'),
                          content:  TextFormField(
                            controller: _changeController,
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
                                                      _changeController.text=suggestion.name;
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
                                                                  _changeController.text="${data['name']}";
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
                              border: const OutlineInputBorder(),
                              hintText: 'Set Country',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'country':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.country=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),

              ListTile(
                title: Text("Occupation"),
                subtitle: Text(provider.userData!.occupation!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.occupation!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Occupation'),
                          content:  TextFormField(
                            controller: _changeController,
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
                                                      _changeController.text=suggestion.name;
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
                                                                  _changeController.text="${data['name']}";
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
                              border: const OutlineInputBorder(),
                              hintText: 'Set Occupation',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'occupation':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.occupation=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),

              ListTile(
                title: Text("Job Description"),
                subtitle: Text(provider.userData!.jobDescription!),
                trailing: IconButton(
                  onPressed: (){
                    _changeController.text=provider.userData!.jobDescription!;
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Set Job Description'),
                          content:  TextFormField(
                            controller: _changeController,
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
                                                      _changeController.text=suggestion.name;
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
                                                                  _changeController.text="${data['name']}";
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
                              border: const OutlineInputBorder(),
                              hintText: 'Set Job Description',
                              fillColor: Colors.white,
                              filled: true,

                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child:  Text('LATER',style: TextStyle(color: primaryColor),),
                              onPressed: () {
                                Navigator.pop(context);

                                //Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child:  Text('CHANGE',style: TextStyle(color: primaryColor)),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'jobDescription':_changeController.text,

                                }).then((val){
                                  final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  AppUser user = provider.userData!;
                                  user.jobDescription=_changeController.text;
                                  provider.setUserData(user);
                                  Navigator.pop(context);

                                  //Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });

                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),



            ],
          );
        },
      ),
    );
  }
}
