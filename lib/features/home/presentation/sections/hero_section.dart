import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/shared/widgets/language_switcher.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';

/// Full-width hero banner at the top of the landing page.
/// AI-hint: Add scroll-triggered fade-in animation (AnimationController) here.
class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onExploreApps,
    required this.onWhatWeBuild,
  });

  /// Scrolls the page to the portfolio section.
  final VoidCallback onExploreApps;

  /// Scrolls the page to the capabilities section.
  final VoidCallback onWhatWeBuild;

  static const _heroImage = 'assets/images/hero/catwebback.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // ── Layer 1: Background photo — always fully visible ───────────
          Positioned.fill(
            child: Image.asset(
              _heroImage,
              fit: BoxFit.cover,
              // -0.15 sits just below topCenter: moon stays top-right,
              // cat + windowsill + laptop become visible in the lower frame.
              alignment: const Alignment(0, -0.15),
            ),
          ),

          // ── Layer 2: Minimal scrim — just enough depth (≈20 %) ─────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withAlpha(50)),
            ),
          ),

          // ── Layer 3: Bottom vignette — helps button/text readability ───
          // Fades from transparent (top 45 %) to soft black (bottom edge).
          Positioned.fill(
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.45, 1.0],
                  colors: [Colors.transparent, Color(0xBB000000)],
                ),
              ),
            ),
          ),

          // ── Layer 4: Floating ambient glow — very subtle, slow animation ─
          // AI-hint: Tune orb size/alpha here for seasonal mood changes.
          const Positioned.fill(child: _FloatingGlowLayer()),

          // ── Layer 5: Content — text directly over the image ────────────
          _HeroContent(
            onExploreApps: onExploreApps,
            onWhatWeBuild: onWhatWeBuild,
          ),

          // ── Layer 6: Language ──────────────────────────────────────────
          // Top right of the first thing a visitor sees, so someone who
          // landed in the wrong language finds it without scrolling.
          const Positioned(
            top: 16,
            right: 16,
            child: SafeArea(child: LanguageSwitcher()),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content column — no card, no backdrop, just typography over the image
// ---------------------------------------------------------------------------
class _HeroContent extends StatelessWidget {
  const _HeroContent({
    required this.onExploreApps,
    required this.onWhatWeBuild,
  });

  final VoidCallback onExploreApps;
  final VoidCallback onWhatWeBuild;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 640;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          // Top is smaller than bottom → content sits higher in the frame.
          padding: EdgeInsets.fromLTRB(
            isNarrow ? 24 : 56,
            isNarrow ? 52 : 76, // top
            isNarrow ? 24 : 56,
            isNarrow ? 108 : 172, // bottom — taller hero, more image visible
          ),
          child: Column(
            crossAxisAlignment: isNarrow
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              _GoldBadge(label: context.t(SiteText.heroBadge)),
              const SizedBox(height: 28),
              _GlowHeadline(isNarrow: isNarrow),
              const SizedBox(height: 18),
              _Subline(isNarrow: isNarrow),
              const SizedBox(height: 16),
              _BodyText(isNarrow: isNarrow),
              const SizedBox(height: 52),
              _CtaRow(
                isNarrow: isNarrow,
                onExploreApps: onExploreApps,
                onWhatWeBuild: onWhatWeBuild,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gold badge — studio positioning line
// ---------------------------------------------------------------------------
class _GoldBadge extends StatelessWidget {
  const _GoldBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withAlpha(120)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.4,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main headline — warm gold with soft glow via TextStyle.shadows
// ---------------------------------------------------------------------------
class _GlowHeadline extends StatelessWidget {
  const _GlowHeadline({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Text(
      'CatLab Studios',
      textAlign: isNarrow ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: isNarrow ? 40 : 76,
        fontWeight: FontWeight.w800,
        color: AppColors.accent,
        height: 1.05,
        letterSpacing: -1.5,
        shadows: const [
          // Cinematic luxury glow — tight core, soft bloom, no neon.
          Shadow(color: Color(0xCCFFDD88), blurRadius: 4),
          Shadow(color: Color(0xAAFFBB55), blurRadius: 18),
          Shadow(color: Color(0x66FF9900), blurRadius: 42),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Subline — warm cream-gold, lighter weight
// ---------------------------------------------------------------------------
class _Subline extends StatelessWidget {
  const _Subline({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.t(SiteText.heroSubline),
      textAlign: isNarrow ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: isNarrow ? 19 : 26,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFFFDDA0),
        letterSpacing: 0.2,
        shadows: const [Shadow(color: Color(0x88FF9900), blurRadius: 16)],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body copy — readable light text
// ---------------------------------------------------------------------------
class _BodyText extends StatelessWidget {
  const _BodyText({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Text(
        context.t(SiteText.heroBody),
        textAlign: isNarrow ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          fontSize: 15,
          height: 1.65,
          color: Color(0xCCF0F0F8),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CTA row — wraps on narrow screens
// ---------------------------------------------------------------------------
class _CtaRow extends StatelessWidget {
  const _CtaRow({
    required this.isNarrow,
    required this.onExploreApps,
    required this.onWhatWeBuild,
  });

  final bool isNarrow;
  final VoidCallback onExploreApps;
  final VoidCallback onWhatWeBuild;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: isNarrow ? WrapAlignment.center : WrapAlignment.start,
      spacing: 16,
      runSpacing: 14,
      children: [
        _CtaButton(
          label: context.t(SiteText.heroExploreApps),
          icon: Icons.apps_rounded,
          primary: true,
          compact: isNarrow,
          onPressed: onExploreApps,
        ),
        _CtaButton(
          label: context.t(SiteText.heroWhatWeBuild),
          icon: Icons.layers_outlined,
          primary: false,
          compact: isNarrow,
          onPressed: onWhatWeBuild,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CTA button — hover-aware, transparent dark fill + soft gold glow on hover
// AI-hint: Wire onPressed to go_router navigation when routing is added.
// ---------------------------------------------------------------------------
class _CtaButton extends StatefulWidget {
  const _CtaButton({
    required this.label,
    required this.icon,
    required this.primary,
    required this.compact,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool primary;

  /// Tightens padding on phones — at 320 px the roomy desktop padding pushes
  /// the label past the edge of the screen.
  final bool compact;

  final VoidCallback onPressed;

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hovered = false;

  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );
  static const _padding = EdgeInsets.symmetric(horizontal: 28, vertical: 16);
  static const _compactPadding = EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 14,
  );
  static const _textStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    final bgAlpha = widget.primary
        ? (_hovered ? 115 : 90)
        : (_hovered ? 65 : 40);
    final borderAlpha = widget.primary
        ? (_hovered ? 220 : 255)
        : (_hovered ? 200 : 160);
    final glowAlpha = _hovered ? (widget.primary ? 55 : 38) : 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withAlpha(glowAlpha),
              blurRadius: 22,
              spreadRadius: -3,
            ),
          ],
        ),
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.black.withAlpha(bgAlpha),
            foregroundColor: AppColors.accent,
            side: BorderSide(
              color: AppColors.accent.withAlpha(borderAlpha),
              width: 1.0,
            ),
            padding: widget.compact ? _compactPadding : _padding,
            textStyle: _textStyle,
            shape: _shape,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
// Floating ambient glow orbs — very slow, very subtle
// ---------------------------------------------------------------------------
class _FloatingGlowLayer extends StatefulWidget {
  const _FloatingGlowLayer();

  @override
  State<_FloatingGlowLayer> createState() => _FloatingGlowLayerState();
}

class _FloatingGlowLayerState extends State<_FloatingGlowLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(seconds: 9),
      vsync: this,
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final t = _anim.value; // 0.0 → 1.0 smooth
        return Stack(
          children: [
            // Violet orb — drifts gently upward
            Positioned(
              top: -60 + t * 14,
              left: -80 + t * 8,
              child: _GlowOrb(
                size: 360,
                color: AppColors.primary.withAlpha(28),
              ),
            ),
            // Gold orb — drifts gently in the opposite phase
            Positioned(
              bottom: -40 - t * 10,
              right: -60 + t * 6,
              child: _GlowOrb(size: 260, color: AppColors.accent.withAlpha(16)),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Radial glow circle — used by _FloatingGlowLayer
// ---------------------------------------------------------------------------
class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
