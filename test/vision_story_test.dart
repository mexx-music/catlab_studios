import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catlab_studios/core/theme/app_theme.dart';
import 'package:catlab_studios/data/models/app_project.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/features/vision/data/business_brain_story.dart';
import 'package:catlab_studios/features/vision/data/master_chat_story.dart';
import 'package:catlab_studios/features/vision/data/vision_stories_repository.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_story_player.dart';
import 'package:catlab_studios/shared/widgets/app_card.dart';
import 'package:catlab_studios/shared/widgets/app_detail_sheet.dart';

/// Every published story. The player suite runs against all of them, so a
/// second story cannot quietly regress the first.
final List<VisionStory> _stories = VisionStoriesRepository.all;

final VisionStory _businessBrain = businessBrainStory;
final VisionStory _masterChat = masterChatStory;

// Tests run in the fallback locale, so the English source is what renders.
String _headlineOf(VisionStory story, int index) =>
    story.scenes[index].headline.source;

/// Long enough for the scene switcher to finish and drop the outgoing scene,
/// short enough that it never crosses a scene boundary on its own.
const Duration _settle = Duration(milliseconds: 520);

/// Opens the player over a trivial host page.
///
/// Deliberately avoids `pumpAndSettle`: a playing story is a continuous
/// animation, so settling would spin forever.
Future<void> _openStory(
  WidgetTester tester,
  VisionStory story, {
  Size size = const Size(1280, 800),
  bool reducedMotion = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
        child: child!,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => VisionStoryPlayer.open(context, story),
              child: const Text('open story'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open story'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _tapTooltip(WidgetTester tester, String tooltip) async {
  await tester.tap(find.byTooltip(tooltip));
  await tester.pump();
  await tester.pump(_settle);
}

Future<void> _showDetailSheet(WidgetTester tester, AppProject project) async {
  tester.view.physicalSize = const Size(1280, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: SingleChildScrollView(child: AppDetailSheet(project: project)),
      ),
    ),
  );
  await tester.pump();
}

/// Paints one scene's visual in isolation and returns the pixels.
///
/// Comparing two of these is how the reduced-motion promise gets checked for
/// real: the diagrams are CustomPainters, so no widget assertion can tell
/// whether they actually stopped moving — only their output can.
Future<Uint8List> _paintVisual(
  WidgetTester tester,
  VisionScene scene,
  VisionVisualState state,
) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: 400,
              height: 300,
              child: Builder(builder: (c) => scene.visual(c, state)),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  // toImage needs real async, which the test clock otherwise suspends.
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data!.buffer.asUint8List();
  });
  return bytes!;
}

/// Renders one portfolio card at a given grid column width.
Future<void> _showCard(
  WidgetTester tester,
  AppProject project,
  double width,
) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            height: 260,
            child: AppCard(project: project),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  // ── Which projects get a vision story ────────────────────────────────────
  group('vision story eligibility', () {
    test('the pilot targets a project that actually exists', () {
      final ids = AppProjectsRepository.all.map((p) => p.id).toSet();
      for (final story in VisionStoriesRepository.all) {
        expect(
          ids,
          contains(story.projectId),
          reason: 'a story must point at a real portfolio entry',
        );
      }
    });

    test('exactly the two piloted projects have a story', () {
      expect(VisionStoriesRepository.all, hasLength(2));
      expect(VisionStoriesRepository.hasStory('universal_business'), isTrue);
      expect(VisionStoriesRepository.hasStory('master_chat'), isTrue);
      expect(VisionStoriesRepository.hasStory('hb_cure'), isFalse);
      expect(VisionStoriesRepository.forProject('madame_gatto'), isNull);
    });

    test('each project gets its own story, never the other one', () {
      expect(
        VisionStoriesRepository.forProject('universal_business'),
        same(_businessBrain),
      );
      expect(
        VisionStoriesRepository.forProject('master_chat'),
        same(_masterChat),
      );
      // The two stories share an engine, not a script.
      expect(
        _businessBrain.scenes.first.headline.source,
        isNot(_masterChat.scenes.first.headline.source),
      );
      final ids = {for (final story in _stories) story.projectId};
      expect(ids, hasLength(_stories.length), reason: 'one story per project');
    });

    testWidgets('Business Brain shows the vision CTA', (tester) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'universal_business',
      );
      await _showDetailSheet(tester, project);

      // Two entry points: the explainer block, and a button in the action
      // row beside the demo link.
      expect(find.textContaining('Explore the Vision'), findsNWidgets(2));
      expect(find.text('THE BIGGER PICTURE'), findsOneWidget);
      expect(find.text('Explore the Vision'), findsOneWidget);
      // The existing factual content is untouched.
      expect(find.text('What it does'.toUpperCase()), findsOneWidget);
      expect(find.text(project.name), findsOneWidget);
    });

    testWidgets(
      'the action row carries the vision button beside the demo link',
      (tester) async {
        final project = AppProjectsRepository.all.firstWhere(
          (p) => p.id == 'universal_business',
        );
        await _showDetailSheet(tester, project);

        // Both actions live in the same row, in that order.
        final row = find.ancestor(
          of: find.text('Explore the Vision'),
          matching: find.byType(Wrap),
        );
        expect(row, findsOneWidget);
        expect(
          find.descendant(of: row, matching: find.textContaining('Open Demo')),
          findsOneWidget,
        );

        // And it opens the story rather than launching a link.
        await tester.tap(find.text('Explore the Vision'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.byType(VisionStoryPlayer), findsOneWidget);
        expect(find.text(_headlineOf(_businessBrain, 0)), findsOneWidget);
      },
    );

    testWidgets('the portfolio card carries the vision action too', (
      tester,
    ) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'universal_business',
      );
      await _showCard(tester, project, 420);

      // The demo link keeps its full label — the vision button must not
      // squeeze it, which is exactly what a shared flex once did.
      expect(find.text('Open Demo'), findsOneWidget);
      expect(find.text('Vision'), findsOneWidget);
      expect(find.byTooltip('Explore the Vision'), findsOneWidget);

      await tester.tap(find.byTooltip('Explore the Vision'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(VisionStoryPlayer), findsOneWidget);
      expect(find.text(_headlineOf(_businessBrain, 0)), findsOneWidget);
    });

    testWidgets('a narrow card keeps the action but drops its label', (
      tester,
    ) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'universal_business',
      );
      // A four-column desktop card: too narrow for two labelled buttons.
      await _showCard(tester, project, 333);

      expect(find.text('Open Demo'), findsOneWidget);
      expect(find.text('Vision'), findsNothing);
      // Still there, still reachable, still named for a screen reader.
      expect(find.byTooltip('Explore the Vision'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('cards fit at every grid width', (tester) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'universal_business',
      );
      // Every card width the grid actually produces, from a 320px phone in
      // one column to a 1920px desktop in four.
      for (final width in <double>[
        280,
        300,
        312,
        333,
        340,
        350,
        415,
        453,
        520,
      ]) {
        await _showCard(tester, project, width);
        expect(
          tester.takeException(),
          isNull,
          reason: 'card overflowed at ${width.toInt()}px',
        );
      }
    });

    testWidgets('a card without a story shows no vision action', (
      tester,
    ) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'hb_cure',
      );
      await _showCard(tester, project, 420);
      expect(find.byTooltip('Explore the Vision'), findsNothing);
      expect(find.text('Vision'), findsNothing);
    });

    testWidgets('Master Chat shows the vision CTA and opens its own story', (
      tester,
    ) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'master_chat',
      );
      await _showDetailSheet(tester, project);

      expect(find.textContaining('Explore the Vision'), findsNWidgets(2));
      // The existing entry is untouched: the vision is a second layer, not a
      // replacement for what the project is today.
      expect(find.text(project.name), findsOneWidget);
      expect(find.text('What it does'.toUpperCase()), findsOneWidget);

      await tester.tap(find.text('Explore the Vision'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Master Chat's own opening scene, not Business Brain's.
      expect(find.text(_headlineOf(_masterChat, 0)), findsOneWidget);
      expect(find.text(_headlineOf(_businessBrain, 0)), findsNothing);
    });

    testWidgets('Business Brain still opens Business Brain', (tester) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'universal_business',
      );
      await _showDetailSheet(tester, project);
      await tester.tap(find.text('Explore the Vision'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text(_headlineOf(_businessBrain, 0)), findsOneWidget);
      expect(find.text(_headlineOf(_masterChat, 0)), findsNothing);
    });

    testWidgets('the Master Chat card carries the action too', (tester) async {
      final project = AppProjectsRepository.all.firstWhere(
        (p) => p.id == 'master_chat',
      );
      await _showCard(tester, project, 420);
      expect(find.byTooltip('Explore the Vision'), findsOneWidget);

      await tester.tap(find.byTooltip('Explore the Vision'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(_headlineOf(_masterChat, 0)), findsOneWidget);
    });

    testWidgets('other projects do not get one automatically', (tester) async {
      for (final id in ['hb_cure', 'madame_gatto', 'palettenfuchs']) {
        final matches = AppProjectsRepository.all.where((p) => p.id == id);
        if (matches.isEmpty) continue;
        await _showDetailSheet(tester, matches.first);
        expect(
          find.textContaining('Explore the Vision'),
          findsNothing,
          reason: '$id has no vision story and must not advertise one',
        );
      }
    });
  });

  // ── The story's honesty contract ─────────────────────────────────────────
  for (final story in _stories) {
    _playerSuite(story);
  }

  group('today versus vision', () {
    for (final story in _stories) {
      test('${story.projectId}: runtime stays in the 60–90 second window', () {
        expect(story.runtime.inSeconds, greaterThanOrEqualTo(60));
        expect(story.runtime.inSeconds, lessThanOrEqualTo(90));
      });

      test(
        '${story.projectId}: shows both what exists and where it is going',
        () {
          final stages = story.scenes.map((s) => s.stage).toSet();
          expect(stages, contains(VisionStage.today));
          expect(stages, contains(VisionStage.vision));
        },
      );

      test('${story.projectId}: every scene id is unique', () {
        final ids = story.scenes.map((s) => s.id).toList();
        expect(ids.toSet().length, ids.length);
      });
    }

    test('every forward-looking claim names what exists today', () {
      for (final scene in _stories.expand((s) => s.scenes)) {
        if (scene.stage == VisionStage.vision && scene.points.isNotEmpty) {
          expect(
            scene.stageNote,
            isNotNull,
            reason: '"${scene.id}" makes vision claims with no today note',
          );
        }
        // A today scene may carry a note as well. Master Chat's seventh
        // scene works now *and* points further, and a rule forbidding that
        // would have forced the dishonest half of the sentence.
      }
    });

    for (final story in _stories) {
      testWidgets('${story.projectId}: the vision badge is on screen', (
        tester,
      ) async {
        await _openStory(tester, story);
        final visionIndex = story.scenes.indexWhere(
          (s) => s.stage == VisionStage.vision,
        );
        await _tapTooltip(tester, story.scenes[visionIndex].kicker.source);

        expect(find.text('VISION'), findsOneWidget);
        expect(find.text('VISION STORY'), findsOneWidget);
        expect(
          find.text(story.scenes[visionIndex].stageNote!.source),
          findsOneWidget,
        );
      });
    }
  });
}

/// The whole player surface, exercised against one story.
///
/// Run for every published story: the engine is shared, so a second story is
/// exactly the thing that would expose an assumption baked into the first.
void _playerSuite(VisionStory story) {
  String headline(int index) => story.scenes[index].headline.source;

  /// "03 / 08" — derived, because the two stories are different lengths.
  String counter(int oneBased) =>
      '${oneBased.toString().padLeft(2, '0')} / '
      '${story.sceneCount.toString().padLeft(2, '0')}';

  group(story.projectId, () {
    // ── Transport ────────────────────────────────────────────────────────────
    group('player transport', () {
      testWidgets('opens on the first scene', (tester) async {
        await _openStory(tester, story);
        expect(find.text(headline(0)), findsOneWidget);
        expect(find.text(counter(1)), findsOneWidget);
        expect(find.byTooltip('Pause'), findsOneWidget);
      });

      testWidgets('autoplay advances through scenes', (tester) async {
        await _openStory(tester, story);
        await tester.pump(story.scenes[0].duration);
        await tester.pump(_settle);
        expect(find.text(headline(1)), findsOneWidget);
        expect(find.text(headline(0)), findsNothing);
      });

      testWidgets('pause really stops autoplay', (tester) async {
        await _openStory(tester, story);
        await _tapTooltip(tester, 'Pause');
        expect(find.byTooltip('Play'), findsOneWidget);

        // Well past the point where the scene would otherwise have advanced.
        await tester.pump(story.scenes[0].duration * 3);
        expect(find.text(headline(0)), findsOneWidget);
        expect(find.text(counter(1)), findsOneWidget);
      });

      testWidgets('play resumes from where it paused', (tester) async {
        await _openStory(tester, story);
        await tester.pump(const Duration(seconds: 5));
        await _tapTooltip(tester, 'Pause');
        await tester.pump(const Duration(seconds: 20));
        expect(find.text(headline(0)), findsOneWidget);

        await _tapTooltip(tester, 'Play');
        // Only the remainder of scene one is left, not a full scene.
        await tester.pump(const Duration(seconds: 5));
        await tester.pump(_settle);
        expect(find.text(headline(1)), findsOneWidget);
      });

      testWidgets('next moves forward', (tester) async {
        await _openStory(tester, story);
        await _tapTooltip(tester, 'Next scene');
        expect(find.text(headline(1)), findsOneWidget);
        expect(find.text(counter(2)), findsOneWidget);
      });

      testWidgets('previous steps back a scene near a scene start', (
        tester,
      ) async {
        await _openStory(tester, story);
        await _tapTooltip(tester, 'Next scene');
        await _tapTooltip(tester, 'Next scene');
        expect(find.text(counter(3)), findsOneWidget);

        await _tapTooltip(tester, 'Previous scene');
        expect(find.text(headline(1)), findsOneWidget);
        expect(find.text(counter(2)), findsOneWidget);
      });

      testWidgets('previous replays the current scene once it is under way', (
        tester,
      ) async {
        await _openStory(tester, story);
        await _tapTooltip(tester, 'Next scene');
        // Past the 35% mark of a 12s scene.
        await tester.pump(const Duration(seconds: 7));
        await _tapTooltip(tester, 'Previous scene');
        expect(find.text(counter(2)), findsOneWidget);
        expect(find.text(headline(1)), findsOneWidget);
      });

      testWidgets('a segment jumps straight to its scene', (tester) async {
        await _openStory(tester, story);
        // Each segment is tooltipped with its scene's kicker.
        await _tapTooltip(tester, story.scenes[3].kicker.source);
        expect(find.text(headline(3)), findsOneWidget);
        expect(find.text(counter(4)), findsOneWidget);
      });

      testWidgets('the scrubber actually fills as the story advances', (
        tester,
      ) async {
        await _openStory(tester, story);
        await _tapTooltip(tester, story.scenes[3].kicker.source);

        final fills = tester
            .widgetList<FractionallySizedBox>(find.byType(FractionallySizedBox))
            .toList();
        expect(fills, hasLength(story.sceneCount));
        // Played scenes are full, the rest are empty, and every segment has a
        // height — a missing heightFactor once made the fill invisible.
        for (var i = 0; i < 3; i++) {
          expect(fills[i].widthFactor, 1.0, reason: 'scene ${i + 1} is played');
        }
        expect(fills.last.widthFactor, 0.0);
        for (final fill in fills) {
          expect(fill.heightFactor, 1.0);
        }
      });

      testWidgets('manual navigation invalidates the previous scene timer', (
        tester,
      ) async {
        await _openStory(tester, story);
        // Sit just short of scene one's natural end, then jump away.
        await tester.pump(
          story.scenes[0].duration - const Duration(seconds: 1),
        );
        await _tapTooltip(tester, 'Next scene');
        expect(find.text(counter(2)), findsOneWidget);

        // The old timer, had it survived, would fire about here and push to
        // scene three. It must not.
        await tester.pump(const Duration(seconds: 2));
        expect(find.text(counter(2)), findsOneWidget);
        expect(find.text(headline(1)), findsOneWidget);
      });

      testWidgets('the end stops and offers a replay', (tester) async {
        await _openStory(tester, story);
        for (var i = 0; i < story.sceneCount - 1; i++) {
          await _tapTooltip(tester, 'Next scene');
        }
        expect(find.text(counter(story.sceneCount)), findsOneWidget);

        await tester.pump(story.scenes.last.duration);
        await tester.pump(_settle);
        expect(find.byTooltip('Replay'), findsOneWidget);
        expect(find.text('Watch again'), findsOneWidget);
        expect(find.text('See what exists today'), findsOneWidget);
        // It stops at the last scene rather than looping.
        await tester.pump(const Duration(seconds: 30));
        expect(find.text(counter(story.sceneCount)), findsOneWidget);

        await tester.tap(find.text('Watch again'));
        await tester.pump();
        await tester.pump(_settle);
        expect(find.text(counter(1)), findsOneWidget);
      });
    });

    // ── Lifecycle ────────────────────────────────────────────────────────────
    group('closing the story', () {
      testWidgets('close leaves nothing animating behind it', (tester) async {
        await _openStory(tester, story);
        await tester.pump(const Duration(seconds: 3));

        await tester.tap(find.byTooltip('Close'));
        await tester.pumpAndSettle();

        expect(find.text(headline(0)), findsNothing);
        expect(find.text('open story'), findsOneWidget);
        // A surviving ticker would keep a transient frame callback registered.
        expect(tester.binding.transientCallbackCount, 0);
        expect(tester.takeException(), isNull);
      });
    });

    // ── Reduced motion ───────────────────────────────────────────────────────
    group('reduced motion', () {
      testWidgets('scene copy is shown outright instead of fading in', (
        tester,
      ) async {
        await _openStory(tester, story, reducedMotion: true);
        expect(
          find.ancestor(
            of: find.text(headline(0)),
            matching: find.byType(Opacity),
          ),
          findsNothing,
          reason: 'reduced motion must not stage the text behind a fade',
        );
        expect(find.text(headline(0)), findsOneWidget);
      });

      testWidgets('the story still plays and stays fully readable', (
        tester,
      ) async {
        await _openStory(tester, story, reducedMotion: true);
        await tester.pump(story.scenes[0].duration);
        await tester.pump(_settle);
        expect(find.text(headline(1)), findsOneWidget);
        for (final point in story.scenes[1].points) {
          expect(find.text(point.source), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('animations are staged normally without the preference', (
        tester,
      ) async {
        await _openStory(tester, story);
        expect(
          find.ancestor(
            of: find.text(headline(0)),
            matching: find.byType(Opacity),
          ),
          findsOneWidget,
        );
      });
    });

    // ── Reduced motion, at the pixel level ───────────────────────────────────
    group('reduced motion diagrams', () {
      testWidgets('every scene visual is genuinely static', (tester) async {
        for (final scene in story.scenes) {
          final atStart = await _paintVisual(
            tester,
            scene,
            const VisionVisualState(
              entrance: 0,
              progress: 0,
              reducedMotion: true,
            ),
          );
          final atEnd = await _paintVisual(
            tester,
            scene,
            const VisionVisualState(
              entrance: 1,
              progress: 1,
              reducedMotion: true,
            ),
          );
          expect(
            atEnd,
            equals(atStart),
            reason: 'scene "${scene.id}" still animates under reduced motion',
          );
        }
      });

      testWidgets('and shows its finished state rather than an empty box', (
        tester,
      ) async {
        for (final scene in story.scenes) {
          final reduced = await _paintVisual(
            tester,
            scene,
            const VisionVisualState(
              entrance: 0,
              progress: 0,
              reducedMotion: true,
            ),
          );
          final unbuilt = await _paintVisual(
            tester,
            scene,
            const VisionVisualState(
              entrance: 0,
              progress: 0,
              reducedMotion: false,
            ),
          );
          // At t=0 an animated scene has barely drawn anything; the reduced
          // one must already be complete, so the two cannot match.
          expect(
            reduced,
            isNot(equals(unbuilt)),
            reason: 'scene "${scene.id}" renders nothing under reduced motion',
          );
        }
      });

      testWidgets('without the preference the diagrams do move', (
        tester,
      ) async {
        final scene = story.scenes[1];
        final early = await _paintVisual(
          tester,
          scene,
          const VisionVisualState(
            entrance: 0.2,
            progress: 0.07,
            reducedMotion: false,
          ),
        );
        final later = await _paintVisual(
          tester,
          scene,
          const VisionVisualState(
            entrance: 1,
            progress: 0.8,
            reducedMotion: false,
          ),
        );
        expect(later, isNot(equals(early)));
      });
    });

    // ── Layout ───────────────────────────────────────────────────────────────
    group('responsive layout', () {
      for (final size in <Size>[
        Size(320, 640), // smallest phone we support
        Size(360, 780),
        Size(390, 844), // iPhone
        Size(430, 932), // large phone
        Size(768, 1024), // iPad portrait
        Size(834, 1112),
        Size(1024, 768), // iPad landscape — short viewport
        Size(1280, 800),
        Size(1440, 900),
        Size(1920, 1080),
      ]) {
        testWidgets(
          'every scene fits at ${size.width.toInt()}×${size.height.toInt()}',
          (tester) async {
            await _openStory(tester, story, size: size);
            for (var i = 0; i < story.sceneCount; i++) {
              expect(
                tester.takeException(),
                isNull,
                reason: 'scene ${i + 1} overflowed at ${size.width}px',
              );
              if (i < story.sceneCount - 1) {
                await _tapTooltip(tester, 'Next scene');
              }
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    });
  });
}
