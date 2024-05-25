import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String id;
  final String parentId;
  final String doctorId;
  final double? latitude; // Correction ici
  final double? longitude; // Correction ici
  final String status;
  final Timestamp timestamp;

  Request({
    required this.id,
    required this.parentId,
    required this.doctorId,
    required this.latitude, // Correction ici
    required this.longitude, // Correction ici
    required this.status,
    required this.timestamp,
  });

  factory Request.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Request(
      id: doc.id,
      parentId: data['parentId'],
      doctorId: data['doctorId'],
      latitude: (data['latitude'] as num?)?.toDouble(), // Correction ici
      longitude: (data['longitude'] as num?)?.toDouble(), // Correction ici
      status: data['status'],
      timestamp: data['timestamp'],
    );
  }
}
