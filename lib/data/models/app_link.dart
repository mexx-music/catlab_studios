import 'package:flutter/material.dart';

/// Where an outbound link points, which decides its icon and default label.
enum AppLinkKind {
  appStore('App Store', Icons.apple_rounded),
  playStore('Google Play', Icons.shop_rounded),
  web('Open App', Icons.open_in_new_rounded),
  repository('Source', Icons.code_rounded);

  const AppLinkKind(this.defaultLabel, this.icon);

  final String defaultLabel;
  final IconData icon;
}

/// A single verified outbound link for a project.
///
/// Only add entries here that actually resolve — an empty link list renders no
/// button at all, which is the intended behaviour for unreleased apps.
class AppLink {
  const AppLink({required this.kind, required this.url, this.label});

  final AppLinkKind kind;
  final String url;

  /// Overrides [AppLinkKind.defaultLabel] when a project needs its own wording.
  final String? label;

  String get displayLabel => label ?? kind.defaultLabel;
}
