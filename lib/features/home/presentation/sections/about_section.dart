import 'package:flutter/material.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// Short studio bio section.
/// AI-hint: Expand with a team grid or timeline when the about page is built.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About the Studio', style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            'CatLab Studios is an indie app studio focused on creating '
            'beautiful, useful apps for everyday life. Built with Flutter — '
            'one pixel at a time.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
