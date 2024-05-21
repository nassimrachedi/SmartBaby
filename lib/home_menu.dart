import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:SmartBaby/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'features/home/Screen/historique/historique.dart';
import 'features/home/Screen/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/personalization/screens/setting/settings.dart';
import 'features/personalization/screens/DoctorAi/ChoseOption.dart';
class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppScreenController());
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          animationDuration: const Duration(seconds: 3),
          selectedIndex: controller.selectedMenu.value,
          backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
          elevation: 0,
          indicatorColor: THelperFunctions.isDarkMode(context) ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
          onDestinationSelected: (index) => controller.selectedMenu.value = index,
          destinations:  [
            NavigationDestination(icon: Icon(Iconsax.home), label: AppLocalizations.of(context)!.home),
            NavigationDestination(icon: Icon(Icons.history), label: 'Historique'),
            NavigationDestination(icon: Icon(Iconsax.message), label: 'Chatbot'),
            NavigationDestination(icon: Icon(Iconsax.user), label: AppLocalizations.of(context)!.profile),

          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedMenu.value]),
    );
  }
}
class AppScreenController extends GetxController {
  static AppScreenController get instance => Get.find();

  final Rx<int> selectedMenu = 0.obs;

  final screens = [HomeScreen(), EtatSantePage(), ChooseOption(), SettingsScreen()];
}