import 'package:get/get.dart';
import '../../../data/repositories/child/child_repository.dart';
import '../models/children_model.dart';

class DoctorController extends GetxController {
  final ChildRepository repository = ChildRepository(); // Assurez-vous que ChildRepository est bien défini
  var isLoading = false.obs; // Pour gérer l'état de chargement
  var child = Rxn<ModelChild>();

  DoctorController();

  @override
  void onReady() {
    super.onReady();
    loadChildAssignedToDoctor();
  }

  void loadChildAssignedToDoctor() async {
    try {
      isLoading(true);
      var childData = await repository.getChildAssignedToDoctor();
      if (childData != null) {
        child.value = childData;
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Erreur', 'Impossible de charger les données de l\'enfant : $e');
    }
  }

  void deleteCurrentDoctorChild() async {
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
}