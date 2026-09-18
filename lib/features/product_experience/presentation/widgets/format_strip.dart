import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/features/product_experience/data/product_experience_showcase.dart';
import 'package:catlab_studios/features/product_experience/domain/staged_media.dart';

/// The delivery shapes, drawn to scale rather than listed.
///
/// Four frames sharing one height say "the same work, cut four ways" in less
/// space than a sentence would, and they are the only place on the page where
/// a ratio is shown as a ratio.
class FormatStrip extends StatelessWidget {
  const FormatStrip({super.key});

  @override
  Widget build(BuildContext context) {
    // The 16:9 frame is the widest tile; on a 320 px phone a full-height one
    // plus its label would not fit beside itself, so the frames shrink before
    // anything is allowed to overflow.
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxWidth < 400 ? 54.0 : 78.0;
        return Wrap(
          spacing: 22,
          runSpacing: 18,
          children: [
            for (final format in ProductExperienceShowcase.formats)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: _FormatTile(format: format, height: height),
              ),
          ],
        );
      },
    );
  }
}

class _FormatTile extends StatelessWidget {
  const _FormatTile({required this.format, required this.height});

  final OutputFormat format;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: height,
          child: AspectRatio(
            aspectRatio: format.ratio,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.45),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.18),
                    AppColors.surface,
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                format.label,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.t(format.use),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
