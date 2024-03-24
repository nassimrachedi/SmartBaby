import 'package:SmartBaby/utils/constants/image_strings.dart';
import 'package:SmartBaby/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../personalization/models/user_model.dart';
import '../screens/signup/verify_email.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  Future<void> signup(UserRole selectedRole) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information...', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.');
        return;
      }

      await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      final isDoctor = (selectedRole == UserRole.doctor);

      final role = determineUserRole(isDoctor);
      final newUser = UserModel(
        id: AuthenticationRepository.instance.getUserID,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
        role: role,
      );
      await UserRepository.instance.saveUserRecord(newUser);
      if (role == UserRole.parent) {
        final newParent = UserModel(
          id: AuthenticationRepository.instance.getUserID,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          username: username.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '',
          role: UserRole.parent,
        );
        await UserRepository.instance.saveParentRecord(newParent);
      } else if (role == UserRole.doctor) {
        final newDoctor = UserModel(
          id: AuthenticationRepository.instance.getUserID,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          username: username.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '',
          role: UserRole.doctor,
        );
        await UserRepository.instance.saveDoctorRecord(newDoctor);
      }

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');
      Get.to(() => const VerifyEmailScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  UserRole determineUserRole(bool isDoctor) {
    return isDoctor ? UserRole.doctor : UserRole.parent;
  }
}