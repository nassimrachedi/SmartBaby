import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          color: Colors.blue,
          onTap: () {  },
        ),
        SizedBox(width: 10),
        ClickableBox(
          label: 'Maladies',
          icon: Icons.local_hospital,
          color: Colors.blue,
          onTap: () {  },
        ),
        SizedBox(width: 10),
        ClickableBox(
          label: 'Allergies',
          icon: Icons.warning,
          color: Colors.blue,
          onTap: () {  },
        ),
        SizedBox(width: 10),
        ClickableBox(
          label: 'Médicaments',
          icon: Icons.medical_services,
          color: Colors.blue,
          onTap: () {  },
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
