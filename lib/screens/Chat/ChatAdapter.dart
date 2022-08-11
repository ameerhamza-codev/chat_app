import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'Message.dart';


class ChatAdapter {

  List items = <Message>[];
  BuildContext context;
  Function onItemClick;
  ScrollController scrollController = new ScrollController();

  ChatAdapter(this.context, this.items, this.onItemClick);

  void insertSingleItem(Message msg) {
    int insertIndex = items.length;
    items.insert(insertIndex, msg);
    scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut
    );
  }

  Widget getView() {
    return ListView.builder(itemCount: items.length,
      padding: EdgeInsets.symmetric(vertical: 10),
      controller: scrollController,
      itemBuilder: (context, index) {
        Message item = items[index];
        return buildListItemView(index, item);
      },
    );
  }

  Widget buildListItemView(int index, Message item){
    bool isMe = item.fromMe;
    return Wrap(
      alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        isMe ? Container(): Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile_img.png'),
            maxRadius: 20,
            minRadius: 20,
          ),
        ),
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
                    child: Text(item.content, style: TextStyle(
                        color: Colors.black)
                    ),
                  ),
                  Container(height: 3, width: 0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(item.date, textAlign: TextAlign.end, style: TextStyle(fontSize: 12, color: isMe ? Color(0xff58B346) : textColor.shade200)),
                      Container(width: 3),
                    ],
                  )
                ],
              ),
            )
        ),
        isMe ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/me.png'),
            maxRadius: 20,
            minRadius: 20,
          ),
        ): Container(),
      ],
    );
  }

  int getItemCount() => items.length;

}
