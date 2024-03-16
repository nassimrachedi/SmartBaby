

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class SearchEnfant extends StatelessWidget {
  const SearchEnfant({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Container(
        width: TDeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: TColors.white,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: Border.all(color: TColors.grey),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: TColors.darkerGrey),
            const SizedBox(width: TSizes.spaceBtwSections),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search your child', // Hint text displayed when there's no input
                  border: InputBorder.none, // Removes default border for a cleaner look (optional)
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

