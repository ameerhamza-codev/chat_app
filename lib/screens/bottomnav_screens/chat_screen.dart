import 'dart:async';
import 'dart:io';
import 'package:chat_app/apis/db_api.dart';
import 'package:chat_app/apis/image_api.dart';
import 'package:chat_app/model/social_chat_model.dart';
import 'package:chat_app/model/user_model_class.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/image_viewer.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/widgets/chat_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';
import '../../provider/user_data_provider.dart';
import '../../utils/global.dart';
import '../forward_message.dart';

class ChatScreen extends StatefulWidget {
  String messageType;
  String chatheadId;

  ChatScreen(this.messageType,this.chatheadId);

  @override
  State<ChatScreen> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<ChatScreen> {

  final TextEditingController inputController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();







  Future<File> _chooseCamera() async{
    File file;
    final image=await ImagePicker().pickImage(source: ImageSource.camera);
    return File(image!.path);
  }


  _scroll(){
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  late final _focusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {
          //_sendMessage();
        }
        return KeyEventResult.handled;
      }
      else {
        return KeyEventResult.ignored;
      }
    },
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final provider = Provider.of<ChatProvider>(context, listen: false);
      provider.chatReset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);


    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            if(widget.messageType==MessageType.individual)
              FutureBuilder<AppUser>(
                future: DBApi.getUserData(getRecieverId(widget.chatheadId)),
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
                        padding: EdgeInsets.only(top: 5,bottom: 5),
                        color: primaryColor,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back,color: Colors.white,),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!.profilePicture!),
                            ),
                            SizedBox(width: 10,),
                            Text(snapshot.data!.name!, style: TextStyle(color: Colors.white)),

                          ],
                        ),
                      );

                    }
                  }
                }
            ),
            if(widget.messageType==MessageType.group)
              Container(
                padding: EdgeInsets.only(top: 5,bottom: 5),
                color: primaryColor,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back,color: Colors.white,),
                    ),

                    SizedBox(width: 10,),
                    Text(widget.chatheadId, style: TextStyle(color: Colors.white)),

                  ],
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child:  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('social_chat')
                          .where("groupId",isEqualTo: widget.chatheadId)
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
                          controller: _scrollController,
                          shrinkWrap: true,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                            SocialChatModel model=SocialChatModel.fromMap(data,document.reference.id);

                            return Consumer<ChatProvider>(
                              builder: (context,chat,child){
                                return GestureDetector(

                                  onLongPress: (){
                                    chat.setOptions(true);

                                    if(chat.selectedList.contains(model)){
                                      chat.removeSelectedList(model);
                                      chat.setSelectedModel(null);
                                    }
                                    else{
                                      chat.setSelectedModel(model);
                                      chat.addSelectedList(model);
                                    }


                                    chat.selectedList.forEach((element) {
                                      print('selected list ${element.id}');
                                    });
                                    print("${chat.selectedModel==null?"null id":"this is the id"}");
                                  },
                                  child: model.isReply?buildReplyItem(context, model,chat.selectedModel==null?"":chat.selectedModel.id):
                                  model.message=="uploading"?
                                  ChatWidget.loader(context, model.senderId==FirebaseAuth.instance.currentUser!.uid?true:false, model.senderId)
                                      :
                                  buildListItemView(context,model)
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                 /* if(!provider.userData!.isAdmin && widget.messageType==MessageType.group)
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

                                            await DBApi.storeChat(
                                              "uploading",
                                              widget.chatheadId,
                                              MediaType.image,
                                              chat.reply,
                                              chat.selectedModel==null?"":chat.selectedModel.id,
                                              "all",
                                              DefaultTabController.of(context)!.index==0?MessageType.social:MessageType.individual,
                                              false,
                                              false,
                                            ).then((value){
                                              chat.setReply(false);
                                              ImageApi.uploadFileToFirebase(context, imageFile,value);
                                            });
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
                                              maxLines: null,
                                              minLines: 1,
                                              keyboardType: TextInputType.multiline,
                                              textInputAction: TextInputAction.newline,
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
                                              sendMessage(widget.chatheadId,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
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
                                                    await DBApi.storeChat(
                                                        "uploading",
                                                        widget.chatheadId,
                                                        MediaType.audio,
                                                        chat.reply,
                                                        chat.selectedModel==null?"":chat.selectedModel.id,
                                                        "all",
                                                        widget.messageType,
                                                        false,
                                                        false
                                                    ).then((value){
                                                      ImageApi.uploadFileToFirebase(context, audioFile,value);
                                                    });
                                                    //uploadFileToFirebase(context, audioFile, widget.chatheadId,MediaType.audio,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
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
                                  if(chat.selectedModel!.senderId!=FirebaseAuth.instance.currentUser!.uid)
                                    IconButton(
                                      onPressed: ()async{
                                        await FirebaseFirestore.instance.collection('social_chat').doc(chat.selectedModel.id).delete().then((value){
                                          chat.setOptions(false);


                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  if(widget.messageType!=MessageType.social)
                                    IconButton(
                                      onPressed: ()async{
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ForwardMessage(chat.selectedModel)));

                                      },
                                      icon: Icon(Icons.forward),
                                    ),
                                ],
                              )

                            ],
                          ),
                        );
                    },
                  )
                  else*/
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

                                              await DBApi.storeChat(
                                                "uploading",
                                                widget.chatheadId,
                                                MediaType.image,
                                                chat.reply,
                                                chat.selectedModel==null?"":chat.selectedModel.id,
                                                "all",
                                                DefaultTabController.of(context)!.index==0?MessageType.social:MessageType.individual,
                                                false,
                                                false,
                                              ).then((value){
                                                chat.setReply(false);
                                                ImageApi.uploadFileToFirebase(context, imageFile,value);
                                              });
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
                                                maxLines: null,
                                                minLines: 1,
                                                keyboardType: TextInputType.multiline,
                                                textInputAction: TextInputAction.newline,
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
                                                sendMessage(widget.chatheadId,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
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
                                                      await DBApi.storeChat(
                                                          "uploading",
                                                          widget.chatheadId,
                                                          MediaType.audio,
                                                          chat.reply,
                                                          chat.selectedModel==null?"":chat.selectedModel.id,
                                                          "all",
                                                          widget.messageType,
                                                          false,
                                                          false
                                                      ).then((value){
                                                        ImageApi.uploadFileToFirebase(context, audioFile,value);
                                                      });
                                                      //uploadFileToFirebase(context, audioFile, widget.chatheadId,MediaType.audio,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id);
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
                                    if(chat.selectedList.length==1)
                                    IconButton(
                                      onPressed: (){

                                        chat.setReply(true);
                                        chat.setOptions(false);


                                      },
                                      icon: Icon(Icons.reply),
                                    ),
                                    if(chat.selectedModel!.senderId==FirebaseAuth.instance.currentUser!.uid)
                                      IconButton(
                                        onPressed: ()async{

                                          chat.selectedList.forEach((element) async{
                                            await FirebaseFirestore.instance.collection('social_chat').doc(element.id).delete().then((value){

                                              chat.removeSelectedList(element);
                                          });
                                            chat.setOptions(false);


                                          });
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    if(widget.messageType!=MessageType.social)
                                      IconButton(
                                        onPressed: ()async{

                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  ForwardMessage(chat.selectedList)));

                                        },
                                        icon: Icon(Icons.forward),
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
            )
          ],
        ),
      ),
    );
  }

  void sendMessage(groupId,bool reply,replyId)async{
    String message = inputController.text;
    inputController.clear();
    await DBApi.storeChat(
        message,
        groupId,
        MediaType.plainText,
        reply,
        replyId,
        "all",
        widget.messageType,
        false,
        false
    );
    _scroll();
  }
  void selectMediaAndUpload(String mediaType,reply,replyId,List<String> extensions)async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    //chat.setReply(false);
    if (result != null) {
      File file = File(result.files.single.path!);
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      await DBApi.storeChat(
          "uploading",
          widget.chatheadId,
          mediaType,
          reply,
          replyId,
          "all",
          widget.messageType,
          false,
          false
      ).then((value){
        //chat.setReply(false);
        ImageApi.uploadFileToFirebase(context,file,value);
      });
      Navigator.pop(context);

    };
  }



  Widget buildListItemView(BuildContext context,SocialChatModel item){
    bool isMe = item.senderId==FirebaseAuth.instance.currentUser!.uid?true:false;
    bool isSelected=false;
    //(chat.selectedList.isEmpty?(chat.selectedModel==null?"":chat.selectedModel.id):chat.selectedList.contains(model)model.id):chat.selectedModel==null?"":chat.selectedModel.id
    final provider = Provider.of<ChatProvider>(context, listen: false);

    if(provider.selectedList.contains(item)){
      isSelected=true;
    }
    else if(provider.selectedModel!=null){
      if(provider.selectedModel!.id==item.id)
        isSelected=true;
    }
    return Container(
      color: isSelected?Colors.grey[400]:Colors.grey[300],
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



  Widget buildReplyItem(BuildContext context,SocialChatModel item,selectedId){
    bool isMe = item.senderId==FirebaseAuth.instance.currentUser!.uid?true:false;
    bool isSelected=selectedId==item.id;
    print("reply selected");
    print("media type ${item.mediaType}");
    return  Container(
      color: isSelected?Colors.grey[400]:Colors.grey[300],
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
      ),
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
                        selectMediaAndUpload( MediaType.video,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id,['mp4']);
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
                          selectMediaAndUpload( MediaType.image,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id,['jpg', 'png']);

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
                          selectMediaAndUpload( MediaType.audio,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id,['mp3','opus','m4a','amr']);

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
                          selectMediaAndUpload( MediaType.document,chat.reply,chat.selectedModel==null?"":chat.selectedModel.id,['pdf', 'doc']);


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
