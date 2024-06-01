import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import '../../../../data/repositories/Conversastion_repository/Chat_repository.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import 'WidgetChat/ChatAiWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final ChatRepository _chatRepository = ChatRepository();
  late final String _sessionId;

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    initializeChat();
  }

  void initializeChat() async {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);

    final sessionRef = await _chatRepository.createSession();
    _sessionId = sessionRef.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorai),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.blueAccent,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    String userId = AuthenticationRepository.instance.getUserID; // Assurez-vous que cette méthode est définie correctement

    Message userMessage = Message(text: DialogText(text: [text]));
    addMessage(userMessage, true);
    await _chatRepository.storeMessage(
      sessionId: _sessionId,
      userId: userId,
      text: text,
      messageType: 'user',
    );

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );
    if (response.message != null) {
      Message botMessage = response.message!;
      addMessage(botMessage);
      await _chatRepository.storeMessage(
        sessionId: _sessionId,
        userId: userId,
        text: botMessage.text!.text![0],
        messageType: 'bot',
      );
    }
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    setState(() {
      messages.add({'message': message, 'isUserMessage': isUserMessage});
    });
  }
}
