import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';

/// The shared drawing toolkit every vision story is painted with.
///
/// Stories do not share a *picture* — Business Brain draws knowledge as orbits
/// and rings, Master Chat draws interfaces as panels and lanes — but they do
/// share a hand: the same ink, the same line weights, the same restraint with
/// gold, and the same way an element arrives. That is what makes two very
/// different diagrams read as two presentations from one studio.
///
/// Everything is a [CustomPainter] over normalised coordinates, which keeps
/// the whole presentation asset-free and cheap on mobile GPUs.
///
/// AI-hint: a new story adds its own `*_visuals.dart` built on these; it does
/// not add a second drawing style here.

/// Fraction of a scene spent on its entrance beat.
const double kEntranceFraction = 0.34;

/// Maps a global 0→1 value onto a sub-window, for staggering elements.
double visionStep(double t, double start, double end) =>
    ((t - start) / (end - start)).clamp(0.0, 1.0);

double visionEase(double t) => Curves.easeOutCubic.transform(t.clamp(0.0, 1.0));

/// Pen colours. Gold is rationed: it marks the human, the core and the
/// resolution, never ordinary structure.
abstract final class VisionInk {
  static const Color line = Color(0xFF2E3155);
  static const Color node = AppColors.textMuted;
  static const Color live = AppColors.primary;
  static const Color focus = AppColors.accent;
  static const Color flag = AppColors.statusInDevelopment;
}

void visionDot(
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
void visionLink(
  Canvas canvas,
  Offset a,
  Offset b,
  double t, {
  Color color = VisionInk.line,
  double width = 1.0,
  bool dashed = false,
}) {
  if (t <= 0.01) return;
  final end = Offset.lerp(a, b, visionEase(t))!;
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
void visionPulse(Canvas canvas, Offset a, Offset b, double phase, Color color) {
  final p = phase % 1.0;
  final at = Offset.lerp(a, b, p)!;
  visionDot(canvas, at, 2.4, color, math.sin(p * math.pi).clamp(0.0, 1.0));
}

void visionLabel(
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
abstract class VisionScenePainter extends CustomPainter {
  const VisionScenePainter(this.state);

  final VisionVisualState state;

  bool get still => state.reducedMotion;
  double get entrance => still ? 1.0 : state.entrance;
  double get progress => still ? 0.0 : state.progress;

  /// Converts a normalised (-1..1) point to canvas coordinates.
  Offset p(Size size, double x, double y, double scale) =>
      Offset(size.width / 2 + x * scale, size.height / 2 + y * scale);

  double scaleOf(Size size) => math.min(size.width, size.height) / 2.2;

  @override
  bool shouldRepaint(covariant VisionScenePainter old) =>
      old.state.entrance != state.entrance ||
      old.state.progress != state.progress ||
      old.state.reducedMotion != state.reducedMotion;
}

/// Wraps a painter in the box every scene visual shares.
class VisionVisualBox extends StatelessWidget {
  const VisionVisualBox(this.painter, {super.key});

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
