import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catlab_studios/app.dart';
import 'package:catlab_studios/core/l10n/app_locales.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/features/vision/data/business_brain_story.dart';
import 'package:catlab_studios/shared/widgets/language_switcher.dart';

/// Renders the site in a given language.
Future<void> _pumpSite(
  WidgetTester tester, {
  required Locale locale,
  Size size = const Size(1440, 2600),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.localesTestValue = [locale];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);

  await tester.pumpWidget(const CatLabApp());
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  // ── Completeness ─────────────────────────────────────────────────────────
  //
  // Checked at the source level rather than through a registry: a registry
  // only catches what someone remembered to register, while every
  // LocalizedText in the repository has to appear in a source file. A new
  // project added without a German tagline fails here.
  group('translation completeness', () {
    final sources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    test('every LocalizedText carries every supported language', () {
      final gaps = <String>[];

      for (final file in sources) {
        final text = file.readAsStringSync();
        // Each literal runs from "LocalizedText({" to its closing "})".
        for (final match in RegExp(
          r'LocalizedText\(\{(.*?)\}\)',
          dotAll: true,
        ).allMatches(text)) {
          final block = match.group(1)!;
          for (final locale in AppLocales.supported) {
            final code = locale.languageCode;
            if (!block.contains("'$code':")) {
              final preview = block.replaceAll(RegExp(r'\s+'), ' ').trim();
              gaps.add(
                '${file.path}: missing "$code" in '
                '${preview.substring(0, preview.length.clamp(0, 70))}…',
              );
            }
          }
        }
      }

      expect(
        gaps,
        isEmpty,
        reason:
            'untranslated copy would silently fall back to English:\n'
            '${gaps.join('\n')}',
      );
    });

    test('every project and vision scene is fully translated', () {
      for (final locale in AppLocales.supported) {
        final code = locale.languageCode;
        for (final project in AppProjectsRepository.all) {
          expect(
            project.tagline.values,
            contains(code),
            reason: '${project.id} has no $code tagline',
          );
          expect(project.description.values, contains(code));
          expect(project.categoryLabel.values, contains(code));
          for (final highlight in project.highlights) {
            expect(highlight.values, contains(code));
          }
        }
        for (final scene in businessBrainStory.scenes) {
          expect(
            scene.headline.values,
            contains(code),
            reason: 'scene ${scene.id} has no $code headline',
          );
          expect(scene.body.values, contains(code));
        }
      }
    });

    test('English is always present, because everything falls back to it', () {
      for (final project in AppProjectsRepository.all) {
        expect(project.tagline.source, isNotEmpty);
        expect(project.description.source, isNotEmpty);
      }
    });
  });

  // ── Rendering ────────────────────────────────────────────────────────────
  group('the site in German', () {
    testWidgets('a German browser gets German without touching anything', (
      tester,
    ) async {
      await _pumpSite(tester, locale: const Locale('de'));

      expect(find.text('Unsere Apps'), findsOneWidget);
      expect(find.text('Über das Studio'), findsOneWidget);
      expect(find.text('Was wir bauen'), findsWidgets);
      expect(find.text('Verbundene Produkte'), findsOneWidget);
      // And the English is gone, not merely joined.
      expect(find.text('Our Apps'), findsNothing);
      expect(find.text('About the Studio'), findsNothing);
    });

    testWidgets('project content is translated, not just the chrome', (
      tester,
    ) async {
      await _pumpSite(tester, locale: const Locale('de'));
      expect(
        find.text(
          'Bluetooth-Steuerung für CureBase- und CureClip-Geräte.',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Bluetooth control for CureBase and CureClip devices.',
          skipOffstage: false,
        ),
        findsNothing,
      );
    });

    testWidgets('an English browser still gets English', (tester) async {
      await _pumpSite(tester, locale: const Locale('en'));
      expect(find.text('Our Apps'), findsOneWidget);
      expect(find.text('Unsere Apps'), findsNothing);
    });

    testWidgets('an unsupported language falls back to English', (
      tester,
    ) async {
      await _pumpSite(tester, locale: const Locale('fr'));
      expect(find.text('Our Apps'), findsOneWidget);
    });
  });

  // ── Switcher ─────────────────────────────────────────────────────────────
  group('language switcher', () {
    testWidgets('offers every supported language', (tester) async {
      await _pumpSite(tester, locale: const Locale('en'));
      expect(find.byType(LanguageSwitcher), findsOneWidget);
      for (final locale in AppLocales.supported) {
        expect(find.text(AppLocales.shortLabel(locale)), findsOneWidget);
      }
    });

    testWidgets('switches the whole site, content included', (tester) async {
      await _pumpSite(tester, locale: const Locale('en'));
      expect(find.text('Our Apps'), findsOneWidget);

      await tester.tap(find.text('DE'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Unsere Apps'), findsOneWidget);
      expect(find.text('Our Apps'), findsNothing);
      expect(
        find.text(
          'Echtes Katzenschnurren für Schlaf, Fokus und Ruhe.',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('a chosen language outranks the browser', (tester) async {
      await _pumpSite(tester, locale: const Locale('de'));
      expect(find.text('Unsere Apps'), findsOneWidget);

      await tester.tap(find.text('EN'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Our Apps'), findsOneWidget);
    });

    testWidgets('lays out without overflow at every breakpoint', (
      tester,
    ) async {
      for (final width in <double>[320, 390, 560, 768, 1024, 1440, 1920]) {
        for (final locale in AppLocales.supported) {
          await _pumpSite(tester, locale: locale, size: Size(width, 7000));
          expect(
            tester.takeException(),
            isNull,
            reason:
                'overflowed at ${width.toInt()}px '
                'in ${locale.languageCode}',
          );
        }
      }
    });
  });
}
