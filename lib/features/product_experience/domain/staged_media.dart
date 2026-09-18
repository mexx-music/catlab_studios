/// The media of one programmed product experience.
///
/// Everything in here points at a file that was actually produced — a film
/// that was rendered, a card that was published. The section refuses to
/// invent a reference: a missing file means an entry is left out, never
/// filled with a stand-in.
///
/// AI-hint: no entry may be added for work that does not exist as a file in
/// `web/media/` (films) or `assets/images/showcase/` (stills).
library;

import 'package:catlab_studios/core/l10n/localized_text.dart';

/// A rendered film, shown in its real aspect ratio.
class StagedFilm {
  const StagedFilm({
    required this.id,
    required this.title,
    required this.note,
    required this.posterAsset,
    required this.videoUrl,
    required this.duration,
    this.aspectRatio = 9 / 16,
  });

  /// Stable slug, used for keys and for addressing a film in tests.
  final String id;

  final LocalizedText title;

  /// One line naming what the film actually shows.
  final LocalizedText note;

  /// Still frame from the film itself — not a separate rendering. Shown
  /// before playback, and the only thing loaded until a visitor asks for
  /// the film.
  final String posterAsset;

  /// Relative to the site root, so it works under the apex base-href and in
  /// `flutter run -d chrome` alike. Deliberately *not* a bundled asset: a
  /// film is only fetched when someone presses play.
  final String videoUrl;

  final Duration duration;

  final double aspectRatio;

  /// '0:20', for the badge on the frame.
  String get durationLabel {
    final seconds = duration.inSeconds;
    return '0:${seconds.toString().padLeft(2, '0')}';
  }
}

/// A published campaign still — a product card as it goes out in a channel.
class CampaignCard {
  const CampaignCard({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.aspectRatio,
  });

  final String id;
  final LocalizedText title;
  final String imageAsset;
  final double aspectRatio;
}

/// One delivery format, drawn to scale in the format strip.
class OutputFormat {
  const OutputFormat(this.label, this.ratio, this.use);

  /// '9:16' — the same string designers and ad managers use.
  final String label;

  final double ratio;

  /// Where that shape is actually used.
  final LocalizedText use;
}
