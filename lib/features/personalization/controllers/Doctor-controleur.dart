import 'package:get/get.dart';
import '../../../data/repositories/child/child_repository.dart';
import '../models/children_model.dart';

class DoctorController extends GetxController {
  final ChildRepository repository = Get.find<ChildRepository>();
  var isLoading = false.obs;
  Rx<ModelChild?> currentChild = Rxn<ModelChild>();

  DoctorController() {
    bindChildStream();
  }

  void bindChildStream() {
    isLoading(true);
    currentChild.bindStream(repository.getChildAssignedToDoctorD());
    currentChild.stream.listen((_) => isLoading(false), onError: (error) {
      isLoading(false);
      Get.snackbar('Erreur', 'Impossible de charger les données de l\'enfant : $error');
    });
  }

  void deleteCurrentDoctorChild() async {
    try {
      if (currentChild.value != null) {
        await repository.deleteChild();
        currentChild.value = null;
        Get.snackbar('Succès', 'Enfant supprimé avec succès');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer l\'enfant : $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    currentChild.close();
  }
}
