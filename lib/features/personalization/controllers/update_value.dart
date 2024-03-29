import 'package:get/get.dart';
import '../../../data/repositories/child/child_repository.dart';
import 'Doctor-controleur.dart';

class UpdateVitalSignsController extends GetxController {
  final ChildRepository repository;
  var isLoading = false.obs;

  var minBpm = Rx<double>(60.0);
  var maxBpm = Rx<double>(100.0);
  var minTemp = Rx<double>(36.5);
  var maxTemp = Rx<double>(37.5);
  var spo2 = Rx<double>(95.0);

  UpdateVitalSignsController({required this.repository});
  @override
  void onReady() {
    super.onReady();
    fetchCurrentChildVitalSigns();
  }

  void fetchCurrentChildVitalSigns() async {
    var childVitalSigns = await repository.getChildAssignedToDoctor(); // Your method to fetch data
    if (childVitalSigns != null) {
      minBpm.value = childVitalSigns.minBpm;
      maxBpm.value = childVitalSigns.maxBpm;
      minTemp.value = childVitalSigns.minTemp;
      maxTemp.value = childVitalSigns.maxTemp;
      spo2.value = childVitalSigns.spo2;
    }
  }
  Future<void> updateVitalSigns() async {
    if (!validateVitalValues()) return;
    isLoading(true);
    try {
      await repository.updateChildVitalValuesForDoctor(
        minBpm: minBpm.value,
        maxBpm: maxBpm.value,
        minTemp: minTemp.value,
        maxTemp: maxTemp.value,
        spo2: spo2.value,
      );
      Get.back();
      Get.find<DoctorController>().refreshChildData();
      Get.snackbar('Success', 'Vital signs updated successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to update vital signs: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  bool validateVitalValues() {
    if (minBpm.value < 0 || maxBpm.value > 200 || minBpm.value >= maxBpm.value) {
      Get.snackbar('Error', 'Invalid BPM values');
      return false;
    }
    if (minTemp.value < 0 || maxTemp.value > 200 || minTemp.value >= maxTemp.value) {
      Get.snackbar('Error', 'Invalid Temperature values');
      return false;
    }
    if (spo2.value < 75 || spo2.value > 100) {
      Get.snackbar('Error', 'Invalid SpO2 value');
      return false;
    }
    return true;
  }

}
