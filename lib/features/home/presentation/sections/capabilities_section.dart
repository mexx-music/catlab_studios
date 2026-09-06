import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_category.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// The fields the studio actually builds in, counted from the portfolio.
///
/// Counts are derived rather than written down, so this section can never
/// drift out of sync with the repository.
/// AI-hint: Add a domain by adding an app in that category — not by editing
/// a number here.
class CapabilitiesSection extends StatelessWidget {
  const CapabilitiesSection({super.key});

  static const _domains = <AppCategory, ({IconData icon, String blurb})>{
    AppCategory.ai: (
      icon: Icons.auto_awesome_mosaic_rounded,
      blurb: 'Chat platforms and assistants that route real work to real '
          'tools.',
    ),
    AppCategory.business: (
      icon: Icons.business_center_rounded,
      blurb: 'Company knowledge made usable, with sources and human review.',
    ),
    AppCategory.health: (
      icon: Icons.monitor_heart_rounded,
      blurb: 'Device control and information tools in the health space.',
    ),
    AppCategory.logistics: (
      icon: Icons.local_shipping_rounded,
      blurb: 'Load planning and arrival times for people who drive for a '
          'living.',
    ),
    AppCategory.games: (
      icon: Icons.sports_esports_rounded,
      blurb: 'Casual games — puzzle, arcade and quiz — with our own artwork.',
    ),
    AppCategory.lifestyle: (
      icon: Icons.nightlight_round,
      blurb: 'Everyday apps for sleep, focus, calm and a little curiosity.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.sizeOf(context).width < 640;

    return SectionContainer(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 20 : 24,
        vertical: isNarrow ? 64 : 96,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What We Build',
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: isNarrow ? 30 : 40,
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              'The studio started with cats. It still keeps them — but the '
              'work now spans six fields.',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: isNarrow ? 36 : 52),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 620
                  ? 1
                  : (constraints.maxWidth < 1000 ? 2 : 3);
              final entries = _domains.entries.toList();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  // Fixed height, not a ratio: the blurb wraps to three lines
                  // on a narrow tile and a ratio would clip it.
                  mainAxisExtent: columns > 1
                      ? 198
                      : (constraints.maxWidth < 380 ? 200 : 178),
                ),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _DomainTile(
                    icon: entry.value.icon,
                    label: entry.key.label,
                    blurb: entry.value.blurb,
                    count: AppProjectsRepository.byCategory(entry.key).length,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// One domain tile — icon, count, name, one line of substance
// ---------------------------------------------------------------------------
class _DomainTile extends StatefulWidget {
  const _DomainTile({
    required this.icon,
    required this.label,
    required this.blurb,
    required this.count,
  });

  final IconData icon;
  final String label;
  final String blurb;
  final int count;

  @override
  State<_DomainTile> createState() => _DomainTileState();
}

class _DomainTileState extends State<_DomainTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surface : AppColors.surface.withAlpha(140),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withAlpha(140)
                : AppColors.cardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 22, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  widget.count.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.blurb,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13.5,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
