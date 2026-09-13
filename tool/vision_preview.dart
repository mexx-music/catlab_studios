// Visual review harness for the vision story — not part of the shipped app.
//
// Renders the player inside exact device-sized frames and writes a PNG of each
// frame at the midpoint of every scene, so the presentation can be judged at
// real breakpoints without depending on screen capture or window management:
//
//   flutter build macos --debug -t tool/vision_preview.dart \
//     --dart-define=VIEW=mobile
//   open build/macos/Build/Products/Debug/catlab_studios.app
//
// VIEW is "desktop" or "mobile"; add --dart-define=REDUCED=true for the
// reduced-motion rendering. The app must reach the foreground — a backgrounded
// macOS window gets no vsync, and the story would sit frozen on frame one,
// which is why the harness waits before it starts. Each capture logs the
// absolute path it wrote (inside the app's sandbox container).
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/theme/app_theme.dart';
import 'package:catlab_studios/features/vision/data/business_brain_story.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/features/vision/presentation/vision_story_player.dart';
import 'package:catlab_studios/shared/widgets/app_card.dart';
import 'package:catlab_studios/shared/widgets/app_detail_sheet.dart';

const String _view = String.fromEnvironment('VIEW', defaultValue: 'desktop');
/// The macOS app is sandboxed, so shots land in its own container temp
/// directory; the absolute path is logged for each capture.
final String _out = Directory.systemTemp.path;
const bool _reducedMotion = bool.fromEnvironment('REDUCED');

const Map<String, List<Size>> _frames = {
  'desktop': [Size(960, 640)],
  'mobile': [Size(320, 620), Size(390, 760)],
  // The project detail sheet, to check the vision button in the action row.
  'sheet': [Size(620, 760)],
  // Portfolio cards at the real grid widths: 4-column desktop, 3-column
  // laptop, 2-column tablet and a 1-column phone.
  'cards': [Size(333, 260), Size(453, 260), Size(350, 260), Size(280, 260)],
};

void main() => runApp(const _Preview());

class _Preview extends StatefulWidget {
  const _Preview();

  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  final List<GlobalKey> _keys = [];
  final List<Timer> _timers = [];

  bool _armed = false;

  @override
  void initState() {
    super.initState();
    final sizes = _frames[_view]!;
    _keys.addAll(List.generate(sizes.length, (_) => GlobalKey()));
    // Give the window time to reach the foreground first: a backgrounded
    // macOS app gets no vsync, so the story would sit frozen at frame one.
    Timer(const Duration(seconds: 5), _arm);
  }

  void _armStatic() {
    setState(() => _armed = true);
    _timers.add(Timer(const Duration(seconds: 2), () => _capture(_view)));
  }

  void _arm() {
    if (_view == 'sheet' || _view == 'cards') {
      _armStatic();
      return;
    }
    setState(() => _armed = true);

    // Fire at 60% through each scene — past the entrance, before the exit.
    var elapsed = Duration.zero;
    for (var i = 0; i < businessBrainStory.sceneCount; i++) {
      final duration = businessBrainStory.scenes[i].duration;
      final at = elapsed + duration * 0.6;
      _timers.add(Timer(at, () => _capture('scene${i + 1}')));
      elapsed += duration;
    }
    // And once more after the story has played out, for the ending state.
    _timers.add(
      Timer(elapsed + const Duration(seconds: 2), () => _capture('ending')),
    );
  }

  Future<void> _capture(String label) async {
    final sizes = _frames[_view]!;
    for (var i = 0; i < _keys.length; i++) {
      final object = _keys[i].currentContext?.findRenderObject();
      if (object is! RenderRepaintBoundary) continue;
      final image = await object.toImage(pixelRatio: 2);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (data == null) continue;
      final name = '${_view}_${sizes[i].width.toInt()}_$label'
          '${_reducedMotion ? '_reduced' : ''}.png';
      final file = File('$_out/$name')
        ..writeAsBytesSync(data.buffer.asUint8List());
      stdout.writeln('CAPTURED ${file.path}');
    }
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = _frames[_view]!;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: ColoredBox(
        color: const Color(0xFF05060D),
        child: !_armed
            ? const SizedBox.expand()
            : Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < sizes.length; i++)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: RepaintBoundary(
                    key: _keys[i],
                    child: _Frame(size: sizes[i]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: MediaQuery(
          data: MediaQueryData(size: size, disableAnimations: _reducedMotion),
          // Its own MaterialApp so the content gets a Navigator sized like
          // the device it is standing in for.
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            home: _view == 'cards'
                ? Scaffold(
                    backgroundColor: AppColors.surface,
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AppCard(
                        project: AppProjectsRepository.all.firstWhere(
                          (p) => p.id == businessBrainStory.projectId,
                        ),
                      ),
                    ),
                  )
                : _view == 'sheet'
                ? Scaffold(
                    backgroundColor: AppColors.background,
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(22),
                      child: AppDetailSheet(
                        project: AppProjectsRepository.all.firstWhere(
                          (p) => p.id == businessBrainStory.projectId,
                        ),
                      ),
                    ),
                  )
                : VisionStoryPlayer(story: businessBrainStory),
          ),
        ),
      ),
    );
  }
}
