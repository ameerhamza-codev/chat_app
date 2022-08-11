import 'dart:async';

import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

import '../Chat/ChatAdapter.dart';
import '../Chat/Message.dart';
import '../Chat/Tools.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<ChatScreen> {
  bool showSend = false;
  final TextEditingController inputController = new TextEditingController();
  List<Message> items = [];
  late ChatAdapter adapter;

  @override
  void initState() {
    super.initState();
    items.add(Message.time(items.length, "Hello everyone how is life going?", false, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
    items.add(Message.time(items.length, "Tomorrow will be a holiday. Yaaay!!", false, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
    items.add(Message.time(items.length, "Let's have a party, What do you say ?", false, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
    items.add(Message.time(items.length, "AWESOME :D", true, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
  }

  @override
  Widget build(BuildContext context) {
    adapter = ChatAdapter(context, items, onItemClick);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                    child: adapter.getView(),
                  ),
                  Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: inputController,
                            maxLines: 1, minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration:const InputDecoration.collapsed(
                                hintText: 'Message'
                            ),
                            onChanged: (term){
                              setState(() { showSend = (term.length > 0); });
                            },
                          ),
                        ),
                        IconButton(icon: Icon(Icons.attach_file, color: textColor.shade200), onPressed: () {}),
                        IconButton(icon: Icon(showSend ? Icons.send : Icons.mic, color: Colors.blue), onPressed: () {
                          if(showSend) sendMessage();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
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
                        backgroundImage: AssetImage('assets/images/profile_img.png'),
                      ),
                      trailing: Icon(Icons.delete_forever, size: 20, color: Colors.red,),
                      title: Text("Mary Jackson"),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  Chat()));
                      },
                    ),
                  );
                }
            ),          ],
        ),
      ),
    );
  }

  void onItemClick(int index, String obj) { }

  void sendMessage(){
    String message = inputController.text;
    inputController.clear();
    showSend = false;
    setState(() {
      adapter.insertSingleItem(
          Message.time(adapter.getItemCount(), message, true,
              adapter.getItemCount() % 5 == 0,
              Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)
          )
      );
    });
    generateReply(message);
  }

  void generateReply(String msg){
    Timer(Duration(seconds: 1), () {
      setState(() {
        adapter.insertSingleItem(
            Message.time(adapter.getItemCount(), msg, false, adapter.getItemCount() % 5 == 0,
                Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)
            )
        );
      });
    });
  }
}
