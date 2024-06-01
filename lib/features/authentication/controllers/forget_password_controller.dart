import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../screens/password_configuration/reset_password.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();
  late BuildContext _context;

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password EMail
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(AppLocalizations.of(_context)!.processing, TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {TFullScreenLoader.stopLoading(); return;}

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send EMail to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      TLoaders.successSnackBar(title: AppLocalizations.of(_context)!.email_sent, message: AppLocalizations.of(_context)!.emailLinkSenResetPassword.tr);
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(AppLocalizations.of(_context)!.processing, TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {TFullScreenLoader.stopLoading(); return;}

      // Send EMail to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.trim());

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      TLoaders.successSnackBar(title: AppLocalizations.of(_context)!.email_sent, message: AppLocalizations.of(_context)!.emailLinkSenResetPassword.tr);

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }
}