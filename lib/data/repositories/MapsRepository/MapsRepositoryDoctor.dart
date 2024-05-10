import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import '../../../features/personalization/models/RequestModel.dart';
import '../../../features/personalization/models/user_model.dart';

class UnifiedDoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();

  Stream<List<Doctor>> getActiveDoctors() {
    return _firestore
        .collection('Doctors')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Doctor.fromSnapshot(doc))
        .toList());
  }

  Stream<List<Doctor>> getActiveDoctorsStream() {
    return _firestore.collection('Doctors')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Doctor.fromSnapshot(doc)).toList());
  }

  Future<void> updateDoctorLocation(String doctorId) async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      _firestore.collection('Doctors').doc(doctorId).update({
        'lat': currentLocation.latitude,
        'lng': currentLocation.longitude
      });
    });
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
}




