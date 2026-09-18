import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

const bool kInlineVideoSupported = true;

/// A `<video>` element embedded in the page.
///
/// Each instance registers its own view type, because a view factory can only
/// be registered once per name and two films — or the same film played twice —
/// must not fight over one element.
///
/// Playback only ever starts from a visitor's tap, which is also what lets the
/// film play *with sound*: an autoplaying muted video would defeat the point
/// of a piece of work whose cuts are scored to music.
class InlineVideo extends StatefulWidget {
  const InlineVideo({
    super.key,
    required this.src,
    this.autoplay = true,
    this.controls = true,
  });

  /// Relative to the site root, e.g. `media/hb_system_9x16.mp4`.
  final String src;

  final bool autoplay;

  /// The browser's own controls — seek, volume, fullscreen and picture in
  /// picture, all for free and all already accessible.
  final bool controls;

  @override
  State<InlineVideo> createState() => _InlineVideoState();
}

int _nextViewId = 0;

class _InlineVideoState extends State<InlineVideo> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'catlab-inline-video-${_nextViewId++}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final element = web.HTMLVideoElement()
        ..src = widget.src
        ..autoplay = widget.autoplay
        ..controls = widget.controls
        // iOS Safari otherwise takes every video fullscreen the moment it
        // starts, which would throw the visitor out of the page.
        ..playsInline = true
        ..preload = 'auto';
      element.style
        ..width = '100%'
        ..height = '100%'
        ..objectFit = 'cover'
        ..border = '0'
        ..backgroundColor = 'transparent';
      return element;
    });
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
