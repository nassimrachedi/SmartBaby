import 'package:SmartBaby/data/repositories/child/child_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../models/requete_model.dart';
import 'Doctor-controleur.dart';

class AssignmentRequestController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<DoctorAssignmentRequest> pendingRequests = RxList();
  DoctorController cc = DoctorController();
  ChildRepository chil= ChildRepository();

  @override
  void onReady() {
    super.onReady();
    loadPendingRequests();
  }

  void loadPendingRequests() async {
    try {
      String? doctorEmail = await getDoctorEmail();
      if (doctorEmail != null) {
        var querySnapshot = await _db.collection('AssignmentRequests')
            .where('doctorEmail', isEqualTo: doctorEmail)
            .where('status', isEqualTo: 'pending')
            .get();
        pendingRequests.value = querySnapshot.docs
            .map((doc) => DoctorAssignmentRequest.fromSnapshot(doc))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les demandes: $e');
    }
  }

  Future<void> acceptAssignment(String requestId) async {
    try {
      chil.acceptAssignment(requestId);
      loadPendingRequests(); // Recharger les demandes d'assignation
      cc.refreshChildData();
      Get.snackbar('Succès', 'La demande a été acceptée.');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d\'accepter la demande: $e');
    }
  }

  Future<void> rejectAssignment(String requestId) async {
    try {
      await _db.collection('AssignmentRequests').doc(requestId).update({'status': 'rejected'});
      loadPendingRequests(); // Recharger les demandes d'assignation
      Get.snackbar('Succès', 'La demande a été rejetée.');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de rejeter la demande: $e');
    }
  }

  Future<String?> getDoctorEmail() async {
    try {
      String userId = AuthenticationRepository.instance.getUserID;
      final doctorSnapshot = await _db.collection('Doctors').doc(userId).get();
      return doctorSnapshot.data()?['Email'] as String?;
    } catch (e) {
      print("Erreur lors de la récupération de l'e-mail du médecin: $e");
      return null;
    }
  }
}
