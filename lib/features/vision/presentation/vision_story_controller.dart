import 'package:flutter/widgets.dart';

import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_visuals.dart';

/// Playback state for one vision story.
///
/// Timing is driven by a single [AnimationController] rather than a `Timer`,
/// which is what makes the required behaviour fall out structurally:
///
///   * **Pause is a real pause.** Stopping the controller stops the scene
///     clock, the auto-advance and every visual at once — a stopped controller
///     notifies no listeners, so the painters stop repainting entirely.
///   * **Manual navigation cannot be overtaken by a stale timer.** Moving to a
///     scene resets the same controller, so the pending completion that would
///     have advanced the previous scene no longer exists. There is nothing left
///     to fire.
///
/// [scene] doubles as the progress source for the scrubber and as the animation
/// input for the scene's painter.
class VisionStoryController extends ChangeNotifier {
  VisionStoryController({
    required this.story,
    required TickerProvider vsync,
    bool reducedMotion = false,
  }) : _reducedMotion = reducedMotion,
       _scene = AnimationController(
         vsync: vsync,
         duration: story.scenes.first.duration,
       ) {
    _scene.addStatusListener(_onSceneStatus);
  }

  final VisionStory story;
  final AnimationController _scene;

  int _index = 0;
  bool _playing = false;
  bool _finished = false;
  bool _reducedMotion;

  /// Set while the controller is restructuring itself, so its own writes to
  /// [_scene] can never be mistaken for a scene reaching its natural end.
  bool _reseating = false;

  /// Progress through the current scene, 0 → 1. Also the painter's clock.
  Animation<double> get scene => _scene;

  int get index => _index;
  bool get isPlaying => _playing;

  /// True once the last scene has played out. Playback stops here rather than
  /// looping, and the player offers a replay.
  bool get isFinished => _finished;

  bool get isFirst => _index == 0;
  bool get isLast => _index == story.sceneCount - 1;

  VisionScene get current => story.scenes[_index];

  bool get reducedMotion => _reducedMotion;
  set reducedMotion(bool value) {
    if (_reducedMotion == value) return;
    _reducedMotion = value;
    notifyListeners();
  }

  /// The per-frame inputs a scene visual needs.
  VisionVisualState get visualState => VisionVisualState(
    entrance: (_scene.value / kEntranceFraction).clamp(0.0, 1.0),
    progress: _scene.value,
    reducedMotion: _reducedMotion,
  );

  /// How full a given scene's progress segment should be drawn.
  double segmentFill(int sceneIndex) {
    if (sceneIndex < _index) return 1.0;
    if (sceneIndex > _index) return 0.0;
    return _scene.value;
  }

  // ── Transport ──────────────────────────────────────────────────────────

  void play() {
    // Replaying from the end restarts rather than resuming a finished scene.
    if (_finished) {
      _seat(0, resume: true);
      return;
    }
    _playing = true;
    _scene.forward();
    notifyListeners();
  }

  void pause() {
    _playing = false;
    _scene.stop();
    notifyListeners();
  }

  void toggle() => _playing ? pause() : play();

  void next() {
    if (isLast) {
      _finish();
      return;
    }
    _seat(_index + 1, resume: _playing);
  }

  /// Mid-scene, back means "play this scene again" — what a viewer expects
  /// when they missed a line. Near a scene's start it steps back a scene.
  void previous() {
    final restartCurrent = _finished || _scene.value > 0.35 || isFirst;
    final target = restartCurrent ? _index : _index - 1;
    _seat(target, resume: _playing || _finished);
  }

  void goTo(int sceneIndex) {
    if (sceneIndex < 0 || sceneIndex >= story.sceneCount) return;
    _seat(sceneIndex, resume: _playing || _finished);
  }

  void restart() => _seat(0, resume: true);

  /// Stops everything. Called when the story is closed so nothing keeps
  /// ticking behind a dismissed route.
  void stop() {
    _playing = false;
    _scene.stop();
    notifyListeners();
  }

  // ── Internals ──────────────────────────────────────────────────────────

  /// Moves to [sceneIndex] and rebuilds the scene clock from scratch.
  void _seat(int sceneIndex, {required bool resume}) {
    _reseating = true;
    _scene
      ..stop()
      ..duration = story.scenes[sceneIndex].duration
      ..value = 0.0;
    _reseating = false;

    _index = sceneIndex;
    _finished = false;
    _playing = resume;
    if (resume) _scene.forward();
    notifyListeners();
  }

  void _onSceneStatus(AnimationStatus status) {
    if (_reseating || status != AnimationStatus.completed) return;
    if (isLast) {
      _finish();
      return;
    }
    _seat(_index + 1, resume: true);
  }

  void _finish() {
    _reseating = true;
    _scene
      ..stop()
      ..value = 1.0;
    _reseating = false;

    _index = story.sceneCount - 1;
    _playing = false;
    _finished = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _scene
      ..removeStatusListener(_onSceneStatus)
      ..dispose();
    super.dispose();
  }
}
