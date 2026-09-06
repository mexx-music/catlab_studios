import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_category.dart';
import 'package:catlab_studios/data/models/app_project.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/shared/widgets/app_card.dart';
import 'package:catlab_studios/shared/widgets/app_detail_sheet.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// The portfolio: three highlighted apps, then a filterable grid of the rest.
///
/// The filter only applies to the grid. When a category is selected the
/// featured row collapses into it, so filtering never hides a matching app.
/// AI-hint: Grid breakpoints live in [_columnsFor]; card heights are fixed
/// pixel extents, not aspect ratios — see [_CardGrid.cardHeight].
class FeaturedAppsSection extends StatefulWidget {
  const FeaturedAppsSection({super.key, required this.apps});

  final List<AppProject> apps;

  @override
  State<FeaturedAppsSection> createState() => _FeaturedAppsSectionState();
}

class _FeaturedAppsSectionState extends State<FeaturedAppsSection> {
  AppCategory? _selected;

  bool get _isFiltered => _selected != null;

  List<AppProject> get _featured =>
      widget.apps.where((app) => app.featured).toList();

  /// When unfiltered the featured apps are shown separately above, so the grid
  /// skips them; when filtered everything matching goes into one grid.
  List<AppProject> get _gridApps {
    if (_isFiltered) {
      return widget.apps.where((app) => app.category == _selected).toList();
    }
    return widget.apps.where((app) => !app.featured).toList();
  }

  /// Phone → 1, small tablet → 2, tablet/laptop → 3, wide desktop → 4.
  int _columnsFor(double width) {
    if (width < 560) return 1;
    if (width < 900) return 2;
    if (width < 1320) return 3;
    return 4;
  }

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
            'Our Apps',
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: isNarrow ? 30 : 40,
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              '${widget.apps.length} projects across AI, business, health, '
              'logistics, games and everyday life — at every stage from '
              'shipped to concept.',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: isNarrow ? 28 : 36),

          // ── Filters ──────────────────────────────────────────────────────
          _CategoryFilterRow(
            selected: _selected,
            onSelected: (category) => setState(() => _selected = category),
          ),
          SizedBox(height: isNarrow ? 32 : 44),

          // ── Featured row (unfiltered view only) ──────────────────────────
          if (!_isFiltered) ...[
            const _RowLabel('Flagship projects'),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Featured cards are wider, so they get one column fewer.
                final columns = constraints.maxWidth < 760
                    ? 1
                    : (constraints.maxWidth < 1100 ? 2 : 3);
                return _CardGrid(
                  apps: _featured,
                  columns: columns,
                  cardHeight: 258,
                  featured: true,
                );
              },
            ),
            SizedBox(height: isNarrow ? 36 : 48),
            const _RowLabel('More from the studio'),
            const SizedBox(height: 16),
          ],

          // ── Grid ─────────────────────────────────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columnsFor(constraints.maxWidth);
              return _CardGrid(
                apps: _gridApps,
                columns: columns,
                cardHeight: 250,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small-caps label separating the flagship row from the rest of the grid
// ---------------------------------------------------------------------------
class _RowLabel extends StatelessWidget {
  const _RowLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            text.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(child: Divider(color: AppColors.cardBorder, height: 1)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Responsive grid of cards — wraps to a single column on phones
// ---------------------------------------------------------------------------
class _CardGrid extends StatelessWidget {
  const _CardGrid({
    required this.apps,
    required this.columns,
    required this.cardHeight,
    this.featured = false,
  });

  final List<AppProject> apps;
  final int columns;

  /// A fixed pixel height rather than an aspect ratio: card content does not
  /// shrink with the viewport, so a ratio silently overflows on phones.
  final double cardHeight;

  final bool featured;

  @override
  Widget build(BuildContext context) {
    if (apps.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        mainAxisExtent: cardHeight,
      ),
      itemBuilder: (context, index) {
        final app = apps[index];
        return AppCard(
          project: app,
          featured: featured,
          onTap: () => AppDetailSheet.show(context, app),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Category filter — wraps freely, so it stays readable on a phone
// ---------------------------------------------------------------------------
class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({required this.selected, required this.onSelected});

  final AppCategory? selected;
  final ValueChanged<AppCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _FilterChip(
          label: 'All',
          active: selected == null,
          onTap: () => onSelected(null),
        ),
        for (final category in AppProjectsRepository.usedCategories)
          _FilterChip(
            label: category.label,
            active: selected == category,
            onTap: () => onSelected(category),
          ),
      ],
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? AppColors.accent.withAlpha(24)
                : (_hovered
                      ? AppColors.surfaceVariant
                      : AppColors.background.withAlpha(120)),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: active
                  ? AppColors.accent.withAlpha(150)
                  : (_hovered ? AppColors.primary.withAlpha(120)
                      : AppColors.cardBorder),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: active ? AppColors.accent : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
