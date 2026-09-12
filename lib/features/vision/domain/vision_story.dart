import 'package:flutter/widgets.dart';

/// How a statement in a scene relates to the product as it exists today.
///
/// This is the heart of the feature: the site shows ambitious direction for
/// unfinished projects without ever implying that planned work already ships.
enum VisionStage {
  /// Verifiable in the product right now.
  today('Today'),

  /// Intended direction. Not built, not promised.
  vision('Vision');

  const VisionStage(this.label);

  final String label;
}

/// Per-frame state handed to a scene's visual while it plays.
///
/// [entrance] runs 0 → 1 over the scene's opening beat and is what elements
/// should use to appear; [progress] runs 0 → 1 across the whole scene and is
/// for slow, continuous motion. Under [reducedMotion] both arrive pinned at 1
/// so the visual paints its finished state immediately.
@immutable
class VisionVisualState {
  const VisionVisualState({
    required this.entrance,
    required this.progress,
    required this.reducedMotion,
  });

  final double entrance;
  final double progress;
  final bool reducedMotion;
}

typedef VisionVisualBuilder = Widget Function(BuildContext, VisionVisualState);

/// One beat of a story: a claim, its evidence level, and a drawing of it.
@immutable
class VisionScene {
  const VisionScene({
    required this.id,
    required this.kicker,
    required this.headline,
    required this.body,
    required this.visual,
    this.stage,
    this.stageNote,
    this.points = const [],
    this.duration = const Duration(seconds: 11),
  });

  /// Stable slug, used for keys and for addressing a scene in tests.
  final String id;

  /// Small label above the headline, e.g. 'Connect knowledge'.
  final String kicker;

  final String headline;

  /// Two or three sentences. The scene's argument.
  final String body;

  /// Short supporting lines, revealed one after another.
  final List<String> points;

  /// Null on scenes that make no product claim at all (an opening or a
  /// framing beat), so the badge stays meaningful where it does appear.
  final VisionStage? stage;

  /// The honest counterweight on a [VisionStage.vision] scene: one line
  /// naming what exists today, so an ambitious slide can never be misread.
  final String? stageNote;

  final VisionVisualBuilder visual;

  final Duration duration;
}

/// A complete presentation attached to one portfolio project.
@immutable
class VisionStory {
  const VisionStory({
    required this.projectId,
    required this.title,
    required this.subtitle,
    required this.scenes,
    this.ctaLabel = 'Explore the Vision',
  });

  /// Matches [AppProject.id]; this is the only thing that decides which
  /// projects get a vision CTA.
  final String projectId;

  final String title;

  /// One line under the title inside the player.
  final String subtitle;

  /// Label of the secondary action on the project's detail sheet.
  final String ctaLabel;

  final List<VisionScene> scenes;

  int get sceneCount => scenes.length;

  Duration get runtime =>
      scenes.fold(Duration.zero, (total, scene) => total + scene.duration);
}
