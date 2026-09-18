import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/features/product_experience/data/product_experience_showcase.dart';

/// The argument of the whole section, made literal.
///
/// Left and right are the *same file* — the original CureBase cut-out that
/// the real films were built from. Left shows it as it arrives: flat, on a
/// plain surface. Right shows it staged: a light field, depth, particles and
/// frequency lines drawn around it in code, while the product's own pixels
/// are never touched. Dragging the handle moves the seam between the two.
///
/// This is also the honest demo of the service: everything on the right is
/// painted live by this widget, at the same 60 fps a delivered film runs at.
///
/// AI-hint: the product image must never be recoloured, warped or masked —
/// the moment it is, the picture stops making the argument it exists to make.
class PrincipleStage extends StatefulWidget {
  const PrincipleStage({super.key, required this.isNarrow});

  final bool isNarrow;

  @override
  State<PrincipleStage> createState() => _PrincipleStageState();
}

class _PrincipleStageState extends State<PrincipleStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  /// Where the seam sits, 0 → 1 across the stage.
  double _seam = 0.52;

  bool _reduced = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.disableAnimationsOf(context);
    if (reduced == _reduced && (_ambient.isAnimating || reduced)) return;
    _reduced = reduced;
    // Under reduced motion the staged side is painted once, in its resting
    // state, and the ticker never runs.
    if (reduced) {
      _ambient.stop();
      _ambient.value = 0.25;
    } else {
      _ambient.repeat();
    }
  }

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  void _moveSeam(Offset localPosition, double width) {
    setState(() => _seam = (localPosition.dx / width).clamp(0.06, 0.94));
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.isNarrow ? 300.0 : 420.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _moveSeam(d.localPosition, width),
              onHorizontalDragUpdate: (d) => _moveSeam(d.localPosition, width),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const _RawSide(),
                    ClipRect(
                      clipper: _SeamClipper(_seam),
                      child: RepaintBoundary(
                        child: AnimatedBuilder(
                          animation: _ambient,
                          builder: (context, child) => CustomPaint(
                            painter: _StagedLightPainter(
                              phase: _ambient.value,
                              still: _reduced,
                            ),
                            child: child,
                          ),
                          child: const _ProductImage(lit: true),
                        ),
                      ),
                    ),
                    _SeamHandle(seam: _seam),
                    Positioned(
                      left: 16,
                      top: 14,
                      child: _SideLabel(
                        text: context.t(SiteText.experienceBefore),
                        accent: false,
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 14,
                      child: _SideLabel(
                        text: context.t(SiteText.experienceAfter),
                        accent: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Left half — the asset as delivered: flat ground, no light, no motion
// ---------------------------------------------------------------------------
class _RawSide extends StatelessWidget {
  const _RawSide();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.surfaceVariant),
      child: CustomPaint(
        painter: const _GridPainter(),
        child: const _ProductImage(lit: false),
      ),
    );
  }
}

/// The product photograph itself, identical on both sides.
///
/// The unlit version is dimmed by an overlay *behind* nothing and a plain
/// opacity — never a colour filter on the product, which would change the
/// thing the picture promises is unchanged.
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.lit});

  final bool lit;

  @override
  Widget build(BuildContext context) {
    // Held to a little under half the stage, and a touch below centre: the
    // staging has to be visible *around* the product, and the floor light
    // needs somewhere to pool.
    return Align(
      alignment: const Alignment(0, 0.12),
      child: FractionallySizedBox(
        widthFactor: 0.46,
        heightFactor: 0.66,
        // Its own layer: the bloom is expensive to filter and never changes,
        // so it is rasterised once instead of on every ambient frame.
        child: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Bloom — the product's own silhouette, blurred and tinted,
              // sitting behind it. Light *from* the product, not a filter on
              // it: the sharp copy on top is untouched.
              if (lit)
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppColors.accent.withValues(alpha: 0.55),
                      BlendMode.srcATop,
                    ),
                    child: Transform.scale(
                      scale: 1.06,
                      child: Image.asset(
                        ProductExperienceShowcase.productCutout,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.low,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                ),
              Opacity(
                opacity: lit ? 1.0 : 0.72,
                child: Image.asset(
                  ProductExperienceShowcase.productCutout,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                  // The cut-out is one product shot: describing it is enough.
                  semanticLabel: 'CureBase',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Flat technical grid behind the raw asset — "a file on a surface"
// ---------------------------------------------------------------------------
class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withValues(alpha: 0.55)
      ..strokeWidth = 1;
    const step = 44.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Right half — the staging, drawn live: light field, rings, frequency lines
// and particles. Nothing here touches the product's own pixels.
// ---------------------------------------------------------------------------
class _StagedLightPainter extends CustomPainter {
  const _StagedLightPainter({required this.phase, required this.still});

  /// 0 → 1, looping.
  final double phase;

  /// True under prefers-reduced-motion: one frame, no repaints.
  final bool still;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.52);
    final radius = math.max(size.width, size.height) * 0.62;
    final breath = still ? 0.5 : (math.sin(phase * 2 * math.pi) + 1) / 2;

    // Ground: a deep pool of studio light behind the product. Dark at the
    // edges on purpose — a glow only reads as light if something near it is
    // genuinely dark.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            // Opaque on purpose: this rectangle *replaces* the plain ground
            // on the staged side rather than tinting it, which is what lets
            // the edges go properly dark and the core read as light.
            Color.lerp(
              const Color(0xFF0A0C18),
              Color.lerp(AppColors.primary, AppColors.accent, 0.22)!,
              0.26 + breath * 0.06,
            )!,
            const Color(0xFF05060C),
          ],
          stops: const [0.0, 0.95],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    // Key light: a tight, hot core right behind the product, which is what
    // separates a staged shot from an image on a coloured background. Added
    // rather than painted over, so it behaves like light and not like paint.
    canvas.drawCircle(
      center.translate(0, -size.height * 0.04),
      size.height * (0.30 + breath * 0.02),
      Paint()
        ..blendMode = BlendMode.plus
        ..shader = RadialGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.52 + breath * 0.10),
            AppColors.accent.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromCircle(
            center: center.translate(0, -size.height * 0.04),
            radius: size.height * 0.30,
          ),
        ),
    );

    // Floor: the product stands on something, so the light pools under it.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.80),
        width: size.width * 0.66,
        height: size.height * 0.12,
      ),
      Paint()
        ..blendMode = BlendMode.plus
        ..color = AppColors.accent.withValues(alpha: 0.30 + breath * 0.06)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 26),
    );

    // Beam: a soft column of light standing behind the product, the studio
    // lamp the whole picture is lit by.
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.46),
        width: size.width * 0.34,
        height: size.height,
      ),
      Paint()
        ..blendMode = BlendMode.plus
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.0),
            AppColors.primary.withValues(alpha: 0.26 + breath * 0.06),
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromCenter(
            center: Offset(center.dx, size.height * 0.46),
            width: size.width * 0.34,
            height: size.height,
          ),
        ),
    );

    // Depth rings — the spatial layer the product sits inside.
    for (var i = 0; i < 4; i++) {
      final t = (phase + i / 4) % 1.0;
      final r = radius * (0.28 + t * 0.72);
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = AppColors.accent.withValues(
            alpha: 0.44 * (1 - t) * (still ? 0.8 : 1),
          ),
      );
    }

    // Frequency lines — the signature of the Healing & Balance films, and the
    // clearest example of motion that is computed rather than filmed.
    for (var line = 0; line < 3; line++) {
      final path = Path();
      final amplitude = size.height * (0.034 + line * 0.016);
      final y = center.dy + (line - 1) * size.height * 0.085;
      final drift = still ? 0.0 : phase * 2 * math.pi * (line.isEven ? 1 : -1);
      for (var x = 0.0; x <= size.width; x += 6) {
        final k = x / size.width;
        final wave =
            math.sin(k * math.pi * 3 + drift) *
            math.sin(k * math.pi) * // fades out at both edges
            amplitude;
        if (x == 0) {
          path.moveTo(x, y + wave);
        } else {
          path.lineTo(x, y + wave);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..blendMode = BlendMode.plus
          ..color = Color.lerp(
            AppColors.accent,
            AppColors.textPrimary,
            0.25,
          )!.withValues(alpha: 0.78 - line * 0.16)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0),
      );
    }

    // Particles — deterministic, so the field never flickers between frames.
    final random = math.Random(7);
    for (var i = 0; i < 46; i++) {
      final bx = random.nextDouble();
      final by = random.nextDouble();
      final speed = 0.4 + random.nextDouble() * 0.8;
      final drift = still ? 0.0 : (phase * speed) % 1.0;
      final y = ((by - drift) % 1.0) * size.height;
      final twinkle =
          0.25 + 0.75 * (math.sin((phase * speed + bx) * 2 * math.pi) + 1) / 2;
      canvas.drawCircle(
        Offset(bx * size.width, y),
        0.9 + random.nextDouble() * 1.3,
        Paint()
          ..blendMode = BlendMode.plus
          ..color = AppColors.textPrimary.withValues(alpha: 0.42 * twinkle),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StagedLightPainter old) =>
      old.phase != phase || old.still != still;
}

// ---------------------------------------------------------------------------
// The seam itself — a thin lit line with a grab handle
// ---------------------------------------------------------------------------
class _SeamClipper extends CustomClipper<Rect> {
  const _SeamClipper(this.seam);

  final double seam;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(size.width * seam, 0, size.width, size.height);

  @override
  bool shouldReclip(covariant _SeamClipper oldClipper) =>
      oldClipper.seam != seam;
}

class _SeamHandle extends StatelessWidget {
  const _SeamHandle({required this.seam});

  final double seam;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(seam * 2 - 1, 0),
      child: IgnorePointer(
        child: SizedBox(
          width: 34,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 1.4,
                height: double.infinity,
                color: AppColors.accent.withValues(alpha: 0.75),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background.withValues(alpha: 0.85),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.9),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.28),
                      blurRadius: 18,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.code_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideLabel extends StatelessWidget {
  const _SideLabel({required this.text, required this.accent});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accent
              ? AppColors.accent.withValues(alpha: 0.55)
              : AppColors.cardBorder,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: accent ? AppColors.accent : AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
