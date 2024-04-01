import 'package:SmartBaby/common/widgets/appbar/appbar.dart';
import 'package:SmartBaby/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:SmartBaby/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:SmartBaby/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:SmartBaby/common/widgets/texts/section_heading.dart';
import 'package:SmartBaby/features/homeDoctor/profilWidget/Child/childDoc.dart';
import 'package:SmartBaby/features/personalization/controllers/user_controller.dart';
import 'package:SmartBaby/features/personalization/screens/address/address.dart';
import 'package:SmartBaby/features/personalization/screens/profile/profile.dart';
import 'package:SmartBaby/home_menu_med.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:SmartBaby/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../data/repositories/child/child_repository.dart';
import '../personalization/controllers/Doctor-controleur.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsMed extends StatelessWidget {
    SettingsMed({super.key});

  final controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // Intercept the back button press and redirect to Home Screen
      onPopInvoked: (value) async => Get.offAll(const HomeMedMenu()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// -- Header
              TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    /// AppBar
                    TAppBar(title: Text(AppLocalizations.of(context)!.account, style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white)),
                    ),

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
                      title : AppLocalizations.of(context)!.address,
                      subTitle: AppLocalizations.of(context)!.myHome,
                      onTap: () => Get.to(() => const UserAddressScreen()),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Icons.baby_changing_station,
                      title: AppLocalizations.of(context)!.myChildren,
                      subTitle: AppLocalizations.of(context)!.clickToViewChildrenList,
                      onTap: () {
                        Get.lazyPut(() => ChildRepository());
                        Get.put(DoctorController());
                        // Naviguer vers DoctorChildScreen
                        Get.to(() => DoctorChildScreen());
                      },

                    ),
                    TSettingsMenuTile(
                        icon: Iconsax.notification, title: AppLocalizations.of(context)!.notifications, subTitle: AppLocalizations.of(context)!.setAnyNotificationMessage, onTap: () {}),
                    TSettingsMenuTile(
                        icon: Iconsax.security_card, title: AppLocalizations.of(context)!.accountPrivacy, subTitle: AppLocalizations.of(context)!.manageDataUsageAndConnectedAccounts,),

                    /// -- App Settings
                     SizedBox(height: TSizes.spaceBtwSections),
                     TSectionHeading(title: AppLocalizations.of(context)!.appSettings, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.document_upload,
                      title: AppLocalizations.of(context)!.loadData,
                      subTitle:  AppLocalizations.of(context)!.uploadDataToCloudFirebase,
                      onTap: () => Get.to(() {}),
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
                      subTitle: AppLocalizations.of(context)!.setImageQualityToBeSeen,
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),

                    /// -- Logout Button
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                        width: double.infinity, child: OutlinedButton(onPressed: () => controller.logout(), child:  Text(AppLocalizations.of(context)!.logout)),),
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
