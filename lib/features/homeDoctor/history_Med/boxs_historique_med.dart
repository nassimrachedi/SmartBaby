import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Allergies/allergiesMed.dart';
import 'Maladies/maladiesMed.dart';
import 'build_check_box_med.dart';



class listBoxHistoriqueMed extends StatelessWidget {
  const listBoxHistoriqueMed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(width: 10),
        ClickableBoxMed(
          label: 'Historique',
          icon: Icons.history,
          color: TColors.accent1,
          onTap: () {},
        ),
        SizedBox(width: 10),
        ClickableBoxMed(
          label: 'Maladies',
          icon: Icons.local_hospital,
          color: TColors.accent1,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListMaladiesMedWidget()),
            );
          },
        ),
        SizedBox(width: 10),
        ClickableBoxMed(
          label: 'Allergies',
          icon: Icons.warning,
          color: TColors.accent1,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListAllergiesWidget()),
            );
          },
        ),
      ],
    );
  }
}