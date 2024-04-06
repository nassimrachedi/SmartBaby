import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String type; // 'user' or 'bot'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.type,
    required this.text,
    required this.timestamp,
  });

  // Convert a ChatMessage to a Map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create a ChatMessage from a Map
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      type: json['type'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatSession {
  final String sessionId;
  final String userId; // Ajout de l'identifiant de l'utilisateur
  final DateTime timestamp;
  final List<ChatMessage> messages;

  ChatSession({
    required this.sessionId,
    required this.userId, // Modification ici
    required this.timestamp,
    this.messages = const [],
  });

  // Convert a ChatSession to a Map
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId, // Ajout de l'userId dans le JSON
      'timestamp': timestamp.toIso8601String(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  // Create a ChatSession from a snapshot
  factory ChatSession.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    var messageList = data['messages'] as List;
    List<ChatMessage> messages = messageList.map((message) => ChatMessage.fromJson(message)).toList();

    return ChatSession(
      sessionId: data['sessionId'],
      userId: data['userId'], // Récupération de l'userId à partir du snapshot
      timestamp: DateTime.parse(data['timestamp']),
      messages: messages,
    );
  }
}
