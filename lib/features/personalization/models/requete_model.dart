import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAssignmentRequest {
  String id;
  String doctorEmail;
  String childId;
  String status;
  Timestamp? timestamp;

  DoctorAssignmentRequest({
    required this.id,
    required this.doctorEmail,
    required this.childId,
    required this.status,
    this.timestamp,
  });

  // Convertir un document Firestore en DoctorAssignmentRequest
  factory DoctorAssignmentRequest.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return DoctorAssignmentRequest(
      id: doc.id,
      doctorEmail: data['doctorEmail'] ?? '',
      childId: data['childId'] ?? '',
      status: data['status'] ?? '',
      timestamp: data['timestamp'],
    );
  }

  // Convertir DoctorAssignmentRequest en Map
  Map<String, dynamic> toMap() {
    return {
      'doctorEmail': doctorEmail,
      'childId': childId,
      'status': status,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }
}
