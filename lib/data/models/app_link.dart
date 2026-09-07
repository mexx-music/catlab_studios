import 'package:flutter/material.dart';

/// Where an outbound link points, which decides its icon and default label.
///
/// Declaration order doubles as priority: [AppProject.primaryLink] walks these
/// in order, so a store listing always outranks a web build.
enum AppLinkKind {
  appStore('App Store', 'Download on the App Store', Icons.apple_rounded),
  playStore('Google Play', 'Get it on Google Play', Icons.shop_rounded),
  web('Open App', 'Open App', Icons.open_in_new_rounded),
  external('Learn more', 'Learn more', Icons.north_east_rounded),
  repository('Source', 'View Source', Icons.code_rounded);

  const AppLinkKind(this.defaultLabel, this.defaultLongLabel, this.icon);

  /// Short form, used on cards where space is tight.
  final String defaultLabel;

  /// Official platform wording, used in the detail sheet.
  final String defaultLongLabel;

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
  final String? label;

  /// Overrides [AppLinkKind.defaultLongLabel] in the detail sheet.
  final String? longLabel;

  String get displayLabel => label ?? kind.defaultLabel;

  /// Falls back through the short override, so a project that sets only
  /// [label] keeps that wording in both places.
  String get displayLongLabel => longLabel ?? label ?? kind.defaultLongLabel;
}
