import 'package:SmartBaby/features/authentication/screens/SignUpMed/widgets/sign_up_form.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class SignupMedScreen extends StatelessWidget {
  final UserRole role;
  const SignupMedScreen({Key? key, required this.role}) : super(key: key);
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
              /// Title
              Text(TTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              const TSignupFormMed() ,
              const SizedBox(height: TSizes.spaceBtwSections),


            /// Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
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
