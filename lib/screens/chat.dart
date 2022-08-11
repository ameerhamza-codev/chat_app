import 'dart:async';

import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

import 'Chat/ChatAdapter.dart';
import 'Chat/Message.dart';
import 'Chat/Tools.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool showSend = false;
  final TextEditingController inputController = new TextEditingController();
  List<Message> items = [];
  late ChatAdapter adapter;

  @override
  void initState() {
    super.initState();
    items.add(Message.time(items.length, "Hai..", false, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
    items.add(Message.time(items.length, "Hello!", true, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
  }

  @override
  Widget build(BuildContext context) {
    adapter = ChatAdapter(context, items, onItemClick);

    return Scaffold(
      backgroundColor: Color(0xffD0DBE2),
      appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: Row(
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile_img.png'),
                minRadius: 15,
                maxRadius: 15,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text("Mary Jackson", style: TextStyle(
                      color: Colors.white)
                  ),

                ],
              )
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            // PopupMenuButton<String>(
            //   onSelected: (String value){},
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //       value: "Settings",
            //       child: Text("Settings"),
            //     ),
            //   ],
            // )
          ]
      ),
      body: Container(
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

