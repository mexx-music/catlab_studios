import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_story_controller.dart';

/// Immersive player for a [VisionStory].
///
/// Behaves like a short film that the viewer is never locked out of: it plays
/// itself, but pause, back, forward, direct scene selection, swipe and the
/// keyboard are all live at any moment. It is a full route rather than a
/// dialog so mobile browsers give it the whole viewport.
///
/// AI-hint: layout decisions live in [_Metrics] — change sizing there rather
/// than sprinkling breakpoints through the tree.
class VisionStoryPlayer extends StatefulWidget {
  const VisionStoryPlayer({super.key, required this.story});

  final VisionStory story;

  /// Opens the story. Autoplay only ever starts from here — never from the
  /// landing page itself.
  static Future<void> open(BuildContext context, VisionStory story) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: true,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, _, _) => VisionStoryPlayer(story: story),
        transitionsBuilder: (context, animation, _, child) {
          final eased =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: eased,
            child: MediaQuery.disableAnimationsOf(context)
                ? child
                : ScaleTransition(
                    scale: Tween(begin: 0.97, end: 1.0).animate(eased),
                    child: child,
                  ),
          );
        },
      ),
    );
  }

  @override
  State<VisionStoryPlayer> createState() => _VisionStoryPlayerState();
}

class _VisionStoryPlayerState extends State<VisionStoryPlayer>
    with SingleTickerProviderStateMixin {
  late final VisionStoryController _controller = VisionStoryController(
    story: widget.story,
    vsync: this,
  );
  final FocusNode _keys = FocusNode(debugLabel: 'vision-story-keys');
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The platform's reduced-motion preference — on web this is
    // prefers-reduced-motion.
    _controller.reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (!_started) {
      _started = true;
      _controller.play();
    }
  }

  @override
  void dispose() {
    // Belt and braces: the controller's own dispose stops the ticker, but
    // stopping first means nothing is mid-flight while the route unwinds.
    _controller
      ..stop()
      ..dispose();
    _keys.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).maybePop();

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.keyK:
        _controller.toggle();
      case LogicalKeyboardKey.arrowRight:
        _controller.next();
      case LogicalKeyboardKey.arrowLeft:
        _controller.previous();
      case LogicalKeyboardKey.escape:
        _close();
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Focus(
        focusNode: _keys,
        autofocus: true,
        onKeyEvent: _onKey,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final metrics = _Metrics.of(constraints);
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => Column(
                  children: [
                    _Header(
                      story: widget.story,
                      metrics: metrics,
                      onClose: _close,
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _controller.toggle,
                        onHorizontalDragEnd: (details) {
                          final v = details.primaryVelocity ?? 0;
                          if (v < -240) _controller.next();
                          if (v > 240) _controller.previous();
                        },
                        child: _SceneView(
                          controller: _controller,
                          metrics: metrics,
                          onClose: _close,
                        ),
                      ),
                    ),
                    _Transport(controller: _controller, metrics: metrics),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Responsive sizing
// ---------------------------------------------------------------------------

/// One place for every size that changes with the viewport, so a phone gets a
/// layout designed for it rather than a shrunken desktop slide.
class _Metrics {
  const _Metrics({
    required this.wide,
    required this.gutter,
    required this.headline,
    required this.body,
    required this.short,
  });

  factory _Metrics.of(BoxConstraints c) {
    final wide = c.maxWidth >= 900 && c.maxHeight >= 540;
    final short = c.maxHeight < 620;
    return _Metrics(
      wide: wide,
      gutter: c.maxWidth < 400 ? 20 : (wide ? 48 : 28),
      headline: wide ? 34 : (c.maxWidth < 360 ? 22 : 25),
      body: wide ? 16 : 14.5,
      short: short,
    );
  }

  final bool wide;
  final double gutter;
  final double headline;
  final double body;

  /// Little vertical room — landscape phones, mostly. The visual gives way
  /// before the words do.
  final bool short;
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.story,
    required this.metrics,
    required this.onClose,
  });

  final VisionStory story;
  final _Metrics metrics;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(metrics.gutter, 14, metrics.gutter - 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // The one label that never leaves the screen: whatever
                    // else is on show, this is a vision story.
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.55)),
                      ),
                      child: const Text(
                        'VISION STORY',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        story.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: metrics.wide ? 16 : 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  story.subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textSecondary,
            tooltip: 'Close',
            iconSize: 22,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scene
// ---------------------------------------------------------------------------

class _SceneView extends StatelessWidget {
  const _SceneView({
    required this.controller,
    required this.metrics,
    required this.onClose,
  });

  final VisionStoryController controller;
  final _Metrics metrics;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scene = controller.current;
    final reduced = controller.reducedMotion;

    final visual = _SceneVisual(controller: controller, scene: scene);
    final copy = _SceneCopy(
      controller: controller,
      scene: scene,
      metrics: metrics,
      onClose: onClose,
    );

    final layout = metrics.wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 6, child: copy),
              SizedBox(width: metrics.gutter),
              Expanded(flex: 5, child: visual),
            ],
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              // On a phone the drawing leads and the words follow — but the
              // words get whatever they need. The diagram is capped rather
              // than given a share, because a scene's copy is what has to
              // stay readable, and a desktop slide scaled down would lose
              // both.
              // A scene carrying points and a today-note needs the room for
              // them; a sparse scene can let its diagram breathe instead.
              final dense = scene.points.isNotEmpty;
              final cap = metrics.short ? 170.0 : (dense ? 210.0 : 300.0);
              final visualHeight =
                  (constraints.maxHeight * (dense ? 0.30 : 0.40))
                      .clamp(120.0, cap);
              return Column(
                children: [
                  SizedBox(height: visualHeight, child: visual),
                  const SizedBox(height: 10),
                  Expanded(child: copy),
                ],
              );
            },
          );

    return Padding(
      padding: EdgeInsets.fromLTRB(
          metrics.gutter, 8, metrics.gutter, metrics.wide ? 8 : 4),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: reduced ? 130 : 460),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        layoutBuilder: (current, previous) => Stack(
          fit: StackFit.expand,
          children: [...previous, if (current != null) current],
        ),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: reduced
              ? child
              : SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.035),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
        ),
        child: KeyedSubtree(key: ValueKey(scene.id), child: layout),
      ),
    );
  }
}

class _SceneVisual extends StatelessWidget {
  const _SceneVisual({required this.controller, required this.scene});

  final VisionStoryController controller;
  final VisionScene scene;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.scene,
      builder: (context, _) => scene.visual(context, controller.visualState),
    );
  }
}

class _SceneCopy extends StatelessWidget {
  const _SceneCopy({
    required this.controller,
    required this.scene,
    required this.metrics,
    required this.onClose,
  });

  final VisionStoryController controller;
  final VisionScene scene;
  final _Metrics metrics;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      _Reveal(
        controller: controller,
        start: 0.0,
        end: 0.10,
        // A Wrap, not a Row: on a 320px phone a long kicker and its badge do
        // not fit on one line, and the badge must never be the thing that
        // gets clipped.
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              scene.kicker.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            if (scene.stage != null) _StageBadge(stage: scene.stage!),
          ],
        ),
      ),
      SizedBox(height: metrics.wide ? 14 : 11),
      _Reveal(
        controller: controller,
        start: 0.02,
        end: 0.14,
        child: Text(
          scene.headline,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: metrics.headline,
            height: 1.2,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
      ),
      SizedBox(height: metrics.wide ? 14 : 11),
      _Reveal(
        controller: controller,
        start: 0.08,
        end: 0.20,
        child: Text(
          scene.body,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: metrics.body,
            height: metrics.wide ? 1.62 : 1.52,
          ),
        ),
      ),
    ];

    void addStageNote() {
      if (scene.stageNote == null) return;
      children
        ..add(SizedBox(height: metrics.wide ? 20 : 16))
        ..add(
          _Reveal(
            controller: controller,
            start: metrics.wide ? 0.30 : 0.16,
            end: metrics.wide ? 0.44 : 0.28,
            child: _StageNote(scene.stageNote!),
          ),
        );
    }

    // On a phone the points are what may fall below the fold; the today-note
    // never is, so it goes first there.
    if (!metrics.wide) addStageNote();

    for (var i = 0; i < scene.points.length; i++) {
      final delay = metrics.wide ? 0.0 : 0.06;
      children
        ..add(SizedBox(height: i == 0 ? (metrics.wide ? 18 : 14) : 9))
        ..add(
          _Reveal(
            controller: controller,
            start: 0.16 + delay + i * 0.05,
            end: 0.28 + delay + i * 0.05,
            child: _Point(scene.points[i], metrics: metrics),
          ),
        );
    }

    if (metrics.wide) addStageNote();

    if (controller.isFinished) {
      children
        ..add(const SizedBox(height: 24))
        ..add(_Ending(controller: controller, onClose: onClose));
    }

    final column = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
    if (metrics.wide) return column;

    // A phone scene can run longer than the viewport. Fading the last few
    // pixels says "there is more" instead of looking like a clipping bug;
    // the content itself stays scrollable and complete.
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.white, Colors.transparent],
        stops: [0.0, 0.94, 1.0],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: column,
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.text, {required this.metrics});

  final String text;
  final _Metrics metrics;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 7),
          child: Icon(Icons.circle, size: 4.5, color: AppColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: metrics.wide ? 14.5 : 13.5,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// The per-scene honesty marker. Deliberately small and typographic — the
/// point is that a reader always knows which register they are in, not that
/// the slide looks like a disclaimer.
class _StageBadge extends StatelessWidget {
  const _StageBadge({required this.stage});

  final VisionStage stage;

  @override
  Widget build(BuildContext context) {
    final isToday = stage == VisionStage.today;
    final color = isToday ? AppColors.statusAvailable : AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isToday ? Icons.check_circle_outline_rounded : Icons.north_east_rounded,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            stage.label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// The counterweight under an ambitious scene: what is true right now.
class _StageNote extends StatelessWidget {
  const _StageNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 6, color: AppColors.statusAvailable),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ending extends StatelessWidget {
  const _Ending({required this.controller, required this.onClose});

  final VisionStoryController controller;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        OutlinedButton.icon(
          onPressed: controller.restart,
          icon: const Icon(Icons.replay_rounded, size: 17),
          label: const Text('Watch again'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accent,
            side: BorderSide(color: AppColors.accent.withValues(alpha: 0.6)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            textStyle:
                const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ),
        // Sends the viewer back to the factual half of the project.
        TextButton.icon(
          onPressed: onClose,
          icon: const Icon(Icons.arrow_back_rounded, size: 17),
          label: const Text('See what exists today'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            textStyle:
                const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Fades and lifts a child in over a window of the scene's own clock.
///
/// Tied to the scene controller rather than its own timer, so pausing the
/// story pauses these too — and the pre-built [child] is never rebuilt, only
/// re-composited.
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.controller,
    required this.start,
    required this.end,
    required this.child,
  });

  final VisionStoryController controller;
  final double start;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (controller.reducedMotion) return child;
    return AnimatedBuilder(
      animation: controller.scene,
      child: child,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(
          ((controller.scene.value - start) / (end - start)).clamp(0.0, 1.0),
        );
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 10),
            child: child,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Transport
// ---------------------------------------------------------------------------

class _Transport extends StatelessWidget {
  const _Transport({required this.controller, required this.metrics});

  final VisionStoryController controller;
  final _Metrics metrics;

  @override
  Widget build(BuildContext context) {
    final count = controller.story.sceneCount;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          metrics.gutter, 4, metrics.gutter, metrics.wide ? 20 : 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Segmented scrubber: progress and direct scene selection in one
          // control, so the bar is not just decoration.
          AnimatedBuilder(
            animation: controller.scene,
            builder: (context, _) => Row(
              children: [
                for (var i = 0; i < count; i++) ...[
                  if (i > 0) const SizedBox(width: 5),
                  Expanded(
                    child: _Segment(
                      fill: controller.segmentFill(i),
                      index: i,
                      label: controller.story.scenes[i].kicker,
                      onTap: () => controller.goTo(i),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                // Narrow phones cannot afford symmetric side columns; the
                // transport keeps its touch targets and the runtime goes.
                width: metrics.wide ? 64 : 52,
                child: Text(
                  '${(controller.index + 1).toString().padLeft(2, '0')} / '
                  '${count.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TransportButton(
                      icon: Icons.skip_previous_rounded,
                      tooltip: 'Previous scene',
                      onPressed: controller.previous,
                    ),
                    const SizedBox(width: 6),
                    _PlayButton(controller: controller),
                    const SizedBox(width: 6),
                    _TransportButton(
                      icon: Icons.skip_next_rounded,
                      tooltip: 'Next scene',
                      onPressed: controller.isLast && controller.isFinished
                          ? null
                          : controller.next,
                    ),
                  ],
                ),
              ),
              if (metrics.wide)
                SizedBox(
                  width: 64,
                  child: Text(
                    '${controller.story.runtime.inSeconds}s',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.fill,
    required this.index,
    required this.label,
    required this.onTap,
  });

  final double fill;
  final int index;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Scene ${index + 1}: $label',
      child: Tooltip(
        message: label,
        waitDuration: const Duration(milliseconds: 400),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            // Slim bar, generous hit area — the padding is the touch target.
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 3,
                  // heightFactor is load-bearing: without it the fill has no
                  // intrinsic height in the stack and never paints.
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: AppColors.cardBorder),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: fill.clamp(0.0, 1.0),
                          heightFactor: 1,
                          child: const ColoredBox(color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.controller});

  final VisionStoryController controller;

  @override
  Widget build(BuildContext context) {
    final finished = controller.isFinished;
    final playing = controller.isPlaying;
    return Tooltip(
      message: finished ? 'Replay' : (playing ? 'Pause' : 'Play'),
      child: Semantics(
        button: true,
        label: finished ? 'Replay' : (playing ? 'Pause' : 'Play'),
        child: Material(
          color: AppColors.accent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: finished ? controller.restart : controller.toggle,
            child: SizedBox(
              width: 52,
              height: 52,
              child: Icon(
                finished
                    ? Icons.replay_rounded
                    : (playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                color: AppColors.background,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 24,
      tooltip: tooltip,
      color: AppColors.textSecondary,
      disabledColor: AppColors.textMuted.withValues(alpha: 0.4),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}
