import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/personalization/models/EtatSante_model.dart';
import '../authentication/authentication_repository.dart';

class RepositorySignVitauxVlues {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<EtatSante?> getEtatSanteStreamForCurrentUser() {
    // Assurez-vous que l'ID de l'utilisateur actuel est bien récupéré et non nul.
    String? parentId = AuthenticationRepository.instance.getUserID;

    // Récupérez l'ID de l'enfant associé au parent.
    // Remarque: vous devrez convertir cette logique pour utiliser des Stream plutôt que des Future.
    return _db
        .collection('Parents')
        .doc(parentId)
        .snapshots()
        .asyncMap((parentSnapshot) async {
      String? childId = parentSnapshot.data()?['ChildId'];
      if (childId == null) {
        throw Exception("Child ID cannot be found for the current user.");
      }

      String? smartwatchId = await _db
          .collection('Children')
          .doc(childId)
          .get()
          .then((childSnapshot) => childSnapshot.data()?['smartwatchId']);

      if (smartwatchId == null) {
        throw Exception("Smartwatch ID cannot be found for the child.");
      }

      return smartwatchId;
    })
        .asyncExpand((smartwatchId) => _db
        .collection('SmartWatchEsp32')
        .doc(smartwatchId)
        .snapshots()
        .map((healthSnapshot) =>
    healthSnapshot.exists ? EtatSante.fromDocumentSnapshot(healthSnapshot) : null))
        .handleError((error) {
      print(error); // Traitez l'erreur comme vous le souhaitez.
    });
  }

  Stream<EtatSante?> getEtatSanteStreamForCurrenTMedecin() {
    // Assurez-vous que l'ID de l'utilisateur actuel est bien récupéré et non nul.
    String? parentId = AuthenticationRepository.instance.getUserID;

    // Récupérez l'ID de l'enfant associé au parent.
    // Remarque: vous devrez convertir cette logique pour utiliser des Stream plutôt que des Future.
    return _db
        .collection('Doctors')
        .doc(parentId)
        .snapshots()
        .asyncMap((parentSnapshot) async {
      String? childId = parentSnapshot.data()?['ChildId'];
      if (childId == null) {
        throw Exception("Child ID cannot be found for the current user.");
      }

      String? smartwatchId = await _db
          .collection('Children')
          .doc(childId)
          .get()
          .then((childSnapshot) => childSnapshot.data()?['smartwatchId']);

      if (smartwatchId == null) {
        throw Exception("Smartwatch ID cannot be found for the child.");
      }

      return smartwatchId;
    })
        .asyncExpand((smartwatchId) => _db
        .collection('SmartWatchEsp32')
        .doc(smartwatchId)
        .snapshots()
        .map((healthSnapshot) =>
    healthSnapshot.exists ? EtatSante.fromDocumentSnapshot(healthSnapshot) : null))
        .handleError((error) {
      print(error); // Traitez l'erreur comme vous le souhaitez.
    });
  }
}
