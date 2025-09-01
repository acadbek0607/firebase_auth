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
        final width = constraints.maxWidth > maxContentWidth
            ? maxContentWidth
            : constraints.maxWidth;
        return Align(
          alignment: alignment,
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
