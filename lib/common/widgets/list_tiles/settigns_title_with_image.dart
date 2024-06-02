import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class TSettingsMenuTileImage extends StatelessWidget {
  const TSettingsMenuTileImage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
  });

  final String image;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:Container(
        margin: const EdgeInsets.only(left: 0), // Ajuster la marge pour positionner l'image plus à gauche
        child: Image.asset(image, height: 40, width: 40),
      ), // Utilisation de leading pour afficher l'image
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
