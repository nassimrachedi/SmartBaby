import 'dart:io';
import 'package:SmartBaby/features/authentication/screens/ChooseRole/choose_role.dart';
import 'package:SmartBaby/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/widgets/loaders/circular_loader.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/screens/login/login.dart';
import '../models/user_model.dart';
import '../screens/profile/re_authenticate_user_login_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Controller to manage user-related functionality.
class UserController extends GetxController {
  static UserController get instance => Get.find();
  late BuildContext _context;
  Rx<UserModel> user = UserModel.empty().obs;
  final imageUploading = false.obs;
  final profileLoading = false.obs;
  final profileImageUrl = ''.obs;
  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  /// init user data when Home Screen appears
  @override
  void onInit() {
    fetchUserRecord();
    super.onInit();
  }

  /// Fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord({UserModel? user, UserCredential? userCredentials}) async {
    try {
      // First UPDATE Rx User and then check if user data is already stored. If not store new data
      await fetchUserRecord();

      // If no record already stored.
      if (this.user.value.id.isEmpty) {
        if (userCredentials != null) {
          // Convert Name to First and Last Name
          final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final customUsername = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

          // Map data
          final newUser = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts.isNotEmpty ? nameParts[0] : '',
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: customUsername,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
            role: UserRole.parent,
          );

          // Save user data
          await userRepository.saveUserRecord(newUser);

          // Assign new user to the RxUser so that we can use it throughout the app.
          this.user(newUser);
        } else if (user != null) {
          // Save Model when user registers using Email and Password
          await userRepository.saveUserRecord(user);

          // Assign new user to the RxUser so that we can use it throughout the app.
          this.user(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: AppLocalizations.of(_context)!.dataNotSavedMessage,
        message: AppLocalizations.of(_context)!.somethingWentWrong,
      );
    }
  }

  /// Upload Profile Picture
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        final uploadedImage = await userRepository.uploadImage('Users/Images/Profile/', image);
        profileImageUrl.value = uploadedImage;
        Map<String, dynamic> newImage = {'ProfilePicture': uploadedImage};
        await userRepository.updateSingleField(newImage);
        user.value.profilePicture = uploadedImage;
        user.refresh();
        imageUploading.value = false;
        TLoaders.successSnackBar(title: AppLocalizations.of(_context)!.congratulations, message: 'Your Profile Image has been updated!');
      }
    } catch (e) {
      imageUploading.value = false;
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.oh_snap , message: 'Something went wrong: $e');
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: AppLocalizations.of(_context)!.deleteAccount,
      middleText:
      AppLocalizations.of(_context)!.deleteAccountConfirmationMessage,
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: TSizes.lg), child: Text(AppLocalizations.of(_context)!.delete)),
      ),
      cancel: OutlinedButton(
        child:  Text(AppLocalizations.of(_context)!.cancel),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ),
    );
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog(AppLocalizations.of(_context)!.processing_request, TImages.docerAnimation);

      /// First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.firebaseUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Re Verify Auth Email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'facebook.com') {
          await auth.signInWithFacebook();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }

  /// -- RE-AUTHENTICATE before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog(AppLocalizations.of(_context)!.processing_info, TImages.docerAnimation);

      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title:AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }

  /// Logout Loader Function
  logout() {
    try {
      Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: AppLocalizations.of(_context)!.logout,
        middleText: AppLocalizations.of(_context)!.logoutConfirmationText,
        confirm: ElevatedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
            child: Text(AppLocalizations.of(_context)!.confirm),
          ),
          onPressed: () async {
            onClose();
            /// On Confirmation show any loader until user Logged Out.
            Get.defaultDialog(
              title: '',
              barrierDismissible: false,
              backgroundColor: Colors.transparent,
              content: const TCircularLoader(),
            );
            await AuthenticationRepository.instance.logout();
            Get.offAllNamed(TRoutes.chooseRole);
          },
        ),
        cancel: OutlinedButton(
          child: Text(AppLocalizations.of(_context)!.cancel),
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        ),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }

  UserRole determineUserRole(bool isDoctor) {
    return isDoctor ? UserRole.doctor : UserRole.parent;
  }
  void setContext(BuildContext context) {
    _context = context;
  }

}