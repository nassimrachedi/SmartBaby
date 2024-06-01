import 'package:SmartBaby/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    _futureSessions = _chatRepository.fetchSessionsForParent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.sessions)),
      body: FutureBuilder<List<ChatSession>>(
        future: _futureSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.nosession));
          }

          List<ChatSession> sessions = snapshot.data!;
          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              ChatSession session = sessions[index];
              String formattedDate = DateFormat('dd/MM/yyyy').format(session.timestamp);
              String messagePreview = session.firstMessage.length > 20
                  ? session.firstMessage.substring(0, 20) + '...'
                  : session.firstMessage;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(TImages.Icon),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedDate),
                    Text(messagePreview, style: TextStyle(color: Colors.grey)),
                  ],
                ),
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
