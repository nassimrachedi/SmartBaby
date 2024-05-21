import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../../../features/personalization/models/RequestModel.dart';
import '../../../features/personalization/models/user_model.dart';
import '../authentication/authentication_repository.dart';

class UnifiedDoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();

  String? parentId = AuthenticationRepository.instance.getUserID;
  Future<void> sendHelpRequest(String doctorId) async {

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



}

