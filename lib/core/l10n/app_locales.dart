import 'package:flutter/widgets.dart';

/// The languages CatLab Studios is published in.
///
/// Adding one is deliberately a three-line change: add the [Locale] here, give
/// it a name in [nativeName], and fill in the new key wherever the l10n test
/// reports it missing.
abstract final class AppLocales {
  /// English is the source language and the fallback for every missing string.
  static const String fallbackCode = 'en';

  static const Locale fallback = Locale(fallbackCode);

  static const List<Locale> supported = [Locale('en'), Locale('de')];

  /// Shown in the language switcher — always in the language itself, because
  /// someone looking for German is looking for the word "Deutsch".
  static const Map<String, String> nativeName = {
    'en': 'English',
    'de': 'Deutsch',
  };

  /// Two letters for the compact switcher.
  static String shortLabel(Locale locale) => locale.languageCode.toUpperCase();

  static bool isSupported(Locale locale) =>
      supported.any((l) => l.languageCode == locale.languageCode);

  /// Picks the best supported locale for a visitor's browser settings,
  /// matching on language alone so de-AT and de-CH both get German.
  static Locale resolve(Locale? deviceLocale, Iterable<Locale> _) {
    if (deviceLocale == null) return fallback;
    for (final locale in supported) {
      if (locale.languageCode == deviceLocale.languageCode) return locale;
    }
    return fallback;
  }
}
