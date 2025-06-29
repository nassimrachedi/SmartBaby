import 'package:SmartBaby/features/authentication/screens/LoginMed/login_form_med.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'login_header_med.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginScreenMed extends StatelessWidget {
  const LoginScreenMed({super.key,});

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
              const TLoginHeaderMed(),

              /// Form
              TLoginFormMed(selectedRole: UserRole.doctor,),

              /// Divider
              TFormDivider(dividerText:  AppLocalizations.of(context)!.orSignInWith.capitalize!),
              const SizedBox(height: 14),

              /// Footer
               TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
