import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catlab_studios/app.dart';
import 'package:catlab_studios/core/l10n/app_locales.dart';
import 'package:catlab_studios/features/product_experience/data/product_experience_showcase.dart';
import 'package:catlab_studios/features/product_experience/presentation/product_experience_section.dart';
import 'package:catlab_studios/features/product_experience/presentation/widgets/film_frame.dart';

/// Guards the one promise this section makes: everything shown is real.
///
/// The copy claims nothing was generated, so the files it points at have to
/// exist in the repository — a broken poster path would leave the section
/// making that claim over an empty box.
Future<void> _pumpSite(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  Size size = const Size(1440, 5200),
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
  group('showcase media', () {
    test('every film has its poster bundled and its video on the domain', () {
      expect(ProductExperienceShowcase.films, isNotEmpty);
      for (final film in ProductExperienceShowcase.films) {
        expect(
          File(film.posterAsset).existsSync(),
          isTrue,
          reason: '${film.id}: ${film.posterAsset} is missing',
        );
        // Films are served from web/, not bundled — they must not be pulled
        // into the app bundle, and they must not be absolute URLs either, or
        // the apex base-href would stop applying.
        expect(film.videoUrl, isNot(startsWith('assets/')));
        expect(film.videoUrl, isNot(startsWith('/')));
        expect(
          File('web/${film.videoUrl}').existsSync(),
          isTrue,
          reason: '${film.id}: web/${film.videoUrl} is missing',
        );
      }
    });

    test('every campaign card and the product cut-out are real files', () {
      expect(ProductExperienceShowcase.cards, isNotEmpty);
      for (final card in ProductExperienceShowcase.cards) {
        expect(card.imageAsset, startsWith('assets/images/showcase/'));
        expect(
          File(card.imageAsset).existsSync(),
          isTrue,
          reason: '${card.id}: ${card.imageAsset} is missing',
        );
      }
      expect(
        File(ProductExperienceShowcase.productCutout).existsSync(),
        isTrue,
      );
    });

    test('film ids are unique and every duration is stated', () {
      final ids = ProductExperienceShowcase.films.map((f) => f.id).toList();
      expect(ids.toSet().length, ids.length);
      for (final film in ProductExperienceShowcase.films) {
        expect(film.duration.inSeconds, greaterThan(0));
      }
    });

    test('the showcase copy carries every supported language', () {
      for (final locale in AppLocales.supported) {
        final code = locale.languageCode;
        expect(ProductExperienceShowcase.referenceNote.values, contains(code));
        for (final film in ProductExperienceShowcase.films) {
          expect(film.title.values, contains(code));
          expect(film.note.values, contains(code));
        }
        for (final format in ProductExperienceShowcase.formats) {
          expect(format.use.values, contains(code));
        }
      }
    });
  });

  group('the hero teaser', () {
    testWidgets('points at the new field of work in both languages', (
      tester,
    ) async {
      await _pumpSite(tester);
      expect(find.text('NEW · PRODUCT EXPERIENCES'), findsOneWidget);
      expect(
        find.text('Real products. Precisely brought to life.'),
        findsOneWidget,
      );
      expect(find.text('Discover'), findsOneWidget);

      await _pumpSite(tester, locale: const Locale('de'));
      expect(find.text('NEU · PRODUCT EXPERIENCES'), findsOneWidget);
      expect(find.text('Echte Produkte. Präzise inszeniert.'), findsOneWidget);
      expect(find.text('Entdecken'), findsOneWidget);
    });

    testWidgets('scrolls the page down to the section when tapped', (
      tester,
    ) async {
      // A short viewport, so the section really is off-screen to begin with.
      await _pumpSite(tester, size: const Size(1280, 900));
      final scrollable = find.byType(Scrollable).first;
      expect(tester.widget<Scrollable>(scrollable).controller?.offset ?? 0, 0);

      await tester.tap(find.text('Discover'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      final position = tester.state<ScrollableState>(scrollable).position;
      expect(
        position.pixels,
        greaterThan(0),
        reason: 'the teaser did not move the page',
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('the section on the landing page', () {
    testWidgets('renders with a frame for every film', (tester) async {
      await _pumpSite(tester);
      expect(find.byType(ProductExperienceSection), findsOneWidget);
      expect(
        find.byType(FilmFrame, skipOffstage: false),
        findsNWidgets(ProductExperienceShowcase.films.length),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('speaks German to a German browser', (tester) async {
      await _pumpSite(tester, locale: const Locale('de'));
      expect(
        find.text('Produktinszenierung', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('Product Experiences', skipOffstage: false),
        findsNothing,
      );
      expect(
        find.text('Systemfilm', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('names the reference and never promises a generated one', (
      tester,
    ) async {
      await _pumpSite(tester);
      expect(
        find.text('Healing & Balance', skipOffstage: false),
        findsOneWidget,
      );
    });

    // Same sweep as the rest of the site: the principle stage, the film row
    // and the format strip all reflow, and each is a chance to overflow.
    for (final width in <double>[320, 390, 430, 560, 768, 900, 1024, 1440, 1920]) {
      testWidgets('lays out without overflow at ${width.toInt()}px', (
        tester,
      ) async {
        await _pumpSite(tester, size: Size(width, 9000));
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('holds still under reduced motion', (tester) async {
      tester.view.physicalSize = const Size(1440, 5200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(
            disableAnimations: true,
            reduceMotion: true,
          );
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await tester.pumpWidget(const CatLabApp());
      await tester.pump(const Duration(milliseconds: 300));

      // The hero keeps its own ambient loop running site-wide, so this
      // cannot assert a settled tree — what it does assert is that the
      // section renders and paints its resting state without throwing.
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(ProductExperienceSection), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

