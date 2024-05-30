import 'package:get/get.dart';

import '../../../data/repositories/ParentRepository/ParentRepository.dart';

class ParentController extends GetxController {
  final ParentRepository parentRepository = ParentRepository();
  RxString currentChildId = ''.obs; // Observable pour le ChildId actuel

  @override
  void onInit() {
    super.onInit();
    getCurrentChildId();
  }

  void getCurrentChildId() async {
    var childId = await parentRepository.getChildAssignedToParent();
    if (childId != null) {
      currentChildId.value = childId;
    }
  }

  Future<void> selectChild(String childId) async {
    currentChildId.value = childId;
    await parentRepository.selectChild(childId);
  }
}
