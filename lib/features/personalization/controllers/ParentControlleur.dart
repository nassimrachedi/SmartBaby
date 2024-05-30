import 'package:SmartBaby/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentAssignmentController extends GetxController {
  TextEditingController emailController = TextEditingController();

  Future<void> assignParent() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Erreur', 'Veuillez entrer un email');
      return;
    }

    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('Parents')
          .where('Email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String parent2Id = userSnapshot.docs.first.id;
        String currentUserId = AuthenticationRepository.instance.getUserID;
        var childrenSnapshot = await FirebaseFirestore.instance
            .collection('Children')
            .where('idParent1', isEqualTo: currentUserId)
            .get();

        bool alreadyAssigned = false;

        for (var childDoc in childrenSnapshot.docs) {
          if (childDoc['idParent2'] != null && childDoc['idParent2'].isNotEmpty) {
            alreadyAssigned = true;
            break;
          }
        }

        if (alreadyAssigned) {
          Get.defaultDialog(
            title: 'Parent déjà assigné',
            middleText: 'Le deuxième parent est déjà assigné. Voulez-vous le remplacer ?',
            textCancel: 'Non',
            textConfirm: 'Oui',
            onConfirm: () async {
              await _updateParent2Id(childrenSnapshot, parent2Id);
              Get.back(); // Close the dialog
              Get.snackbar('Succès', 'Deuxième parent assigné avec succès');
            },
            onCancel: () {
              Get.back();
              Get.snackbar('Annulé', 'Aucune modification effectuée');
            },
          );
        } else {
          await _updateParent2Id(childrenSnapshot, parent2Id);
          Get.snackbar('Succès', 'Deuxième parent assigné avec succès');
        }
      } else {
        Get.snackbar('Erreur', 'Aucun utilisateur trouvé avec cet email');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de l\'assignation du parent: $e');
    }
  }

  Future<void> _updateParent2Id(QuerySnapshot childrenSnapshot, String parent2Id) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var childDoc in childrenSnapshot.docs) {
      batch.update(childDoc.reference, {'idParent2': parent2Id});
    }
    await batch.commit();
  }
}
