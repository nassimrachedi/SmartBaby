import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';

class NotificationIconWidget extends StatelessWidget {
  const NotificationIconWidget({
    super.key,
    required this.iconColor, required this.onPressed
  });
  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_active_rounded, color: TColors.white)),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        )
      ],
    );
  }
}

