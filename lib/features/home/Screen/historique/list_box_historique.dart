import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../homeDoctor/history_Med/Maps/maps.dart';
import '../Maps/pages/map_page.dart';
import 'Allergie/allergies.dart';
import 'Maladie/maladies.dart';
import 'build_check_box.dart';
import 'package:SmartBaby/utils/constants/colors.dart';

class ListBoxHistorique extends StatelessWidget {
  const ListBoxHistorique({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(width: 10),
        ClickableBox(
          label: 'maps',
          icon: Icons.map,
          color: TColors.accent1,
          onTap: () {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPages()),
          );},
        ),
        SizedBox(width: 10),
        ClickableBox(
          label: AppLocalizations.of(context)!.diseases,
          icon: Icons.local_hospital,
          color: TColors.accent1,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Maladies()),
            );
          },
        ),
        SizedBox(width: 10),
        ClickableBox(
          label: AppLocalizations.of(context)!.allergies,
          icon: Icons.warning,
          color: TColors.accent1,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Allergies()),
            );
          },
        ),
      ],
    );
  }
}
