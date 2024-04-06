import 'package:cloud_firestore/cloud_firestore.dart';

import '../authentication/authentication_repository.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentReference> createSession() async {
    String userId= AuthenticationRepository.instance.getUserID;
    // Crée une nouvelle session et renvoie la référence
    return _firestore.collection('chat_sessions').add({
      'timestamp': FieldValue.serverTimestamp(),
      'userId': userId,
    });
  }

  Future<void> storeMessage({
    required String sessionId,
    required String userId,
    required String text,
    required String messageType, // 'user' ou 'bot'
  }) async {
    // Crée un nouveau message dans la sous-collection 'messages' de la session
    await _firestore.collection('chat_sessions').doc(sessionId).collection('messages').add({
      'type': messageType,
      'text': text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}