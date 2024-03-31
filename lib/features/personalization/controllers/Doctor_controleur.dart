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
      // Pas besoin de passer childId car il est récupéré dans la méthode.
      await _childRepository.createAssignmentRequest(emailController.text.trim());
      Get.back(); // Retour à l'écran précédent.
      Get.snackbar('Succès', 'Demande d\'assignation créée avec succès');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading(false);
    }
  }
}