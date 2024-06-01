import 'package:SmartBaby/data/repositories/authentication/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/repositories/child/child_repository.dart';
import '../models/user_model.dart';

class DoctorDisplayController extends GetxController {
  var isLoading = false.obs;
  var assignedDoctors = <Doctor>[].obs;
  ChildRepository childRepository = ChildRepository();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  void onReady() {
    super.onReady();
    fetchAssignedDoctors();
  }


  Future<void> deleteDoctor(String doctorId) async {
    String parentid = AuthenticationRepository.instance.getUserID;
    DocumentSnapshot<Map<String, dynamic>> parentSnapshot = await _db
        .collection('Parents').doc(parentid).get();
    String? childId = parentSnapshot.data()?['ChildId'];
    try {
      // Fetch the document ID from the DoctorChild collection
      var querySnapshot = await FirebaseFirestore.instance
          .collection('DoctorChild')
          .where('ChildId', isEqualTo: childId)
          .where('DoctorId', isEqualTo: doctorId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await FirebaseFirestore.instance
              .collection('DoctorChild')
              .doc(doc.id)
              .delete();
        }
        assignedDoctors.removeWhere((doctor) => doctor.id == doctorId);
        Get.snackbar('Success', 'Doctor removed successfully');
      } else {
        Get.snackbar('Error', 'No such doctor assignment found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete doctor: $e');
    }
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
