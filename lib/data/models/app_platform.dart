import 'package:flutter/material.dart';

/// A platform a project actually ships on.
///
/// Listed only where there is evidence — a store listing, a live web build, or
/// a configured production bundle id. A Flutter project having an `ios/` folder
/// is not, on its own, enough.
enum AppPlatform {
  ios('iOS', Icons.phone_iphone_rounded),
  android('Android', Icons.android_rounded),
  web('Web', Icons.language_rounded),
  desktop('Desktop', Icons.desktop_mac_rounded);

  const AppPlatform(this.label, this.icon);

  final String label;
  final IconData icon;
}
