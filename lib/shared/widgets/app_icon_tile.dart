import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_project.dart';

/// Rounded tile showing a project's real app icon.
///
/// Falls back to the CatLab gradient badge with the project's glyph when no
/// icon asset exists yet, so a missing icon still looks intentional.
/// AI-hint: Keep the fallback — several projects legitimately have no icon.
class AppIconTile extends StatelessWidget {
  const AppIconTile({
    super.key,
    required this.project,
    this.size = 56,
    this.hovered = false,
  });

  final AppProject project;
  final double size;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.26;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: AppColors.primary.withAlpha(hovered ? 150 : 55),
        ),
        boxShadow: hovered
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(90),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : const [],
        gradient: project.hasIconAsset
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withAlpha(hovered ? 110 : 70),
                  AppColors.primaryVariant.withAlpha(hovered ? 140 : 90),
                ],
              ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: project.hasIconAsset
            ? Image.asset(
                project.iconAsset!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              )
            : Icon(project.icon, color: AppColors.accent, size: size * 0.44),
      ),
    );
  }
}
