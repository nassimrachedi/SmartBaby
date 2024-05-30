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

  Stream<List<ModelChild>> getDoctorChildren() async* {
    try {
      // Récupérer les documents de la collection 'DoctorChild' où 'DoctorId' est égal à l'ID du médecin actuel
      var doctorChildSnapshots = await _firestore
          .collection('DoctorChild')
          .where('DoctorId', isEqualTo: currentDoctorId)
          .get();

      // Extraire les 'ChildId' de chaque document
      List<String> childIds = doctorChildSnapshots.docs.map((doc) => doc['ChildId'] as String).toList();

      // Créer une liste pour stocker les futures des enfants
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> childFutures = childIds.map((childId) => _firestore.collection('Children').doc(childId).get()).toList();

      // Attendre que toutes les futures soient complétées et récupérer les snapshots
      List<DocumentSnapshot<Map<String, dynamic>>> childSnapshots = await Future.wait(childFutures);

      // Mapper les snapshots en objets ModelChild
      List<ModelChild> children = childSnapshots.map((snapshot) => ModelChild.fromSnapshot(snapshot)).toList();

      // Utiliser un StreamController pour émettre les résultats
      final StreamController<List<ModelChild>> controller = StreamController<List<ModelChild>>();
      controller.add(children);
      yield* controller.stream;
    } catch (e) {
      print("Erreur lors de la récupération des enfants du médecin : $e");
      yield* Stream.error(e);
    }
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