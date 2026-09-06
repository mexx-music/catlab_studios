import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_status.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// Studio bio plus a plain-spoken key to the status labels used on the cards.
///
/// The legend matters: it is what makes an honest portfolio readable, since
/// most of these projects are not shipped yet and the site says so.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.sizeOf(context).width < 640;

    return SectionContainer(
      backgroundColor: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 20 : 24,
        vertical: isNarrow ? 64 : 96,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the Studio',
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: isNarrow ? 30 : 40,
            ),
          ),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 660),
            child: Text(
              'CatLab Studios is an independent software studio building '
              'practical, creative and AI-powered applications across mobile, '
              'web and desktop. Most of it is built with Flutter, from one '
              'codebase, by a small team that ships when something is '
              'genuinely ready.',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: isNarrow ? 40 : 56),
          const _StatusLegend(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status legend — explains what each badge on a card actually means
// ---------------------------------------------------------------------------
class _StatusLegend extends StatelessWidget {
  const _StatusLegend();

  static const _meanings = <AppStatus, String>{
    AppStatus.available: 'Released and in use.',
    AppStatus.advanced: 'Works end to end, being polished before release.',
    AppStatus.inDevelopment: 'Core features work, still being built out.',
    AppStatus.prototype: 'A working proof of concept.',
    AppStatus.concept: 'Scoped, not yet built.',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(160),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HOW WE LABEL PROGRESS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 28,
            runSpacing: 16,
            children: [
              for (final entry in _meanings.entries)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: entry.key.color,
                            boxShadow: [
                              BoxShadow(
                                color: entry.key.color.withAlpha(110),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key.label} · '
                              '${AppProjectsRepository.all.where((a) => a.status == entry.key).length}',
                              style: TextStyle(
                                color: entry.key.color,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              entry.value,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12.5,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
