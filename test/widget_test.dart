import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catlab_studios/app.dart';
import 'package:catlab_studios/core/config/beta_access_config.dart';
import 'package:catlab_studios/data/models/app_category.dart';
import 'package:catlab_studios/data/models/app_link.dart';
import 'package:catlab_studios/data/models/app_platform.dart';
import 'package:catlab_studios/data/models/app_project.dart';
import 'package:catlab_studios/data/models/app_status.dart';
import 'package:catlab_studios/shared/widgets/beta_access_dialog.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/data/repositories/connected_products_repository.dart';
import 'package:catlab_studios/features/home/presentation/sections/connected_products_section.dart';
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
    // AppDetailSheet always lives inside _SheetShell's scroll view; mirror
    // that here so a tall sheet is not a false overflow.
    Future<void> pumpDetail(WidgetTester tester, AppProject project) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AppDetailSheet(project: project),
            ),
          ),
        ),
      );
      await tester.pump();
    }

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
      // Medical ProCat is a concept with nothing public to link to.
      final concept = AppProjectsRepository.all
          .firstWhere((a) => a.id == 'medical_procat');
      expect(concept.hasLinks, isFalse);

      await pumpDetail(tester, concept);

      expect(find.textContaining('Not publicly available yet'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('HB Cure shows all three verified destinations', (
      tester,
    ) async {
      final hbCure =
          AppProjectsRepository.all.firstWhere((a) => a.id == 'hb_cure');
      await pumpDetail(tester, hbCure);

      expect(find.text('Download on the App Store'), findsOneWidget);
      expect(find.text('Get it on Google Play'), findsOneWidget);
      expect(find.text('Learn about CureClip & CureBase'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Feline Alarm separates iOS from the Android beta', (
      tester,
    ) async {
      final felineAlarm =
          AppProjectsRepository.all.firstWhere((a) => a.id == 'feline_alarm');
      await pumpDetail(tester, felineAlarm);

      expect(find.text('Beta · Closed Test'), findsOneWidget);
      expect(find.text('Available'), findsWidgets);
      expect(find.text('Join Android Beta'), findsOneWidget);
      expect(find.text('Download on the App Store'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('release information', () {
    AppProject byId(String id) =>
        AppProjectsRepository.all.firstWhere((a) => a.id == id);

    test('HB Cure offers App Store, Google Play and the hardware site', () {
      final hbCure = byId('hb_cure');
      expect(hbCure.status, AppStatus.available);
      expect(
        hbCure.links.map((l) => l.kind),
        containsAll([
          AppLinkKind.appStore,
          AppLinkKind.playStore,
          AppLinkKind.external,
        ]),
      );
      // The store listing must win the card's single button slot.
      expect(hbCure.primaryLink!.kind, AppLinkKind.appStore);
    });

    test('Feline Alarm is available on iOS and in beta on Android', () {
      final felineAlarm = byId('feline_alarm');
      expect(felineAlarm.status, AppStatus.available);
      expect(
        felineAlarm.platformStages[AppPlatform.ios],
        PlatformStage.available,
      );
      expect(
        felineAlarm.platformStages[AppPlatform.android],
        PlatformStage.beta,
      );
      expect(felineAlarm.hasBetaPlatform, isTrue);
    });

    test('no Play link is claimed while Android is in closed testing', () {
      final felineAlarm = byId('feline_alarm');
      expect(
        felineAlarm.links.any((l) => l.kind == AppLinkKind.playStore),
        isFalse,
        reason: 'a closed test has no public Play listing to link to',
      );
    });

    test('only projects with differing platforms declare stages', () {
      for (final app in AppProjectsRepository.all) {
        if (app.platformStages.isEmpty) continue;
        for (final platform in app.platformStages.keys) {
          expect(
            app.platforms,
            contains(platform),
            reason: '${app.name} stages a platform it does not list',
          );
        }
      }
    });
  });

  group('android beta flow', () {
    testWidgets('the request form cannot be submitted while unconfigured', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: BetaAccessDialog(appName: 'Feline Alarm')),
        ),
      );
      await tester.pump();

      expect(find.text('Join the Android Beta'), findsOneWidget);
      expect(find.textContaining('Google account email address'), findsOneWidget);

      expect(find.text('Request Beta Access'), findsOneWidget);

      // Guards the promise in BetaAccessConfig: with no destination set, a
      // submit must not report success. Typing a valid address and pressing
      // the button has to leave the form exactly where it was.
      if (!BetaAccessConfig.isConfigured) {
        expect(find.textContaining('not open yet'), findsOneWidget);

        await tester.enterText(find.byType(TextFormField), 'tester@gmail.com');
        await tester.pump();
        await tester.tap(find.text('Request Beta Access'), warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Almost there'), findsNothing);
        expect(find.text('Request Beta Access'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });
  });

  group('connected products', () {
    test('SchnurrPurr is a product, not a fifteenth app', () {
      expect(
        AppProjectsRepository.all.any(
          (a) => a.name.toLowerCase().contains('schnurrpurr'),
        ),
        isFalse,
        reason: 'a pillow has no status, platform or category — it belongs in '
            'the connected-products section',
      );
      expect(ConnectedProductsRepository.all, isNotEmpty);
    });

    test('the product links to its real site and to PurrLove', () {
      final product = ConnectedProductsRepository.all
          .firstWhere((p) => p.id == 'schnurrpurr');
      expect(product.links.single.url, 'https://schnurrpurr.com');
      expect(product.companionAppId, 'purrlove');
      // The companion id must resolve, or the cross-link silently does nothing.
      expect(
        AppProjectsRepository.all.any((a) => a.id == product.companionAppId),
        isTrue,
      );
    });

    test('no product claims app-controlled hardware', () {
      // PurrLove has no BLE dependency, no Bluetooth permission, and its
      // entitlement service documents module detection as unimplemented
      // "Phase 2" — so the site must not say the app connects to the module.
      for (final product in ConnectedProductsRepository.all) {
        final copy = '${product.description} ${product.highlights.join(' ')}'
            .toLowerCase();
        for (final claim in ['bluetooth', 'connect', 'control', 'pair']) {
          expect(copy.contains(claim), isFalse,
              reason: '${product.name} copy claims "$claim"');
        }
      }
    });

    test('product images are real assets under products/', () {
      for (final product in ConnectedProductsRepository.all) {
        expect(product.imageAsset, startsWith('assets/images/products/'));
        expect(File(product.imageAsset).existsSync(), isTrue,
            reason: '${product.imageAsset} is missing');
      }
    });

    testWidgets('the section renders on the landing page', (tester) async {
      await _pumpSite(tester);
      expect(find.byType(ConnectedProductsSection), findsOneWidget);
      expect(find.text('SchnurrPurr'), findsOneWidget);
      expect(find.text('Discover SchnurrPurr'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('PurrLove and Cat Purr Relax are one app', () {
    test('the Play listing name is stated, not split into a second entry', () {
      final purrlove =
          AppProjectsRepository.all.firstWhere((a) => a.id == 'purrlove');
      final play = purrlove.links
          .firstWhere((l) => l.kind == AppLinkKind.playStore);
      expect(play.displayLongLabel, contains('Cat Purr Relax'));
      expect(
        AppProjectsRepository.all
            .where((a) => a.name.toLowerCase().contains('cat purr relax')),
        isEmpty,
        reason: 'the same app must not appear twice',
      );
    });

    test('PurrLove names the SchnurrPurr set', () {
      final purrlove =
          AppProjectsRepository.all.firstWhere((a) => a.id == 'purrlove');
      expect(purrlove.companionProductNote, isNotNull);
      expect(purrlove.companionProductNote, contains('SchnurrPurr'));
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
