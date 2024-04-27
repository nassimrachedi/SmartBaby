import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../features/personalization/models/children_model.dart';
import '../authentication/authentication_repository.dart';

class DoctorRepository {
  RxString currentChildId = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String currentDoctorId =AuthenticationRepository.instance.getUserID;
  Future<String?> getChildAssignedToDoctor() async {
    DocumentSnapshot<Map<String, dynamic>> doctorSnapshot = await _firestore
        .collection('Doctors').doc(currentDoctorId).get();
    String? childId = doctorSnapshot.data()?['ChildId'];
    if (childId != null) {
      currentChildId.value = childId;
    }
    return childId;
  }

  Stream<List<ModelChild>> getDoctorChildren() {
    return _firestore
        .collection('Children')
        .where('DoctorId', isEqualTo: currentDoctorId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ModelChild.fromSnapshot(doc)).toList());
  }

  Future<void> selectChild(String childId) async {
    currentChildId.value = childId;
    await _firestore
        .collection('Doctors')
        .doc(currentDoctorId)
        .update({'ChildId': childId});
  }
}