import 'package:SmartBaby/data/repositories/authentication/authentication_repository.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/child/child_repository.dart';

class DoctorAssignmentController extends GetxController {
  final ChildRepository _childRepository = ChildRepository();
  final TextEditingController emailController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> assignDoctor() async {
    isLoading(true);
    try {
      await _childRepository.createAssignmentRequest(emailController.text.trim());
      Get.back();
      Get.snackbar('Succès', 'Demande d\'assignation créée avec succès');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading(false);
    }
  }


  void deleteDoctor(String doctorId) {

  }
  Future<List<UserModel>> getAssignedDoctors() async {
    try {
      String userId = AuthenticationRepository.instance.getUserID;
      print('User ID: $userId');

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      print(
          'User Snapshot: $userSnapshot');

      UserModel user = UserModel.fromSnapshot(userSnapshot);
      print('User Role: ${user.role}, Child ID: ${user
          .childId}');

      if ( user.childId == null) {
        // Si l'utilisateur n'est pas un parent ou n'a pas d'enfant, retournez une liste vide
        return [];
      }

      QuerySnapshot<
          Map<String, dynamic>> doctorsSnapshot = await FirebaseFirestore
          .instance
          .collection('Doctors')
          .where('childId', isEqualTo: user
          .childId) // Filtrer les médecins ayant le même enfant que le parent
          .get();
      print(
          'Doctors Snapshot: $doctorsSnapshot'); // Vérifiez le snapshot des médecins

      // Convertir chaque document de médecin en un objet UserModel
      List<UserModel> assignedDoctors = doctorsSnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
      print(
          'Assigned Doctors: $assignedDoctors'); // Vérifiez la liste des médecins assignés

      return assignedDoctors;
    } catch (e) {
      print('Erreur lors de la récupération des médecins assignés: $e');
      return [];
    }
  }

  Future<String?> getDoctorProfilePicture(String doctorId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(doctorId).get();

      if (doctorSnapshot.exists) {
        UserModel doctor = UserModel.fromSnapshot(doctorSnapshot);
        print('Doctor Profile Picture URL: ${doctor.profilePicture}');
        return doctor.profilePicture;
      } else {
        print('Doctor with ID $doctorId not found.');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération de la photo de profil du docteur: $e');
      return null;
    }
  }



}