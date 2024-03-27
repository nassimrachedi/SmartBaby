import 'package:SmartBaby/features/personalization/screens/DoctorAi/WidgetChat/ChatAiWidget.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';


class chatAi extends StatefulWidget {
  const chatAi({super.key});

  @override
  State<chatAi> createState() => _chatAi();
}

class _chatAi extends State<chatAi>{
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState(){
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Ai"),
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
                Expanded(child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  ),
                ),

                IconButton(onPressed: (){
                  sendMessage(_controller.text);
                  _controller.clear();
                }, icon: const Icon(Icons.send),
                ),
              ],
            ),
          )
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print("Message is empty");}
      else {
        setState(() {
          addMessage(
            Message(text: DialogText(text: [text])),
          true,
          );
        });
        DetectIntentResponse response = await dialogFlowtter.detectIntent(
            queryInput: QueryInput(text: TextInput(text: text)));

        if(response.message == null){
          return;
        }else{
          setState(() {
            addMessage(Message(text: DialogText(text: [text])));
          });

        }
    }

    }
    addMessage(Message message, [bool isUserMessage = false ]){
    messages.add({"message": message, "isUserMessage": isUserMessage});
    }

  }
