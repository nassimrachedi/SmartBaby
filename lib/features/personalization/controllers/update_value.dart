import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/child/child_repository.dart';

class UpdateVitalSignsController extends GetxController {
  final ChildRepository repository;
  var isLoading = false.obs;

  // Initialisation des contrôleurs pour chaque champ de saisie
  final TextEditingController minBpmController = TextEditingController();
  final TextEditingController maxBpmController = TextEditingController();
  final TextEditingController minTempController = TextEditingController();
  final TextEditingController maxTempController = TextEditingController();
  final TextEditingController spo2Controller = TextEditingController();

  UpdateVitalSignsController({required this.repository});

  Future<void> updateVitalSigns() async {
    if (!validateVitalValues()) return; // Assurez-vous que les valeurs sont valides avant de continuer.

    isLoading(true); // Indiquez que le processus de mise à jour a commencé.
    try {
      await repository.updateChildVitalValuesForDoctor(
        minBpm: double.tryParse(minBpmController.text),
        maxBpm: double.tryParse(maxBpmController.text),
        minTemp: double.tryParse(minTempController.text),
        maxTemp: double.tryParse(maxTempController.text),
        spo2: double.tryParse(spo2Controller.text),
      );
      Get.snackbar('Succès', 'Les valeurs vitales de l\'enfant ont été mises à jour.');
    } catch (e) {
      Get.snackbar('Erreur', 'La mise à jour a échoué : ${e.toString()}');
    } finally {
      isLoading(false); // La mise à jour est terminée.
    }
  }

  bool validateVitalValues() {
    // Extraire les valeurs des contrôleurs
    double? minBpm = double.tryParse(minBpmController.text);
    double? maxBpm = double.tryParse(maxBpmController.text);
    double? minTemp = double.tryParse(minTempController.text);
    double? maxTemp = double.tryParse(maxTempController.text);
    double? spo2 = double.tryParse(spo2Controller.text);

    if (minBpm != null && maxBpm != null && (minBpm < 0 || maxBpm > 200 || minBpm >= maxBpm)) {
      Get.snackbar('Erreur', 'Les valeurs de BPM ne sont pas valides.');
      return false;
    }
    if (minTemp != null && maxTemp != null && (minTemp < 0 || maxTemp > 200 || minTemp >= maxTemp)) {
      Get.snackbar('Erreur', 'Les valeurs de température ne sont pas valides.');
      return false;
    }
    if (spo2 != null && (spo2 < 75 || spo2 > 100)) {
      Get.snackbar('Erreur', 'La valeur de SpO2 n est pas valide.');
      return false;
      }
          return true; // Les valeurs sont valides si nous arrivons ici.
      }
}
