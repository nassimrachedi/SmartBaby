import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../login/login.dart';
import 'widgets/signup_form.dart';

class SignupParentScreen extends StatelessWidget {

  const SignupParentScreen({super.key, required UserRole role,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///  Title
              Text(AppLocalizations.of(context)!.letscreateaccount, style: Theme.of(context).textTheme.headlineMedium),

              /// Form
              const TSignupFormParent(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Divider
              TFormDivider(dividerText: AppLocalizations.of(context)!.orSignInWith),
              const SizedBox(height: TSizes.spaceBtwSections),


              /// Social Buttons
              const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
