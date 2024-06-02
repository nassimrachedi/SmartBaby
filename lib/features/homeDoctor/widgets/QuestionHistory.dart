import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'IntentDetail.dart';

class QuestionHistoryScreen extends StatelessWidget {
  const QuestionHistoryScreen({super.key});

  Color _getStateColor(String state) {
    switch (state) {
      case 'IntentState.Acceptee':
        return Colors.green;
      case 'IntentState.Refusee':
        return Colors.red;
      case 'IntentState.EnAttente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique Am\élioration'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('intents').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              var data = doc.data() as Map<String, dynamic>;
              var question = data['question'];
              var state = data['state'];
              var color = _getStateColor(state);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: color, width: 2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.blue.shade50,
                child: ListTile(
                  title: Text(
                    question,
                    style: TextStyle(color: color),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IntentDetailScreen(
                          question: question,
                          responses: List<String>.from(data['responses']),
                          state: state,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
