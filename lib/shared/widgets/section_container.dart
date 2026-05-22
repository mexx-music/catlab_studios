import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';

/// A generic full-width section wrapper used on the landing page.
/// AI-hint: Add background gradient or image overrides via optional params.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.maxWidth = 1200,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  /// Constrains content width for large screens.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: child,
          ),
        ),
      ),
    );
  }
}
