import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SmartBaby/features/personalization/models/intent.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> answerControllers = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Proposer Questions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saisir une question :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: questionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une question';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Entrez votre question ici',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Réponses possibles :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: answerControllers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == answerControllers.length) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            answerControllers.add(TextEditingController());
                          });
                        },
                        child: Text('Ajouter une réponse', style: TextStyle(color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffc8d8fc),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: answerControllers[index],
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Réponse ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir une réponse';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                answerControllers.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (answerControllers.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Veuillez ajouter au moins une réponse.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              String question = questionController.text;
              List<String> responses = answerControllers.map((controller) => controller.text).toList();

              IntentModel newIntent = IntentModel(
                question: question,
                responses: responses,
                state: IntentState.EnAttente, // Default state
              );

              firestore.collection('intents').add(newIntent.toMap());

              questionController.clear();
              answerControllers.clear();
              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Intent enregistré avec succès.'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: Text('Enregistrer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffc8d8fc),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}