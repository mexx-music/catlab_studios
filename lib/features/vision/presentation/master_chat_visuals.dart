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
// Scene 3 — what it could offer, and what it can run right now
// ---------------------------------------------------------------------------

Widget masterChatCapabilities(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _CapabilitiesPainter(
        state,
        context.tAll(MasterChatDiagramText.capabilityNames),
        [
          context.t(MasterChatDiagramText.capabilityReady),
          context.t(MasterChatDiagramText.capabilityReady),
          context.t(MasterChatDiagramText.capabilityInactive),
          context.t(MasterChatDiagramText.capabilityBlocked),
        ],
      ),
    );

class _CapabilitiesPainter extends VisionScenePainter {
  const _CapabilitiesPainter(super.state, this.names, this.states);

  final List<String> names;
  final List<String> states;

  /// Index 0 and 1 can run; 2 is known but its module is off; 3 needs software
  /// this device cannot verify, so it blocks rather than being assumed.
  static const int _firstUnavailable = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    // Sized off the box, not off `s` alone: the labels are absolute pixels,
    // and on a phone a purely `s`-scaled row collapses under them.
    final rowWidth = math.min(s * 1.10, size.width * 0.62);
    final pitch = math.min(
      math.max(s * 0.36, 26.0),
      (size.height - 6) / names.length,
    );
    final rowHeight = pitch * 0.80;
    // Below this a row cannot hold two lines of type, so it keeps the name
    // and lets colour and the dashed link carry the state.
    final compact = rowHeight < 27 || rowWidth < 124;

    final hubWidth = math.min(s * 0.40, size.width * 0.13);
    final hubRect = Rect.fromCenter(
      center: Offset(size.width * 0.13, size.height / 2),
      width: hubWidth,
      height: math.min(s * 0.56, pitch * 1.7),
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

    final blockTop = size.height / 2 - (names.length * pitch) / 2;
    final rowX = size.width - rowWidth / 2 - 6;

    for (var i = 0; i < names.length; i++) {
      final t = visionStep(entrance, 0.15 + i * 0.12, 0.75 + i * 0.06);
      if (t <= 0.01) continue;
      final centreY = blockTop + i * pitch + pitch / 2;

      final available = i < _firstUnavailable;
      final colour = available
          ? VisionInk.live
          : (i == _firstUnavailable ? VisionInk.node : VisionInk.flag);

      final rect = Rect.fromCenter(
        center: Offset(rowX, centreY),
        width: rowWidth,
        height: rowHeight,
      );

      // An unavailable capability is still drawn — that is the whole point of
      // knowing it exists — but its line never becomes solid.
      visionLink(
        canvas,
        Offset(hubRect.right, hubRect.center.dy),
        Offset(rect.left, centreY),
        t,
        color: colour.withValues(alpha: available ? 0.55 : 0.32),
        dashed: !available,
      );

      _panel(
        canvas,
        rect,
        t * (available ? 1.0 : 0.75),
        border: colour.withValues(alpha: available ? 0.8 : 0.5),
        titleBar: false,
      );
      visionDot(
        canvas,
        Offset(rect.left + 10, centreY),
        3.0,
        colour,
        t * (available ? 1.0 : 0.6),
      );

      final textX = rect.left + 10 + rowWidth * 0.30;
      if (compact) {
        visionLabel(
          canvas,
          Offset(textX, centreY),
          names[i],
          t,
          size: 9,
          color: available ? AppColors.textPrimary : AppColors.textMuted,
        );
        continue;
      }
      // Name above, state below. Side by side, a longer word for "module not
      // active" ran straight through the capability's name.
      visionLabel(
        canvas,
        Offset(textX, centreY - 7),
        names[i],
        t,
        size: 10,
        color: AppColors.textPrimary,
      );
      visionLabel(
        canvas,
        Offset(textX, centreY + 7),
        states[i],
        t * 0.9,
        size: 8.5,
        weight: FontWeight.w500,
        color: available ? AppColors.statusAvailable : AppColors.textMuted,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 4 — one state, three hands, and a model that only ever gets a copy
// ---------------------------------------------------------------------------

Widget masterChatOneState(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _OneStatePainter(
        state,
        [
          context.t(MasterChatDiagramText.inputTouch),
          context.t(MasterChatDiagramText.inputKeys),
          context.t(MasterChatDiagramText.inputVoice),
        ],
        context.t(MasterChatDiagramText.theState),
        context.t(MasterChatDiagramText.snapshot),
        context.t(MasterChatDiagramText.intent),
        context.t(MasterChatDiagramText.model),
      ),
    );

class _OneStatePainter extends VisionScenePainter {
  const _OneStatePainter(
    super.state,
    this.inputs,
    this.stateLabel,
    this.snapshotLabel,
    this.intentLabel,
    this.modelLabel,
  );

  final List<String> inputs;
  final String stateLabel;
  final String snapshotLabel;
  final String intentLabel;
  final String modelLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final core = p(size, -0.14, 0, s);
    final coreRect = Rect.fromCenter(
      center: core,
      width: s * 0.76,
      height: s * 0.44,
    );

    // Three hands, arriving one after another, all reaching the same box.
    for (var i = 0; i < inputs.length; i++) {
      final y = -0.62 + i * 0.62;
      final from = p(size, -0.92, y, s);
      final t = visionStep(entrance, 0.05 + i * 0.10, 0.62);
      visionLink(
        canvas,
        from,
        Offset(coreRect.left, core.dy),
        t,
        color: VisionInk.live.withValues(alpha: 0.5),
      );
      if (!still && t > 0.9) {
        visionPulse(
          canvas,
          from,
          Offset(coreRect.left, core.dy),
          progress * 0.9 + i * 0.3,
          VisionInk.live,
        );
      }
      visionDot(canvas, from, 4, VisionInk.live, t);
      visionLabel(
        canvas,
        from + Offset(0, -s * 0.15),
        inputs[i],
        t,
        size: 9.5,
        color: AppColors.textSecondary,
      );
    }

    // The one value. Everything above writes here; nothing keeps a copy.
    final coreT = visionStep(entrance, 0.30, 0.72);
    _panel(
      canvas,
      coreRect,
      coreT,
      border: VisionInk.focus,
      borderWidth: 1.3,
      fill: AppColors.surface,
      titleBar: false,
    );
    visionLabel(
      canvas,
      core,
      stateLabel,
      coreT,
      size: 11,
      color: AppColors.accent,
    );

    // The model is a peer, not the owner: it reads a snapshot and writes back
    // an intent. Two arrows, deliberately in opposite directions.
    final modelCentre = p(size, 0.78, 0, s);
    final modelT = visionStep(entrance, 0.55, 0.95);
    final modelRect = Rect.fromCenter(
      center: modelCentre,
      width: s * 0.40,
      height: s * 0.30,
    );
    _panel(canvas, modelRect, modelT, titleBar: false);
    visionLabel(
      canvas,
      modelCentre,
      modelLabel,
      modelT,
      size: 9.5,
      color: AppColors.textSecondary,
    );

    final out = Offset(coreRect.right, core.dy - s * 0.10);
    final back = Offset(coreRect.right, core.dy + s * 0.10);
    visionLink(
      canvas,
      out,
      Offset(modelRect.left, modelCentre.dy - s * 0.10),
      visionStep(entrance, 0.62, 0.9),
      color: VisionInk.node.withValues(alpha: 0.6),
    );
    visionLink(
      canvas,
      Offset(modelRect.left, modelCentre.dy + s * 0.10),
      back,
      visionStep(entrance, 0.72, 1.0),
      color: VisionInk.focus.withValues(alpha: 0.7),
    );
    // On a phone these two words crowd the model panel; the arrows still
    // carry the direction, and the body text explains it.
    if (s > 115) {
      visionLabel(
        canvas,
        Offset((out.dx + modelRect.left) / 2, out.dy - s * 0.13),
        snapshotLabel,
        visionStep(entrance, 0.70, 0.95),
        size: 8.5,
        weight: FontWeight.w500,
        color: AppColors.textMuted,
      );
      visionLabel(
        canvas,
        Offset((back.dx + modelRect.left) / 2, back.dy + s * 0.13),
        intentLabel,
        visionStep(entrance, 0.80, 1.0),
        size: 8.5,
        weight: FontWeight.w500,
        color: AppColors.accent,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Scene 5 — capabilities inside one context, not in separate windows
// ---------------------------------------------------------------------------

Widget masterChatContext(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _ContextPainter(
        state,
        context.tAll(MasterChatDiagramText.capabilityNames),
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
    visionLabel(
      canvas,
      p(size, 0, -0.44, s),
      oldWay,
      fadeOut * 0.6,
      size: 9,
      weight: FontWeight.w500,
      color: AppColors.textMuted,
    );

    // One container, holding everything that follows.
    final band = visionEase(visionStep(entrance, 0.25, 0.7));
    if (band <= 0.01) return;
    final container = Rect.fromCenter(
      center: p(size, 0, 0.12, s),
      width: s * 1.86 * band,
      height: s * 0.66,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(container, const Radius.circular(12)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = VisionInk.focus.withValues(alpha: 0.45 * band),
    );

    // A thread running through every capability: the same piece of work.
    final threadY = container.center.dy;
    visionLink(
      canvas,
      Offset(container.left + 10, threadY),
      Offset(container.right - 10, threadY),
      visionStep(entrance, 0.45, 0.9),
      color: VisionInk.line,
    );

    for (var i = 0; i < names.length; i++) {
      final t = visionStep(entrance, 0.40 + i * 0.09, 0.92);
      if (t <= 0.01) continue;
      final x = container.left + container.width * (0.16 + i * 0.226);
      final rect = Rect.fromCenter(
        center: Offset(x, threadY),
        width: s * 0.38,
        height: s * 0.24,
      );
      _panel(canvas, rect, t, titleBar: false);
      visionLabel(
        canvas,
        Offset(x, threadY),
        names[i],
        t,
        size: 8.5,
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
      size: 10.5,
    );
  }
}

// ---------------------------------------------------------------------------
// Scene 6 — one interface, more than one intelligence
// ---------------------------------------------------------------------------

Widget masterChatIntelligences(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _IntelligencesPainter(
        state,
        context.tAll(MasterChatDiagramText.providers),
        context.t(MasterChatDiagramText.providerInterface),
        context.tAll(MasterChatDiagramText.specialists),
      ),
    );

class _IntelligencesPainter extends VisionScenePainter {
  const _IntelligencesPainter(
    super.state,
    this.providers,
    this.interfaceLabel,
    this.specialists,
  );

  final List<String> providers;
  final String interfaceLabel;
  final List<String> specialists;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);

    // Solid above the bar: two adapters behind one interface exist today.
    for (var i = 0; i < providers.length; i++) {
      final at = p(size, -0.42 + i * 0.84, -0.74, s);
      final t = visionStep(entrance, i * 0.10, 0.45);
      final rect = Rect.fromCenter(
        center: at,
        width: s * 0.56,
        height: s * 0.26,
      );
      _panel(canvas, rect, t, titleBar: false);
      visionLabel(
        canvas,
        at,
        providers[i],
        t,
        size: 9.5,
        color: AppColors.textSecondary,
      );
      visionLink(
        canvas,
        Offset(at.dx, rect.bottom),
        Offset(at.dx, p(size, 0, -0.36, s).dy),
        t,
        color: VisionInk.live.withValues(alpha: 0.5),
      );
    }

    final barT = visionStep(entrance, 0.22, 0.55);
    final bar = Rect.fromCenter(
      center: p(size, 0, -0.30, s),
      width: s * 1.70,
      height: s * 0.17,
    );
    _panel(
      canvas,
      bar,
      barT,
      border: VisionInk.focus,
      borderWidth: 1.2,
      titleBar: false,
    );
    visionLabel(
      canvas,
      bar.center,
      interfaceLabel,
      barT,
      size: 9,
      color: AppColors.accent,
    );

    // Dashed below it: splitting a task across specialists is the direction,
    // not something that runs. The picture says so before the words do.
    final merge = p(size, 0, 0.82, s);
    for (var i = 0; i < specialists.length; i++) {
      final x = -0.66 + i * 0.44;
      final at = p(size, x, 0.24, s);
      final t = visionStep(entrance, 0.42 + i * 0.08, 0.88);
      if (t <= 0.01) continue;
      visionLink(
        canvas,
        Offset(at.dx, bar.bottom),
        Offset(at.dx, at.dy - s * 0.13),
        t,
        color: VisionInk.node.withValues(alpha: 0.5),
        dashed: true,
      );
      final rect = Rect.fromCenter(
        center: at,
        width: s * 0.40,
        height: s * 0.22,
      );
      _panel(canvas, rect, t * 0.8, titleBar: false);
      visionLabel(canvas, at, specialists[i], t * 0.9, size: 8.5);
      visionLink(
        canvas,
        Offset(at.dx, rect.bottom),
        merge,
        visionStep(entrance, 0.62 + i * 0.06, 1.0),
        color: VisionInk.node.withValues(alpha: 0.4),
        dashed: true,
      );
    }
    final mergeT = visionStep(entrance, 0.80, 1.0);
    canvas.drawCircle(
      merge,
      s * 0.13,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = VisionInk.focus.withValues(alpha: 0.55 * mergeT),
    );
    visionDot(canvas, merge, 4, VisionInk.focus, mergeT);
  }
}

// ---------------------------------------------------------------------------
// Scene 7 — three doors, one registry, one gate
// ---------------------------------------------------------------------------

Widget masterChatRegistry(BuildContext context, VisionVisualState state) =>
    VisionVisualBox(
      _RegistryPainter(
        state,
        context.tAll(MasterChatDiagramText.doors),
        context.t(MasterChatDiagramText.registry),
        context.t(MasterChatDiagramText.confirmGate),
      ),
    );

class _RegistryPainter extends VisionScenePainter {
  const _RegistryPainter(
    super.state,
    this.doors,
    this.registryLabel,
    this.gateLabel,
  );

  final List<String> doors;
  final String registryLabel;
  final String gateLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scaleOf(size);
    final registry = Rect.fromCenter(
      center: p(size, 0.04, 0, s),
      width: s * 0.52,
      height: s * 1.16,
    );

    // Three ways in, deliberately identical: the point is that none of them
    // is special.
    for (var i = 0; i < doors.length; i++) {
      final at = p(size, -0.80, -0.56 + i * 0.56, s);
      final t = visionStep(entrance, i * 0.10, 0.5);
      final rect = Rect.fromCenter(
        center: at,
        width: s * 0.42,
        height: s * 0.26,
      );
      _panel(canvas, rect, t, titleBar: false);
      visionLabel(
        canvas,
        at,
        doors[i],
        t,
        size: 9,
        color: AppColors.textSecondary,
      );
      visionLink(
        canvas,
        Offset(rect.right, at.dy),
        Offset(registry.left, registry.center.dy),
        t,
        color: VisionInk.live.withValues(alpha: 0.5),
      );
      if (!still && t > 0.9) {
        visionPulse(
          canvas,
          Offset(rect.right, at.dy),
          Offset(registry.left, registry.center.dy),
          progress * 0.8 + i * 0.33,
          VisionInk.live,
        );
      }
    }

    final regT = visionStep(entrance, 0.30, 0.65);
    _panel(
      canvas,
      registry,
      regT,
      border: VisionInk.live,
      borderWidth: 1.2,
      fill: AppColors.surface,
      titleBar: false,
    );
    visionLabel(
      canvas,
      registry.center,
      registryLabel,
      regT,
      size: 9.5,
      color: AppColors.textPrimary,
    );

    // The gate is the only gold thing here, because it is the only thing that
    // can refuse.
    final gateT = visionStep(entrance, 0.55, 0.9);
    final gate = Rect.fromCenter(
      center: p(size, 0.62, 0, s),
      width: s * 0.34,
      height: s * 0.56,
    );
    visionLink(
      canvas,
      Offset(registry.right, registry.center.dy),
      Offset(gate.left, gate.center.dy),
      gateT,
      color: VisionInk.focus.withValues(alpha: 0.6),
    );
    _panel(
      canvas,
      gate,
      gateT,
      border: VisionInk.focus,
      borderWidth: 1.3,
      titleBar: false,
    );
    visionLabel(
      canvas,
      Offset(gate.center.dx, gate.bottom + s * 0.18),
      gateLabel,
      visionStep(entrance, 0.7, 1.0),
      size: 9.5,
      color: AppColors.accent,
    );

    final runT = visionStep(entrance, 0.78, 1.0);
    visionLink(
      canvas,
      Offset(gate.right, gate.center.dy),
      p(size, 0.92, 0, s),
      runT,
      color: VisionInk.focus.withValues(alpha: 0.5),
    );
    visionDot(canvas, p(size, 0.94, 0, s), 5, VisionInk.focus, runT, glow: 3.6);
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
