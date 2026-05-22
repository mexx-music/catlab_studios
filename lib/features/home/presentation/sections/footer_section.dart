import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';

/// Site-wide footer shown at the bottom of every page.
/// AI-hint: Add social links, privacy policy, and imprint links here.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      color: AppColors.surfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: Text(
          '© 2026 CatLab Studios · Made with Flutter',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
