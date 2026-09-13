import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_diagram_text.dart';
import 'package:catlab_studios/features/vision/presentation/vision_paint.dart';

/// The drawn half of the Master Chat vision story.
///
/// Where Business Brain draws *knowledge* — fragments, orbits, rings — this
/// story draws *interfaces*: panels, lanes and doors. Same ink, same restraint
/// with gold, same shared toolkit in [vision_paint.dart]; a different picture,
/// because the argument is a different one. Eight scenes move one shape from
/// scattered windows to a single layered system.
///
/// AI-hint: keep the panel as this story's unit. A node-and-orbit diagram here
/// would make the two stories look like the same slide deck.

// ---------------------------------------------------------------------------
// Panel — this story's equivalent of Business Brain's glowing node
// ---------------------------------------------------------------------------

/// An application window, reduced to the two things that make one readable:
/// a title bar and a body.
void _panel(
  Canvas canvas,
  Rect rect,
  double t, {
  Color border = VisionInk.line,
  Color? fill,
  double borderWidth = 1,
  bool titleBar = true,
}) {
  if (t <= 0.01) return;
  final a = t.clamp(0.0, 1.0);
  final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(7));

  canvas.drawRRect(
    rrect,
    Paint()
      ..color = (fill ?? AppColors.surfaceVariant).withValues(alpha: 0.85 * a),
  );
  canvas.drawRRect(
    rrect,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = border.withValues(alpha: a),
  );
  if (!titleBar || rect.height < 16) return;
  // One short line where a window's title would be: enough to read as an
  // interface without drawing chrome nobody looks at.
  canvas.drawLine(
    Offset(rect.left + 7, rect.top + 8),
    Offset(rect.left + math.min(rect.width * 0.45, 26), rect.top + 8),
    Paint()
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..color = border.withValues(alpha: 0.75 * a),
  );
}

/// The caret-and-line that says "this is where you speak to it".
void _promptLine(Canvas canvas, Rect rect, double t, {double inset = 10}) {
  if (t <= 0.02) return;
  final y = rect.bottom - 13;
  final paint = Paint()
    ..strokeWidth = 1.4
    ..strokeCap = StrokeCap.round
    ..color = VisionInk.focus.withValues(alpha: 0.75 * t);
  canvas.drawLine(
    Offset(rect.left + inset, y),
    Offset(rect.left + inset + (rect.width - inset * 2) * 0.55 * t, y),
    paint,
  );
}

// ---------------------------------------------------------------------------
// Scene 1 — an app for everything, and nothing joined up
// ---------------------------------------------------------------------------

/// Deliberately irregular: real desktops are not grids.
const List<Offset> _scatter = [
  Offset(-0.74, -0.62),
  Offset(-0.06, -0.80),
  Offset(0.62, -0.66),
  Offset(-0.88, 0.02),
  Offset(0.86, -0.02),
  Offset(-0.66, 0.62),
  Offset(0.04, 0.78),
  Offset(0.70, 0.60),
];

Widget masterChatScatteredApps(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _ScatteredAppsPainter(
        state,
        context.tAll(MasterChatDiagramText.scatteredApps),
      ),
    );

class _ScatteredAppsPainter extends VisionScenePainter {
  const _ScatteredAppsPainter(super.state, this.labels);

  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final w = s * 0.46;
    final h = s * 0.30;

    for (var i = 0; i < _scatter.length && i < labels.length; i++) {
      final t = visionStep(entrance, i / (_scatter.length * 1.5), 0.9);
      if (t <= 0.01) continue;
      // Each window drifts on its own phase: eight things, eight rhythms,
      // none of them aware of the others.
      final drift = still
          ? Offset.zero
          : Offset(
              math.sin(progress * math.pi * 2 + i) * s * 0.012,
              math.cos(progress * math.pi * 2 + i * 1.7) * s * 0.014,
            );
      final centre = p(size, _scatter[i].dx, _scatter[i].dy, s) + drift;
      final rect = Rect.fromCenter(center: centre, width: w, height: h);
      _panel(canvas, rect, t);
      visionLabel(
        canvas,
        centre + Offset(0, 4),
        labels[i],
        t * 0.9,
        size: 9.5,
        color: AppColors.textSecondary,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 2 — the windows collapse into one surface
// ---------------------------------------------------------------------------

Widget masterChatOneSurface(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _OneSurfacePainter(
        state,
        context.tAll(MasterChatDiagramText.scatteredApps),
        context.t(MasterChatDiagramText.oneConversation),
      ),
    );

class _OneSurfacePainter extends VisionScenePainter {
  const _OneSurfacePainter(super.state, this.labels, this.caption);

  final List<String> labels;
  final String caption;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final pull = visionEase(visionStep(entrance, 0.0, 0.62));
    final centre = p(size, 0, 0, s);

    // The same eight windows as scene one, travelling inward and fading as
    // the one surface takes over.
    for (var i = 0; i < _scatter.length && i < labels.length; i++) {
      final from = _scatter[i];
      final at = p(size, from.dx * (1 - pull), from.dy * (1 - pull), s);
      final fade = (1 - pull).clamp(0.0, 1.0);
      if (fade <= 0.02) continue;
      final rect = Rect.fromCenter(
        center: at,
        width: s * 0.46 * (1 - pull * 0.45),
        height: s * 0.30 * (1 - pull * 0.45),
      );
      _panel(canvas, rect, fade * 0.7);
      visionLabel(canvas, at + Offset(0, 4), labels[i], fade * 0.7, size: 9);
    }

    // The Master Chat panel: the one window that stays.
    final appear = visionEase(visionStep(entrance, 0.35, 0.95));
    if (appear <= 0.01) return;
    final panel = Rect.fromCenter(
      center: centre,
      width: s * 1.24 * appear,
      height: s * 0.72 * appear,
    );
    _panel(
      canvas,
      panel,
      appear,
      border: VisionInk.focus,
      borderWidth: 1.3,
      fill: AppColors.surface,
    );
    _promptLine(canvas, panel, appear);
    // The microphone, as a peer of the prompt rather than a feature of it.
    visionDot(
      canvas,
      Offset(panel.right - 16, panel.bottom - 13),
      3.4,
      VisionInk.focus,
      appear,
    );
    visionLabel(
      canvas,
      centre + Offset(0, s * 0.56),
      caption,
      visionStep(entrance, 0.75, 1.0),
      color: AppColors.accent,
      size: 10.5,
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 3 — the task arrives, and the capability that fits lights up
// ---------------------------------------------------------------------------

Widget masterChatCapabilities(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _CapabilitiesPainter(
        state,
        context.tAll(MasterChatDiagramText.capabilityNames),
        context.t(MasterChatDiagramText.yourTask),
      ),
    );

class _CapabilitiesPainter extends VisionScenePainter {
  const _CapabilitiesPainter(super.state, this.names, this.taskLabel);

  final List<String> names;
  final String taskLabel;

  /// The one the task turns out to need. Everything else stays available and
  /// simply does not light up — which is the point being made.
  static const int _chosen = 0;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    // Sized off the box, not off the drawing scale alone: the labels are
    // absolute pixels, and a purely scaled row collapses under them on a
    // phone.
    final rowWidth = math.min(s * 1.00, size.width * 0.56);
    final pitch = math.min(
      math.max(s * 0.34, 24.0),
      (size.height - 6) / names.length,
    );
    final rowHeight = pitch * 0.78;

    final hubRect = Rect.fromCenter(
      center: Offset(size.width * 0.15, size.height / 2),
      width: math.min(s * 0.44, size.width * 0.15),
      height: math.min(s * 0.58, pitch * 1.8),
    );
    final hubT = visionStep(entrance, 0, 0.3);
    _panel(
      canvas,
      hubRect,
      hubT,
      border: VisionInk.focus,
      borderWidth: 1.3,
      fill: AppColors.surface,
      titleBar: false,
    );
    if (hubRect.height > 26) _promptLine(canvas, hubRect, hubT, inset: 6);
    if (s > 95) {
      visionLabel(
        canvas,
        Offset(hubRect.center.dx, hubRect.bottom + s * 0.20),
        taskLabel,
        visionStep(entrance, 0.15, 0.45),
        size: 9.5,
        color: AppColors.textMuted,
        weight: FontWeight.w500,
      );
    }

    final blockTop = size.height / 2 - (names.length * pitch) / 2;
    final rowX = size.width - rowWidth / 2 - 6;

    for (var i = 0; i < names.length; i++) {
      final t = visionStep(entrance, 0.15 + i * 0.10, 0.70 + i * 0.06);
      if (t <= 0.01) continue;
      final centreY = blockTop + i * pitch + pitch / 2;
      final chosen = i == _chosen;
      // The match arrives last, so the eye sees the choice being made.
      final lit = chosen ? visionStep(entrance, 0.62, 0.92) : 0.0;

      final rect = Rect.fromCenter(
        center: Offset(rowX, centreY),
        width: rowWidth,
        height: rowHeight,
      );
      visionLink(
        canvas,
        Offset(hubRect.right, hubRect.center.dy),
        Offset(rect.left, centreY),
        t,
        color: chosen
            ? VisionInk.focus.withValues(alpha: 0.30 + 0.50 * lit)
            : VisionInk.line,
      );
      _panel(
        canvas,
        rect,
        t,
        border: chosen
            ? Color.lerp(VisionInk.line, VisionInk.focus, lit)!
            : VisionInk.line,
        borderWidth: chosen ? 1 + 0.4 * lit : 1,
        titleBar: false,
      );
      // On a narrow row the marker and the word crowd each other, so the
      // border colour carries the match on its own and the label centres.
      final roomForDot = rowWidth >= 150;
      if (roomForDot) {
        visionDot(
          canvas,
          Offset(rect.left + 10, centreY),
          3.0,
          chosen ? VisionInk.focus : VisionInk.node,
          chosen ? t * (0.45 + 0.55 * lit) : t * 0.5,
        );
      }
      visionLabel(
        canvas,
        Offset(
          roomForDot ? rect.left + 10 + rowWidth * 0.32 : rect.center.dx,
          centreY,
        ),
        names[i],
        t,
        size: 9.5,
        color: chosen
            ? Color.lerp(AppColors.textSecondary, AppColors.accent, lit)!
            : AppColors.textMuted,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 4 — spoken in, calculator out. Shown, not explained.
// ---------------------------------------------------------------------------

Widget masterChatOneState(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _OneStatePainter(state, context.t(MasterChatDiagramText.spokenPhrase), [
        context.t(MasterChatDiagramText.inputVoice),
        context.t(MasterChatDiagramText.inputKeyboard),
        context.t(MasterChatDiagramText.inputKeys),
      ]),
    );

class _OneStatePainter extends VisionScenePainter {
  const _OneStatePainter(super.state, this.phrase, this.inputs);

  final String phrase;
  final List<String> inputs;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    // 1. What the person says.
    final said = Rect.fromCenter(
      center: Offset(size.width * 0.22, size.height * 0.30),
      width: math.min(s * 0.96, size.width * 0.40),
      height: s * 0.30,
    );
    final saidT = visionStep(entrance, 0, 0.28);
    _panel(
      canvas,
      said,
      saidT,
      border: VisionInk.focus,
      borderWidth: 1.2,
      fill: AppColors.surface,
      titleBar: false,
    );
    visionLabel(
      canvas,
      said.center,
      phrase,
      saidT,
      size: 10.5,
      color: AppColors.accent,
    );

    // 2. The calculator that appears because of it.
    final calc = Rect.fromCenter(
      center: Offset(size.width * 0.68, size.height * 0.52),
      width: math.min(s * 0.86, size.width * 0.36),
      height: math.min(s * 1.10, size.height * 0.66),
    );
    final calcT = visionEase(visionStep(entrance, 0.30, 0.70));
    visionLink(
      canvas,
      Offset(said.right, said.center.dy),
      Offset(calc.left, calc.top + calc.height * 0.18),
      visionStep(entrance, 0.24, 0.50),
      color: VisionInk.focus.withValues(alpha: 0.55),
    );
    if (calcT > 0.01) {
      _panel(
        canvas,
        calc,
        calcT,
        border: VisionInk.focus,
        borderWidth: 1.3,
        fill: AppColors.surface,
        titleBar: false,
      );
      // The display, then the result landing in it.
      final display = Rect.fromLTWH(
        calc.left + 8,
        calc.top + 8,
        calc.width - 16,
        calc.height * 0.22,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(display, const Radius.circular(5)),
        Paint()..color = AppColors.background.withValues(alpha: 0.8 * calcT),
      );
      visionLabel(
        canvas,
        Offset(display.right - 16, display.center.dy),
        '66',
        visionStep(entrance, 0.72, 0.95),
        size: 13,
        color: AppColors.accent,
        weight: FontWeight.w700,
      );
      // A hint of a keypad: enough to read as one, not a real calculator.
      for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
          final key = Offset(
            calc.left + calc.width * (0.25 + c * 0.25),
            display.bottom + calc.height * (0.18 + r * 0.22),
          );
          visionDot(
            canvas,
            key,
            2.6,
            VisionInk.node,
            visionStep(entrance, 0.55 + (r * 3 + c) * 0.015, 0.85) * 0.7,
            glow: 1.6,
          );
        }
      }
    }

    // 3. The three hands that all reach the same calculator.
    if (s > 92) {
      for (var i = 0; i < inputs.length; i++) {
        final t = visionStep(entrance, 0.70 + i * 0.07, 1.0);
        final at = Offset(size.width * 0.20, size.height * (0.62 + i * 0.13));
        visionLink(
          canvas,
          at,
          Offset(calc.left, calc.center.dy),
          t,
          color: VisionInk.live.withValues(alpha: 0.40),
        );
        visionDot(canvas, at, 3.2, VisionInk.live, t);
        visionLabel(
          canvas,
          Offset(at.dx - s * 0.26, at.dy),
          inputs[i],
          t,
          size: 9,
          color: AppColors.textSecondary,
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 5 — three steps that belong to one piece of work
// ---------------------------------------------------------------------------

Widget masterChatContext(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _ContextPainter(
        state,
        context.tAll(MasterChatDiagramText.flowSteps),
        context.t(MasterChatDiagramText.workingContext),
        context.t(MasterChatDiagramText.separateWindows),
      ),
    );

class _ContextPainter extends VisionScenePainter {
  const _ContextPainter(super.state, this.names, this.caption, this.oldWay);

  final List<String> names;
  final String caption;
  final String oldWay;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    // The old way, drawn once and then left behind at the top.
    final fadeOut = (1 - visionEase(visionStep(entrance, 0.0, 0.45))).clamp(
      0.0,
      1.0,
    );
    for (var i = 0; i < 3; i++) {
      final at = p(size, -0.62 + i * 0.62, -0.74, s);
      _panel(
        canvas,
        Rect.fromCenter(center: at, width: s * 0.40, height: s * 0.26),
        fadeOut * 0.55,
      );
    }
    if (s > 95) {
      visionLabel(
        canvas,
        p(size, 0, -0.44, s),
        oldWay,
        fadeOut * 0.6,
        size: 9,
        weight: FontWeight.w500,
        color: AppColors.textMuted,
      );
    }

    // One container, holding every step of the same job.
    final band = visionEase(visionStep(entrance, 0.25, 0.7));
    if (band <= 0.01) return;
    final container = Rect.fromCenter(
      center: p(size, 0, 0.12, s),
      width: math.min(s * 1.86, size.width * 0.92) * band,
      height: s * 0.66,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(container, const Radius.circular(12)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = VisionInk.focus.withValues(alpha: 0.45 * band),
    );

    final threadY = container.center.dy;
    visionLink(
      canvas,
      Offset(container.left + 10, threadY),
      Offset(container.right - 10, threadY),
      visionStep(entrance, 0.45, 0.9),
      color: VisionInk.line,
    );

    for (var i = 0; i < names.length; i++) {
      final t = visionStep(entrance, 0.40 + i * 0.11, 0.92);
      if (t <= 0.01) continue;
      final x = container.left + container.width * (0.20 + i * 0.30);
      final rect = Rect.fromCenter(
        center: Offset(x, threadY),
        width: container.width * 0.26,
        height: s * 0.26,
      );
      _panel(canvas, rect, t, titleBar: false);
      visionLabel(
        canvas,
        Offset(x, threadY),
        names[i],
        t,
        size: 9,
        color: AppColors.textSecondary,
      );
    }
    if (!still) {
      visionPulse(
        canvas,
        Offset(container.left + 10, threadY),
        Offset(container.right - 10, threadY),
        progress * 0.7,
        VisionInk.focus,
      );
    }
    visionLabel(
      canvas,
      Offset(container.center.dx, container.bottom + s * 0.20),
      caption,
      visionStep(entrance, 0.8, 1.0),
      color: AppColors.accent,
      size: 10,
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 6 — one task, several specialists, one result
// ---------------------------------------------------------------------------

Widget masterChatIntelligences(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _IntelligencesPainter(
        state,
        context.t(MasterChatDiagramText.yourTask),
        context.tAll(MasterChatDiagramText.specialists),
        context.t(MasterChatDiagramText.broughtTogether),
      ),
    );

class _IntelligencesPainter extends VisionScenePainter {
  const _IntelligencesPainter(
    super.state,
    this.taskLabel,
    this.specialists,
    this.mergeLabel,
  );

  final String taskLabel;
  final List<String> specialists;
  final String mergeLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    final bar = Rect.fromCenter(
      center: p(size, 0, -0.62, s),
      width: math.min(s * 1.40, size.width * 0.62),
      height: s * 0.26,
    );
    final barT = visionStep(entrance, 0, 0.35);
    _panel(
      canvas,
      bar,
      barT,
      border: VisionInk.focus,
      borderWidth: 1.2,
      fill: AppColors.surface,
      titleBar: false,
    );
    visionLabel(
      canvas,
      bar.center,
      taskLabel,
      barT,
      size: 10,
      color: AppColors.accent,
    );

    // Dashed throughout: several specialists working on one task is the
    // direction, so the picture says so before the words do.
    final merge = p(size, 0, 0.76, s);
    final spread = math.min(s * 0.48, size.width * 0.21);
    for (var i = 0; i < specialists.length; i++) {
      final at = Offset(
        size.width / 2 + (i - (specialists.length - 1) / 2) * spread,
        p(size, 0, 0.10, s).dy,
      );
      final t = visionStep(entrance, 0.32 + i * 0.09, 0.82);
      if (t <= 0.01) continue;
      visionLink(
        canvas,
        Offset(at.dx, bar.bottom),
        Offset(at.dx, at.dy - s * 0.14),
        t,
        color: VisionInk.node.withValues(alpha: 0.5),
        dashed: true,
      );
      final rect = Rect.fromCenter(
        center: at,
        width: spread * 0.86,
        height: s * 0.24,
      );
      _panel(canvas, rect, t * 0.85, titleBar: false);
      visionLabel(canvas, at, specialists[i], t * 0.9, size: 8.5);
      visionLink(
        canvas,
        Offset(at.dx, rect.bottom),
        merge,
        visionStep(entrance, 0.55 + i * 0.06, 1.0),
        color: VisionInk.node.withValues(alpha: 0.4),
        dashed: true,
      );
    }
    final mergeT = visionStep(entrance, 0.76, 1.0);
    canvas.drawCircle(
      merge,
      s * 0.13,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = VisionInk.focus.withValues(alpha: 0.55 * mergeT),
    );
    visionDot(canvas, merge, 4, VisionInk.focus, mergeT);
    if (s > 95) {
      visionLabel(
        canvas,
        Offset(merge.dx, merge.dy + s * 0.30),
        mergeLabel,
        visionStep(entrance, 0.85, 1.0),
        size: 9,
        color: AppColors.accent,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 7 — understand, choose, act, result — and the gate where you decide
// ---------------------------------------------------------------------------

Widget masterChatFlow(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _FlowPainter(
        state,
        context.tAll(MasterChatDiagramText.actionSteps),
        context.t(MasterChatDiagramText.youDecide),
      ),
    );

class _FlowPainter extends VisionScenePainter {
  const _FlowPainter(super.state, this.steps, this.gateLabel);

  final List<String> steps;
  final String gateLabel;

  /// The gate sits before the step that actually changes something.
  static const int _gateBefore = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    // A vertical chain reads better than a horizontal one here: four labels
    // side by side would each get a third of the width a word needs.
    final count = steps.length;
    final pitch = math.min(math.max(s * 0.42, 30.0), (size.height - 8) / count);
    final boxW = math.min(s * 1.20, size.width * 0.62);
    final boxH = pitch * 0.62;
    final top = size.height / 2 - (count * pitch) / 2;
    final cx = size.width * 0.52;

    for (var i = 0; i < count; i++) {
      final t = visionEase(visionStep(entrance, i * 0.13, 0.45 + i * 0.13));
      if (t <= 0.01) continue;
      final centreY = top + i * pitch + pitch / 2;
      final rect = Rect.fromCenter(
        center: Offset(cx, centreY),
        width: boxW,
        height: boxH,
      );
      final last = i == count - 1;

      if (i > 0) {
        visionLink(
          canvas,
          Offset(cx, centreY - pitch / 2 - boxH * 0.06),
          Offset(cx, rect.top),
          visionStep(entrance, i * 0.13 - 0.05, 0.4 + i * 0.13),
          color: VisionInk.line,
        );
      }
      _panel(
        canvas,
        rect,
        t,
        border: last ? VisionInk.focus : VisionInk.line,
        borderWidth: last ? 1.3 : 1,
        fill: last ? AppColors.surface : AppColors.surfaceVariant,
        titleBar: false,
      );
      visionLabel(
        canvas,
        rect.center,
        steps[i],
        t,
        size: 10,
        color: last ? AppColors.accent : AppColors.textSecondary,
      );

      // The one place the chain waits for a person.
      if (i == _gateBefore) {
        final gateT = visionStep(entrance, 0.55, 0.85);
        final gateY = rect.top - (pitch - boxH) / 2;
        canvas.drawLine(
          Offset(cx - boxW * 0.30, gateY),
          Offset(cx + boxW * 0.30, gateY),
          Paint()
            ..strokeWidth = 1.6
            ..strokeCap = StrokeCap.round
            ..color = VisionInk.focus.withValues(alpha: 0.85 * gateT),
        );
        if (s > 88) {
          visionLabel(
            canvas,
            Offset(cx + boxW * 0.30 + s * 0.34, gateY),
            gateLabel,
            gateT,
            size: 9,
            color: AppColors.accent,
          );
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 8 — the layers, resolved
// ---------------------------------------------------------------------------

Widget masterChatStack(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _StackPainter(state, context.tAll(MasterChatDiagramText.stack)),
    );

class _StackPainter extends VisionScenePainter {
  const _StackPainter(super.state, this.layers);

  final List<String> layers;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    // A slow breath, so the closing frame is calm rather than static.
    final breath = still ? 1.0 : 1 + math.sin(progress * math.pi * 2) * 0.008;
    final count = layers.length;
    final bandH = s * 0.23;
    final gap = s * 0.11;
    final totalH = count * bandH + (count - 1) * gap;
    final top = size.height / 2 - totalH / 2;

    for (var i = 0; i < count; i++) {
      final t = visionEase(visionStep(entrance, i * 0.09, 0.55 + i * 0.07));
      if (t <= 0.01) continue;
      final y = top + i * (bandH + gap);
      // The ends of the chain are the human and the result; everything
      // between them is machinery, and drawn as such.
      final ends = i == 0 || i == count - 1;
      final width = s * (ends ? 1.10 : 1.70) * breath;
      final rect = Rect.fromLTWH(size.width / 2 - width / 2, y, width, bandH);
      if (i > 0) {
        visionLink(
          canvas,
          Offset(size.width / 2, y - gap),
          Offset(size.width / 2, y),
          visionStep(entrance, i * 0.09 - 0.04, 0.5 + i * 0.07),
          color: VisionInk.line,
        );
      }
      _panel(
        canvas,
        rect,
        t,
        border: ends ? VisionInk.focus : VisionInk.line,
        borderWidth: ends ? 1.3 : 1,
        fill: ends ? AppColors.surface : AppColors.surfaceVariant,
        titleBar: false,
      );
      visionLabel(
        canvas,
        rect.center,
        layers[i],
        t,
        size: 10,
        color: ends ? AppColors.accent : AppColors.textSecondary,
      );
    }
  }
}
