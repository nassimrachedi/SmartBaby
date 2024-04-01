import 'package:SmartBaby/features/personalization/screens/DoctorAi/WidgetChat/ChatAiWidget.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatAi extends StatefulWidget {
  const ChatAi({Key? key}) : super(key: key);

  @override
  State<ChatAi> createState() => _ChatAiState();
}

class _ChatAiState extends State<ChatAi> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorAi),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: ChatAiScreen(messages: messages)),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.deepPurple,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterMessage,
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send),
                    tooltip: AppLocalizations.of(context)!.send,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print(AppLocalizations.of(context)!.messageEmpty);
    } else {
      setState(() {
        addMessage(
          Message(text: DialogText(text: [text])),
          true,
        );
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));

      if (response.message == null) {
        return;
      } else {
        setState(() {
          addMessage(Message(text: DialogText(text: [text])));
        });
      }
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({"message": message, "isUserMessage": isUserMessage});
  }
}
