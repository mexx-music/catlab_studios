import 'package:flutter/material.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_platform.dart';

/// Row of platform indicators (iOS / Android / Web / Desktop).
///
/// A platform listed in [stages] carries its own release stage, so a project
/// that is live on iOS while Android is still in closed testing reads correctly
/// at a glance — on the compact card as a small tag next to the glyph, and in
/// the detail sheet spelled out in full.
///
/// Renders nothing when the list is empty: an unreleased project should not
/// advertise platforms it does not ship on.
class PlatformChips extends StatelessWidget {
  const PlatformChips({
    super.key,
    required this.platforms,
    this.stages = const {},
    this.showLabels = false,
  });

  final List<AppPlatform> platforms;

  /// Per-platform stage. Platforms absent from the map show no tag.
  final Map<AppPlatform, PlatformStage> stages;

  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    if (platforms.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: showLabels ? 8 : 8,
      runSpacing: 6,
      children: [
        for (final platform in platforms)
          showLabels
              ? _LabelledChip(platform: platform, stage: stages[platform])
              : _CompactChip(platform: platform, stage: stages[platform]),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card form — glyph, plus a short stage tag only when the platform differs
// ---------------------------------------------------------------------------
class _CompactChip extends StatelessWidget {
  const _CompactChip({required this.platform, this.stage});

  final AppPlatform platform;
  final PlatformStage? stage;

  @override
  Widget build(BuildContext context) {
    final stage = this.stage;

    return Tooltip(
      message: stage == null
          ? platform.label
          : '${platform.label} — ${stage.detailLabel}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            platform.icon,
            size: 15,
            color: stage == null ? AppColors.textMuted : stage.color,
          ),
          // Only a non-default stage earns extra pixels on a card.
          if (stage != null && stage != PlatformStage.available) ...[
            const SizedBox(width: 3),
            Text(
              context.t(stage.shortLabel).toUpperCase(),
              style: TextStyle(
                color: stage.color,
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail-sheet form — named pill with the stage spelled out
// ---------------------------------------------------------------------------
class _LabelledChip extends StatelessWidget {
  const _LabelledChip({required this.platform, this.stage});

  final AppPlatform platform;
  final PlatformStage? stage;

  @override
  Widget build(BuildContext context) {
    final stage = this.stage;
    final accent = stage?.color ?? AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: stage == null ? AppColors.cardBorder : accent.withAlpha(70),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(platform.icon, size: 14, color: accent),
          const SizedBox(width: 7),
          Text(
            platform.label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (stage != null) ...[
            Text(
              ' — ',
              style: TextStyle(fontSize: 12, color: accent.withAlpha(140)),
            ),
            Text(
              context.t(stage.detailLabel),
              style: TextStyle(
                fontSize: 12,
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
