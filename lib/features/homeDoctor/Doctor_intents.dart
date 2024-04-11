import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:googleapis/dialogflow/v2.dart' as df;


class AddIntentPage extends StatefulWidget {
  @override
  _AddIntentPageState createState() => _AddIntentPageState();
}

class _AddIntentPageState extends State<AddIntentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _trainingPhraseController = TextEditingController();
  final _responseTextController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _trainingPhraseController.dispose();
    _responseTextController.dispose();
    super.dispose();
  }

  Future<void> createIntent() async {
    if (_formKey.currentState!.validate()) {
      final serviceAccountCredentials = await getServiceAccountCredentials();
      final accessToken = await getAccessToken(serviceAccountCredentials);

      final url = 'https://dialogflow.googleapis.com/v2/projects/${serviceAccountCredentials["project_id"]}/agent/intents';

      final headers = <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final requestBody = jsonEncode({
        "displayName": _nameController.text,
        "trainingPhrases": [
          {
            "type": "EXAMPLE",
            "parts": [
              {"text": _trainingPhraseController.text}
            ]
          }
        ],
        "messages": [
          {
            "text": {
              "text": [_responseTextController.text]
            }
          }
        ]
      });

      try {
        final response = await http.post(
            Uri.parse(url), headers: headers, body: requestBody);

        if (response.statusCode == 200) {
          // Intent created successfully
          _showDialog('Success', 'The intent was added successfully.');
        } else {
          // Error handling
          _showErrorDialog('Failed to add intent: ${response.body}');
        }
      } catch (e) {
        _showErrorDialog('Failed to add intent: $e');
      }
    }
  }

  Future<Map<String, String>> getServiceAccountCredentials() async {
    final String credentialsString = await DefaultAssetBundle.of(context)
        .loadString('assets/dialog_flow_auth.json');
    return json.decode(credentialsString);
  }

  Future<String> getAccessToken(
      Map<String, String> serviceAccountCredentials) async {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key": serviceAccountCredentials['private_key'],
      "client_email": serviceAccountCredentials['client_email'],
      "token_uri": serviceAccountCredentials['token_uri'],
    });
    final authClient = await clientViaServiceAccount(
        accountCredentials, ['https://www.googleapis.com/auth/cloud-platform']);


    final accessToken = authClient.credentials.accessToken.data;
    authClient.close();
    return accessToken;
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) => _showDialog('Error', message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Intent to Dialogflow'),
      ),
      body: SingleChildScrollView( // Ajouté pour permettre le défilement
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Intent Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the intent name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _trainingPhraseController,
                decoration: InputDecoration(labelText: 'Training Phrase'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a training phrase';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _responseTextController,
                decoration: InputDecoration(labelText: 'Response Text'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the response text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createIntent();
                  }
                },
                child: Text('Add Intent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}