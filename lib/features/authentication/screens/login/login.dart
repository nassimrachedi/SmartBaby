import 'package:SmartBaby/features/authentication/controllers/login_in_controller.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///  Header
              const TLoginHeader(),

              /// Form
              const TLoginForm(selectedRole: UserRole.parent,),

              /// Divider
              TFormDivider(dividerText: AppLocalizations.of(context)!.orSignInWith.capitalize!),
              const SizedBox(height: 15),

              /// Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}