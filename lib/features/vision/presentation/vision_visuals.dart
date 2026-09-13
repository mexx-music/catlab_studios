import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_diagram_text.dart';

/// The drawn half of a vision story.
///
/// All seven Business Brain visuals are painted from one small vocabulary —
/// glowing nodes, thin links, travelling pulses, short labels — so the story
/// reads as a single diagram unfolding rather than seven unrelated slides.
/// Everything is a [CustomPainter] over normalised coordinates, which keeps
/// the whole presentation asset-free and cheap on mobile GPUs.
///
/// AI-hint: new scenes should reuse [_Ink] and the shared helpers below rather
/// than introducing another drawing style.

// ---------------------------------------------------------------------------
// Shared drawing vocabulary
// ---------------------------------------------------------------------------

/// Fraction of a scene spent on its entrance beat.
const double kEntranceFraction = 0.34;

/// Scattered knowledge, reused across scenes 1 and 2 so the fragments the
/// viewer saw drifting are literally the ones that get pulled into the core.
const List<Offset> _fragments = [
  Offset(-0.78, -0.52),
  Offset(-0.34, -0.74),
  Offset(0.22, -0.80),
  Offset(0.68, -0.58),
  Offset(0.86, -0.14),
  Offset(0.72, 0.36),
  Offset(0.34, 0.72),
  Offset(-0.16, 0.82),
  Offset(-0.58, 0.64),
  Offset(-0.88, 0.22),
  Offset(-0.52, -0.16),
  Offset(0.44, -0.30),
  Offset(0.18, 0.34),
  Offset(-0.28, 0.26),
];

/// Maps a global 0→1 value onto a sub-window, for staggering elements.
double _step(double t, double start, double end) =>
    ((t - start) / (end - start)).clamp(0.0, 1.0);

double _ease(double t) => Curves.easeOutCubic.transform(t.clamp(0.0, 1.0));

/// Pen colours. Gold is rationed: it marks the human, the core and the
/// resolution, never ordinary structure.
abstract final class _Ink {
  static const Color line = Color(0xFF2E3155);
  static const Color node = AppColors.textMuted;
  static const Color live = AppColors.primary;
  static const Color focus = AppColors.accent;
  static const Color flag = AppColors.statusInDevelopment;
}

void _dot(
  Canvas canvas,
  Offset at,
  double radius,
  Color color,
  double alpha, {
  double glow = 2.6,
}) {
  if (alpha <= 0.01) return;
  final a = alpha.clamp(0.0, 1.0);
  canvas.drawCircle(
    at,
    radius * glow,
    Paint()
      ..color = color.withValues(alpha: 0.13 * a)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.6),
  );
  canvas.drawCircle(at, radius, Paint()..color = color.withValues(alpha: a));
}

/// A link that draws itself from [a] toward [b] as [t] runs 0 → 1.
void _link(
  Canvas canvas,
  Offset a,
  Offset b,
  double t, {
  Color color = _Ink.line,
  double width = 1.0,
  bool dashed = false,
}) {
  if (t <= 0.01) return;
  final end = Offset.lerp(a, b, _ease(t))!;
  final paint = Paint()
    ..color = color
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round;

  if (!dashed) {
    canvas.drawLine(a, end, paint);
    return;
  }
  const dash = 5.0;
  const gap = 4.0;
  final total = (end - a).distance;
  final dir = total == 0 ? Offset.zero : (end - a) / total;
  for (var d = 0.0; d < total; d += dash + gap) {
    canvas.drawLine(a + dir * d, a + dir * math.min(d + dash, total), paint);
  }
}

/// A pulse travelling along a link — the only continuously moving element,
/// and the first thing dropped under reduced motion.
void _pulse(Canvas canvas, Offset a, Offset b, double phase, Color color) {
  final p = phase % 1.0;
  final at = Offset.lerp(a, b, p)!;
  _dot(canvas, at, 2.4, color, math.sin(p * math.pi).clamp(0.0, 1.0));
}

void _label(
  Canvas canvas,
  Offset at,
  String text,
  double alpha, {
  Color color = AppColors.textSecondary,
  double size = 10.5,
  FontWeight weight = FontWeight.w600,
  TextDirection direction = TextDirection.ltr,
}) {
  if (alpha <= 0.02) return;
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color.withValues(alpha: alpha.clamp(0.0, 1.0)),
        fontSize: size,
        fontWeight: weight,
        letterSpacing: 0.3,
      ),
    ),
    textDirection: direction,
    textAlign: TextAlign.center,
  )..layout();
  painter.paint(canvas, at - Offset(painter.width / 2, painter.height / 2));
}

/// Base for every scene painter: resolves the normalised coordinate system and
/// carries the animation inputs.
abstract class _ScenePainter extends CustomPainter {
  const _ScenePainter(this.state);

  final VisionVisualState state;

  bool get still => state.reducedMotion;
  double get entrance => still ? 1.0 : state.entrance;
  double get progress => still ? 0.0 : state.progress;

  /// Converts a normalised (-1..1) point to canvas coordinates.
  Offset p(Size size, double x, double y, double scale) =>
      Offset(size.width / 2 + x * scale, size.height / 2 + y * scale);

  double scaleOf(Size size) => math.min(size.width, size.height) / 2.2;

  @override
  bool shouldRepaint(covariant _ScenePainter old) =>
      old.state.entrance != state.entrance ||
      old.state.progress != state.progress ||
      old.state.reducedMotion != state.reducedMotion;
}

/// Wraps a painter in the box every scene visual shares.
class _Visual extends StatelessWidget {
  const _Visual(this.painter);

  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: CustomPaint(painter: painter, size: Size.infinite),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 1 — the scattered question
// ---------------------------------------------------------------------------

Widget visionImpulse(BuildContext context, VisionVisualState state) =>
    _Visual(_ImpulsePainter(state, context.t(VisionDiagramText.question)));

class _ImpulsePainter extends _ScenePainter {
  const _ImpulsePainter(super.state, this.question);

  final String question;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final centre = p(size, 0, 0, s);

    // Knowledge already in the business, but scattered and unreachable.
    for (var i = 0; i < _fragments.length; i++) {
      final t = _step(entrance, i / (_fragments.length * 1.6), 1.0);
      final drift = still
          ? Offset.zero
          : Offset(0, math.sin(progress * math.pi * 2 + i) * s * 0.012);
      _dot(
        canvas,
        p(size, _fragments[i].dx, _fragments[i].dy, s) + drift,
        2.6,
        _Ink.node,
        t * 0.75,
      );
    }

    // The question itself: one impulse, waiting.
    if (!still) {
      for (var ring = 0; ring < 3; ring++) {
        final phase = (progress * 0.9 + ring / 3) % 1.0;
        canvas.drawCircle(
          centre,
          s * (0.10 + phase * 0.30),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = _Ink.focus.withValues(
              alpha: (1 - phase) * 0.22 * entrance,
            ),
        );
      }
    }
    _dot(
      canvas,
      centre,
      6 + 2 * _ease(entrance),
      _Ink.focus,
      entrance,
      glow: 4,
    );
    // The caption is an echo of the headline, so it is the first thing to go
    // when the canvas is too small to hold it clear of the rings.
    if (s > 95) {
      _label(
        canvas,
        centre + Offset(0, s * 0.46),
        question,
        _step(entrance, 0.45, 1.0) * 0.8,
        color: AppColors.textMuted,
        size: 11,
        weight: FontWeight.w500,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 2 — grounding: the same fragments, pulled in and cited
// ---------------------------------------------------------------------------

Widget visionGrounding(BuildContext context, VisionVisualState state) =>
    _Visual(
      _GroundingPainter(
        state,
        context.tAll(VisionDiagramText.sources),
        context.t(VisionDiagramText.groundedAnswer),
      ),
    );

class _GroundingPainter extends _ScenePainter {
  const _GroundingPainter(super.state, this.sourceLabels, this.answerLabel);

  final List<String> sourceLabels;
  final String answerLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final centre = p(size, 0, 0, s);
    final pull = _ease(_step(entrance, 0.0, 0.6));

    // The loose material collapses toward the core.
    for (var i = 0; i < _fragments.length; i++) {
      final from = _fragments[i];
      final at = p(
        size,
        from.dx * (1 - pull * 0.62),
        from.dy * (1 - pull * 0.62),
        s,
      );
      _dot(canvas, at, 2.0, _Ink.node, (1 - pull * 0.55) * 0.5);
    }

    // Four of them resolve into named, cited sources.
    for (var i = 0; i < sourceLabels.length; i++) {
      final angle = -math.pi / 2 + i * math.pi / 2 + math.pi / 4;
      final at = p(size, math.cos(angle) * 0.62, math.sin(angle) * 0.62, s);
      final t = _step(entrance, 0.45 + i * 0.09, 0.95);
      _link(canvas, centre, at, t, color: _Ink.live.withValues(alpha: 0.55));
      if (!still && t > 0.9) {
        _pulse(canvas, at, centre, progress * 0.8 + i * 0.25, _Ink.live);
      }
      _dot(canvas, at, 4, _Ink.live, t);
      _label(
        canvas,
        at + Offset(math.cos(angle), math.sin(angle)) * (s * 0.16),
        sourceLabels[i],
        t,
        size: 10,
        color: AppColors.textSecondary,
      );
    }

    // The answer, bound to what was cited.
    _dot(canvas, centre, 9, _Ink.focus, entrance, glow: 4.2);
    canvas.drawCircle(
      centre,
      s * 0.17 * _ease(entrance),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = _Ink.focus.withValues(alpha: 0.35 * entrance),
    );
    _label(
      canvas,
      centre + Offset(0, s * 0.30),
      answerLabel,
      _step(entrance, 0.7, 1.0),
      color: AppColors.accent,
      size: 11,
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 3 — the knowledge loop, with a human gate
// ---------------------------------------------------------------------------

Widget visionLoop(BuildContext context, VisionVisualState state) => _Visual(
  _LoopPainter(
    state,
    context.tAll(VisionDiagramText.loopStations),
    context.t(VisionDiagramText.confirmedKnowledge),
  ),
);

class _LoopPainter extends _ScenePainter {
  const _LoopPainter(super.state, this.stations, this.confirmedLabel);

  final List<String> stations;
  final String confirmedLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final centre = p(size, 0, 0, s);
    final r = s * 0.60;

    // The loop is drawn, not implied — it is the product.
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: r),
      -math.pi / 2,
      2 * math.pi * _ease(entrance),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round
        ..color = _Ink.line,
    );

    for (var i = 0; i < stations.length; i++) {
      final angle = -math.pi / 2 + i * math.pi / 2;
      final at = centre + Offset(math.cos(angle) * r, math.sin(angle) * r);
      final t = _step(entrance, 0.2 + i * 0.16, 0.85 + i * 0.04);
      // The human gate is the one station that is allowed to be gold.
      final human = i == stations.length - 1;
      _dot(
        canvas,
        at,
        human ? 6 : 4.5,
        human ? _Ink.focus : _Ink.live,
        t,
        glow: human ? 4 : 2.6,
      );
      // Top and bottom stations label outward; the side stations label
      // upward, because outward there would run past the edge of the box.
      final offset = i.isEven
          ? Offset(math.cos(angle), math.sin(angle)) * (s * 0.20)
          : Offset(0, -s * 0.17);
      _label(
        canvas,
        at + offset,
        stations[i],
        t,
        color: human ? AppColors.accent : AppColors.textSecondary,
      );
    }

    // One item moving through the loop, so the cycle reads as a process.
    if (!still) {
      final angle = -math.pi / 2 + progress * 2 * math.pi;
      _dot(
        canvas,
        centre + Offset(math.cos(angle) * r, math.sin(angle) * r),
        3.2,
        AppColors.textPrimary,
        entrance,
      );
    }

    _label(
      canvas,
      centre,
      confirmedLabel,
      _step(entrance, 0.75, 1.0),
      color: AppColors.textMuted,
      size: 11,
      weight: FontWeight.w500,
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 4 — several kinds of expertise on one question
// ---------------------------------------------------------------------------

Widget visionManyMinds(BuildContext context, VisionVisualState state) =>
    _Visual(
      _ManyMindsPainter(
        state,
        context.tAll(VisionDiagramText.disciplines),
        context.t(VisionDiagramText.theQuestion),
        context.t(VisionDiagramText.compared),
        context.t(VisionDiagramText.lowConfidence),
      ),
    );

class _ManyMindsPainter extends _ScenePainter {
  const _ManyMindsPainter(
    super.state,
    this.disciplines,
    this.questionLabel,
    this.comparedLabel,
    this.flagLabel,
  );

  final List<String> disciplines;
  final String questionLabel;
  final String comparedLabel;
  final String flagLabel;

  /// The lane deliberately drawn as unresolved: the vision is to surface
  /// disagreement, not to hide it behind one confident voice.
  static const int _flagged = 1;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final source = p(size, -0.88, 0, s);
    final synthesis = p(size, 0.86, 0, s);

    for (var i = 0; i < disciplines.length; i++) {
      final y = -0.56 + i * 0.28;
      final node = p(size, 0.0, y, s);
      final flagged = i == _flagged;
      final inT = _step(entrance, 0.05 + i * 0.07, 0.55);
      final outT = _step(entrance, 0.45 + i * 0.07, 0.95);

      _link(canvas, source, node, inT, color: _Ink.line);
      _link(
        canvas,
        node,
        synthesis,
        outT,
        color: flagged
            ? _Ink.flag.withValues(alpha: 0.75)
            : _Ink.live.withValues(alpha: 0.5),
        dashed: flagged,
      );

      if (!still && outT > 0.9) {
        _pulse(canvas, source, node, progress * 1.1 + i * 0.19, _Ink.node);
      }
      _dot(
        canvas,
        node,
        flagged ? 5 : 4.5,
        flagged ? _Ink.flag : _Ink.live,
        inT,
      );
      _label(
        canvas,
        node + Offset(0, -s * 0.13),
        disciplines[i],
        inT,
        size: 10,
      );
    }

    _dot(canvas, source, 7, _Ink.focus, _step(entrance, 0, 0.3), glow: 3.6);
    _label(
      canvas,
      source + Offset(0, s * 0.20),
      questionLabel,
      _step(entrance, 0.1, 0.4),
      color: AppColors.textMuted,
      size: 10,
      weight: FontWeight.w500,
    );

    final synthT = _step(entrance, 0.7, 1.0);
    _dot(canvas, synthesis, 8, _Ink.focus, synthT, glow: 4);
    _label(
      canvas,
      synthesis + Offset(0, s * 0.22),
      comparedLabel,
      synthT,
      color: AppColors.accent,
      size: 10.5,
    );
    // The flagged lane gets named, not quietly averaged away — but only
    // where there is room for the words.
    if (s > 95) {
      _label(
        canvas,
        p(size, 0.40, 0.13, s),
        flagLabel,
        _step(entrance, 0.8, 1.0),
        color: AppColors.statusInDevelopment,
        size: 9.5,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 5 — insight becomes a prioritised plan
// ---------------------------------------------------------------------------

Widget visionAction(BuildContext context, VisionVisualState state) => _Visual(
  _ActionPainter(
    state,
    context.tAll(VisionDiagramText.actionFacets),
    context.t(VisionDiagramText.step),
  ),
);

class _ActionPainter extends _ScenePainter {
  const _ActionPainter(super.state, this.facets, this.stepLabel);

  final List<String> facets;
  final String stepLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    // Sized off the box rather than off `s` alone: on a phone the visual is
    // wide and short, and cards scaled purely by `s` would collapse under
    // their own labels.
    final cardW = math.min(s * 1.56, size.width * 0.88);
    // Three cards, two gaps and the head node above them all have to fit the
    // box: 1.5 + 3 + 2x0.46 card-heights, plus a little margin.
    final cardH = math
        .max(s * 0.30, 26.0)
        .clamp(20.0, (size.height - 10) / 5.42);
    final gap = cardH * 0.46;
    // Below this the facet chips stop fitting, so the card shows its rank
    // and its priority weight only.
    final compact = cardW < 210;

    final blockHeight = 3 * cardH + 2 * gap;
    final blockTop = math.max(
      cardH * 1.5,
      size.height / 2 - blockHeight / 2 + cardH * 0.55,
    );
    final head = Offset(size.width / 2, blockTop - cardH * 0.95);

    _dot(canvas, head, 7, _Ink.focus, _step(entrance, 0, 0.25), glow: 3.6);

    Rect? previous;
    for (var i = 0; i < 3; i++) {
      final t = _ease(_step(entrance, 0.18 + i * 0.16, 0.70 + i * 0.12));
      if (t <= 0.01) continue;
      // Cards settle in from the right; under reduced motion they are simply
      // already in place.
      final dx = still ? 0.0 : (1 - t) * s * 0.28;
      final rect = Rect.fromLTWH(
        (size.width - cardW) / 2 + dx,
        blockTop + i * (cardH + gap),
        cardW,
        cardH,
      );
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));

      // A chain from card to card, so no connector ever runs behind one.
      _link(
        canvas,
        previous == null ? head : Offset(previous.center.dx, previous.bottom),
        Offset(rect.center.dx, rect.top),
        _step(entrance, 0.12 + i * 0.16, 0.6),
        color: _Ink.line,
      );
      previous = rect;

      canvas.drawRRect(
        rrect,
        Paint()..color = AppColors.surfaceVariant.withValues(alpha: 0.9 * t),
      );
      canvas.drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = (i == 0 ? _Ink.focus : _Ink.line).withValues(
            alpha: (i == 0 ? 0.55 : 1.0) * t,
          ),
      );
      // Priority reads as rank down the left edge, strongest at the top.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            rect.left + 10,
            rect.center.dy - cardH * 0.22,
            3,
            cardH * 0.44,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = _Ink.focus.withValues(alpha: (0.9 - i * 0.28) * t),
      );

      _label(
        canvas,
        Offset(compact ? rect.center.dx : rect.left + 52, rect.center.dy),
        '$stepLabel ${i + 1}',
        t,
        color: i == 0 ? AppColors.accent : AppColors.textSecondary,
        size: 11,
      );

      if (compact) continue;
      for (var f = 0; f < facets.length; f++) {
        _label(
          canvas,
          Offset(rect.left + cardW * (0.46 + f * 0.19), rect.center.dy),
          facets[f],
          t * 0.85,
          color: AppColors.textMuted,
          size: 9.5,
          weight: FontWeight.w500,
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 6 — the record a business builds up over months
// ---------------------------------------------------------------------------

Widget visionMemory(BuildContext context, VisionVisualState state) =>
    _Visual(_MemoryPainter(state, context.t(VisionDiagramText.companyMemory)));

class _MemoryPainter extends _ScenePainter {
  const _MemoryPainter(super.state, this.memoryLabel);

  final String memoryLabel;

  static const int _rings = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final centre = p(size, 0, 0, s);
    // A very slow drift: growth over months, not a spinner.
    final drift = still ? 0.0 : progress * 0.10;

    for (var ring = 0; ring < _rings; ring++) {
      final t = _step(entrance, ring * 0.13, 0.55 + ring * 0.10);
      if (t <= 0.01) continue;
      final radius = s * (0.26 + ring * 0.16);
      canvas.drawCircle(
        centre,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = _Ink.line.withValues(alpha: t),
      );

      // Each mark is a decision that was made and later reviewed.
      final marks = 4 + ring * 2;
      for (var m = 0; m < marks; m++) {
        final angle = (m / marks + drift + ring * 0.07) * 2 * math.pi;
        final at =
            centre + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
        final worked = (m + ring) % 3 != 0;
        _dot(
          canvas,
          at,
          worked ? 3.0 : 2.2,
          worked ? _Ink.focus : _Ink.node,
          t * (worked ? 0.9 : 0.45),
          glow: worked ? 3 : 1.8,
        );
      }
    }

    _dot(canvas, centre, 7, _Ink.focus, entrance, glow: 4);
    _label(
      canvas,
      centre + Offset(0, s * 0.13),
      memoryLabel,
      _step(entrance, 0.6, 1.0),
      color: AppColors.textMuted,
      size: 10.5,
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 7 — the whole thing, resolved
// ---------------------------------------------------------------------------

const List<Offset> _constellation = [
  Offset(0, 0),
  Offset(-0.66, -0.42),
  Offset(0.04, -0.68),
  Offset(0.70, -0.40),
  Offset(-0.80, 0.16),
  Offset(0.82, 0.18),
  Offset(-0.44, 0.62),
  Offset(0.30, 0.70),
];

Widget visionConstellation(BuildContext context, VisionVisualState state) =>
    _Visual(_ConstellationPainter(state));

class _ConstellationPainter extends _ScenePainter {
  const _ConstellationPainter(super.state);

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    // A slow breath, so the closing frame is calm rather than static.
    final breath = still ? 1.0 : 1 + math.sin(progress * math.pi * 2) * 0.012;
    final centre = p(size, 0, 0, s);

    Offset at(int i) =>
        centre +
        Offset(_constellation[i].dx, _constellation[i].dy) * s * breath;

    for (var i = 1; i < _constellation.length; i++) {
      _link(
        canvas,
        at(0),
        at(i),
        _step(entrance, 0.1 + i * 0.06, 0.75),
        color: _Ink.line,
      );
    }
    // The outer ring closes on itself: a system, not a hub and spokes.
    for (var i = 1; i < _constellation.length; i++) {
      final next = i == _constellation.length - 1 ? 1 : i + 1;
      _link(
        canvas,
        at(i),
        at(next),
        _step(entrance, 0.45 + i * 0.05, 1.0),
        color: _Ink.line.withValues(alpha: 0.6),
      );
    }

    for (var i = 1; i < _constellation.length; i++) {
      final t = _step(entrance, 0.1 + i * 0.06, 0.7);
      _dot(canvas, at(i), 4, _Ink.live, t);
      if (!still) {
        _pulse(canvas, at(i), at(0), progress * 0.6 + i * 0.12, _Ink.focus);
      }
    }

    final coreT = _step(entrance, 0.55, 1.0);
    canvas.drawCircle(
      at(0),
      s * 0.24 * _ease(coreT),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = _Ink.focus.withValues(alpha: 0.30 * coreT),
    );
    _dot(canvas, at(0), 10, _Ink.focus, entrance, glow: 5);
  }
}
