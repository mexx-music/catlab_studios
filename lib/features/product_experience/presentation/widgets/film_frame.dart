import 'package:flutter/material.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/core/utils/link_launcher.dart';
import 'package:catlab_studios/features/product_experience/domain/staged_media.dart';
import 'package:catlab_studios/features/product_experience/presentation/video/inline_video.dart';

/// One rendered film, in the shape it was delivered in.
///
/// Until a visitor presses play there is only a still frame from the film
/// itself — no video is fetched, which is what keeps a section carrying three
/// films cheap on a phone connection. Pressing play swaps the poster for a
/// real player in place; where no player exists (anything that is not a
/// browser, and the widget tests) the file is opened instead.
class FilmFrame extends StatefulWidget {
  const FilmFrame({super.key, required this.film, required this.width});

  final StagedFilm film;

  /// Fixed width, so a row of films keeps one rhythm and the aspect ratio
  /// decides the height.
  final double width;

  @override
  State<FilmFrame> createState() => _FilmFrameState();
}

class _FilmFrameState extends State<FilmFrame> {
  bool _playing = false;
  bool _hovered = false;

  void _play() {
    if (!kInlineVideoSupported) {
      LinkLauncher.open(widget.film.videoUrl);
      return;
    }
    setState(() => _playing = true);
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hovered || _playing
                      ? AppColors.accent.withValues(alpha: 0.55)
                      : AppColors.cardBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _hovered ? 0.34 : 0.2),
                    blurRadius: _hovered ? 30 : 16,
                    offset: const Offset(0, 12),
                  ),
                  if (_hovered || _playing)
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.16),
                      blurRadius: 40,
                      spreadRadius: -10,
                      offset: const Offset(0, 14),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: AspectRatio(
                  aspectRatio: film.aspectRatio,
                  child: _playing
                      ? InlineVideo(src: film.videoUrl)
                      : _Poster(
                          film: film,
                          hovered: _hovered,
                          onPlay: _play,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.t(film.title),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            context.t(film.note),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Still frame, play affordance, format and duration badges
// ---------------------------------------------------------------------------
class _Poster extends StatelessWidget {
  const _Poster({
    required this.film,
    required this.hovered,
    required this.onPlay,
  });

  final StagedFilm film;
  final bool hovered;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${context.t(SiteText.experiencePlay)} — ${context.t(film.title)}',
      child: GestureDetector(
        onTap: onPlay,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              film.posterAsset,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.45, 1.0],
                  colors: [Colors.transparent, Color(0x99000000)],
                ),
              ),
            ),
            Center(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                scale: hovered ? 1.08 : 1.0,
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background.withValues(alpha: 0.62),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.85),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(
                          alpha: hovered ? 0.36 : 0.18,
                        ),
                        blurRadius: 26,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 32,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: _Badge(text: _ratioLabel(film.aspectRatio)),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: _Badge(text: film.durationLabel),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                children: [
                  const Icon(
                    Icons.volume_up_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      context.t(SiteText.experienceSoundHint),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _ratioLabel(double ratio) =>
      (ratio - 9 / 16).abs() < 0.001 ? '9:16' : '16:9';
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
