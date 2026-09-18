import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/features/product_experience/data/product_experience_showcase.dart';
import 'package:catlab_studios/features/product_experience/domain/staged_media.dart';
import 'package:catlab_studios/features/product_experience/presentation/widgets/film_frame.dart';
import 'package:catlab_studios/features/product_experience/presentation/widgets/format_strip.dart';
import 'package:catlab_studios/features/product_experience/presentation/widgets/principle_stage.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// Programmed product staging — the studio's second kind of work.
///
/// Placed directly after the connected products because it continues the same
/// thread: the site has just shown a physical product with software attached,
/// and this is what the studio does *with* a real product once it exists. It
/// deliberately comes before the capabilities grid, which counts app domains
/// and would flatten this into a seventh tile.
///
/// The section is also the demo. The principle stage paints its staged half
/// live, the films are the real Healing & Balance exports, and the campaign
/// cards are the ones that actually went out — so a visitor judging whether
/// the studio can do this is looking at the work, not at a description of it.
///
/// AI-hint: never illustrate this section with generated imagery. A reference
/// that does not exist as a file simply is not shown.
class ProductExperienceSection extends StatelessWidget {
  const ProductExperienceSection({super.key});

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
          _Badge(label: context.t(SiteText.experienceBadge)),
          const SizedBox(height: 20),
          Text(
            context.t(SiteText.experienceTitle),
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: isNarrow ? 30 : 40,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              context.t(SiteText.experienceClaim),
              style: TextStyle(
                color: AppColors.accent,
                fontSize: isNarrow ? 18 : 22,
                height: 1.4,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              context.t(SiteText.experienceIntro),
              style: theme.textTheme.bodyLarge,
            ),
          ),

          SizedBox(height: isNarrow ? 40 : 60),
          _PrincipleBlock(isNarrow: isNarrow),

          SizedBox(height: isNarrow ? 44 : 64),
          _ReferenceBlock(isNarrow: isNarrow),

          SizedBox(height: isNarrow ? 40 : 60),
          _OutputsBlock(isNarrow: isNarrow),

          SizedBox(height: isNarrow ? 36 : 52),
          const _ContrastNote(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gold badge — matches the hero's positioning line
// ---------------------------------------------------------------------------
class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.47)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The principle: one image, everything around it painted in code
// ---------------------------------------------------------------------------
class _PrincipleBlock extends StatelessWidget {
  const _PrincipleBlock({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t(SiteText.experiencePrincipleTitle),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isNarrow ? 20 : 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            context.t(SiteText.experiencePrincipleBody),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.5,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 24),
        PrincipleStage(isNarrow: isNarrow),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// The real reference — films, then the cards cut from the same system
// ---------------------------------------------------------------------------
class _ReferenceBlock extends StatelessWidget {
  const _ReferenceBlock({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.t(SiteText.experienceReferenceLabel),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(height: 1, color: AppColors.divider),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          ProductExperienceShowcase.referenceName,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isNarrow ? 20 : 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            context.t(ProductExperienceShowcase.referenceNote),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.5,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            // Three 9:16 frames side by side need room; below that they wrap,
            // and on a phone one frame takes the column at a size where the
            // app screens inside the film are still legible.
            final available = constraints.maxWidth;
            final width = available < 560
                ? available.clamp(0.0, 300.0)
                : (available < 900 ? (available - 24) / 2 : (available - 48) / 3)
                      .clamp(0.0, 300.0);
            return Wrap(
              spacing: 24,
              runSpacing: 28,
              children: [
                for (final film in ProductExperienceShowcase.films)
                  FilmFrame(film: film, width: width.toDouble()),
              ],
            );
          },
        ),
        SizedBox(height: isNarrow ? 36 : 48),
        Text(
          context.t(SiteText.experienceCardsTitle),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        const _CampaignCardRow(),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            context.t(SiteText.experienceCardsNote),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

/// The published cards, scrolled horizontally rather than stacked: they are
/// one campaign, and a visitor should read them as a set.
class _CampaignCardRow extends StatelessWidget {
  const _CampaignCardRow();

  @override
  Widget build(BuildContext context) {
    const height = 210.0;
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: ProductExperienceShowcase.cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) =>
            _CampaignCardTile(card: ProductExperienceShowcase.cards[index]),
      ),
    );
  }
}

class _CampaignCardTile extends StatelessWidget {
  const _CampaignCardTile({required this.card});

  final CampaignCard card;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: card.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.asset(
            card.imageAsset,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            semanticLabel: context.t(card.title),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// What comes out of it, and in which shapes
// ---------------------------------------------------------------------------
class _OutputsBlock extends StatelessWidget {
  const _OutputsBlock({required this.isNarrow});

  final bool isNarrow;

  static const _outputs = <({IconData icon, LocalizedText label})>[
    (icon: Icons.movie_creation_outlined, label: SiteText.outputLaunchFilm),
    (
      icon: Icons.phone_iphone_rounded,
      label: SiteText.outputDeviceShowcase,
    ),
    (icon: Icons.bolt_rounded, label: SiteText.outputSocialSpot),
    (icon: Icons.style_outlined, label: SiteText.outputCampaignCard),
    (icon: Icons.web_asset_rounded, label: SiteText.outputHeroAnimation),
    (icon: Icons.touch_app_outlined, label: SiteText.outputFeatureDemo),
    (icon: Icons.play_lesson_outlined, label: SiteText.outputExplainer),
    (icon: Icons.blur_on_rounded, label: SiteText.outputInteractive),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t(SiteText.experienceOutputsTitle),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isNarrow ? 20 : 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 18),
        // A chip may not outgrow the column: "Interaktive Produkt-Experiences"
        // is wider than a 320 px phone, so the label wraps inside the chip
        // rather than pushing past the edge.
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final output in _outputs)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(output.icon, size: 15, color: AppColors.accent),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            context.t(output.label),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: isNarrow ? 32 : 40),
        Text(
          context.t(SiteText.experienceFormatsTitle),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        const FormatStrip(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Where generative video ends and this begins — stated without belittling it
// ---------------------------------------------------------------------------
class _ContrastNote extends StatelessWidget {
  const _ContrastNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t(SiteText.experienceContrastTitle),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              context.t(SiteText.experienceContrastBody),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
