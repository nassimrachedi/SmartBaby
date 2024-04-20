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
    final String fullDateFormatted = DateFormat('dd,MM,yyyy').format(timestamp);

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
          isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: isUserMessage ? Colors.white : Colors.black87),
            ),
            SizedBox(height: 4),
            Text(
              timeFormatted,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
