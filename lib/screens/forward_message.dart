import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apis/db_api.dart';
import '../model/user_model_class.dart';
import '../provider/user_data_provider.dart';
import '../utils/constants.dart';
class ForwardMessage extends StatefulWidget {
  List<SocialChatModel> chat;

  ForwardMessage(this.chat);

  @override
  _ForwardMessageState createState() => _ForwardMessageState();
}

class _ForwardMessageState extends State<ForwardMessage> {
  var _searchController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Consumer<ChatProvider>(
          builder: (context,chat,_){
            return ListView(
              children: [

                Container(
                  height: AppBar().preferredSize.height,
                  color: primaryColor,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                      ),
                      Expanded(
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },

                            controller: _searchController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Search',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search,color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Groups",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
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
                    title: Text(provider.userData!.subGroup3!),
                    onTap: ()async{
                      widget.chat.forEach((element) async{
                        await DBApi.forwardMessage(element, provider.userData!.subGroup3Code, MessageType.group);
                      });
                      chat.clearSelectedList();
                      chat.setOptions(false);
                      Navigator.pop(context);
                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, provider.userData!.subGroup3Code!)));
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
                    title: Text(provider.userData!.subGroup4!),
                    onTap: ()async{
                      widget.chat.forEach((element) async{
                        await DBApi.forwardMessage(element, provider.userData!.subGroup4Code, MessageType.group);
                      });
                      chat.clearSelectedList();
                      chat.setOptions(false);
                      Navigator.pop(context);

                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.group, provider.userData!.subGroup4Code!)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Users",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users')
                      .where("email",isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .where("subGroup3Code",isEqualTo: provider.userData!.subGroup3Code)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }


                    if (snapshot.data!.size==0) {
                      return Center(
                        child: Text("No Users"),
                      );
                    }
                    if(snapshot.hasData){

                    }
                    return ListView(
                      padding: EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        AppUser model=AppUser.fromMap(data,document.reference.id);

                        if(model.name.toString().toLowerCase().contains(_searchController.text.toString().toLowerCase()))
                          return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide( color: textColor.shade100),
                                ),
                              ),
                              child: ListTile(
                                leading:  CircleAvatar(
                                  backgroundColor: textColor,
                                  minRadius: 20.0,
                                  maxRadius: 20.0,
                                  backgroundImage: NetworkImage(model.profilePicture!),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
                                title: Text(model.name!),
                                onTap: ()async{
                                  bool exists=false;
                                  await FirebaseFirestore.instance.collection('chat_head').get().then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) async{
                                      if(checkIfChatExists(doc.reference.id,FirebaseAuth.instance.currentUser!.uid,model.userId)){
                                        exists=true;
                                        widget.chat.forEach((element) async{
                                          await DBApi.forwardMessage(element,doc.reference.id, MessageType.individual);
                                        });
                                        chat.clearSelectedList();
                                        chat.setOptions(false);
                                        Navigator.pop(context);
                                      }
                                    });
                                  });
                                  if(!exists){
                                    await FirebaseFirestore.instance.collection('chat_head').doc("${FirebaseAuth.instance.currentUser!.uid}_${model.userId}").set({
                                      "user1":FirebaseAuth.instance.currentUser!.uid,
                                      "user2":model.userId,
                                      "timestamp":DateTime.now().millisecondsSinceEpoch,
                                    });
                                    widget.chat.forEach((element) async{
                                      await DBApi.forwardMessage(element,"${FirebaseAuth.instance.currentUser!.uid}.${model.userId}", MessageType.individual);

                                    });
                                    chat.setOptions(false);
                                    chat.clearSelectedList();
                                    Navigator.pop(context);

                                  }

                                },
                              )
                          );
                        else
                          return Container();
                      }).toList(),
                    );
                  },
                ),



              ],
            );
          },
        )
      ),
    );
  }
}
