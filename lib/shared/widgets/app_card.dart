import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_project.dart';
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
                                project.categoryLabel,
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
                              StatusBadge(status: project.status, compact: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: featured ? 20 : 14),

                    // ── Tagline (+ description when featured) ─────────────
                    Text(
                      project.tagline,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: featured ? 14.5 : 13,
                        height: 1.5,
                      ),
                      maxLines: featured ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // ── Platforms + links ────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: PlatformChips(
                            platforms: project.platforms,
                            stages: project.platformStages,
                          ),
                        ),
                        if (project.hasLinks) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: LinkButton(
                              link: project.primaryLink!,
                              filled: featured,
                            ),
                          ),
                        ] else
                          _DetailsHint(hovered: _hovered),
                      ],
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Learn more',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.arrow_forward_rounded,
            size: 14,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
