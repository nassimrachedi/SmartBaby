import 'package:SmartBaby/features/home/Screen/historique/Maladie/maladies.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Allergie/allergies.dart';
import 'build_check_box.dart';

class listBoxHistorique extends StatelessWidget {
  const listBoxHistorique({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(width: 10),
        ClickableBox(
          label: 'Historique',
          icon: Icons.history,
          color: TColors.accent1,
          onTap: () {},
        ),
        SizedBox(width: 10),
        ClickableBox(
          label: 'Maladies',
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
          label: 'Allergies',
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