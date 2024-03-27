import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/child/child_repository.dart';
import '../models/children_model.dart';

class ChildController extends GetxController {
  final ChildRepository repository = ChildRepository();

  final GlobalKey<FormState> childFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final Rx<String> selectedGender = 'boy'.obs;

  // Utilisez l'ID de l'utilisateur courant comme ID du parent
  late final String parentId;

  ChildController();

  @override
  void onInit() {
    super.onInit();
    // Assurez-vous de récupérer l'ID du parent (par exemple, depuis un authentificateur)
     // parentId = AuthRepository.instance.getCurrentUser().uid;
  }

  void addChild() async {
    if (!childFormKey.currentState!.validate()) return;

    final birthDate = DateTime.tryParse(birthDateController.text) ?? DateTime.now();

    ModelChild child = ModelChild(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      birthDate: birthDate,
      gender: selectedGender.value,
      minBpm: 60.0,
      maxBpm: 100.0,
      spo2: 95.0,
      minTemp: 36.0,
      maxTemp: 37.5,
      smartwatchId: '',
      cameraId: '', idChild: '',
    );

    try {
      await repository.addChild(child);
      Get.back(); // Ferme le formulaire après l'ajout réussi
      // Optionnel: Affichez un message de succès
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors de l\'ajout de l\'enfant : $e');
      // Optionnel: Affichez un message d'erreur
    }
  }

  Future<ModelChild?> getChildForParent() async {
    return repository.getChild();
  }


}