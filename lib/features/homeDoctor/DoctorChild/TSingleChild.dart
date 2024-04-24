import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../personalization/models/children_model.dart';

class TSingleChild extends StatelessWidget {
  const TSingleChild({
    Key? key,
    required this.childModel,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final ModelChild childModel;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // Définir des couleurs fixes pour le mode clair
    Color backgroundColor = isSelected ? TColors.primary.withOpacity(0.5) : Colors.white;
    Color borderColor = TColors.grey;
    Color textColor = Colors.black;
    Color iconColor = isSelected ? TColors.primary : TColors.grey;

    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(TSizes.md),
        width: double.infinity,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        child: Stack(
          children: [
            Positioned(
              right: 5,
              top: 0,
              child: Icon(
                isSelected ? Iconsax.tick_circle1 : Iconsax.tick_circle1,
                color: iconColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  childModel.firstName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor, // Couleur de texte fixe pour le mode clair
                    fontSize: 16.0, // Taille de police exemple
                    fontWeight: FontWeight.bold, // Exemple de graisse de police
                  ),
                ),
                // Ajoutez plus de détails ici si nécessaire
              ],
            ),
          ],
        ),
      ),
    );
  }
}
