import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';

/// A platform a project actually ships on.
///
/// Listed only where there is evidence — a store listing, a live web build, or
/// a configured production bundle id. A Flutter project having an `ios/` folder
/// is not, on its own, enough.
enum AppPlatform {
  // Platform names are proper nouns: the same word in every language.
  ios('iOS', Icons.apple_rounded),
  android('Android', Icons.android_rounded),
  web('Web', Icons.language_rounded),
  desktop('Desktop', Icons.desktop_mac_rounded);

  const AppPlatform(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// How far along a project is *on one specific platform*.
///
/// An app can be live on iOS while Android is still in closed testing, and the
/// single project-level [AppStatus] cannot express that. Projects that ship
/// everywhere at once simply omit this and inherit their overall status.
/// AI-hint: Only set a stage when platforms genuinely differ — an all-Available
/// map is noise on the card.
enum PlatformStage {
  available(
    LocalizedText({'en': 'Available', 'de': 'Verfügbar'}),
    LocalizedText({'en': 'Available', 'de': 'Verfügbar'}),
    AppColors.statusAvailable,
  ),
  beta(
    LocalizedText({'en': 'Beta', 'de': 'Beta'}),
    LocalizedText({
      'en': 'Beta · Closed Test',
      'de': 'Beta · Geschlossener Test',
    }),
    AppColors.statusInDevelopment,
  );

  const PlatformStage(this.shortLabel, this.detailLabel, this.color);

  /// Fits next to an icon on a compact card.
  final LocalizedText shortLabel;

  /// Spelled out in the detail sheet, where there is room.
  final LocalizedText detailLabel;

  final Color color;
}
