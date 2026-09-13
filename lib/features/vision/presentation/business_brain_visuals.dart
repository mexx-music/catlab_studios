import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_diagram_text.dart';
import 'package:catlab_studios/features/vision/presentation/vision_paint.dart';

/// The drawn half of the Business Brain vision story.
///
/// Its visual language is knowledge: scattered fragments that collapse into a
/// cited core, a loop with a human gate, rings that accumulate like the record
/// of a business. Everything is painted from the shared vocabulary in
/// [vision_paint.dart], so it sits beside the Master Chat story as a sibling
/// rather than a different product.

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

// ---------------------------------------------------------------------------
// Scene 1 — the scattered question
// ---------------------------------------------------------------------------

Widget visionImpulse(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _ImpulsePainter(state, context.t(BusinessBrainDiagramText.question)),
    );

class _ImpulsePainter extends VisionScenePainter {
  const _ImpulsePainter(super.state, this.question);

  final String question;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final centre = p(size, 0, 0, s);

    // Knowledge already in the business, but scattered and unreachable.
    for (var i = 0; i < _fragments.length; i++) {
      final t = visionStep(entrance, i / (_fragments.length * 1.6), 1.0);
      final drift = still
          ? Offset.zero
          : Offset(0, math.sin(progress * math.pi * 2 + i) * s * 0.012);
      visionDot(
        canvas,
        p(size, _fragments[i].dx, _fragments[i].dy, s) + drift,
        2.6,
        VisionInk.node,
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
            ..color = VisionInk.focus.withValues(
              alpha: (1 - phase) * 0.22 * entrance,
            ),
        );
      }
    }
    visionDot(
      canvas,
      centre,
      6 + 2 * visionEase(entrance),
      VisionInk.focus,
      entrance,
      glow: 4,
    );
    // The caption is an echo of the headline, so it is the first thing to go
    // when the canvas is too small to hold it clear of the rings.
    if (s > 95) {
      visionLabel(
        canvas,
        centre + Offset(0, s * 0.46),
        question,
        visionStep(entrance, 0.45, 1.0) * 0.8,
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
    VisionVisualBox(
      _GroundingPainter(
        state,
        context.tAll(BusinessBrainDiagramText.sources),
        context.t(BusinessBrainDiagramText.groundedAnswer),
      ),
    );

class _GroundingPainter extends VisionScenePainter {
  const _GroundingPainter(super.state, this.sourceLabels, this.answerLabel);

  final List<String> sourceLabels;
  final String answerLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final centre = p(size, 0, 0, s);
    final pull = visionEase(visionStep(entrance, 0.0, 0.6));

    // The loose material collapses toward the core.
    for (var i = 0; i < _fragments.length; i++) {
      final from = _fragments[i];
      final at = p(
        size,
        from.dx * (1 - pull * 0.62),
        from.dy * (1 - pull * 0.62),
        s,
      );
      visionDot(canvas, at, 2.0, VisionInk.node, (1 - pull * 0.55) * 0.5);
    }

    // Four of them resolve into named, cited sources.
    for (var i = 0; i < sourceLabels.length; i++) {
      final angle = -math.pi / 2 + i * math.pi / 2 + math.pi / 4;
      final at = p(size, math.cos(angle) * 0.62, math.sin(angle) * 0.62, s);
      final t = visionStep(entrance, 0.45 + i * 0.09, 0.95);
      visionLink(
        canvas,
        centre,
        at,
        t,
        color: VisionInk.live.withValues(alpha: 0.55),
      );
      if (!still && t > 0.9) {
        visionPulse(
          canvas,
          at,
          centre,
          progress * 0.8 + i * 0.25,
          VisionInk.live,
        );
      }
      visionDot(canvas, at, 4, VisionInk.live, t);
      visionLabel(
        canvas,
        at + Offset(math.cos(angle), math.sin(angle)) * (s * 0.16),
        sourceLabels[i],
        t,
        size: 10,
        color: AppColors.textSecondary,
      );
    }

    // The answer, bound to what was cited.
    visionDot(canvas, centre, 9, VisionInk.focus, entrance, glow: 4.2);
    canvas.drawCircle(
      centre,
      s * 0.17 * visionEase(entrance),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = VisionInk.focus.withValues(alpha: 0.35 * entrance),
    );
    visionLabel(
      canvas,
      centre + Offset(0, s * 0.30),
      answerLabel,
      visionStep(entrance, 0.7, 1.0),
      color: AppColors.accent,
      size: 11,
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 3 — the knowledge loop, with a human gate
// ---------------------------------------------------------------------------

Widget visionLoop(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _LoopPainter(
        state,
        context.tAll(BusinessBrainDiagramText.loopStations),
        context.t(BusinessBrainDiagramText.confirmedKnowledge),
      ),
    );

class _LoopPainter extends VisionScenePainter {
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
      2 * math.pi * visionEase(entrance),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round
        ..color = VisionInk.line,
    );

    for (var i = 0; i < stations.length; i++) {
      final angle = -math.pi / 2 + i * math.pi / 2;
      final at = centre + Offset(math.cos(angle) * r, math.sin(angle) * r);
      final t = visionStep(entrance, 0.2 + i * 0.16, 0.85 + i * 0.04);
      // The human gate is the one station that is allowed to be gold.
      final human = i == stations.length - 1;
      visionDot(
        canvas,
        at,
        human ? 6 : 4.5,
        human ? VisionInk.focus : VisionInk.live,
        t,
        glow: human ? 4 : 2.6,
      );
      // Top and bottom stations label outward; the side stations label
      // upward, because outward there would run past the edge of the box.
      final offset = i.isEven
          ? Offset(math.cos(angle), math.sin(angle)) * (s * 0.20)
          : Offset(0, -s * 0.17);
      visionLabel(
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
      visionDot(
        canvas,
        centre + Offset(math.cos(angle) * r, math.sin(angle) * r),
        3.2,
        AppColors.textPrimary,
        entrance,
      );
    }

    visionLabel(
      canvas,
      centre,
      confirmedLabel,
      visionStep(entrance, 0.75, 1.0),
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
    VisionVisualBox(
      _ManyMindsPainter(
        state,
        context.tAll(BusinessBrainDiagramText.disciplines),
        context.t(BusinessBrainDiagramText.theQuestion),
        context.t(BusinessBrainDiagramText.compared),
        context.t(BusinessBrainDiagramText.lowConfidence),
      ),
    );

class _ManyMindsPainter extends VisionScenePainter {
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
      final inT = visionStep(entrance, 0.05 + i * 0.07, 0.55);
      final outT = visionStep(entrance, 0.45 + i * 0.07, 0.95);

      visionLink(canvas, source, node, inT, color: VisionInk.line);
      visionLink(
        canvas,
        node,
        synthesis,
        outT,
        color: flagged
            ? VisionInk.flag.withValues(alpha: 0.75)
            : VisionInk.live.withValues(alpha: 0.5),
        dashed: flagged,
      );

      if (!still && outT > 0.9) {
        visionPulse(
          canvas,
          source,
          node,
          progress * 1.1 + i * 0.19,
          VisionInk.node,
        );
      }
      visionDot(
        canvas,
        node,
        flagged ? 5 : 4.5,
        flagged ? VisionInk.flag : VisionInk.live,
        inT,
      );
      visionLabel(
        canvas,
        node + Offset(0, -s * 0.13),
        disciplines[i],
        inT,
        size: 10,
      );
    }

    visionDot(
      canvas,
      source,
      7,
      VisionInk.focus,
      visionStep(entrance, 0, 0.3),
      glow: 3.6,
    );
    visionLabel(
      canvas,
      source + Offset(0, s * 0.20),
      questionLabel,
      visionStep(entrance, 0.1, 0.4),
      color: AppColors.textMuted,
      size: 10,
      weight: FontWeight.w500,
    );

    final synthT = visionStep(entrance, 0.7, 1.0);
    visionDot(canvas, synthesis, 8, VisionInk.focus, synthT, glow: 4);
    visionLabel(
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
      visionLabel(
        canvas,
        p(size, 0.42, -0.04, s),
        flagLabel,
        visionStep(entrance, 0.8, 1.0),
        color: AppColors.statusInDevelopment,
        size: 9.5,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 5 — insight becomes a prioritised plan
// ---------------------------------------------------------------------------

Widget visionAction(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _ActionPainter(
        state,
        context.tAll(BusinessBrainDiagramText.actionFacets),
        context.t(BusinessBrainDiagramText.step),
      ),
    );

class _ActionPainter extends VisionScenePainter {
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

    visionDot(
      canvas,
      head,
      7,
      VisionInk.focus,
      visionStep(entrance, 0, 0.25),
      glow: 3.6,
    );

    Rect? previous;
    for (var i = 0; i < 3; i++) {
      final t = visionEase(
        visionStep(entrance, 0.18 + i * 0.16, 0.70 + i * 0.12),
      );
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
      visionLink(
        canvas,
        previous == null ? head : Offset(previous.center.dx, previous.bottom),
        Offset(rect.center.dx, rect.top),
        visionStep(entrance, 0.12 + i * 0.16, 0.6),
        color: VisionInk.line,
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
          ..color = (i == 0 ? VisionInk.focus : VisionInk.line).withValues(
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
        Paint()
          ..color = VisionInk.focus.withValues(alpha: (0.9 - i * 0.28) * t),
      );

      visionLabel(
        canvas,
        Offset(compact ? rect.center.dx : rect.left + 52, rect.center.dy),
        '$stepLabel ${i + 1}',
        t,
        color: i == 0 ? AppColors.accent : AppColors.textSecondary,
        size: 11,
      );

      if (compact) continue;
      for (var f = 0; f < facets.length; f++) {
        visionLabel(
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
    VisionVisualBox(
      _MemoryPainter(state, context.t(BusinessBrainDiagramText.companyMemory)),
    );

class _MemoryPainter extends VisionScenePainter {
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
      final t = visionStep(entrance, ring * 0.13, 0.55 + ring * 0.10);
      if (t <= 0.01) continue;
      final radius = s * (0.26 + ring * 0.16);
      canvas.drawCircle(
        centre,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = VisionInk.line.withValues(alpha: t),
      );

      // Each mark is a decision that was made and later reviewed.
      final marks = 4 + ring * 2;
      for (var m = 0; m < marks; m++) {
        final angle = (m / marks + drift + ring * 0.07) * 2 * math.pi;
        final at =
            centre + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
        final worked = (m + ring) % 3 != 0;
        visionDot(
          canvas,
          at,
          worked ? 3.0 : 2.2,
          worked ? VisionInk.focus : VisionInk.node,
          t * (worked ? 0.9 : 0.45),
          glow: worked ? 3 : 1.8,
        );
      }
    }

    visionDot(canvas, centre, 7, VisionInk.focus, entrance, glow: 4);
    visionLabel(
      canvas,
      centre + Offset(0, s * 0.13),
      memoryLabel,
      visionStep(entrance, 0.6, 1.0),
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
    VisionVisualBox(_ConstellationPainter(state));

class _ConstellationPainter extends VisionScenePainter {
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
      visionLink(
        canvas,
        at(0),
        at(i),
        visionStep(entrance, 0.1 + i * 0.06, 0.75),
        color: VisionInk.line,
      );
    }
    // The outer ring closes on itself: a system, not a hub and spokes.
    for (var i = 1; i < _constellation.length; i++) {
      final next = i == _constellation.length - 1 ? 1 : i + 1;
      visionLink(
        canvas,
        at(i),
        at(next),
        visionStep(entrance, 0.45 + i * 0.05, 1.0),
        color: VisionInk.line.withValues(alpha: 0.6),
      );
    }

    for (var i = 1; i < _constellation.length; i++) {
      final t = visionStep(entrance, 0.1 + i * 0.06, 0.7);
      visionDot(canvas, at(i), 4, VisionInk.live, t);
      if (!still) {
        visionPulse(
          canvas,
          at(i),
          at(0),
          progress * 0.6 + i * 0.12,
          VisionInk.focus,
        );
      }
    }

    final coreT = visionStep(entrance, 0.55, 1.0);
    canvas.drawCircle(
      at(0),
      s * 0.24 * visionEase(coreT),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = VisionInk.focus.withValues(alpha: 0.30 * coreT),
    );
    visionDot(canvas, at(0), 10, VisionInk.focus, entrance, glow: 5);
  }
}
