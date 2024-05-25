import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../../../features/personalization/models/RequestModel.dart';
import '../../../features/personalization/models/user_model.dart';
import '../authentication/authentication_repository.dart';

class UnifiedDoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();

  String? userIs = AuthenticationRepository.instance.getUserID;

  Future<void> sendHelpRequest(String doctorId) async {
    LocationData currentLocation = await _location.getLocation();
    await _firestore.collection('Requests').add({
      'parentId': userIs,
      'doctorId': doctorId,
      'longitude': currentLocation.longitude!,
      'latitude': currentLocation.latitude!,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Stream<List<Request>> getRequestsForDoctor() {
    return _firestore
        .collection('Requests')
        .where('doctorId', isEqualTo: userIs)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Request.fromSnapshot(doc))
        .toList());
  }
}
