import 'package:SmartBaby/data/repositories/user/user_repository.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../personalization/controllers/user_controller.dart';
import '../screens/ChooseRole/choose_role.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  late BuildContext _context;

  /// Variables
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final userController = Get.put(UserController());
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// -- Email and Password SignIn
  Future<void> emailAndPasswordSignIn({required String selectedRole}) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog( AppLocalizations.of(_context)!.loggingYouIn, TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write(AppLocalizations.of(_context)!.rememberMeEmail, email.text.trim());
        localStorage.write(AppLocalizations.of(_context)!.rememberMePassword, password.text.trim());
      }
      print('Selected Role: $selectedRole');

      // Login user using EMail & Password Authentication
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Fetch the user role based on email
      final userRole = await getUserRoleByEmail(email.text.trim());

      print('User Role: $userRole'); // Ajout du print pour vérifier le rôle récupéré
      if (userRole == null) {
        // Si aucun rôle n'est trouvé pour cet e-mail, affichez un message d'erreur et redirigez vers la page "Choose Your Role"
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.error, message: AppLocalizations.of(_context)!.noRoleFound);
        Get.offAll(() => ChooseYourRole());
        return;
      }

      // Vérifiez si le rôle sélectionné correspond au rôle de l'utilisateur
      if (userRole != selectedRole) {
        // Si les rôles ne correspondent pas, affichez un message d'erreur et redirigez vers la page "Choose Your Role"
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.error, message: AppLocalizations.of(_context)!.selectedRoleDoesNotMatch);
        Get.offAll(() => ChooseYourRole());
        return;
      }

      // Assign user data to RxUser of UserController to use in app
      await userController.fetchUserRecord();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      await AuthenticationRepository.instance.screenRedirect(userCredentials.user);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }

  /// Google SignIn Authentication
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(AppLocalizations.of(_context)!.loggingYouIn, TImages.docerAnimation);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Google Authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      // Save Authenticated user data in the Firebase Firestore
      await userController.saveUserRecord(userCredentials: userCredentials);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      await AuthenticationRepository.instance.screenRedirect(userCredentials?.user);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.error, message: e.toString());
    }
  }

  /// Facebook SignIn Authentication
  Future<void> facebookSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(AppLocalizations.of(_context)!.loggingYouIn, TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Facebook Authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithFacebook();

      // Save Authenticated user data in the Firebase Firestore
      await userController.saveUserRecord(userCredentials: userCredentials);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      await AuthenticationRepository.instance.screenRedirect(userCredentials.user);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: AppLocalizations.of(_context)!.oh_snap, message: e.toString());
    }
  }

  Future<String?> getUserRoleByEmail(String email) async {
    try {
      print('${AppLocalizations.of(_context)!.failedToGetUserRoleByEmail}: $email');

      // Récupérer l'utilisateur s'il existe dans la collection des parents
      UserModel parent = await UserRepository.instance.fetchParentDetails();
      if (parent.email == email) {
        print('User Role retrieved: ${UserRole.parent}');
        return UserRole.parent.toString().split('.').last;
      }

      // Récupérer l'utilisateur s'il existe dans la collection des docteurs
      UserModel doctor = await UserRepository.instance.fetchDoctorDetails();
      if (doctor.email == email) {
        print('User Role retrieved: ${UserRole.doctor}');
        return UserRole.doctor.toString().split('.').last;
      }

      // Si aucun utilisateur n'est trouvé avec cet email
      print('No user found for email: $email');
      return null;
    } catch (e) {
      print('Error fetching user role: $e');
      throw "Failed to get user role by email: $e";
    }
  }

  void setContext(BuildContext context) {
    _context = context;
  }

}