import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../apis/db_api.dart';
import '../../model/chat_head_model.dart';
import '../../model/user_model_class.dart';
import 'search_individual.dart';
import 'chat_screen.dart';

class IndividualChat extends StatefulWidget {
  const IndividualChat({Key? key}) : super(key: key);

  @override
  State<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  SearchIndividual()));
        },
        child: Icon(Icons.message,color: Colors.white,),
      ),
      body: FutureBuilder<List<ChatHeadModel>>(
          future: DBApi.getIndividualChats(context),
          builder: (context, AsyncSnapshot<List<ChatHeadModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              if (snapshot.hasError) {
                print("error ${snapshot.error}");
                return Center(
                  child: Text("error :  ${snapshot.error}"),
                );
              }
              else if (snapshot.data!.isEmpty) {

                return Center(
                  child: Text("No Chats"),
                );
              }


              else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context,int index){
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide( color: textColor.shade100),
                        ),
                      ),
                      child: FutureBuilder<AppUser>(
                          future: DBApi.getUserData(snapshot.data![index].user1==FirebaseAuth.instance.currentUser!.uid?snapshot.data![index].user2:snapshot.data![index].user1),
                          builder: (context, AsyncSnapshot<AppUser> usersnap) {
                            if (usersnap.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }
                            else {
                              if (usersnap.hasError) {
                                print("error ${usersnap.error}");
                                return Center(
                                  child: Text("something went wrong : ${usersnap.error}"),
                                );
                              }



                              else {
                                return ListTile(
                                  leading:  CircleAvatar(
                                    backgroundColor: textColor,
                                    minRadius: 20.0,
                                    maxRadius: 20.0,
                                    backgroundImage: NetworkImage(usersnap.data!.profilePicture!),
                                  ),
                                  trailing: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: FutureBuilder<List<SocialChatModel>>(
                                        future: DBApi.getUnreadMessageCount(context,snapshot.data![index].id),
                                        builder: (context, AsyncSnapshot<List<SocialChatModel>> unreadsnap) {
                                          if (usersnap.connectionState == ConnectionState.waiting) {
                                            return Container(height: 5,width: 5,);
                                          }
                                          else {
                                            if (usersnap.hasError) {
                                              print("error ${usersnap.error}");
                                              return Center(
                                                child: Text("something went wrong : ${usersnap.error}"),
                                              );
                                            }



                                            else {
                                              if(unreadsnap.data!=null){
                                                return unreadsnap.data!.isNotEmpty?CircleAvatar(
                                                  child:Text(unreadsnap.data!.length.toString(),style: TextStyle(fontSize: 12),),
                                                  radius: 10,
                                                  backgroundColor: primaryColor,
                                                ):Container(height: 6,width: 5,);
                                              }
                                              else{
                                                return Container(height: 6,width: 5,);
                                              }


                                            }
                                          }
                                        }
                                    ),
                                  ),
                                  title: Text(usersnap.data!.name!),
                                  onTap: (){
                                    DBApi.changeMessageToRead(context, snapshot.data![index].id);
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ChatScreen(MessageType.individual,snapshot.data![index].id)));
                                  },
                                );

                              }
                            }
                          }
                      ),
                    );
                  },
                );

              }
            }
          }
      )
    );
  }
}
