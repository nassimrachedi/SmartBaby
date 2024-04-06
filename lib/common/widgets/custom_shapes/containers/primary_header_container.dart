import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

/// A container widget with a primary color background and curved edges.
class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: SizedBox(
        height: 200,
        child: Container(
          color: TColors.accent,

          /// -- If [size.isFinite': is not true.in Stack] error occurred -> Read README.md file at [DESIGN ERRORS] # 1
          child: Stack(
            children: [
              /// -- Background Custom Shapes
              Positioned(
                  top: -150, right: -250, child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
              Positioned(
                  top: 100, right: -300, child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
              child,
            ],
          ),
        ),
      ),
    );
  }
}