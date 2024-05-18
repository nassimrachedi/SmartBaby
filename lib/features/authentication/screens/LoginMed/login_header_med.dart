import 'package:flutter/material.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TLoginHeaderMed extends StatelessWidget {
  const TLoginHeaderMed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image(
            height: 140,
            image: AssetImage(dark ? TImages.Icon : TImages.Icon),
          ),
        ),
        Text(AppLocalizations.of(context)!.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: TSizes.sm),
        Text(AppLocalizations.of(context)!.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
