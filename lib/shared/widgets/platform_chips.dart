import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_platform.dart';

/// Row of small platform glyphs (iOS / Android / Web / Desktop).
///
/// Renders nothing when the list is empty — an unreleased project should not
/// advertise platforms it does not ship on.
class PlatformChips extends StatelessWidget {
  const PlatformChips({
    super.key,
    required this.platforms,
    this.showLabels = false,
  });

  final List<AppPlatform> platforms;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    if (platforms.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: showLabels ? 8 : 10,
      runSpacing: 6,
      children: [
        for (final platform in platforms)
          if (showLabels)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    platform.icon,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    platform.label,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            Tooltip(
              message: platform.label,
              child: Icon(
                platform.icon,
                size: 15,
                color: AppColors.textMuted,
              ),
            ),
      ],
    );
  }
}
