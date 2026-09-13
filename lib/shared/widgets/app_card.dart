import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/data/models/app_project.dart';
import 'package:catlab_studios/features/vision/data/vision_stories_repository.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_story_player.dart';
import 'package:catlab_studios/shared/widgets/app_icon_tile.dart';
import 'package:catlab_studios/shared/widgets/link_button.dart';
import 'package:catlab_studios/shared/widgets/platform_chips.dart';
import 'package:catlab_studios/shared/widgets/status_badge.dart';

/// Card for a single portfolio entry.
///
/// Two sizes share one widget so the featured row and the grid never drift
/// apart visually: [featured] gives a larger icon, the description line and
/// every verified link; the compact form shows the primary link only.
/// AI-hint: Layout is driven by [featured] and the parent's aspect ratio —
/// don't add a third variant, adjust the grid instead.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.project,
    this.featured = false,
    this.onTap,
  });

  final AppProject project;
  final bool featured;
  final VoidCallback? onTap;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final featured = widget.featured;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _hovered ? -6.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceVariant : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withAlpha(180)
                : AppColors.cardBorder,
            width: _hovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_hovered ? 80 : 40),
              blurRadius: _hovered ? 28 : 12,
              offset: const Offset(0, 8),
            ),
            if (_hovered)
              BoxShadow(
                color: AppColors.primary.withAlpha(70),
                blurRadius: 32,
                spreadRadius: -4,
                offset: const Offset(0, 12),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              splashColor: AppColors.primary.withAlpha(25),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(featured ? 26 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Icon + status ────────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppIconTile(
                          project: project,
                          size: featured ? 68 : 50,
                          hovered: _hovered,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.name,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: featured ? 22 : 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                context.t(project.categoryLabel),
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              StatusBadge(
                                status: project.status,
                                compact: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: featured ? 20 : 14),

                    // ── Tagline (+ description when featured) ─────────────
                    Text(
                      context.t(project.tagline),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: featured ? 14.5 : 13,
                        height: 1.5,
                      ),
                      maxLines: featured ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // ── Platforms + actions ──────────────────────────────
                    // The card height is fixed by the grid, so everything here
                    // has to share one row; the vision button trades its label
                    // for an icon before anything is allowed to overflow.
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final story = VisionStoriesRepository.forProject(
                          project.id,
                        );
                        final hasLink = project.hasLinks;
                        // Below this the two buttons plus the chips stop
                        // fitting side by side, and the vision button gives up
                        // its label rather than squeezing the link button's.
                        // Measured, not guessed: the link button alone is
                        // 168px and the labelled vision button 126px, so a
                        // card carrying both has to give something up.
                        // The platform chips go first — one small glyph, and
                        // the detail sheet states the platforms in full — and
                        // only on a card too narrow even for that does the
                        // button fall back to its icon.
                        final labelled =
                            constraints.maxWidth >= (hasLink ? 302 : 150);
                        final tight =
                            story != null &&
                            labelled &&
                            constraints.maxWidth < 380;

                        return Row(
                          children: [
                            // The chips take their own small width, the
                            // spacer pushes the actions to the trailing edge,
                            // and only the link button flexes.
                            if (!tight)
                              PlatformChips(
                                platforms: project.platforms,
                                stages: project.platformStages,
                              ),
                            const Spacer(),
                            if (hasLink) ...[
                              const SizedBox(width: 8),
                              // The heavy flex means the link takes the slack
                              // before the spacer does, so it keeps its full
                              // label whenever one fits — and ellipsises
                              // instead of overflowing when a translation is
                              // longer than the row can hold.
                              Flexible(
                                flex: 100,
                                child: LinkButton(
                                  link: project.primaryLink!,
                                  filled: featured,
                                ),
                              ),
                            ],
                            if (story != null) ...[
                              const SizedBox(width: 6),
                              _CardVisionButton(
                                story: story,
                                labelled: labelled,
                              ),
                            ] else if (!hasLink)
                              _DetailsHint(hovered: _hovered),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Opens the project's vision story straight from the card
// ---------------------------------------------------------------------------

/// Violet, so it never reads as one more outbound link next to the gold store
/// and demo buttons: this one opens a presentation inside the site.
///
/// Drops to icon-only when the row is too tight for the words, which is what
/// keeps it on a one-column phone card without pushing anything off the edge.
class _CardVisionButton extends StatelessWidget {
  const _CardVisionButton({required this.story, required this.labelled});

  final VisionStory story;

  /// False when the row is too tight for the word, which is most of the
  /// three- and four-column desktop grid: the link button alone is 168px.
  final bool labelled;

  @override
  Widget build(BuildContext context) {
    final name = context.t(story.ctaLabel);
    return Tooltip(
      message: name,
      child: Semantics(
        button: true,
        label: name,
        child: TextButton(
          onPressed: () => VisionStoryPlayer.open(context, story),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.34),
            // Every pixel here is one the demo link would otherwise lose, so
            // the button is sized by hand rather than by the button theme.
            padding: EdgeInsets.symmetric(
              horizontal: labelled ? 9 : 11,
              vertical: 11,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.9)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_graph_rounded, size: 15),
              if (labelled) ...[
                const SizedBox(width: 5),
                Text(
                  context.t(SiteText.visionCardLabel),
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shown instead of a link button when a project has nothing public to link to
// ---------------------------------------------------------------------------
class _DetailsHint extends StatelessWidget {
  const _DetailsHint({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: hovered ? 1 : 0.55,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.t(SiteText.actionLearnMore),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 14,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
