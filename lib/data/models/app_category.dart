import 'package:catlab_studios/core/l10n/localized_text.dart';

/// Filter buckets used by the portfolio section.
///
/// A project has exactly one bucket so the filter row stays predictable; the
/// richer, human-readable label ("Health · Device Control") lives on the
/// project itself as `categoryLabel`.
/// AI-hint: Keep this list short — the filter row must not wrap twice on mobile.
enum AppCategory {
  ai(LocalizedText({'en': 'AI', 'de': 'KI'})),
  business(LocalizedText({'en': 'Business', 'de': 'Business'})),
  health(LocalizedText({'en': 'Health', 'de': 'Gesundheit'})),
  logistics(LocalizedText({'en': 'Logistics', 'de': 'Logistik'})),
  games(LocalizedText({'en': 'Games', 'de': 'Spiele'})),
  lifestyle(LocalizedText({'en': 'Lifestyle', 'de': 'Alltag'}));

  const AppCategory(this.label);

  final LocalizedText label;
}
