import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:chat_app/screens/doc_viewer.dart';
import 'package:chat_app/widgets/video_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

import '../apis/db_api.dart';
import '../model/user_model_class.dart';
import '../screens/image_viewer.dart';
import '../utils/constants.dart';
import '../utils/voice_message.dart';

class ChatWidget{

  static Widget reply(BuildContext context,String message,mediaType,int timestamp){
    return Column(
      children: [
        if(mediaType==MediaType.plainText)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              /* if(item.isReply)
                buildReplyItem(context, item.replyId),*/
              Container(
                constraints: BoxConstraints(minWidth: 150),
                child: Text(message, style: TextStyle(
                    color: Colors.black)
                ),
              ),
              Container(height: 3, width: 0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(format(DateTime.fromMillisecondsSinceEpoch(timestamp)), textAlign: TextAlign.end, style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),),
                  Container(width: 3),
                ],
              )
            ],
          )
          //Text(format(DateTime.fromMillisecondsSinceEpoch(timestamp)), textAlign: TextAlign.end, style: TextStyle(fontSize: 10, color: Colors.grey,),)
        else if(mediaType==MediaType.image)
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ViewImage(message)));

            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child:  Image.network(message, height: MediaQuery.of(context).size.width*0.5,fit: BoxFit.cover,),
            )
          )
        else if(mediaType==MediaType.video)
            Container(
              width: MediaQuery.of(context).size.width*0.7,
              height: MediaQuery.of(context).size.width*0.5,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child:  VideoWidget(false, message),
            )
        else if(mediaType==MediaType.audio)
            Container(
                height: 60,
                child: AudioBubble(filepath: message,timeStamp: timestamp)
            )

      ],
    );
  }


  static Widget showImage(BuildContext context,bool isMe, url){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ViewImage(url)));

      },
      child: Container(
        width: MediaQuery.of(context).size.width*0.5,
        //height: MediaQuery.of(context).size.width*0.5,
        child: Card(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
            margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
            color: isMe ? meChatBubble : Colors.white, elevation: 1,
            child : Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child:  Image.network(url, height: MediaQuery.of(context).size.width*0.5,fit: BoxFit.cover,),
            )
        ),
      ),
    );
  }

  static Widget showVideo(BuildContext context,bool isMe, url){
    return Container(
      width: MediaQuery.of(context).size.width*0.7,
      height: MediaQuery.of(context).size.width*0.5,
      child: Card(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
          margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
          color: isMe ? meChatBubble : Colors.white, elevation: 1,
          child : Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child:  VideoWidget(false, url),
          )
      ),
    );
  }

  static Widget showDocument(BuildContext context,bool isMe, url,timestamp){
    return InkWell(
      onTap: ()async{



        await PDFDocument.fromURL(url).then((value){
          print("pdf ${value}");
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  DocViewer(value)));

        }).onError((error, stackTrace){
          print("pdf ${error.toString()}");
        });


      },
      child: Container(
        width: MediaQuery.of(context).size.width*0.5,
        //height: MediaQuery.of(context).size.width*0.5,
        child: Card(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
            margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
            color: isMe ? meChatBubble : Colors.white, elevation: 1,
            child : Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insert_drive_file,color: Colors.grey,),
                      SizedBox(width: 5,),
                      Text("Document")
                    ],
                  ),
                  Text(format(DateTime.fromMillisecondsSinceEpoch(timestamp)), textAlign: TextAlign.end, style: TextStyle(fontSize: 10, color: Colors.grey,),)

                ],
              ),
            )
        ),
      ),
    );
  }

  static Widget showText(bool isMe,String message,int timestamp){
    return Card(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
        margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
        color: isMe ? meChatBubble : Colors.white, elevation: 1,
        child : Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
             /* if(item.isReply)
                buildReplyItem(context, item.replyId),*/
              Container(
                constraints: BoxConstraints(minWidth: 150),
                child: Text(message, style: TextStyle(
                    color: Colors.black)
                ),
              ),
              Container(height: 3, width: 0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(format(DateTime.fromMillisecondsSinceEpoch(timestamp)), textAlign: TextAlign.end, style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),),
                  Container(width: 3),
                ],
              )
            ],
          ),
        )
    );
  }

  static Widget showAudio(bool isMe,String message,int timestamp){
    return Container(
        height: 45,
        width: 200,
        margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
        padding: const EdgeInsets.only(left: 12, right: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),

          color: isMe ? meChatBubble : Colors.white,
        ),
        child: AudioBubble(filepath: message,timeStamp: timestamp)
    );
  }

  static Widget loader(BuildContext context,bool isMe,senderId){

    return Wrap(
      alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        isMe ? Container(): Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FutureBuilder<AppUser>(
              future: DBApi.getUserData(senderId),
              builder: (context, AsyncSnapshot<AppUser> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    backgroundColor: primaryColor,
                    maxRadius: 20,
                    minRadius: 20,
                  );
                }
                else {
                  if (snapshot.hasError) {
                    print("error ${snapshot.error}");
                    return CircleAvatar(
                      backgroundColor: primaryColor,
                      maxRadius: 20,
                      minRadius: 20,
                    );
                  }


                  else {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!.profilePicture!),
                      maxRadius: 20,
                      minRadius: 20,
                    );

                  }
                }
              }
          ),
        ),

        Card(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
            margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
            color: isMe ? meChatBubble : Colors.white, elevation: 1,
            child : Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child:  CupertinoActivityIndicator(),
            )
        ),

      ],
    );
  }
}