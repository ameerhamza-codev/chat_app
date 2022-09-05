import 'package:chat_app/model/chat_head_model.dart';
import 'package:chat_app/screens/bottomnav_screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/db_api.dart';
import '../../model/user_model_class.dart';
import '../../provider/user_data_provider.dart';
import '../../utils/constants.dart';
import '../search_individual.dart';

class MainChat extends StatefulWidget {
  const MainChat({Key? key}) : super(key: key);

  @override
  _MainChatState createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(

                labelColor: colorWhite,
                indicatorColor: colorWhite,
                tabs: [
                  Tab(child:Text('Social', style: TextStyle(color: colorWhite, fontSize: 16, fontWeight: FontWeight.w600),)),
                  Tab(child: Text('Individual', style: TextStyle(color: colorWhite, fontSize: 16, fontWeight: FontWeight.w600),)),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatScreen(MessageType.social,provider.userData!.mainGroupCode!),

            Stack(
              children: [
                FutureBuilder<List<ChatHeadModel>>(
                    future: DBApi.getIndividualChats(),
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
                                            trailing: Icon(Icons.delete_forever, size: 20, color: Colors.red,),
                                            title: Text(usersnap.data!.name!),
                                            onTap: (){
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
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  SearchIndividual()));

                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: primaryColor,
                        child: Icon(Icons.message,color: Colors.white,),
                      ),
                    ),
                  ),
                )

              ],
            ),


          ],
        ),
      ),
    );
  }
}
