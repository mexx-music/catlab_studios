import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/data/models/app_project.dart';
import 'package:catlab_studios/features/vision/data/vision_stories_repository.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_story_player.dart';
import 'package:catlab_studios/shared/widgets/beta_access_dialog.dart';
import 'package:catlab_studios/shared/widgets/app_icon_tile.dart';
import 'package:catlab_studios/shared/widgets/link_button.dart';
import 'package:catlab_studios/shared/widgets/platform_chips.dart';
import 'package:catlab_studios/shared/widgets/status_badge.dart';

/// Detail view for one project, shown as a modal over the portfolio.
///
/// Deliberately a sheet rather than a routed page: the site is a single scroll
/// surface, and a full detail-page system would be far more architecture than
/// fourteen entries need.
/// AI-hint: Add a screenshot carousel between the description and the
/// highlights once real screenshots exist.
class AppDetailSheet extends StatelessWidget {
  const AppDetailSheet({super.key, required this.project});

  final AppProject project;

  /// Opens the sheet: a bottom sheet on phones, a centred dialog on wider
  /// screens, so it never feels like a mobile pattern bolted onto desktop.
  static Future<void> show(BuildContext context, AppProject project) {
    final isNarrow = MediaQuery.sizeOf(context).width < 720;
    final sheet = AppDetailSheet(project: project);

    if (isNarrow) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withAlpha(170),
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) =>
              _SheetShell(scrollController: controller, child: sheet),
        ),
      );
    }

    return showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(170),
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _SheetShell(child: sheet),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visionStory = VisionStoriesRepository.forProject(project.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ───────────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconTile(project: project, size: 76, hovered: true),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    project.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.t(project.categoryLabel),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  StatusBadge(status: project.status),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close_rounded),
              color: AppColors.textMuted,
              tooltip: context.t(SiteText.actionClose),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── Description ──────────────────────────────────────────────────
        Text(
          context.t(project.description),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.65,
          ),
        ),

        // ── Connected product, when one belongs to this app ──────────────
        if (project.companionProductNote != null) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withAlpha(50)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.all_inclusive_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.t(project.companionProductNote!),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // ── Vision story ─────────────────────────────────────────────────
        // Only projects with an entry in VisionStoriesRepository get this. It
        // sits above the factual sections on purpose: what follows describes
        // today's product, what the button opens describes the direction.
        if (visionStory != null)
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: _VisionStoryCta(story: visionStory),
          ),

        // ── Highlights ───────────────────────────────────────────────────
        if (project.highlights.isNotEmpty) ...[
          const SizedBox(height: 28),
          _SectionLabel(context.t(SiteText.detailWhatItDoes)),
          const SizedBox(height: 12),
          for (final highlight in project.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 5, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.t(highlight),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],

        // ── Platforms ────────────────────────────────────────────────────
        if (project.platforms.isNotEmpty) ...[
          const SizedBox(height: 22),
          _SectionLabel(context.t(SiteText.detailPlatforms)),
          const SizedBox(height: 12),
          PlatformChips(
            platforms: project.platforms,
            stages: project.platformStages,
            showLabels: true,
          ),
        ],

        // ── Links ────────────────────────────────────────────────────────
        const SizedBox(height: 26),
        if (project.hasLinks || project.hasBetaPlatform || visionStory != null)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < project.links.length; i++)
                LinkButton(
                  link: project.links[i],
                  filled: i == 0,
                  useLongLabel: true,
                ),
              // Sits with the links because that is where a visitor looks for
              // something to open, but carries its own treatment: it opens a
              // presentation inside the site, not an outbound page.
              if (visionStory != null) _VisionStoryButton(story: visionStory),
              // A closed test has no public store page to link to, so the
              // beta action stands in for the missing Play button.
              if (project.hasBetaPlatform)
                _BetaAccessButton(appName: project.name),
            ],
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              context.t(SiteText.detailNoLinks),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Secondary action: opens the project's vision story
// ---------------------------------------------------------------------------

/// A deliberately distinct block rather than another entry in the link row.
///
/// The links answer "where can I get this"; this answers "where is this
/// going", and conflating the two is exactly the confusion the feature exists
/// to prevent. The runtime sits on the button so a visitor knows it costs a
/// minute, not a commitment.
class _VisionStoryCta extends StatelessWidget {
  const _VisionStoryCta({required this.story});

  final VisionStory story;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.16),
            AppColors.accent.withValues(alpha: 0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_graph_rounded,
                size: 15,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                context.t(SiteText.visionCtaLabel),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            context.t(
              SiteText.visionCtaBody,
              params: {'project': context.t(story.title)},
            ),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => VisionStoryPlayer.open(context, story),
            icon: const Icon(Icons.play_arrow_rounded, size: 19),
            label: Text(
              '${context.t(story.ctaLabel)}  ·  ${story.runtime.inSeconds}s',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The compact twin of [_VisionStoryCta], for the action row.
///
/// Violet rather than gold so it never reads as one more outbound link
/// sitting next to the store and demo buttons.
class _VisionStoryButton extends StatelessWidget {
  const _VisionStoryButton({required this.story});

  final VisionStory story;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => VisionStoryPlayer.open(context, story),
      icon: const Icon(Icons.auto_graph_rounded, size: 16),
      label: Text(context.t(story.ctaLabel)),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.primary.withValues(alpha: 0.30),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.85)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Opens the Android closed-test request flow
// ---------------------------------------------------------------------------
class _BetaAccessButton extends StatelessWidget {
  const _BetaAccessButton({required this.appName});

  final String appName;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => BetaAccessDialog.show(context, appName),
      icon: const Icon(Icons.android_rounded, size: 16),
      label: Text(context.t(SiteText.betaJoinShort)),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.statusInDevelopment,
        backgroundColor: AppColors.statusInDevelopment.withAlpha(16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.statusInDevelopment.withAlpha(70)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared chrome for both the bottom-sheet and dialog presentations
// ---------------------------------------------------------------------------
class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.child, this.scrollController});

  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(140),
            blurRadius: 48,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: child,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
      ),
    );
  }
}
