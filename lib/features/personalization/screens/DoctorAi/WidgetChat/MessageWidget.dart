import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/Conversastion_model.dart';

class MessageWidget extends StatelessWidget {
  final ChatMessage message;

  MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = message.type == 'user';
    final String text = message.text;

    final DateTime timestamp = message.timestamp;
    final String timeFormatted = DateFormat('HH:mm').format(timestamp);

    var w = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomRight: Radius.circular(isUserMessage ? 0 : 20),
                topLeft: Radius.circular(isUserMessage ? 20 : 0),
              ),
              color: isUserMessage ? Colors.blueAccent : Colors.green,
            ),
            constraints: BoxConstraints(maxWidth: w * 2 / 3),
            child: Column(
              crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isUserMessage ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  timeFormatted,
                  style: TextStyle(fontSize: 10, color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
