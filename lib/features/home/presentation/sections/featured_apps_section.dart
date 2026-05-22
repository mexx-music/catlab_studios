import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/models/app_project.dart';
import 'package:catlab_studios/shared/widgets/app_card.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// Grid of AppCards for all published apps.
/// AI-hint: Add category filter tabs above the grid when the list grows.
class FeaturedAppsSection extends StatelessWidget {
  const FeaturedAppsSection({super.key, required this.apps});

  final List<AppProject> apps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionContainer(
      backgroundColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Our Apps', style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text(
            'A growing collection of apps for life, health, and fun.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apps.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return AppCard(
                    name: app.name,
                    tagline: app.tagline,
                    iconData: app.icon,
                    category: app.category,
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
