import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// Full-width hero banner at the top of the landing page.
/// AI-hint: Add scroll-triggered fade-in animation (AnimationController) here.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.4, 0.75, 1.0],
          colors: [
            Color(0xFF08091A), // deepest navy
            Color(0xFF1A0E60), // deep violet
            Color(0xFF2B0E80), // rich purple
            Color(0xFF08091A), // back to navy
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Ambient violet glow — top-left
          Positioned(
            top: -60,
            left: -80,
            child: _GlowOrb(size: 420, color: AppColors.primary.withAlpha(55)),
          ),
          // Ambient gold glow — bottom-right
          Positioned(
            bottom: -40,
            right: -60,
            child: _GlowOrb(size: 320, color: AppColors.accent.withAlpha(28)),
          ),
          // Main content
          SectionContainer(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: const _HeroCard(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ambient glow orb (pure BoxDecoration, no packages needed)
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

// ---------------------------------------------------------------------------
// Glass card holding all hero content
// AI-hint: Replace static text with animated typewriter effect later.
// ---------------------------------------------------------------------------
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.sizeOf(context).width < 640;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(13),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(38)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(70),
                blurRadius: 48,
                spreadRadius: -8,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 24 : 48,
            vertical: isNarrow ? 40 : 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gold badge label
              _GoldBadge(label: 'INDIE APP STUDIO'),
              const SizedBox(height: 24),
              // Main headline
              Text(
                'CatLab Studios',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: isNarrow ? 42 : 66,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 14),
              // Gold subline
              Text(
                'Indie apps crafted with care.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w400,
                  fontSize: isNarrow ? 20 : 26,
                ),
              ),
              const SizedBox(height: 14),
              // Body copy — constrained for readability
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Text(
                  'Small studio. Big ideas. '
                  'We build beautiful, useful apps that make everyday life '
                  'a little better — one pixel at a time.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 44),
              // CTA buttons
              Wrap(
                spacing: 16,
                runSpacing: 14,
                children: [
                  _CtaButton.filled(
                    label: 'Explore Apps',
                    icon: Icons.apps_rounded,
                    onPressed: () {},
                  ),
                  _CtaButton.outlined(
                    label: 'Contact / Collaborate',
                    icon: Icons.mail_outline_rounded,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small gold pill badge
// ---------------------------------------------------------------------------
class _GoldBadge extends StatelessWidget {
  const _GoldBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withAlpha(90)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontSize: 11,
          letterSpacing: 2.2,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CTA button — filled (gold) and outlined variants
// ---------------------------------------------------------------------------
class _CtaButton extends StatelessWidget {
  const _CtaButton.filled({
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : _filled = true;

  const _CtaButton.outlined({
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : _filled = false;

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool _filled;

  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );
  static const _padding = EdgeInsets.symmetric(horizontal: 28, vertical: 16);
  static const _textStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
    );

    if (_filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          padding: _padding,
          textStyle: _textStyle,
          shape: _shape,
        ),
        child: content,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.accent, width: 1.5),
        padding: _padding,
        textStyle: _textStyle,
        shape: _shape,
      ),
      child: content,
    );
  }
}
