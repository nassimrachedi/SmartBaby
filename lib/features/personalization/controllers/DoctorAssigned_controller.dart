import 'package:SmartBaby/data/repositories/child/child_repository.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';


class DoctorDisplayController extends GetxController {
  var isLoading = false.obs;
  var assignedDoctor = Rxn<Doctor>();
  ChildRepository childRepository = ChildRepository();

  @override
  void onReady() {
    super.onReady();
    fetchAssignedDoctor();
  }

  void fetchAssignedDoctor() async {
    isLoading(true);
    try {
      assignedDoctor.value =
      await childRepository.getDoctorAssignedToChildOfCurrentParent();
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}