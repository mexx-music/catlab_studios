import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';

/// Lifecycle stage of a CatLab Studios app.
///
/// The wording is deliberately conservative: a project is only moved up a step
/// when there is hard evidence for it (a store listing, a live build, a
/// production bundle id). When in doubt, the lower status wins.
/// AI-hint: Add a new stage here and give it a colour — nothing else changes.
enum AppStatus {
  /// Publicly released — reachable through a store listing or a stable build.
  available(
    LocalizedText({'en': 'Available', 'de': 'Verfügbar'}),
    AppColors.statusAvailable,
  ),

  /// Feature-complete enough to use, still being polished before release.
  advanced(
    LocalizedText({'en': 'Advanced', 'de': 'Fortgeschritten'}),
    AppColors.statusAdvanced,
  ),

  /// Actively built, core flows work, not yet feature-complete.
  inDevelopment(
    LocalizedText({'en': 'In Development', 'de': 'In Entwicklung'}),
    AppColors.statusInDevelopment,
  ),

  /// A working proof of concept — playable or usable, but early.
  prototype(
    LocalizedText({'en': 'Prototype', 'de': 'Prototyp'}),
    AppColors.statusPrototype,
  ),

  /// Scoped and designed, implementation not started.
  concept(
    LocalizedText({'en': 'Concept', 'de': 'Konzept'}),
    AppColors.statusConcept,
  );

  const AppStatus(this.label, this.color);

  final LocalizedText label;
  final Color color;
}
