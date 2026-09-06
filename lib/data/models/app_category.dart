/// Filter buckets used by the portfolio section.
///
/// A project has exactly one bucket so the filter row stays predictable; the
/// richer, human-readable label ("Health · Device Control") lives on the
/// project itself as `categoryLabel`.
/// AI-hint: Keep this list short — the filter row must not wrap twice on mobile.
enum AppCategory {
  ai('AI'),
  business('Business'),
  health('Health'),
  logistics('Logistics'),
  games('Games'),
  lifestyle('Lifestyle');

  const AppCategory(this.label);

  final String label;
}
