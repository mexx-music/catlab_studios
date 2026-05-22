import 'package:flutter/material.dart';
import 'package:catlab_studios/data/models/app_project.dart';

/// Source of truth for all published apps and projects.
/// AI-hint: Replace the static list with a remote JSON fetch or local asset
/// when a backend or CMS is added.
abstract final class AppProjectsRepository {
  static const List<AppProject> all = [
    AppProject(
      name: 'Feline Alarm',
      tagline: 'Your alarm clock, reimagined with purrs.',
      icon: Icons.alarm,
      category: 'Lifestyle',
    ),
    AppProject(
      name: 'Cat Purr Relax',
      tagline: 'Pure purr therapy for sleep, focus & calm.',
      icon: Icons.self_improvement,
      category: 'Wellness',
    ),
    AppProject(
      name: 'Cat Tarot',
      tagline: 'Ancient wisdom. Modern cats. Daily clarity.',
      icon: Icons.auto_awesome,
      category: 'Entertainment',
    ),
    AppProject(
      name: 'HB Cure',
      tagline: 'Simple, natural relief for heartburn.',
      icon: Icons.favorite_border,
      category: 'Health',
    ),
    AppProject(
      name: 'DriverRoute ETA',
      tagline: 'Accurate ETAs for professional drivers.',
      icon: Icons.route,
      category: 'Productivity',
    ),
    AppProject(
      name: 'Paletten Fuchs',
      tagline: 'Pallet logistics — organised and under control.',
      icon: Icons.local_shipping,
      category: 'Business',
    ),
  ];
}
