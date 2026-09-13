import 'package:flutter/widgets.dart';

import 'package:catlab_studios/core/l10n/app_locales.dart';

/// A piece of site copy in every language it has been written in.
///
/// The site is a content site: almost everything translatable is structured
/// content — a project entry, a vision scene — rather than an isolated UI
/// string with placeholders. So translations live *next to each other* on the
/// thing they describe:
///
/// ```dart
/// tagline: LocalizedText({
///   'en': 'Bluetooth control for CureBase and CureClip devices.',
///   'de': 'Bluetooth-Steuerung für CureBase- und CureClip-Geräte.',
/// }),
/// ```
///
/// Two properties fall out of that shape and are the reason for it: a new
/// project cannot be added in one language and forgotten in another, because
/// there is only one entry to fill in; and adding a language never changes a
/// single type or signature — it is one more key.
///
/// [AppLocales.fallbackCode] must always be present and is what any missing
/// translation falls back to, so a half-translated site degrades to English
/// rather than to a blank.
///
/// AI-hint: never build one of these from a runtime string — the point is that
/// every translation is visible in source and checkable by the l10n test.
@immutable
class LocalizedText {
  const LocalizedText(this.values);

  /// Language code → copy. Keys are bare language codes ('en', 'de'), not
  /// full locales: the site does not distinguish de-AT from de-DE.
  final Map<String, String> values;

  String resolve(String languageCode) =>
      values[languageCode] ?? values[AppLocales.fallbackCode]!;

  /// The English source text. Used where no context is available — asset
  /// alt text, semantics fallbacks and tests.
  String get source => values[AppLocales.fallbackCode]!;

  @override
  String toString() => 'LocalizedText(${values.keys.join('/')})';
}

/// Resolves site copy against the locale currently in effect.
extension LocalizedTextLookup on BuildContext {
  /// `context.t(project.tagline)`
  ///
  /// [params] fills `{name}` placeholders, which a few strings need for a
  /// project name or a count. Placeholders are named rather than positional
  /// so a translation is free to reorder them.
  String t(LocalizedText text, {Map<String, String>? params}) {
    var resolved = text.resolve(Localizations.localeOf(this).languageCode);
    if (params != null) {
      params.forEach((key, value) {
        resolved = resolved.replaceAll('{$key}', value);
      });
    }
    return resolved;
  }

  /// `context.tAll(project.highlights)`
  List<String> tAll(Iterable<LocalizedText> texts) => [
    for (final text in texts) t(text),
  ];
}
