import 'dart:async';
import 'dart:io';
import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/image_viewer.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/voice_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

import '../../provider/audio_provider.dart';
import '../../provider/user_data_provider.dart';
import '../../utils/global.dart';
import '../Chat/ChatAdapter.dart';
import '../Chat/Message.dart';
import '../Chat/Tools.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<ChatScreen> {

  final TextEditingController inputController = new TextEditingController();
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future uploadImageToFirebase(BuildContext context,File imageFile,String groupId) async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value)async {
      print("audio message : $value");
      await FirebaseFirestore.instance.collection('social_chat').add({
        "senderId":FirebaseAuth.instance.currentUser!.uid,
        "mediaType":"Image",
        "message":value,
        "groupId":groupId,
        "dateTime":DateTime.now().millisecondsSinceEpoch,
      });
      controller.jumpTo(controller.position.maxScrollExtent);
    }).onError((error, stackTrace){
      print("error ${error.toString()}");
    });
  }


  Future<File> _chooseGallery() async{
    final image=await ImagePicker().pickImage(source: ImageSource.gallery);
    return File(image!.path);

  }
  Future<File> _chooseCamera() async{
    File file;
    final image=await ImagePicker().pickImage(source: ImageSource.camera);
    return File(image!.path);
  }

  Future uploadAudioToFirebase(BuildContext context,File audioFile,String groupId) async {
    print("uploading");
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('voice_notes/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorageRef.putFile(audioFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value)async {
      print("audio message : $value");
      await FirebaseFirestore.instance.collection('social_chat').add({
        "senderId":FirebaseAuth.instance.currentUser!.uid,
        "mediaType":"Audio",
        "message":value,
        "groupId":groupId,
        "dateTime":DateTime.now().millisecondsSinceEpoch,
      });
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }
  _scroll(){
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
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
            Container(
              width: double.infinity, height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child:  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('social_chat')
                          .where("groupId",isEqualTo: provider.userData!.mainGroupCode)
                          .orderBy('dateTime',descending: false).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //WidgetsBinding.instance.addPostFrameCallback((_) =>  controller.jumpTo(controller.position.maxScrollExtent));
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if(snapshot.hasData){
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            _scroll();
                          });
                        }


                        if (snapshot.data!.size==0) {
                          return Center(
                            child: Text("No Messages"),
                          );
                        }

                        return ListView(
                          key: Globals.audioListKey,
                          padding: EdgeInsets.only(top: 10),
                          controller: controller,
                          shrinkWrap: true,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                            SocialChatModel model=SocialChatModel.fromMap(data,document.reference.id);

                            return buildListItemView(context,model);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  Consumer<ChatProvider>(
                    builder: (context,chat,child){
                      return Container(
                        height: 50,
                        // margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          //borderRadius: BorderRadius.circular(50)
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            if(chat.recorder.isRecording)
                              InkWell(
                                onTap: ()async{
                                  if(chat.recorder.isRecording){
                                    await chat.stop();
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.delete,color: Colors.white,),
                                ),
                              )
                            else
                              InkWell(
                                onTap: ()async{
                                  File imageFile=await _chooseCamera();
                                  uploadImageToFirebase(context, imageFile, provider.userData!.mainGroupCode!);
                                },
                                child:  CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(Icons.camera_alt,color: Colors.white,),
                                ),
                              ),
                            if(chat.recorder.isRecording)
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: StreamBuilder<RecordingDisposition>(
                                      stream: chat.recorder.onProgress,
                                      builder: (context,AsyncSnapshot<RecordingDisposition> snapshot){
                                        final duration=snapshot.hasData?snapshot.data!.duration:Duration.zero;
                                        if(snapshot.hasError){
                                          return Text("error ${snapshot.error.toString()}");
                                        }
                                        return Text(prettyDuration(duration));
                                      },
                                    ),
                                  )
                              )
                            else
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextField(
                                    controller: inputController,
                                    maxLines: 1, minLines: 1,
                                    keyboardType: TextInputType.multiline,
                                    decoration:const InputDecoration.collapsed(
                                        hintText: 'Message'
                                    ),
                                    onChanged: (value){
                                      if(value.isEmpty){
                                        chat.setShowSend(false);
                                      }
                                      else{
                                        chat.setShowSend(true);
                                      }

                                    },
                                  ),
                                ),
                              ),
                            if(chat.showSend)
                              IconButton(
                                  icon: Icon( Icons.send, color: Colors.blue),

                                  onPressed: () async{
                                    sendMessage(provider.userData!.mainGroupCode);
                                  }
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(!chat.recorder.isRecording)
                                    InkWell(
                                      onTap: ()async{
                                        File imageFile=await _chooseGallery();
                                        uploadImageToFirebase(context, imageFile, provider.userData!.mainGroupCode!);
                                      },
                                      child: Icon(Icons.image, color: textColor.shade200),
                                    ),
                                  IconButton(
                                      icon: Icon(chat.recorder.isRecording?Icons.stop:Icons.mic, color: chat.recorder.isRecording?Colors.redAccent:Colors.blue),

                                      onPressed: () async{
                                        if(chat.recorder.isRecording){
                                          File audioFile=await chat.stop();
                                          uploadAudioToFirebase(context, audioFile, provider.userData!.mainGroupCode!);
                                        }
                                        else{
                                          await chat.record();
                                        }

                                      }
                                  ),
                                ],
                              ),



                          ],
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
            Expanded(
              child:  StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users')
                    .where("subGroup4Code",isEqualTo: provider.userData!.subGroup4Code).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>  controller.jumpTo(controller.position.maxScrollExtent));
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
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      AppUser model=AppUser.fromMap(data,document.reference.id);

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
                          trailing: Icon(Icons.delete_forever, size: 20, color: Colors.red,),
                          title: Text(model.name!),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  Chat()));
                          },
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
  }

  void onItemClick(int index, String obj) {}

  void sendMessage(groupId)async{
    String message = inputController.text;
    inputController.clear();

    await FirebaseFirestore.instance.collection('social_chat').add({
      "senderId":FirebaseAuth.instance.currentUser!.uid,
      "mediaType":"Text",
      "message":message,
      "groupId":groupId,
      "dateTime":DateTime.now().millisecondsSinceEpoch,
    });
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  Future<AppUser> getUserData(String id)async{
    AppUser? request;
    print("uid=$id");
    await FirebaseFirestore.instance.collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print("exxxx");
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        request= AppUser.fromMap(data, documentSnapshot.reference.id);
      }
      else{
        print("no user found $id");
      }
    });
    return request!;
  }

  Widget buildListItemView(BuildContext context,SocialChatModel item){
    bool isMe = item.senderId==FirebaseAuth.instance.currentUser!.uid?true:false;

    return Wrap(

      alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        isMe ? Container(): Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FutureBuilder<AppUser>(
              future: getUserData(item.senderId),
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
        if(item.mediaType=="Text")
          Card(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
            margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
            color: isMe ? Color(0xffEFFFDE) : Colors.white, elevation: 1,
            child : Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(minWidth: 150),
                    child: Text(item.message, style: TextStyle(
                        color: Colors.black)
                    ),
                  ),
                  Container(height: 3, width: 0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(format(DateTime.fromMillisecondsSinceEpoch(item.dateTime)), textAlign: TextAlign.end, style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),),
                      Container(width: 3),
                    ],
                  )
                ],
              ),
            )
        )
        else if(item.mediaType=="Audio")
          Container(
              height: 60,
              child: AudioBubble(filepath: item.message,timeStamp: item.dateTime,isMe: isMe,)
          )

        else if(item.mediaType=="Image")
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ViewImage(item.message)));

            },
            child: Container(
                width: MediaQuery.of(context).size.width*0.5,
                height: MediaQuery.of(context).size.width*0.5,
                child: Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),),
                    margin: EdgeInsets.fromLTRB(isMe ? 20 : 10, 5, isMe ? 10 : 20, 5),
                    color: isMe ? meChatBubble : Colors.white, elevation: 1,
                    child : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Container(
                        child: Image.network(item.message, height: MediaQuery.of(context).size.width*0.5,fit: BoxFit.cover,),
                      ),
                    )
                ),
              ),
          ),

      ],
    );
  }
  /*Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }*/
}
