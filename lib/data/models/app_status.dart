import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';

/// Lifecycle stage of a CatLab Studios app.
///
/// The wording is deliberately conservative: a project is only moved up a step
/// when there is hard evidence for it (a store listing, a live build, a
/// production bundle id). When in doubt, the lower status wins.
/// AI-hint: Add a new stage here and give it a colour — nothing else changes.
enum AppStatus {
  /// Publicly released — reachable through a store listing or a stable build.
  available('Available', AppColors.statusAvailable),

  /// Feature-complete enough to use, still being polished before release.
  advanced('Advanced', AppColors.statusAdvanced),

  /// Actively built, core flows work, not yet feature-complete.
  inDevelopment('In Development', AppColors.statusInDevelopment),

  /// A working proof of concept — playable or usable, but early.
  prototype('Prototype', AppColors.statusPrototype),

  /// Scoped and designed, implementation not started.
  concept('Concept', AppColors.statusConcept);

  const AppStatus(this.label, this.color);

  final String label;
  final Color color;
}
