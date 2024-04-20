import 'package:SmartBaby/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/repositories/Conversastion_repository/Chat_repository.dart';
import '../../models/Conversastion_model.dart';
import 'ChatSessionScreen.dart';

class ChatSessionsScreen extends StatefulWidget {
  @override
  _ChatSessionsScreenState createState() => _ChatSessionsScreenState();
}

class _ChatSessionsScreenState extends State<ChatSessionsScreen> {
  late final ChatRepository _chatRepository;
  late Future<List<ChatSession>> _futureSessions;

  @override
  void initState() {
    super.initState();
    _chatRepository = ChatRepository();
    _chatRepository.main();
    _futureSessions = _chatRepository.fetchSessionsForParent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Sessions')),
      body: FutureBuilder<List<ChatSession>>(
        future: _futureSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No sessions found.');
          }

          List<ChatSession> sessions = snapshot.data!;
          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              ChatSession session = sessions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(TImages.Icon),
                ),
                title:  Text(DateFormat('dd/MM/yyyy').format(session.timestamp)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatMessagesScreen(sessionId: session.sessionId),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
