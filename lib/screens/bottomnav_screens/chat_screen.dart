import 'dart:async';
import 'dart:io';
import 'package:chat_app/apis/db_api.dart';
import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/image_viewer.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/media_type.dart';
import 'package:chat_app/utils/voice_message.dart';
import 'package:chat_app/widgets/chat_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';
import '../../provider/user_data_provider.dart';
import '../../utils/global.dart';

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



  Future uploadFileToFirebase(BuildContext context,File imageFile,String groupId,mediaType,reply,replyId) async {
    var res=await FirebaseFirestore.instance.collection('social_chat').add({
      "senderId":FirebaseAuth.instance.currentUser!.uid,
      "mediaType":mediaType,
      "message":"uploading",
      "groupId":groupId,
      "isReply":reply,
      "replyId":replyId,
      "dateTime":DateTime.now().millisecondsSinceEpoch,
    });
    controller.jumpTo(controller.position.maxScrollExtent);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('media/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value)async {
      print("audio message : $value");
      await FirebaseFirestore.instance.collection('social_chat').doc(res.id).update({
        "message":value,
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

  
  _scroll(){
    controller.jumpTo(controller.position.maxScrollExtent);
  }



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

                            return Consumer<ChatProvider>(
                              builder: (context,chat,child){
                                return GestureDetector(
                                    onPanUpdate: (details) {
                                      // Swiping in right direction.
                                      if (details.delta.dx < 0) {
                                        chat.setSelectedModel(model);
                                        chat.setReply(true);
                                      }


                                    },
                                  onLongPress: (){
                                    chat.setOptions(true);
                                    chat.setSelectedModel(model);
                                  },
                                  child: model.isReply?buildReplyItem(context, model):model.message=="uploading"?ChatWidget.loader(context, model.senderId==FirebaseAuth.instance.currentUser!.uid?true:false, model.senderId):buildListItemView(context,model),
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  Consumer<ChatProvider>(
                    builder: (context,chat,child){
                      if(!chat.options)
                        return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            if(chat.reply)
                              Container(
                                color: Colors.grey[100],
                                height: 50,
                                padding: EdgeInsets.fromLTRB(10,5,10,5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if(chat.selectedModel.mediaType=="Text")
                                            Expanded(
                                              child: Text(chat.selectedModel.message,maxLines: 1,),
                                            )
                                          else if(chat.selectedModel.mediaType=="Audio")
                                            Expanded(
                                              child: Text("Voice Message",maxLines: 1,),
                                            )
                                          else if(chat.selectedModel.mediaType=="Image")
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Image.network(chat.selectedModel.message,height: 24,width: 24,fit: BoxFit.cover,),
                                                    SizedBox(width: 10,),
                                                    Text("Image",maxLines: 1,),
                                                  ],
                                                )
                                              ),
                                          InkWell(
                                            onTap: (){
                                              chat.setReply(false);
                                            },
                                            child:  Icon(Icons.close,size: 15,),
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                            ),
                                ),
                              ),
                            Container(
                              height: 50,
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
                                        chat.setReply(false);
                                        uploadFileToFirebase(context, imageFile, provider.userData!.mainGroupCode!,MediaType.image,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
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
                                          sendMessage(provider.userData!.mainGroupCode,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
                                        }
                                    )
                                  else
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if(!chat.recorder.isRecording)
                                          InkWell(
                                            onTap: ()async{
                                              bottomSheet(context);


                                            },
                                            child: Icon(Icons.attach_file, color: textColor.shade200),
                                          ),
                                        IconButton(
                                            icon: Icon(chat.recorder.isRecording?Icons.stop:Icons.mic, color: chat.recorder.isRecording?Colors.redAccent:Colors.blue),

                                            onPressed: () async{
                                              if(chat.recorder.isRecording){
                                                File audioFile=await chat.stop();
                                                chat.setReply(false);
                                                uploadFileToFirebase(context, audioFile, provider.userData!.mainGroupCode!,MediaType.audio,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
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
                            ),
                          ],
                        )
                      );
                      else
                        return Container(
                          height: 50,
                          // margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //borderRadius: BorderRadius.circular(50)
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                onPressed: (){
                                  chat.setOptions(false);
                                },
                                icon: Icon(Icons.arrow_back),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: (){

                                      chat.setReply(true);
                                      chat.setOptions(false);
                                    },
                                    icon: Icon(Icons.reply),
                                  ),
                                  IconButton(
                                    onPressed: ()async{
                                      await FirebaseFirestore.instance.collection('social_chat').doc(chat.selectedModel.id).delete().then((value){
                                        chat.setOptions(false);


                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              )

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

  void sendMessage(groupId,bool reply,replyId)async{
    String message = inputController.text;
    inputController.clear();

    await FirebaseFirestore.instance.collection('social_chat').add({
      "senderId":FirebaseAuth.instance.currentUser!.uid,
      "mediaType":"Text",
      "message":message,
      "groupId":groupId,
      "isReply":reply,
      "replyId":replyId,
      "dateTime":DateTime.now().millisecondsSinceEpoch,
    });
    controller.jumpTo(controller.position.maxScrollExtent);
  }



  Widget buildListItemView(BuildContext context,SocialChatModel item){
    bool isMe = item.senderId==FirebaseAuth.instance.currentUser!.uid?true:false;

    return Container(

      child: Wrap(
        alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
        children: <Widget>[
          isMe ? Container(): Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FutureBuilder<AppUser>(
                future: DBApi.getUserData(item.senderId),
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
            ChatWidget.showText(isMe, item.message, item.dateTime)
          else if(item.mediaType=="Audio")
            ChatWidget.showAudio(isMe, item.message, item.dateTime)
          else if(item.mediaType==MediaType.video)
              ChatWidget.showVideo(context,isMe, item.message)
            else if(item.mediaType==MediaType.document)
              ChatWidget.showDocument(context,isMe, item.message,item.dateTime)

          else if(item.mediaType=="Image")
              ChatWidget.showImage(context,isMe, item.message)






        ],
      ),
    );
  }



  Widget buildReplyItem(BuildContext context,SocialChatModel item){
    bool isMe = item.senderId==FirebaseAuth.instance.currentUser!.uid?true:false;
    return  Wrap(
      alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        isMe ? Container(): Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FutureBuilder<AppUser>(
              future: DBApi.getUserData(item.senderId),
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
              child:  Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(7)
                    ),
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(2),
                    child: FutureBuilder<SocialChatModel>(
                        future: DBApi.getSocialChat(item.replyId),
                        builder: (context, AsyncSnapshot<SocialChatModel> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CupertinoActivityIndicator();
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
                              return ChatWidget.reply(context, snapshot.data!.message, snapshot.data!.mediaType,snapshot.data!.dateTime);


                            }
                          }
                        }
                    ),
                  ),
                  ChatWidget.reply(context, item.message, item.mediaType,item.dateTime)
                ],
              ),
            )
        ),
          







      ],
    );
  }
  Future bottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (context) =>Container(
        margin: EdgeInsets.all(10),
        height:  100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Consumer<ChatProvider>(

                  builder: (context,chat,_) {
                    return InkWell(
                      onTap: ()async{
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['mp4'],
                        );
                        chat.setReply(false);
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          final provider = Provider.of<UserDataProvider>(context, listen: false);
                          uploadFileToFirebase(context, file, provider.userData!.mainGroupCode!,MediaType.video,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
                          Navigator.pop(context);

                        }
                      },
                      child: Column(
                        children: [
                          Icon(Icons.video_collection_sharp,color:primaryColor),
                          Text("Video")
                        ],
                      ),
                    );
                  }
                ),
              ),
              Expanded(
                flex: 1,
                child: Consumer<ChatProvider>(

                    builder: (context,chat,_) {
                      return InkWell(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png'],
                          );
                          chat.setReply(false);
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            final provider = Provider.of<UserDataProvider>(context, listen: false);
                            uploadFileToFirebase(context, file, provider.userData!.mainGroupCode!,MediaType.image,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(Icons.image,color:primaryColor),
                            Text("Image")
                          ],
                        ),
                      );
                    }
                ),
              ),
              Expanded(
                flex: 1,
                child: Consumer<ChatProvider>(

                    builder: (context,chat,child) {
                      return InkWell(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['mp3','opus','m4a','amr'],
                          );
                          chat.setReply(false);
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            final provider = Provider.of<UserDataProvider>(context, listen: false);
                            uploadFileToFirebase(context, file, provider.userData!.mainGroupCode!,MediaType.audio,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(Icons.headset,color:primaryColor),
                            Text("Audio")
                          ],
                        ),
                      );
                    }
                ),
              ),
              Expanded(
                flex: 1,
                child: Consumer<ChatProvider>(

                    builder: (context,chat,_) {
                      return InkWell(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc'],
                          );
                          chat.setReply(false);
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            final provider = Provider.of<UserDataProvider>(context, listen: false);
                            uploadFileToFirebase(context, file, provider.userData!.mainGroupCode!,MediaType.document,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(Icons.insert_drive_file,color:primaryColor),
                            Text("Document")
                          ],
                        ),
                      );
                    }
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
