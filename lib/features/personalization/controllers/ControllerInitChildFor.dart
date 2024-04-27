import 'package:get/get.dart';

import '../../../data/repositories/DoctorRepos/DoctorRepository.dart';
import 'Doctor-controleur.dart';

class DoctorControllers extends GetxController {
  final DoctorRepository doctorRepository = DoctorRepository();
  RxString currentChildId = ''.obs; // Observable pour le ChildId actuel

  @override
  void onInit() {
    super.onInit();
    getCurrentChildId();// Appeler cette fonction pour initialiser currentChildId
  }

  void getCurrentChildId() async {
    var childId = await doctorRepository.getChildAssignedToDoctor();
    if (childId != null) {
      currentChildId.value = childId;

    }
  }
}