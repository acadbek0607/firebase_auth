import 'package:flutter/widgets.dart';

class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxContentWidth;
  final Alignment alignment;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxContentWidth = 600,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        double width = screenWidth;

        // Shrink content by 30% for medium sized layouts
        if (screenWidth > 700 && screenWidth < 1080) {
          width = screenWidth * 0.5;
        }

        if (width > maxContentWidth) {
          width = maxContentWidth;
        }

        return Align(
          alignment: alignment,
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
