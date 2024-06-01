import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/forget_password_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))]),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(AppLocalizations.of(context)!.forgetPassword, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(AppLocalizations.of(context)!.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections * 2),

            /// Text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email, prefixIcon: Icon(Iconsax.direct_right)),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: Text( AppLocalizations.of(context)!.submit)),
            ),
          ],
        ),
      ),
    );
  }
}
