import 'package:flutter/material.dart';

class SceneSection extends StatelessWidget {
  const SceneSection({super.key, required this.minHeight, required this.child});

  final double minHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 700;
    final effectiveMinHeight = compact ? minHeight * 0.72 : minHeight;
    final verticalPadding = compact ? 48.0 : 72.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: effectiveMinHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}
