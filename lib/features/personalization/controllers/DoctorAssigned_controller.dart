import 'package:get/get.dart';
import '../../../data/repositories/child/child_repository.dart';
import '../models/user_model.dart';

class DoctorDisplayController extends GetxController {
  var isLoading = false.obs;
  var assignedDoctors = <Doctor>[].obs;
  ChildRepository childRepository = ChildRepository();

  @override
  void onReady() {
    super.onReady();
    fetchAssignedDoctors();
  }

  void fetchAssignedDoctors() {
    isLoading(true);
    childRepository.getDoctorsAssignedToChildOfCurrentParent().listen((doctors) {
      assignedDoctors.assignAll(doctors);
      isLoading(false);
    }, onError: (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue: ${e.toString()}');
      isLoading(false);
    });
  }
}
