
import 'package:SmartBaby/features/home/Screen/widget/notification.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';

class appBar extends StatelessWidget {
  const appBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(TTexts.homeAppbarSubTitle, style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),),
        ],
      ),
      actions: [
        NotificationIconWidget(iconColor: null, onPressed: () {  },)
      ],
    );
  }
}
