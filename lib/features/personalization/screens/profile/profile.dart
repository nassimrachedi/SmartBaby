import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';
import 'change_name.dart';
import 'widgets/profile_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text( AppLocalizations.of(context)!.profile, style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(
                      () {
                        final networkImage = controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty ? networkImage : TImages.user;
                        return controller.imageUploading.value
                            ? const TShimmerEffect(width: 80, height: 80, radius: 80)
                            : TCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty);
                      },
                    ),
                    TextButton(
                      onPressed: controller.imageUploading.value ? () {} : () => controller.uploadUserProfilePicture(),
                      child: Text(AppLocalizations.of(context)!.changeprofilepicture),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              TSectionHeading(title: AppLocalizations.of(context)!.profileinformation, showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeName()), title: AppLocalizations.of(context)!.name, value: controller.user.value.fullName),
              TProfileMenu(onPressed: () {}, title:  AppLocalizations.of(context)!.username, value: controller.user.value.username),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              TSectionHeading(title: AppLocalizations.of(context)!.personnelinformation, showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () {}, title: AppLocalizations.of(context)!.userid, value: '45689', icon: Iconsax.copy),
              TProfileMenu(onPressed: () {}, title:  AppLocalizations.of(context)!.email, value: controller.user.value.email),
              TProfileMenu(onPressed: () {}, title:  AppLocalizations.of(context)!.phoneNo, value: controller.user.value.phoneNumber),
              TProfileMenu(onPressed: () {}, title:  AppLocalizations.of(context)!.genre, value: 'Male'),
              TProfileMenu(onPressed: () {}, title:  AppLocalizations.of(context)!.birthDateLabel, value: '1 Jan, 1900'),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                    onPressed: () => controller.deleteAccountWarningPopup(),
                    child: Text(AppLocalizations.of(context)!.closeacoount, style: TextStyle(color: Colors.red))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
