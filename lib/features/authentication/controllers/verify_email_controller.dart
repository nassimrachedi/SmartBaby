import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/success_screen/success_screen.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/popups/loaders.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();
  late BuildContext _context;

  @override
  void onInit() {
    /// Send Email Whenever Verify Screen appears & Set Timer for auto redirect.
    sendEmailVerification();
    setTimerForAutoRedirect();

    super.onInit();
  }

  /// Send Email Verification link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(title:AppLocalizations.of(_context)!.email_sent, message:AppLocalizations.of(_context)!.pleaseCheckInboxVerifyEmail);
    } catch (e) {
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(
      const Duration(seconds: 1),
          (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified ?? false) {
          timer.cancel();
          Get.off(
                () => SuccessScreen(
              image: TImages.successfullyRegisterAnimation,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () => AuthenticationRepository.instance.screenRedirect(FirebaseAuth.instance.currentUser),
            ),
          );
        }
      },
    );
  }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
            () => SuccessScreen(
          image: TImages.successfullyRegisterAnimation,
          title: TTexts.yourAccountCreatedTitle,
          subTitle: TTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(FirebaseAuth.instance.currentUser),
        ),
      );
    }
  }
}