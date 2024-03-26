import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';


class ChatAiScreen extends StatefulWidget{
  final List messages;
  const ChatAiScreen({super.key, required this.messages});

  @override
  State<ChatAiScreen> createState()=> _ChatScreen();
}

class _ChatScreen extends State<ChatAiScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return ListView.separated(
      separatorBuilder: (context, index) =>
           const Padding(padding: EdgeInsets.only(top: 10)),
           itemCount: widget.messages.length,
           itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Row(
              mainAxisAlignment: widget.messages[index]["isUserMessage"]
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.circular(20),
                        topLeft:const Radius.circular(20),
                        bottomRight: Radius.circular(
                            widget.messages[index]["isUserMessage"] ? 0 : 20),
                        topRight: Radius.circular(
                            widget.messages[index]["isUserMessage"] ? 20 : 0)),

                  color: widget.messages[index]["isUserMessage"] ?
                  Colors.deepPurple :
                  Colors.green.shade800,
                  ),

                  constraints: BoxConstraints(maxWidth: width * 2 / 3),
                  child: Text(widget.messages[index]["message"].text.text[0],
                  style: const TextStyle(color: Colors.white),
                  )

                ),
              ]
          ),
        );
      },
    );
  }
}