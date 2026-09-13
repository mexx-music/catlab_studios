import 'package:flutter/material.dart';

import 'package:catlab_studios/core/l10n/localized_text.dart';

/// Where an outbound link points, which decides its icon and default label.
///
/// Declaration order doubles as priority: [AppProject.primaryLink] walks these
/// in order, so a store listing always outranks a web build.
enum AppLinkKind {
  // The long forms use each platform's own official wording per language.
  appStore(
    LocalizedText({'en': 'App Store', 'de': 'App Store'}),
    LocalizedText({
      'en': 'Download on the App Store',
      'de': 'Laden im App Store',
    }),
    Icons.apple_rounded,
  ),
  playStore(
    LocalizedText({'en': 'Google Play', 'de': 'Google Play'}),
    LocalizedText({
      'en': 'Get it on Google Play',
      'de': 'Jetzt bei Google Play',
    }),
    Icons.shop_rounded,
  ),
  web(
    LocalizedText({'en': 'Open App', 'de': 'App öffnen'}),
    LocalizedText({'en': 'Open App', 'de': 'App öffnen'}),
    Icons.open_in_new_rounded,
  ),
  external(
    LocalizedText({'en': 'Learn more', 'de': 'Mehr erfahren'}),
    LocalizedText({'en': 'Learn more', 'de': 'Mehr erfahren'}),
    Icons.north_east_rounded,
  ),
  repository(
    LocalizedText({'en': 'Source', 'de': 'Quellcode'}),
    LocalizedText({'en': 'View Source', 'de': 'Quellcode ansehen'}),
    Icons.code_rounded,
  );

  const AppLinkKind(this.defaultLabel, this.defaultLongLabel, this.icon);

  /// Short form, used on cards where space is tight.
  final LocalizedText defaultLabel;

  /// Official platform wording, used in the detail sheet.
  final LocalizedText defaultLongLabel;

  final IconData icon;
}

/// A single verified outbound link for a project.
///
/// Only add entries here that actually resolve — an empty link list renders no
/// button at all, which is the intended behaviour for unreleased apps.
class AppLink {
  const AppLink({
    required this.kind,
    required this.url,
    this.label,
    this.longLabel,
  });

  final AppLinkKind kind;
  final String url;

  /// Overrides [AppLinkKind.defaultLabel] when a project needs its own wording.
  final LocalizedText? label;

  /// Overrides [AppLinkKind.defaultLongLabel] in the detail sheet.
  final LocalizedText? longLabel;

  LocalizedText get displayLabel => label ?? kind.defaultLabel;

  /// Falls back through the short override, so a project that sets only
  /// [label] keeps that wording in both places.
  LocalizedText get displayLongLabel =>
      longLabel ?? label ?? kind.defaultLongLabel;
}
