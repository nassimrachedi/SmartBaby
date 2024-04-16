import 'package:SmartBaby/app.dart';
import 'package:SmartBaby/features/home/Screen/widget/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/screens/Notification/Notification.dart';

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
        NotificationIconWidget(
          iconColor: Colors.white, // ou une autre couleur de votre choix
          onPressed: () {
            Get.to(() => NotificationsSettingsPage());
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout), // The logout icon
          onPressed: () => controller.logout(), // Call the logout method from the controller
          tooltip: 'Logout', // Optional: tooltip text that appears when the user long-presses the button
        ),
        IconButton(onPressed: () {
    // Afficher une boîte de dialogue pour sélectionner la langue
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
    title: Text('Changer Langue'),
    content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    LanguageOption('English', Locale('en')),
    LanguageOption('Français', Locale('fr')),
    LanguageOption('العربية', Locale('ar')),
    ],
    ),
    ),
    );
    },
            icon: Icon(Icons.language))
      ],
    );
  }
}
