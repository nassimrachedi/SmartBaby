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
    Color backgroundColor = isSelected ? TColors.primary.withOpacity(0.1) : Colors.white;
    Color borderColor = isSelected ? TColors.primary : TColors.grey;
    Color textColor = Colors.black;
    Color iconColor = isSelected ? TColors.primary : TColors.grey;

    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        backgroundColor: Colors.blue.shade50,
        borderColor: borderColor,
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(childModel.childPicture),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${childModel.firstName} ${childModel.lastName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Date de naissance: ${childModel.birthDate.toLocal().toIso8601String().split('T').first}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.6),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Iconsax.tick_circle : Iconsax.tick_circle1,
              color: Colors.blue,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
