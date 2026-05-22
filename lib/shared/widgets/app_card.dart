import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';

/// Reusable card that displays a single app/project entry.
/// AI-hint: Add onTap callback, store URL, or screenshots when ready.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.name,
    required this.tagline,
    this.iconData,
    this.category,
    this.onTap,
  });

  final String name;
  final String tagline;
  final IconData? iconData;
  final String? category;
  final VoidCallback? onTap;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _hovered ? -6.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          // Slightly lighter surface on hover
          color: _hovered ? AppColors.surfaceVariant : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withAlpha(180)
                : AppColors.cardBorder,
            width: _hovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            // Base shadow always present — stronger on hover
            BoxShadow(
              color: Colors.black.withAlpha(_hovered ? 80 : 40),
              blurRadius: _hovered ? 28 : 12,
              offset: const Offset(0, 8),
            ),
            // Violet glow — only on hover
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
          child: InkWell(
            onTap: widget.onTap,
            splashColor: AppColors.primary.withAlpha(25),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: icon badge + category pill ──────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _IconBadge(
                        icon: widget.iconData ?? Icons.apps_rounded,
                        hovered: _hovered,
                      ),
                      const Spacer(),
                      if (widget.category != null)
                        _CategoryPill(label: widget.category!),
                    ],
                  ),
                  const Spacer(),
                  // ── App name ─────────────────────────────────────────
                  Text(
                    widget.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _hovered
                          ? AppColors.textPrimary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // ── Tagline ──────────────────────────────────────────
                  Text(
                    widget.tagline,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Icon badge — glowing circle with accent icon
// ---------------------------------------------------------------------------
class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.hovered});

  final IconData icon;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(hovered ? 110 : 70),
            AppColors.primaryVariant.withAlpha(hovered ? 140 : 90),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withAlpha(hovered ? 160 : 60),
        ),
        boxShadow: hovered
            ? [
                BoxShadow(
                  color: AppColors.primary.withAlpha(80),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Icon(icon, color: AppColors.accent, size: 26),
    );
  }
}

// ---------------------------------------------------------------------------
// Category pill badge — gold / purple tint
// ---------------------------------------------------------------------------
class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withAlpha(70)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(fontSize: 10),
      ),
    );
  }
}
