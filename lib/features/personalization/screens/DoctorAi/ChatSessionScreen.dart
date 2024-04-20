import 'package:flutter/material.dart';

import '../../../../data/repositories/Conversastion_repository/Chat_repository.dart';
import '../../models/Conversastion_model.dart';
import 'WidgetChat/MessageWidget.dart';

class ChatMessagesScreen extends StatelessWidget {
  final String sessionId;

  ChatMessagesScreen({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    ChatRepository chatRepository = ChatRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: chatRepository.streamMessagesForSession(sessionId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<ChatMessage> messages = snapshot.data!;
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              ChatMessage message = messages[index];
              return MessageWidget(message: message);
            },
          );
        },
      ),
    );
  }
}
