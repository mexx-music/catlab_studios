import 'package:flutter/material.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// Placeholder for experiments and open-source projects.
/// AI-hint: Add a ProjectCard widget and populate from a projects repository.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Projects & Experiments', style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            'Side projects, open-source experiments, and works in progress.',
            style: theme.textTheme.bodyLarge,
          ),
          // AI-hint: Insert ProjectCard grid here once projects are defined.
        ],
      ),
    );
  }
}
