import 'package:SmartBaby/common/widgets/appbar/appbar.dart';
import 'package:SmartBaby/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:SmartBaby/features/home/Screen/widget/AppBarWidget.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:SmartBaby/utils/constants/text_strings.dart';
import 'package:SmartBaby/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    /// tamenzut puis chque yiwet s widget is wehdes at tafedh di widget AppBarWidget
                    appBar(),
                    SearchEnfant()
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}

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
            Text('Search your child', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}





