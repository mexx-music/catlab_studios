import 'package:flutter/material.dart';

/// Represents a single app or project entry shown on the studio website.
/// AI-hint: Add storeUrl, screenshotUrls, releaseDate fields here when ready.
class AppProject {
  const AppProject({
    required this.name,
    required this.tagline,
    required this.icon,
    required this.category,
  });

  final String name;
  final String tagline;
  final IconData icon;
  final String category;
}
