import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/utils/link_launcher.dart';
import 'package:catlab_studios/data/models/app_link.dart';

/// Compact outbound-link button used on cards and in the detail sheet.
/// AI-hint: Only ever built from a verified AppLink — never from a raw string.
class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.link,
    this.filled = false,
    this.useLongLabel = false,
  });

  final AppLink link;

  /// Gold-filled treatment for the single most important link.
  final bool filled;

  /// Official platform wording ("Download on the App Store"). Used in the
  /// detail sheet; cards stay on the short form so buttons do not dominate.
  final bool useLongLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: TextButton.icon(
        onPressed: () => LinkLauncher.open(link.url),
        icon: Icon(link.kind.icon, size: 15),
        label: Text(
          useLongLabel ? link.displayLongLabel : link.displayLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: TextButton.styleFrom(
          foregroundColor: filled ? AppColors.background : AppColors.accent,
          backgroundColor: filled
              ? AppColors.accent
              : AppColors.accent.withAlpha(16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: filled
                  ? Colors.transparent
                  : AppColors.accent.withAlpha(70),
            ),
          ),
        ),
      ),
    );
  }
}
