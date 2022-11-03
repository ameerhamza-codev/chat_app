import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/provider/forward_provider.dart';
import 'package:chat_app/widgets/group_tile.dart';
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
  List<AppUser> users=[];
  bool _isLoading=true;
  getAllUsers()async{
    setState(() {
      _isLoading=true;
    });
    await FirebaseFirestore.instance.collection('users').where("email",isNotEqualTo: FirebaseAuth.instance.currentUser!.email).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        setState(() {
          users.add(AppUser.fromMap(data, doc.reference.id));
        });

      });
    });
    setState(() {
      _isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final provider = Provider.of<ForwardProvider>(context, listen: false);
      provider.forwardReset();
      getAllUsers();
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Consumer<ForwardProvider>(
          builder: (context,forward,_){
            return Stack(
              children: [
                ListView(
                  children: [

                    Container(
                      height: AppBar().preferredSize.height,
                      color: primaryColor,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                            ),
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
                                onChanged: (value){
                                  setState(() {

                                  });
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



                    if(provider.userData!.isAdmin)
                    GroupTile(
                      title: provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", ""),
                      reciverId: provider.userData!.subGroup3Code!,
                    ),
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", ""),
                        reciverId: provider.userData!.subGroup4Code!,
                      ),

                    //14 groups
                    //mainGroup
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.country} - ${provider.userData!.mainGroupCode!.replaceAll("${provider.userData!.mainGroupCode!} - ", "")}',
                        reciverId: "${provider.userData!.country}${provider.userData!.mainGroupCode}",
                      ),
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.location} - ${provider.userData!.mainGroupCode!.replaceAll("${provider.userData!.mainGroupCode!} - ", "")}',
                        reciverId: "${provider.userData!.location}${provider.userData!.mainGroupCode}",
                      ),

                    //subgroup1
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.country} - ${provider.userData!.subGroup1!.replaceAll("${provider.userData!.subGroup1Code!} - ", "")}',
                        reciverId: "${provider.userData!.country}${provider.userData!.subGroup1Code}",
                      ),
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.location} - ${provider.userData!.subGroup1!.replaceAll("${provider.userData!.subGroup1Code!} - ", "")}',
                        reciverId: "${provider.userData!.location}${provider.userData!.subGroup1Code}",
                      ),

                    //subgroup2
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.country} - ${provider.userData!.subGroup2!.replaceAll("${provider.userData!.subGroup2Code!} - ", "")}',
                        reciverId: "${provider.userData!.country}${provider.userData!.subGroup2Code}",
                      ),
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.location} - ${provider.userData!.subGroup2!.replaceAll("${provider.userData!.subGroup2Code!} - ", "")}',
                        reciverId: "${provider.userData!.location}${provider.userData!.subGroup2Code}",
                      ),

                    //subgroup3
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.country} - ${provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")}',
                        reciverId: "${provider.userData!.country}${provider.userData!.subGroup3Code}",
                      ),
                    GroupTile(
                      title: '${provider.userData!.location} - ${provider.userData!.subGroup3!.replaceAll("${provider.userData!.subGroup3Code!} - ", "")}',
                      reciverId: "${provider.userData!.location}${provider.userData!.subGroup3Code}",
                    ),


                    //subgroup4
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.country} - ${provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")}',
                        reciverId: "${provider.userData!.country}${provider.userData!.subGroup4Code}",
                      ),
                    GroupTile(
                      title: '${provider.userData!.location} - ${provider.userData!.subGroup4!.replaceAll("${provider.userData!.subGroup4Code!} - ", "")}',
                      reciverId: "${provider.userData!.location}${provider.userData!.subGroup4Code}",
                    ),


                    //occupation
                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.country} - ${provider.userData!.occupation!}',
                        reciverId: "${provider.userData!.country}${provider.userData!.occupation}",
                      ),
                    GroupTile(
                      title: '${provider.userData!.location} - ${provider.userData!.occupation!}',
                      reciverId: "${provider.userData!.location}${provider.userData!.occupation}",
                    ),

                    if(provider.userData!.isAdmin)
                      GroupTile(
                        title: '${provider.userData!.country} - ${provider.userData!.additionalResponsibility!}',
                        reciverId: "${provider.userData!.country}${provider.userData!.additionalResponsibility}",
                      ),
                    GroupTile(
                      title: '${provider.userData!.location} - ${provider.userData!.additionalResponsibility!}',
                      reciverId: "${provider.userData!.location}${provider.userData!.additionalResponsibility}",
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Users",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                    ),
                    if(_isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      users.isEmpty
                          ?
                      Center(
                        child: Text("No Users"),
                      )
                          :
                          ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            shrinkWrap: true,
                            itemCount: users.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context,int index){
                              if(users[index].name.toString().toLowerCase().contains(_searchController.text.toString().toLowerCase()))
                                return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      //color: forward.usersList.contains(users[index])?Colors.grey:Colors.transparent,
                                      border: Border(
                                        bottom: BorderSide( color: textColor.shade100),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading:  CircleAvatar(
                                        backgroundColor: textColor,
                                        minRadius: 20.0,
                                        maxRadius: 20.0,
                                        backgroundImage: NetworkImage(users[index].profilePicture!),
                                      ),
                                      trailing: Icon(forward.checkSelectedUser(users[index].userId!)?Icons.check_circle:Icons.arrow_forward_ios_rounded,color: forward.checkSelectedUser(users[index].userId!)?primaryColor:Colors.grey, size: 15),
                                      title: Text(users[index].name!),
                                      onTap: ()async{

                                        if(forward.checkSelectedUser(users[index].userId!)){
                                          print('here');
                                          forward.removeUserFromList(users[index].userId!);
                                        }
                                        else
                                          forward.addUserToList(users[index]);
                                      },
                                    )
                                );
                              else
                                return Container();
                            },
                          ),




                    /*Consumer<ForwardProvider>(
                      builder: (context,forward,_){
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('users')
                              .where("email",isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
                          //.where("subGroup3Code",isEqualTo: provider.userData!.subGroup3Code)
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
                                        color: forward.usersList.contains(model)?Colors.grey:Colors.transparent,
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
                                        trailing: Icon(forward.checkSelectedUser(model.userId!)?Icons.check_circle:Icons.arrow_forward_ios_rounded,color: forward.checkSelectedUser(model.userId!)?primaryColor:Colors.grey, size: 15),
                                        title: Text(model.name!),
                                        onTap: ()async{
                                          print(forward.checkSelectedUser(model.userId!).toString());
                                          //forward.usersList.contains(model)?:print('false');
                                          print('current ${model.userId}');
                                          forward.usersList.forEach((element) {
                                            print('selected ${element.userId}');
                                          });
                                          if(forward.checkSelectedUser(model.userId!)){
                                            print('here');
                                            forward.removeUserFromList(model.userId!);
                                          }
                                          else
                                            forward.addUserToList(model);
                                        },
                                      )
                                  );
                                else
                                  return Container();
                              }).toList(),
                            );
                          },
                        );
                      },
                    )*/



                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Consumer<ForwardProvider>(
                    builder: (context,forward,_)
                    =>Container(
                      // margin: EdgeInsets.all(10),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //borderRadius: BorderRadius.circular(50)
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("    ${forward.usersList.length+forward.groupList.length} selected"),
                          ),
                          IconButton(
                              icon: Icon( Icons.send, color: Colors.blue),
                              onPressed: () async{


                                final chat = Provider.of<ChatProvider>(context, listen: false);
                                for(int i=0;i<forward.usersList.length;i++){
                                  print('iteration $i ${forward.usersList[i].userId}');
                                  bool exists=false;
                                  await FirebaseFirestore.instance.collection('chat_head').get().then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) async{
                                      if(checkIfChatExists(doc.reference.id,FirebaseAuth.instance.currentUser!.uid,forward.usersList[i].userId)){
                                        exists=true;
                                        widget.chat.forEach((element) async{
                                          await DBApi.forwardMessage(element,doc.reference.id, MessageType.individual);
                                        });

                                        //Navigator.pop(context);
                                      }
                                    });
                                  });
                                  if(!exists){
                                    await FirebaseFirestore.instance.collection('chat_head').doc("${FirebaseAuth.instance.currentUser!.uid}_${forward.usersList[i].userId}").set({
                                      "user1":FirebaseAuth.instance.currentUser!.uid,
                                      "user2":forward.usersList[i].userId,
                                      "timestamp":DateTime.now().millisecondsSinceEpoch,
                                    });
                                    widget.chat.forEach((element) async{
                                      await DBApi.forwardMessage(element,"${FirebaseAuth.instance.currentUser!.uid}.${forward.usersList[i].userId}", MessageType.individual);

                                    });
                                   /* chat.setOptions(false);
                                    chat.clearSelectedList();
                                    chat.setSelectedModel(null);*/
                                    //Navigator.pop(context);

                                  }

                                }
                                for(int i=0;i<forward.groupList.length;i++){
                                  widget.chat.forEach((element) async{
                                    await DBApi.forwardMessage(element, forward.groupList[i], MessageType.group);
                                  });
                                }
                                chat.clearSelectedList();
                                chat.setOptions(false);
                                chat.setSelectedModel(null);
                                Navigator.pop(context);


                              }
                          )
                        ],
                      )
                    ),
                  ),
                )
              ],
            );
          },
        )
      ),
    );
  }
}
