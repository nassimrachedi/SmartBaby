import 'package:SmartBaby/features/personalization/models/intent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController questionController = TextEditingController();
  TextEditingController actionController = TextEditingController();
  List<TextEditingController> parameterNameControllers = [];
  List<TextEditingController> parameterValueControllers = [];
  List<TextEditingController> answerControllers = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saisir une nouvelle question :',
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
                'Action :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: actionController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Entrez le nom de l\'action',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Paramètres :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: parameterNameControllers.length + 1,
                itemBuilder: (context, index) {
                  if (index == parameterNameControllers.length) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          parameterNameControllers.add(TextEditingController());
                          parameterValueControllers.add(TextEditingController());
                        });
                      },
                      child: Text('Ajouter un paramètre'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
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
                            controller: parameterNameControllers[index],
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Nom du paramètre',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: parameterValueControllers[index],
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Valeur du paramètre',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              parameterNameControllers.removeAt(index);
                              parameterValueControllers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
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
                        child: Text('Ajouter une réponse'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String question = questionController.text;
                    String action = actionController.text;
                    List<ParameterModel> parameters = [];
                    for (int i = 0; i < parameterNameControllers.length; i++) {
                      parameters.add(
                        ParameterModel(
                          name: parameterNameControllers[i].text,
                          value: parameterValueControllers[i].text,
                        ),
                      );
                    }
                    List<String> responses = answerControllers.map((controller) => controller.text).toList();

                    IntentModel newIntent = IntentModel(
                      question: question,
                      action: action,
                      parameters: parameters,
                      responses: responses,
                    );

                    firestore.collection('intents').add(newIntent.toMap());

                    questionController.clear();
                    actionController.clear();
                    parameterNameControllers.clear();
                    parameterValueControllers.clear();
                    answerControllers.clear();
                    setState(() {});
                  }
                },
                child: Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}