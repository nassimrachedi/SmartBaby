import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  late final StreamController<bool> _isActiveController;

  DoctorRepository() {
    _isActiveController = StreamController<bool>.broadcast();
    // Commencez à écouter les mises à jour dès que le repository est créé.
    _listenToDoctorStatus();
  }

  void _listenToDoctorStatus() {
    String doctorId = FirebaseAuth.instance.currentUser!.uid; // Obtenez l'ID du médecin

    _firestore.collection('Doctors').doc(doctorId).snapshots().listen(
          (snapshot) {
        if (snapshot.exists && snapshot.data()!.containsKey('isActive')) {
          if (!_isActiveController.isClosed) {  // Vérifiez si le StreamController est fermé
            _isActiveController.add(snapshot.data()!['isActive']);
          }
        }
      },
      onError: (error) {
        if (!_isActiveController.isClosed) {  // Vérifiez si le StreamController est fermé
          _isActiveController.addError(error);
        }
      },
    );
  }


  Stream<bool> get isActiveStream => _isActiveController.stream;

  Future<void> updateDoctorStatus(bool isActive) async {
    String doctorId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection('Doctors')
        .doc(doctorId)
        .update({'isActive': isActive})
        .catchError((error) => print('Erreur lors de la mise à jour du statut du médecin: $error'));
  }

  void dispose() {
    _isActiveController.close();
  }
}