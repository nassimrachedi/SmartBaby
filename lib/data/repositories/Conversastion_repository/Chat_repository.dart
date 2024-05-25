import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/personalization/models/Conversastion_model.dart';
import '../authentication/authentication_repository.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentReference> createSession() async {
    String userId = AuthenticationRepository.instance.getUserID;
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
    await _firestore.collection('chat_sessions').doc(sessionId).collection(
        'messages').add({
      'type': messageType,
      'text': text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }




  Future<List<ChatSession>> fetchSessionsForParent() async {
    String parentId = AuthenticationRepository.instance.getUserID;
    var sessionsQuerySnapshot = await _firestore
        .collection('chat_sessions')
        .where('userId', isEqualTo: parentId)
        .orderBy('timestamp', descending: true)
        .get();

    List<ChatSession> sessionsWithMessages = [];
    for (var sessionDoc in sessionsQuerySnapshot.docs) {
      var messagesQuerySnapshot = await sessionDoc.reference.collection('messages').get();
      if (messagesQuerySnapshot.docs.isNotEmpty) {
        sessionsWithMessages.add(ChatSession.fromSnapshot(sessionDoc));
      }
    }
    return sessionsWithMessages;
  }


  Stream<List<ChatMessage>> streamMessagesForSession(String sessionId) {

  return _firestore
      .collection('chat_sessions')
      .doc(sessionId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {

  return snapshot.docs
      .map((doc) => ChatMessage.fromJson(doc.data() as Map<String, dynamic>))
      .toList();
  });



  }

  void main() async {


    var chatRepository = ChatRepository();


    try {
      var sessions = await chatRepository.fetchSessionsForParent();
      for (var session in sessions) {
        print('Session ID: ${session.sessionId}, User ID: ${session.userId}, Timestamp: ${session.timestamp}, Messages: ${session.messages.length}');
        for (var message in session.messages) {
          print('Message: ${message.text}, Type: ${message.type}, Timestamp: ${message.timestamp}');
        }
      }
    } catch (e) {
      print('An error occurred while fetching sessions: $e');
    }
  }
}