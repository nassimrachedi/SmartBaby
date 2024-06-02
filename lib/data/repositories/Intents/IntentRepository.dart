import 'package:SmartBaby/features/personalization/models/intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IntentsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addIntent(IntentModel intent) async {
    try {
      await _firestore.collection('intents').add(intent.toMap());
      print('Intent ajouté avec succès dans Firebase');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'intent : $e');
    }
  }

  Future<IntentModel?> getIntent(String intentId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('intents').doc(intentId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return IntentModel(
          question: data['question'],
          responses: List<String>.from(data['responses']),
          state:  data['state'],
        );
      }
      return null; // Retourne null si l'intention n'existe pas
    } catch (e) {
      print('Erreur lors de la récupération de l\'intention : $e');
      return null; // Retourne null en cas d'erreur
    }
  }

  Future<List<IntentModel>> fetchIntents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('intents').get();
      List<IntentModel> intents = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return IntentModel(
          question: data['question'],
          responses: List<String>.from(data['responses']),
          state: data['state'],
        );
      }).toList();
      return intents;
    } catch (e) {
      print('Erreur lors de la récupération des intentions : $e');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }
}
