import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:chat_app/model/announcement_model.dart';
import 'package:chat_app/provider/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

import '../../apis/db_api.dart';
import '../../model/user_model_class.dart';
import '../../utils/constants.dart';
import '../../utils/voice_message.dart';
import '../../widgets/video_widget.dart';
import '../doc_viewer.dart';
import '../image_viewer.dart';

class Announcements extends StatefulWidget {
  String infoId;


  Announcements(this.infoId);

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('announcement')
            .where("groupId",isEqualTo: '${widget.infoId}${provider.userData!.gender}').where("disabled",isEqualTo: false)
            .orderBy('dateTime',descending: true).snapshots(),
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
            return  Center(
                child: Text("No Messages",style: TextStyle(color: Colors.black))
            );

          }

          return ListView(
            shrinkWrap: true,
            reverse: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              AnnouncementModel model=AnnouncementModel.fromMap(data,document.reference.id);
              return Card(
                margin: EdgeInsets.fromLTRB(10,10,10,5),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<AppUser>(
                          future: DBApi.getUserData(model.senderId),
                          builder: (context, AsyncSnapshot<AppUser> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                alignment: Alignment.center,
                                child: CupertinoActivityIndicator(),
                              );
                            }
                            else {
                              if (snapshot.hasError) {
                                print("error ${snapshot.error}");
                                return Container(
                                  color: primaryColor,
                                  child: Center(
                                    child: Text("something went wrong"),
                                  ),
                                );
                              }


                              else {
                                return Container(

                                  child: Row(
                                    children: [

                                      CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot.data!.profilePicture!),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(snapshot.data!.name!, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),

                                    ],
                                  ),
                                );

                              }
                            }
                          }
                      ),
                      SizedBox(height: 10,),
                      if(model.mediaType==MediaType.plainText)
                        Text(model.message,style: TextStyle(fontSize: 17),)
                      else if(model.mediaType==MediaType.image)
                        InkWell(
                          onTap: (){
                            print(model.message);
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ViewImage(model.message)));

                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              //height: MediaQuery.of(context).size.width*0.5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                child:  Image.network(model.message, height: MediaQuery.of(context).size.width*0.5,fit: BoxFit.cover,),
                              )
                          ),
                        )
                      else if(model.mediaType==MediaType.location)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.message.substring(model.message.indexOf('+')+1), style: TextStyle(color: Colors.black),),
                              SizedBox(height: 5,),
                              InkWell(
                                onTap: (){
                                  double lat=double.parse(model.message.substring(0, model.message.indexOf(':')));
                                  double lng=double.parse(model.message.substring(model.message.indexOf(':')+1, model.message.indexOf('+')));
                                  MapsLauncher.launchCoordinates(lat, lng);
                                },
                                child: Text('Show on map', style: TextStyle(color: primaryColor)),
                              )
                            ],
                          )
                        else if(model.mediaType==MediaType.video)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child:  VideoWidget(false, model.message),
                            )
                        else if(model.mediaType==MediaType.document)
                            InkWell(
                              onTap: ()async{



                                await PDFDocument.fromURL(model.message).then((value){
                                  print("pdf ${value}");
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  DocViewer(value)));

                                }).onError((error, stackTrace){
                                  print("pdf ${error.toString()}");
                                });


                              },
                              child: Row(
                                children: [
                                  Icon(Icons.insert_drive_file,color: Colors.grey,),
                                  SizedBox(width: 5,),
                                  Text("Document")
                                ],
                              ),
                            )
                          else if(model.mediaType==MediaType.audio)
                              AudioBubble(filepath: model.message,timeStamp: model.dateTime),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(format(DateTime.fromMillisecondsSinceEpoch(model.dateTime)),style: TextStyle(fontSize: 12,color: Colors.grey),)
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
