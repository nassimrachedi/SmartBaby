import 'package:get/get.dart';
import '../../../data/repositories/child/child_repository.dart';
import '../models/children_model.dart';

class DoctorController extends GetxController {
  final ChildRepository repository = Get.find<ChildRepository>(); // Assurez-vous que le ChildRepository est bien injecté ou trouvé via Get
  var isLoading = false.obs; // Pour gérer l'état de chargement
  Rx<ModelChild?> currentChild = Rxn<ModelChild>();

  DoctorController() {
    // Bind stream directement lors de l'initialisation
    bindChildStream();
  }

  void bindChildStream() {
    isLoading(true);
    // Abonnez-vous au flux qui renvoie un enfant assigné en temps réel
    currentChild.bindStream(repository.getChildStream()); // Supposons que getChildStream soit correctement implémenté
    currentChild.stream.listen((_) => isLoading(false), onError: (error) {
      isLoading(false);
      Get.snackbar('Erreur', 'Impossible de charger les données de l\'enfant : $error');
    });
  }

  void deleteCurrentDoctorChild() async {
    try {
      if (currentChild.value != null) {
        await repository.deleteChild(currentChild.value!.idChild);
        currentChild.value = null;
        Get.snackbar('Succès', 'Enfant supprimé avec succès');
        Get.back(); // Retour à l'écran précédent ou fermeture du widget actuel
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer l\'enfant : $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    currentChild.close(); // Assurez-vous de fermer le Rx si nécessaire
  }
}
