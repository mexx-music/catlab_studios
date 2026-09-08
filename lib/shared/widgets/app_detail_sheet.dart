import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_project.dart';
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
                    project.categoryLabel,
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
              tooltip: 'Close',
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── Description ──────────────────────────────────────────────────
        Text(
          project.description,
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
                    project.companionProductNote!,
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

        // ── Highlights ───────────────────────────────────────────────────
        if (project.highlights.isNotEmpty) ...[
          const SizedBox(height: 28),
          const _SectionLabel('What it does'),
          const SizedBox(height: 12),
          for (final highlight in project.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      highlight,
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
          const _SectionLabel('Platforms'),
          const SizedBox(height: 12),
          PlatformChips(
            platforms: project.platforms,
            stages: project.platformStages,
            showLabels: true,
          ),
        ],

        // ── Links ────────────────────────────────────────────────────────
        const SizedBox(height: 26),
        if (project.hasLinks)
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
            child: const Text(
              'Not publicly available yet — no download or demo link to share '
              'at this stage.',
              style: TextStyle(
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
      label: const Text('Join Android Beta'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.statusInDevelopment,
        backgroundColor: AppColors.statusInDevelopment.withAlpha(16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: AppColors.statusInDevelopment.withAlpha(70),
          ),
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
