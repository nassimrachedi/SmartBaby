import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/serviceusage/v1.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/child/child_repository.dart';
import '../models/children_model.dart';
import 'package:SmartBaby/utils/exceptions/firebase_exceptions.dart';
import 'package:SmartBaby/utils/exceptions/format_exceptions.dart';
import 'package:SmartBaby/utils/popups/loaders.dart';
import 'package:image_picker/image_picker.dart';


class ChildController extends GetxController {
  final ChildRepository repository = ChildRepository();
  var child = Rxn<ModelChild>();
  final GlobalKey<FormState> childFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final Rx<String> selectedGender = 'boy'.obs;
  final TextEditingController tailleController = TextEditingController();
  final TextEditingController poidsController = TextEditingController();
  Rx<ModelChild> Child = ModelChild.empty().obs;
  final imageChildUploading = false.obs;
  String idParent = AuthenticationRepository.instance.getUserID;
  final _db = FirebaseFirestore.instance;
  ChildController();
  late final String parentId;
  @override
  void onInit() {
    super.onInit();
  }

  void addChild() async {
    if (!childFormKey.currentState!.validate()) return;

    final birthDate = DateTime.tryParse(birthDateController.text) ?? DateTime.now();
    final double? taille = double.tryParse(tailleController.text);
    final double? poids = double.tryParse(poidsController.text);
    if (taille == null || poids == null) {
      Get.snackbar(
        'Invalid Input',
        'Please enter valid numbers for taille and poids',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
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
        cameraId: '',
        idChild: '',
        taille: taille,
        poids: poids,
        idParent1: idParent,
        childPicture: Child.value.childPicture,
    );

    try {
      await repository.addChild(child);
      Get.back();
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors de l\'ajout de l\'enfant : $e');
    }
  }

  Future<ModelChild?> getChildForParent() async {
    return repository.getChild();
  }
  void loadChildAssignedToparent() async {
    try {
      var childData = await repository.getChild();
      if (childData != null) {
        child.value = childData;
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données de l\'enfant : $e');
    }
  }

  void deleteCurrentChild() async {
    try {
      if (child.value != null) {
        await repository.deleteChild(child.value!.idChild);
        child.value = null;
        Get.snackbar('Succès', 'Enfant supprimé avec succès');
        Get.back(); // Retour à l'écran précédent ou fermeture du widget actuel
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer l\'enfant : $e');
    }
  }

  Future<bool> isSmartwatchAssociatedToChild() async {


    if (parentId.isEmpty) {
      throw Exception("L'ID de l'utilisateur ne peut pas être vide");
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> parentDoc = await _db.collection('Parents').doc(parentId).get();
      String childId = parentDoc.data()?['ChildId'];

      if (childId != null && childId.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> childDoc = await _db.collection('Children').doc(childId).get();
        String currentSmartwatchId = childDoc.data()?['smartwatchId'];
        return currentSmartwatchId != null && currentSmartwatchId.isNotEmpty;
      } else {
        throw Exception("Aucun enfant assigné à cet utilisateur");
      }
    } catch (e) {
      print(e);
      throw Exception("Erreur lors de la vérification de l'ID de la smartwatch: ${e.toString()}");
    }
  }

  Future<void> updateChildSmartwatchId(BuildContext context, String smartwatchId) async {
    try {
      await repository.updateSmartwatchIdForCurrentUser(smartwatchId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID de la smartwatch mis à jour avec succès.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  uploadChildPicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        final imageUrl = await repository.uploadImageChild(
            'Children/Images', image);
        Child.value.childPicture = imageUrl;
        print('Child.value.childPicture');
        TLoaders.successSnackBar(
            title: 'OhSnap', message: 'Your Profile image has been updated');
      }
    } catch (e) {
      imageChildUploading.value = false;
      TLoaders.errorSnackBar(
          title: 'OhSnap', message: 'Something went wrong: $e');
    }
  }
}