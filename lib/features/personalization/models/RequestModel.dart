import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String id;
  String parentId;
  String doctorId;
  GeoPoint parentLocation;
  String status;

  Request({required this.id, required this.parentId, required this.doctorId, required this.parentLocation, required this.status});

  factory Request.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Request(
        id: doc.id,
        parentId: data['parentId'],
        doctorId: data['doctorId'],
        parentLocation: data['parentLocation'],
        status: data['status']
    );
  }
}