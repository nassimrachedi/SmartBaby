import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:SmartBaby/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'features/home/Screen/Child/child.dart';
import 'features/home/Screen/home.dart';
import 'features/personalization/screens/setting/settings.dart';

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
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.child_care), label: 'child'),
            NavigationDestination(icon: Icon(Icons.message_outlined), label: 'chat'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
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

  final screens = [HomeScreen(), Container(), Container(), SettingsScreen()];
}
