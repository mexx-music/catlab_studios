import 'package:flutter/widgets.dart';

/// False off the web, so the caller keeps showing the poster and offers to
/// open the film instead of embedding a player that cannot exist.
const bool kInlineVideoSupported = false;

/// Never built when [kInlineVideoSupported] is false; present only so both
/// sides of the conditional import have the same surface.
class InlineVideo extends StatelessWidget {
  const InlineVideo({
    super.key,
    required this.src,
    this.autoplay = true,
    this.controls = true,
  });

  final String src;
  final bool autoplay;
  final bool controls;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
