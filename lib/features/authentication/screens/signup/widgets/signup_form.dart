import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup_controller.dart';
import 'terms_conditions_checkbox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TSignupFormParent extends StatelessWidget {
  const TSignupFormParent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          const SizedBox(height: TSizes.spaceBtwSections),
          /// First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => TValidator.validateEmptyText(AppLocalizations.of(context)!.firstName, value),
                  expands: false,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.firstName, prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => TValidator.validateEmptyText(AppLocalizations.of(context)!.lastName, value),
                  expands: false,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.lastName, prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            controller: controller.username,
            validator: TValidator.validateUsername,
            expands: false,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.username, prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: TValidator.validateEmail,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: TValidator.validatePhoneNumber,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Password
          Obx(
                () => TextFormField(
              controller: controller.password,
              validator: TValidator.validatePassword,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(Iconsax.eye_slash),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.confirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.veuillezconfirmerMdp;
              }
              if (value != controller.password.text) {
                return AppLocalizations.of(context)!.mdpInc;
              }
              return null;
            },
            obscureText: controller.hidePassword.value,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.confirmPassword,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Terms&Conditions Checkbox
          const TTermsAndConditionCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () => controller.signup(UserRole.parent), child: Text(AppLocalizations.of(context)!.createAccount)),
          ),
        ],
      ),
    );
  }
}