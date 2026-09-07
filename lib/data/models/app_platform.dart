import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';

/// A platform a project actually ships on.
///
/// Listed only where there is evidence — a store listing, a live web build, or
/// a configured production bundle id. A Flutter project having an `ios/` folder
/// is not, on its own, enough.
enum AppPlatform {
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
  available('Available', 'Available', AppColors.statusAvailable),
  beta('Beta', 'Beta · Closed Test', AppColors.statusInDevelopment);

  const PlatformStage(this.shortLabel, this.detailLabel, this.color);

  /// Fits next to an icon on a compact card.
  final String shortLabel;

  /// Spelled out in the detail sheet, where there is room.
  final String detailLabel;

  final Color color;
}
