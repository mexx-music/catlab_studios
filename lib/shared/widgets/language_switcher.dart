import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/app_locales.dart';
import 'package:catlab_studios/core/l10n/locale_scope.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';

/// Compact language control, shown over the hero image.
///
/// A segmented EN|DE rather than a dropdown: with two or three languages the
/// choice is worth showing outright, and a visitor who landed in the wrong
/// language should not have to open a menu to find that out. The full name
/// ("Deutsch") is the tooltip and the accessible label, since two letters
/// alone are a poor screen-reader announcement.
///
/// AI-hint: past four languages this should become a dropdown — the row will
/// not fit a phone hero otherwise.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocaleScope.of(context);
    final effective = Localizations.localeOf(context);

    return Semantics(
      container: true,
      label: context.t(SiteText.languageLabel),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(110),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.accent.withAlpha(90)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final locale in AppLocales.supported)
              _LanguageButton(
                locale: locale,
                active: controller.isActive(locale, effective),
                onTap: () => controller.select(locale),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.locale,
    required this.active,
    required this.onTap,
  });

  final Locale locale;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = AppLocales.nativeName[locale.languageCode] ?? '';
    return Tooltip(
      message: name,
      child: Semantics(
        button: true,
        selected: active,
        label: name,
        child: Material(
          color: active ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(7),
            child: Container(
              // A comfortable touch target even though the label is two
              // characters wide.
              constraints: const BoxConstraints(minWidth: 44, minHeight: 34),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                AppLocales.shortLabel(locale),
                style: TextStyle(
                  color: active ? AppColors.background : AppColors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
