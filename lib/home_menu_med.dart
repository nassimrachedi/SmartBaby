import 'package:SmartBaby/features/homeDoctor/setings_med.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:SmartBaby/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'features/homeDoctor/Doctor_intents.dart';
import 'features/homeDoctor/history_Med/history_med.dart';
import 'features/homeDoctor/homeMed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeMedMenu extends StatelessWidget {
  const HomeMedMenu({super.key});

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
            NavigationDestination(icon: Icon(Icons.history), label: AppLocalizations.of(context)!.history),
            NavigationDestination(icon: Icon(Iconsax.message), label: AppLocalizations.of(context)!.doctorai),
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

  final screens = [HomeScreenMed(), HistoryMed(), ChatbotScreen(), SettingsMed()];

}