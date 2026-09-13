import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';

/// Site-wide footer.
///
/// AI-hint: Add contact, privacy and imprint links here — but only real ones.
/// No studio email address is recorded anywhere in the projects yet.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.sizeOf(context).width < 640;

    return Container(
      width: double.infinity,
      color: AppColors.surfaceVariant,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 20 : 24,
        vertical: 36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 12,
            children: [
              Text(
                context.t(SiteText.footerCopyright),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                context.t(
                  SiteText.footerStats,
                  params: {'count': '${AppProjectsRepository.all.length}'},
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
