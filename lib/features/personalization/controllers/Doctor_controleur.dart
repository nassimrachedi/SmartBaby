import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/child/child_repository.dart';

class DoctorAssignmentController extends GetxController {
  final ChildRepository _doctorRepository = ChildRepository();
  final TextEditingController emailController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> assignDoctor() async {
    isLoading.value = true;
    String? parentId = AuthenticationRepository.instance.getUserID;
    if (parentId == null) {
      Get.snackbar('Erreur', 'Utilisateur non connecté');
      isLoading.value = false;
      return;
    }

    try {
      await _doctorRepository.assignDoctorToChild(emailController.text.trim());
      Get.snackbar('Succès', 'Médecin assigné avec succès');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}