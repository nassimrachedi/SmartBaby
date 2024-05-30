import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/repositories/ParentRepository/ParentRepository.dart';
import '../../../../data/repositories/child/child_repository.dart';
import '../../../../home_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../home/parentchild.dart';
import '../../controllers/children_controller.dart';
import '../../controllers/parentcontroleur.dart';
import '../../controllers/user_controller.dart';
import '../Children/child.dart';
import '../MedecinDesg/DoctorDes.dart';
import '../MedecinDesg/addDoctor.dart';
import '../Notification/Notification.dart';
import '../UpdateSmartwatch/UpdateSmartwatch.dart';
import '../address/address.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final controller =Get.put(UserController());


  @override
  Widget build(BuildContext context) {
    controller.setContext(context);
    return PopScope(
      canPop: false,
      // Intercept the back button press and redirect to Home Screen
      onPopInvoked: (value) async => Get.offAll(const HomeMenu()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// -- Header
              TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    /// AppBar
                    TAppBar(title: Text(AppLocalizations.of(context)!.account, style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white))),

                    /// User Profile Card
                    TUserProfileTile(onPressed: () => Get.to(() => ProfileScreen())),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),

              /// -- Profile Body
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// -- Account  Settings
                    TSectionHeading(title: AppLocalizations.of(context)!.accountSettings, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                        icon: Icons.home,
                        title: AppLocalizations.of(context)!.address,
                        subTitle: AppLocalizations.of(context)!.myHome,
                        onTap: () {
                          Get.lazyPut(()=>ParentRepository());
                          Get.put(ParentController());
                          Get.to(() => ParentChildrenScreen());}
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                        icon: Icons.baby_changing_station,
                        title:  AppLocalizations.of(context)!.myChildren,
                        subTitle:  AppLocalizations.of(context)!.clickToViewChildrenList,
                        onTap: () {
                          Get.lazyPut(() => ChildRepository());
                          Get.put(ChildController());
                          Get.to(() => UserChildrenScreen());}
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Icons.health_and_safety ,
                      title: AppLocalizations.of(context)!.doctor,
                      subTitle: 'List of all doctor',
                      onTap: () => Get.to(() => DoctorDisplayWidget()),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.notification,
                      title: AppLocalizations.of(context)!.notifications,
                      subTitle: 'Set any kind of notification message',
                      onTap: () => Get.to(() => NotificationsSettingsPage()),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.clock, title: "Configurer Smartwatch", subTitle: 'Ajouter l\'identifiant de la smartwatch',
                      onTap: () => Get.to(()=>SmartwatchUpdateFormPage()),
                    ),

                    /// -- App Settings
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TSectionHeading(title: AppLocalizations.of(context)!.appSettings, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.document_upload,
                      title: AppLocalizations.of(context)!.loadData,
                      subTitle: AppLocalizations.of(context)!.uploadDataToCloudFirebase,

                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.location,
                      title: AppLocalizations.of(context)!.geolocation,
                      subTitle: AppLocalizations.of(context)!.setRecommendationBasedOnLocation,
                      trailing: Switch(value: true, onChanged: (value) {}),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.security_user,
                      title: AppLocalizations.of(context)!.safeMode,
                      subTitle: AppLocalizations.of(context)!.searchResultIsSafeForAllAges,
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.image,
                      title: AppLocalizations.of(context)!.hdImageQuality,
                      subTitle: AppLocalizations.of(context)!.hdImageQuality,
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),

                    /// -- Logout Button
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                        width: double.infinity, child: OutlinedButton(onPressed: () => controller.logout(), child:Text( AppLocalizations.of(context)!.logout))),
                    const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}