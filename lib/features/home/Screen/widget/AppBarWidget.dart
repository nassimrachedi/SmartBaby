import 'package:SmartBaby/features/home/Screen/widget/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../personalization/controllers/user_controller.dart';

class appBar extends StatelessWidget {
   appBar({
    super.key,
  });
  final UserController controller = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    controller.setContext(context);
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(TTexts.homeAppbarSubTitle, style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),),
        ],
      ),
      actions: [
        NotificationIconWidget(iconColor: null, onPressed: () {  },),
        IconButton(
          icon: const Icon(Icons.logout), // The logout icon
          onPressed: () => controller.logout(), // Call the logout method from the controller
          tooltip: 'Logout', // Optional: tooltip text that appears when the user long-presses the button
        ),
      ],
    );
  }
}
