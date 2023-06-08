import 'package:chat_app/provider/forward_provider.dart';
import 'package:chat_app/screens/chat/announcements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apis/db_api.dart';
import '../provider/user_data_provider.dart';
import '../screens/chat/chat_screen.dart';
import '../utils/constants.dart';


class AnnouncementTile extends StatefulWidget {
  String title,infoId;


  AnnouncementTile({required this.title, required this.infoId});

  @override
  State<AnnouncementTile> createState() => _AnnouncementTileState();
}

class _AnnouncementTileState extends State<AnnouncementTile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return  FutureBuilder<bool>(
        future: DBApi.checkIfAnnouncementExists(context,'${widget.infoId}'),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(height: 5,width: 5,);
          }
          else {
            if (snapshot.hasError) {
              print("error ${snapshot.error}");
              return Icon(Icons.error,size: 25,);
            }



            else {
              print('checkIfAnnouncementExists ${snapshot.data}');
              if(snapshot.data!){
                return Container(
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
                    trailing: SizedBox(
                      height: 25,
                      width: 25,
                      child: FutureBuilder<bool>(
                          future: DBApi.getUnreadAnnouncement(context,'${widget.infoId}${provider.userData!.gender}'),
                          builder: (context, AsyncSnapshot<bool> unreadsnap) {
                            if (unreadsnap.connectionState == ConnectionState.waiting) {
                              return Container(height: 5,width: 5,);
                            }
                            else {
                              if (unreadsnap.hasError) {
                                print("error ${unreadsnap.error}");
                                return Icon(Icons.error,size: 25,);
                              }



                              else {
                                if(unreadsnap.data!=null){
                                  return unreadsnap.data!?Icon(Icons.circle,color: primaryColor,size: 10,):Container(height: 6,width: 5,);
                                }
                                else{
                                  return Container(height: 6,width: 5,);
                                }


                              }
                            }
                          }
                      ),
                    ),
                    title: Text(widget.title),
                    onTap: (){
                      print(widget.infoId);
                      DBApi.changeAnnouncementToRead(context, '${widget.infoId}${provider.userData!.gender}');
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  Announcements(widget.infoId)));

                    },
                  ),
                );
              }
              else{
                return Container(height: 1,width: 1,);
              }


            }
          }
        }
    );
  }
}

