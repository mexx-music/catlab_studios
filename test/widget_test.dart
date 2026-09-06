import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catlab_studios/app.dart';
import 'package:catlab_studios/data/models/app_category.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/shared/widgets/app_card.dart';
import 'package:catlab_studios/shared/widgets/app_detail_sheet.dart';

/// Sets a wide viewport so the desktop layout is what gets exercised.
Future<void> _pumpSite(WidgetTester tester, {Size size = const Size(1440, 2400)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const CatLabApp());
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('landing page', () {
    testWidgets('renders the studio name', (tester) async {
      await _pumpSite(tester);
      expect(find.text('CatLab Studios'), findsOneWidget);
    });

    testWidgets('renders a card for every project', (tester) async {
      await _pumpSite(tester);
      expect(
        find.byType(AppCard, skipOffstage: false),
        findsNNWidgets(AppProjectsRepository.all.length),
      );
    });

    // Sweeps the real breakpoints: small phone, phone, large phone, the
    // 1→2 and 2→3 column boundaries, tablet portrait/landscape, MacBook and
    // wide desktop.
    for (final width in <double>[
      320, 390, 430, 559, 561, 768, 834, 899, 901, 1024, 1280, 1440, 1920,
    ]) {
      testWidgets('lays out without overflow at ${width.toInt()}px', (
        tester,
      ) async {
        await _pumpSite(tester, size: Size(width, 7000));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('category filter', () {
    testWidgets('narrows the grid to the chosen category', (tester) async {
      await _pumpSite(tester);

      final games = find.widgetWithText(GestureDetector, 'Games');
      await tester.ensureVisible(games.first);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(games.first, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 400));

      final gameCount = AppProjectsRepository.byCategory(AppCategory.games).length;
      expect(
        find.byType(AppCard, skipOffstage: false),
        findsNWidgets(gameCount),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('detail sheet', () {
    // Opens the sheet for the project whose content is longest, since that is
    // the one most likely to overflow.
    // Note: the hero runs a looping ambient animation, so `pumpAndSettle`
    // would never settle — pump fixed durations instead.
    Future<void> openBusiest(WidgetTester tester, Size size) async {
      await _pumpSite(tester, size: size);
      final card = find.byType(AppCard).first;
      await tester.ensureVisible(card);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(card, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    testWidgets('opens as a dialog on desktop and shows the details', (
      tester,
    ) async {
      await openBusiest(tester, const Size(1440, 2400));
      expect(find.byType(AppDetailSheet), findsOneWidget);
      expect(find.text('WHAT IT DOES'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('opens as a bottom sheet on a phone', (tester) async {
      await openBusiest(tester, const Size(390, 7000));
      expect(find.byType(AppDetailSheet), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('says so plainly when a project has no public link', (
      tester,
    ) async {
      await openBusiest(tester, const Size(1440, 2400));
      // The first card is HB Cure, which has no verified store link yet.
      expect(find.textContaining('Not publicly available yet'), findsOneWidget);
    });
  });

  group('portfolio data', () {
    test('every project has a non-empty tagline and description', () {
      for (final app in AppProjectsRepository.all) {
        expect(app.tagline, isNotEmpty, reason: '${app.name} tagline');
        expect(app.description, isNotEmpty, reason: '${app.name} description');
      }
    });

    test('project ids are unique', () {
      final ids = AppProjectsRepository.all.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('every link is an absolute https URL', () {
      for (final app in AppProjectsRepository.all) {
        for (final link in app.links) {
          final uri = Uri.tryParse(link.url);
          expect(uri, isNotNull, reason: '${app.name}: ${link.url}');
          expect(uri!.isAbsolute, isTrue, reason: '${app.name}: ${link.url}');
          expect(uri.scheme, 'https', reason: '${app.name}: ${link.url}');
        }
      }
    });

    test('icon assets point into the app_icons folder', () {
      for (final app in AppProjectsRepository.all.where((a) => a.hasIconAsset)) {
        expect(
          app.iconAsset,
          startsWith('assets/images/app_icons/'),
          reason: app.name,
        );
      }
    });

    test('exactly the three flagship apps are featured', () {
      expect(
        AppProjectsRepository.featured.map((a) => a.id).toSet(),
        {'hb_cure', 'master_chat', 'palettenfuchs'},
      );
    });

    test('byCategory filters, and every category is populated', () {
      expect(AppProjectsRepository.byCategory(null).length,
          AppProjectsRepository.all.length);
      for (final category in AppCategory.values) {
        expect(
          AppProjectsRepository.byCategory(category),
          isNotEmpty,
          reason: '${category.label} has no apps — drop it or fill it',
        );
      }
    });
  });
}

/// `findsNWidgets` with a clearer failure message for the card count.
Matcher findsNNWidgets(int n) => findsNWidgets(n);
