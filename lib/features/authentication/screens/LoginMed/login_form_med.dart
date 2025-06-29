import 'package:SmartBaby/features/authentication/controllers/login_in_controller.dart';
import 'package:SmartBaby/features/authentication/screens/SignUpMed/signup_med.dart';
import 'package:SmartBaby/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TLoginFormMed extends StatelessWidget {
  final UserRole selectedRole;
  const TLoginFormMed({
    Key? key,
    required this.selectedRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(LoginController());
    controller.setContext(context);
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: TValidator.validateEmail,
              decoration: InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: AppLocalizations.of(context)!.email),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            Obx(
                  () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) => TValidator.validateEmptyText(AppLocalizations.of(context)!.password, value),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: const Icon(Iconsax.eye_slash),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = value!)),
                    Text(AppLocalizations.of(context)!.rememberMe),
                  ],
                ),

                /// Forget Password
                TextButton(onPressed: () => Get.to(() => const ForgetPasswordScreen()), child: Text(AppLocalizations.of(context)!.forgetPassword)),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(selectedRole: 'doctor'), child: Text(AppLocalizations.of(context)!.signIn)),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: () => Get.to(() =>  SignupMedScreen(role: UserRole.doctor)), child: Text(AppLocalizations.of(context)!.createAccount)),
            ),
          ],
        ),
      ),
    );
  }
}
