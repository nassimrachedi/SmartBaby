
import 'package:SmartBaby/data/repositories/child/child_repository.dart';
import 'package:SmartBaby/features/personalization/models/children_model.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class childController  extends GetxController {
  static childController get instance => Get.find();

  final lastname = TextEditingController();
  final FirstNamech = TextEditingController();
  final LastNamech = TextEditingController();
  final DateNais = TextEditingController();
  final Genre = TextEditingController();

  final ChildRepo = Get.put(ChildRepository());


  Future<void> registerChild(ModelChild child) async {
    await ChildRepo.saveChild(child as UserModel);
  }
}
