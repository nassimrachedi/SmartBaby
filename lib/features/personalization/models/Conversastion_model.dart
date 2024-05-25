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

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }


  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    var timestamp = json['timestamp'];
    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else {
      dateTime = DateTime.parse(timestamp as String);
    }

    return ChatMessage(
      type: json['type'],
      text: json['text'],
      timestamp: dateTime,
    );
  }
}

  class ChatSession {
  final String sessionId;
  final String userId;
  final DateTime timestamp;
  final List<ChatMessage> messages;

  ChatSession({
    required this.sessionId,
    required this.userId,
    required this.timestamp,
    this.messages = const [],
  });


  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
  String get firstMessage {
    return messages.isNotEmpty ? messages.first.text : '';
  }
  factory ChatSession.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw AssertionError("Snapshot data can't be null");

    List<dynamic> messageListData = data['messages'] as List<dynamic>? ?? [];
    List<ChatMessage> messages = messageListData
        .map((messageJson) => ChatMessage.fromJson(messageJson as Map<String, dynamic>))
        .toList();


    Timestamp timestamp = data['timestamp'] as Timestamp;

    return ChatSession(
      sessionId: snapshot.id,
      userId: data['userId'] ?? '',
      timestamp: timestamp.toDate(),
      messages: messages,
    );
  }

}
