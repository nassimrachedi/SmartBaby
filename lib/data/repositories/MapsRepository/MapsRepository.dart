import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../../../features/personalization/models/RequestModel.dart';
import '../../../features/personalization/models/user_model.dart';

class UnifiedDoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();

  Stream<List<Doctor>> getActiveDoctorsStream() {
    return _firestore.collection('Doctors')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Doctor.fromSnapshot(doc)).toList());
  }

  Future<void> sendHelpRequest(String parentId, String doctorId) async {
    LocationData currentLocation = await _location.getLocation();
    await _firestore.collection('Requests').add({
      'parentId': parentId,
      'doctorId': doctorId,
      'parentLocation': GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Stream<List<Request>> getRequestsForDoctor(String doctorId) {
    return _firestore
        .collection('Requests')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Request.fromSnapshot(doc))
        .toList());
  }

  void printActiveDoctors() {
    getActiveDoctorsStream().listen((doctors) {
      for (Doctor doctor in doctors) {
        print('Doctor: ${doctor.firstName} ${doctor.lastName}, Latitude: ${doctor.latitude}, Longitude: ${doctor.longitude}');
      }
    });
  }
}
