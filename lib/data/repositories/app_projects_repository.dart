import 'package:flutter/material.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/data/models/app_category.dart';
import 'package:catlab_studios/data/models/app_link.dart';
import 'package:catlab_studios/data/models/app_platform.dart';
import 'package:catlab_studios/data/models/app_project.dart';
import 'package:catlab_studios/data/models/app_status.dart';

/// Source of truth for the CatLab Studios portfolio.
///
/// Ground rules for editing this file:
///   * Only add a link that has been opened and verified. No link is better
///     than a broken or invented one — a project with no links simply shows no
///     button.
///   * Only claim a platform with evidence: a store listing, a live build, or a
///     configured production bundle id.
///   * When a status is ambiguous, pick the lower one.
///   * Open TODOs live next to the entry they belong to, never in the copy.
///
/// AI-hint: Replace the static list with a remote JSON fetch when a CMS exists.
abstract final class AppProjectsRepository {
  static const _iconPath = 'assets/images/app_icons';

  static const List<AppProject> all = [
    // ── HB Cure ────────────────────────────────────────────────────────────
    // Store listings verified 2026-09-07: Apple returns trackName "HB Cure"
    // (bundle com.mexxpichler.hbcure), and the Play listing for
    // com.catlabstudios.hbcure resolves where a bogus package 404s.
    AppProject(
      id: 'hb_cure',
      name: 'HB Cure',
      tagline: LocalizedText({
        'en': 'Bluetooth control for CureBase and CureClip devices.',
        'de': 'Bluetooth-Steuerung für CureBase- und CureClip-Geräte.',
      }),
      description: LocalizedText({
        'en':
            'HB Cure connects to CureBase and CureClip hardware over Bluetooth '
            'Low Energy and drives it from the phone: selecting programs, '
            'transferring frequency sequences, starting and stopping runs, and '
            'following the timer while a session is active.',
        'de':
            'HB Cure verbindet sich über Bluetooth Low Energy mit CureBase- und CureClip-Hardware und steuert sie vom Telefon aus: Programme auswählen, Frequenzsequenzen übertragen, Durchläufe starten und stoppen und den Timer während einer laufenden Sitzung verfolgen.',
      }),
      icon: Icons.bluetooth_connected_rounded,
      iconAsset: '$_iconPath/hb_cure.png',
      category: AppCategory.health,
      categoryLabel: LocalizedText({
        'en': 'Health · Device Control',
        'de': 'Gesundheit · Gerätesteuerung',
      }),
      status: AppStatus.available,
      platforms: [AppPlatform.ios, AppPlatform.android],
      links: [
        AppLink(
          kind: AppLinkKind.appStore,
          url: 'https://apps.apple.com/app/hb-cure/id6772611342',
        ),
        AppLink(
          kind: AppLinkKind.playStore,
          url:
              'https://play.google.com/store/apps/details?id=com.catlabstudios.hbcure',
        ),
        // The hardware this app drives is a Healing & Balance product. Linked
        // as further reading only — CatLab Studios builds the software.
        AppLink(
          kind: AppLinkKind.external,
          url: 'https://www.healing-balance.com/',
          label: LocalizedText({
            'en': 'Healing & Balance',
            'de': 'Healing & Balance',
          }),
          longLabel: LocalizedText({
            'en': 'Learn about CureClip & CureBase',
            'de': 'Mehr über CureClip & CureBase',
          }),
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'BLE connection to CureBase / CureClip hardware',
          'de': 'BLE-Verbindung zu CureBase-/CureClip-Hardware',
        }),
        LocalizedText({
          'en': 'Program library with frequency sequences',
          'de': 'Programmbibliothek mit Frequenzsequenzen',
        }),
        LocalizedText({
          'en': 'Program upload, start, pause and stop from the app',
          'de':
              'Programme übertragen, starten, pausieren und stoppen — aus der App',
        }),
        LocalizedText({
          'en': 'Live session timer and device status',
          'de': 'Live-Timer der Sitzung und Gerätestatus',
        }),
      ],
      featured: true,
    ),

    // ── Master Chat ────────────────────────────────────────────────────────
    AppProject(
      id: 'master_chat',
      name: 'Master Chat',
      tagline: LocalizedText({
        'en': 'One chat surface that drives every tool in the studio.',
        'de': 'Eine Chat-Oberfläche, die jedes Werkzeug des Studios steuert.',
      }),
      description: LocalizedText({
        'en':
            'Master Chat is the studio\'s central AI layer: a single chat '
            'interface that routes a request to whichever registered tool can '
            'answer it. The AI provider is pluggable, actions that change '
            'something ask for confirmation first, and the same tools are '
            'reachable by external agents through a gateway.',
        'de':
            'Master Chat ist die zentrale KI-Schicht des Studios: eine einzige Chat-Oberfläche, die eine Anfrage an das registrierte Werkzeug weiterleitet, das sie beantworten kann. Der KI-Anbieter ist austauschbar, Aktionen mit Auswirkungen fragen vorher nach, und dieselben Werkzeuge sind über ein Gateway auch für externe Agenten erreichbar.',
      }),
      // TODO(assets): masterchat still ships the default Flutter icon — no real
      // app icon exists yet. Falls back to the CatLab gradient tile.
      icon: Icons.forum_rounded,
      category: AppCategory.ai,
      categoryLabel: LocalizedText({
        'en': 'AI · Platform',
        'de': 'KI · Plattform',
      }),
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/masterchat-web/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Natural-language routing to registered tools',
          'de':
              'Weiterleitung in natürlicher Sprache an registrierte Werkzeuge',
        }),
        LocalizedText({
          'en': 'Vendor-neutral AI provider layer',
          'de': 'Herstellerneutrale KI-Anbieterschicht',
        }),
        LocalizedText({
          'en': 'Confirmation step before any action tool runs',
          'de': 'Bestätigung, bevor ein ausführendes Werkzeug läuft',
        }),
        LocalizedText({
          'en': 'Conversations persist across sessions',
          'de': 'Unterhaltungen bleiben über Sitzungen hinweg erhalten',
        }),
        LocalizedText({
          'en': 'Shared tool gateway for external agents',
          'de': 'Gemeinsames Werkzeug-Gateway für externe Agenten',
        }),
      ],
      featured: true,
    ),

    // ── Palettenfuchs ──────────────────────────────────────────────────────
    AppProject(
      id: 'palettenfuchs',
      name: 'Palettenfuchs',
      tagline: LocalizedText({
        'en': 'Plan a trailer load before the forklift moves.',
        'de': 'Die Ladung planen, bevor der Stapler fährt.',
      }),
      description: LocalizedText({
        'en':
            'Palettenfuchs works out how a truck trailer can be loaded: it lays '
            'out Euro and industrial pallets row by row, handles mixed rows, '
            'tracks weight distribution, and keeps the load patterns a driver '
            'uses repeatedly.',
        'de':
            'Palettenfuchs ermittelt, wie ein Lkw-Auflieger beladen werden kann: Euro- und Industriepaletten werden Reihe für Reihe angeordnet, gemischte Reihen inklusive, die Gewichtsverteilung wird mitgeführt, und wiederkehrende Lademuster bleiben gespeichert.',
      }),
      icon: Icons.local_shipping_rounded,
      iconAsset: '$_iconPath/palettenfuchs.png',
      category: AppCategory.logistics,
      categoryLabel: LocalizedText({
        'en': 'Logistics · Business',
        'de': 'Logistik · Business',
      }),
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/palettenfuchs/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Euro and industrial pallets, including mixed rows',
          'de': 'Euro- und Industriepaletten, auch in gemischten Reihen',
        }),
        LocalizedText({
          'en': 'Visual trailer layout with row arrangements',
          'de': 'Visuelle Aufliegeransicht mit Reihenanordnung',
        }),
        LocalizedText({
          'en': 'Weight distribution per row',
          'de': 'Gewichtsverteilung je Reihe',
        }),
        LocalizedText({
          'en': 'Saved load patterns for recurring tours',
          'de': 'Gespeicherte Lademuster für wiederkehrende Touren',
        }),
        LocalizedText({
          'en': 'Nine languages: DE, EN, NO, DA, PL, RO, BG, TR, SR',
          'de': 'Neun Sprachen: DE, EN, NO, DA, PL, RO, BG, TR, SR',
        }),
      ],
      featured: true,
    ),

    // ── Universal Business ─────────────────────────────────────────────────
    AppProject(
      id: 'universal_business',
      name: 'Universal Business',
      tagline: LocalizedText({
        'en': 'Answers grounded in a company\'s own approved knowledge.',
        'de':
            'Antworten, die auf dem freigegebenen Wissen des Unternehmens beruhen.',
      }),
      description: LocalizedText({
        'en':
            'Universal Business turns scattered company knowledge into answers '
            'that cite their sources and decline to guess when the evidence is '
            'missing. Anything uncertain is handed to a human reviewer instead '
            'of being invented.',
        'de':
            'Universal Business macht aus verstreutem Firmenwissen Antworten, die ihre Quellen nennen und nicht raten, wenn die Belege fehlen. Alles Unsichere geht an eine menschliche Prüfung, statt erfunden zu werden.',
      }),
      icon: Icons.hub_rounded,
      iconAsset: '$_iconPath/universal_business.png',
      category: AppCategory.business,
      categoryLabel: LocalizedText({
        'en': 'Business · AI',
        'de': 'Business · KI',
      }),
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://universal-business-bot-platform.pages.dev/jury',
          label: LocalizedText({'en': 'Open Demo', 'de': 'Demo öffnen'}),
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Answers grounded in approved company material only',
          'de': 'Antworten ausschließlich aus freigegebenem Firmenmaterial',
        }),
        LocalizedText({
          'en': 'Every answer shows where it came from',
          'de': 'Jede Antwort zeigt, woher sie stammt',
        }),
        LocalizedText({
          'en': 'Uncertain cases routed to human review',
          'de': 'Unsichere Fälle gehen in die menschliche Prüfung',
        }),
        LocalizedText({
          'en': 'Workspace and account tenancy',
          'de': 'Mandantenfähigkeit für Workspaces und Konten',
        }),
      ],
    ),

    // ── Madame Gatto ───────────────────────────────────────────────────────
    AppProject(
      id: 'madame_gatto',
      name: 'Madame Gatto',
      tagline: LocalizedText({
        'en': 'Tarot, astrology, graphology and palmistry in one reading.',
        'de': 'Tarot, Astrologie, Graphologie und Handlesen in einer Deutung.',
      }),
      description: LocalizedText({
        'en':
            'Madame Gatto is a mystic reading app built around a single persona. '
            'It covers tarot draws, astrology, handwriting analysis and '
            'palmistry, and can combine them into one larger reading.',
        'de':
            'Madame Gatto ist eine App für mystische Deutungen rund um eine einzige Figur. Sie umfasst Tarotkarten, Astrologie, Handschriftanalyse und Handlesen — und kann all das zu einer großen Deutung zusammenführen.',
      }),
      icon: Icons.auto_awesome_rounded,
      iconAsset: '$_iconPath/madame_gatto.png',
      category: AppCategory.lifestyle,
      categoryLabel: LocalizedText({
        'en': 'Lifestyle · Entertainment',
        'de': 'Alltag · Unterhaltung',
      }),
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/-cat_oracle/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Tarot draws with card interpretations',
          'de': 'Tarotkarten mit Kartendeutung',
        }),
        LocalizedText({
          'en': 'Astrology readings',
          'de': 'Astrologische Deutungen',
        }),
        LocalizedText({
          'en': 'Graphology — handwriting analysis',
          'de': 'Graphologie — Handschriftanalyse',
        }),
        LocalizedText({
          'en': 'Palmistry via hand scan',
          'de': 'Handlesen per Handscan',
        }),
        LocalizedText({
          'en': 'Combined grand reading across all four',
          'de': 'Große Gesamtdeutung über alle vier Bereiche',
        }),
      ],
    ),

    // ── PurrLove ───────────────────────────────────────────────────────────
    AppProject(
      id: 'purrlove',
      name: 'PurrLove',
      tagline: LocalizedText({
        'en': 'Real cat purrs for sleep, focus and calm.',
        'de': 'Echtes Katzenschnurren für Schlaf, Fokus und Ruhe.',
      }),
      description: LocalizedText({
        'en':
            'PurrLove loops recorded cat purring as a calming soundscape. Pick a '
            'cat, set a timer, adjust the volume — and it keeps playing with the '
            'screen locked.',
        'de':
            'PurrLove spielt aufgenommenes Katzenschnurren als beruhigende Klangkulisse in Schleife. Katze auswählen, Timer stellen, Lautstärke anpassen — und es läuft auch bei gesperrtem Bildschirm weiter.',
      }),
      icon: Icons.pets_rounded,
      iconAsset: '$_iconPath/purrlove.png',
      category: AppCategory.lifestyle,
      categoryLabel: LocalizedText({
        'en': 'Lifestyle · Wellbeing',
        'de': 'Alltag · Wohlbefinden',
      }),
      status: AppStatus.available,
      platforms: [AppPlatform.ios, AppPlatform.android],
      links: [
        AppLink(
          kind: AppLinkKind.appStore,
          url: 'https://apps.apple.com/us/app/purrlove/id6771538849',
        ),
        // Same app, different store name: the Play listing is published as
        // "Cat Purr Relax". Saying so on the button avoids looking like a
        // wrong link without splitting one app into two entries.
        AppLink(
          kind: AppLinkKind.playStore,
          url:
              'https://play.google.com/store/apps/details?id=com.mexx.schnurr_app',
          label: LocalizedText({'en': 'Google Play', 'de': 'Google Play'}),
          longLabel: LocalizedText({
            'en': 'Get it on Google Play — listed as Cat Purr Relax',
            'de': 'Jetzt bei Google Play — dort als Cat Purr Relax',
          }),
        ),
      ],
      companionProductNote: LocalizedText({
        'en':
            'PurrLove is the app in the SchnurrPurr set — a plush pillow with a '
            'removable purr module.',
        'de':
            'PurrLove ist die App zum SchnurrPurr-Set — einem Plüschkissen mit herausnehmbarem Schnurrmodul.',
      }),
      highlights: [
        LocalizedText({
          'en': 'Several cats, each with its own purr recording',
          'de': 'Mehrere Katzen, jede mit eigener Schnurraufnahme',
        }),
        LocalizedText({
          'en': 'Sleep timer from 10 to 90 minutes, or endless',
          'de': 'Einschlaftimer von 10 bis 90 Minuten — oder endlos',
        }),
        LocalizedText({
          'en': 'Separate volume control',
          'de': 'Eigene Lautstärkeregelung',
        }),
        LocalizedText({
          'en': 'Keeps playing in the background',
          'de': 'Spielt im Hintergrund weiter',
        }),
      ],
    ),

    // ── Feline Alarm ───────────────────────────────────────────────────────
    // Verified 2026-09-07 through Apple's lookup API: bundle
    // com.mexxcatlab.catalarm — which matches cat_alarm's iOS project exactly
    // — resolves to trackName "Feline Alarm", id 6767463395.
    //
    // Android is in Google Play closed testing, so it has no public listing
    // (com.mexx.catalarm returns 404) and deliberately gets no store link.
    // Hence the per-platform stages below rather than one blanket status.
    AppProject(
      id: 'feline_alarm',
      name: 'Feline Alarm',
      tagline: LocalizedText({
        'en': 'Wake up to cats instead of a siren.',
        'de': 'Mit Katzen aufwachen statt mit einer Sirene.',
      }),
      description: LocalizedText({
        'en':
            'Feline Alarm is a cat-themed alarm clock: a calm, dark clock face '
            'and gentle wake-up sounds rather than a jarring ringtone.',
        'de':
            'Feline Alarm ist ein Wecker im Katzen-Design: ein ruhiges, dunkles Ziffernblatt und sanfte Weckklänge statt eines schrillen Klingeltons.',
      }),
      icon: Icons.alarm_rounded,
      iconAsset: '$_iconPath/feline_alarm.png',
      category: AppCategory.lifestyle,
      categoryLabel: LocalizedText({
        'en': 'Utility · Lifestyle',
        'de': 'Werkzeug · Alltag',
      }),
      status: AppStatus.available,
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      platformStages: {
        AppPlatform.ios: PlatformStage.available,
        AppPlatform.android: PlatformStage.beta,
      },
      links: [
        AppLink(
          kind: AppLinkKind.appStore,
          url: 'https://apps.apple.com/app/feline-alarm/id6767463395',
        ),
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/cat-alarm-web/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Cat-themed alarm clock face',
          'de': 'Weckerziffernblatt im Katzen-Design',
        }),
        LocalizedText({
          'en': 'Gentle wake-up sound',
          'de': 'Sanfter Weckklang',
        }),
        LocalizedText({
          'en': 'Dark, low-glare night display',
          'de': 'Dunkle, blendarme Nachtanzeige',
        }),
      ],
    ),

    // ── Transzendent ───────────────────────────────────────────────────────
    AppProject(
      id: 'transzendent',
      name: 'Transzendent',
      tagline: LocalizedText({
        'en': 'Guided hypnosis and relaxation sessions.',
        'de': 'Geführte Hypnose- und Entspannungssitzungen.',
      }),
      description: LocalizedText({
        'en':
            'Transzendent plays guided hypnosis and relaxation sessions grouped '
            'by intent — relaxation, sleep, motivation — over ambient background '
            'sound, with a sleep timer and a library to manage them.',
        'de':
            'Transzendent spielt geführte Hypnose- und Entspannungssitzungen, gegliedert nach Ziel — Entspannung, Schlaf, Motivation — über ruhiger Hintergrundklangkulisse, mit Einschlaftimer und einer Bibliothek zur Verwaltung.',
      }),
      icon: Icons.blur_on_rounded,
      iconAsset: '$_iconPath/transzendent.png',
      category: AppCategory.lifestyle,
      categoryLabel: LocalizedText({
        'en': 'Lifestyle · Wellbeing',
        'de': 'Alltag · Wohlbefinden',
      }),
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/transzendent/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Sessions grouped by category',
          'de': 'Sitzungen nach Kategorien gegliedert',
        }),
        LocalizedText({
          'en': 'Positive suggestion scripts',
          'de': 'Texte mit positiven Suggestionen',
        }),
        LocalizedText({
          'en': 'Audio player with ambient background sound',
          'de': 'Audioplayer mit ruhiger Hintergrundklangkulisse',
        }),
        LocalizedText({'en': 'Sleep timer', 'de': 'Einschlaftimer'}),
        LocalizedText({'en': 'Session library', 'de': 'Sitzungsbibliothek'}),
      ],
    ),

    // ── CatQuiz ────────────────────────────────────────────────────────────
    AppProject(
      id: 'catquiz',
      name: 'CatQuiz',
      tagline: LocalizedText({
        'en': 'How much do you really know about cats?',
        'de': 'Wie viel wissen Sie wirklich über Katzen?',
      }),
      description: LocalizedText({
        'en':
            'CatQuiz is a quiz app about cats — breeds, behaviour, body '
            'language and communication — with question sets in German and '
            'English.',
        'de':
            'CatQuiz ist eine Quiz-App rund um Katzen — Rassen, Verhalten, Körpersprache und Kommunikation — mit Fragensätzen auf Deutsch und Englisch.',
      }),
      icon: Icons.quiz_rounded,
      iconAsset: '$_iconPath/catquiz.png',
      category: AppCategory.games,
      categoryLabel: LocalizedText({
        'en': 'Game · Entertainment',
        'de': 'Spiel · Unterhaltung',
      }),
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/catlab-quiz/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Quiz sets on breeds, behaviour and body language',
          'de': 'Fragensätze zu Rassen, Verhalten und Körpersprache',
        }),
        LocalizedText({
          'en': 'Beginner through expert difficulty',
          'de': 'Schwierigkeitsgrade von Einsteiger bis Experte',
        }),
        LocalizedText({
          'en': 'German and English question sets',
          'de': 'Fragensätze auf Deutsch und Englisch',
        }),
      ],
    ),

    // ── DriveTime Arrival ──────────────────────────────────────────────────
    AppProject(
      id: 'drivetime_arrival',
      name: 'DriveTime Arrival',
      tagline: LocalizedText({
        'en': 'Arrival times that account for how a truck really drives.',
        'de':
            'Ankunftszeiten, die berücksichtigen, wie ein Lkw wirklich fährt.',
      }),
      description: LocalizedText({
        'en':
            'DriveTime Arrival plans a tour the way a driver actually drives '
            'it: Google\'s car times are capped to truck speeds per stretch of '
            'road, breaks, daily and weekly rests are placed along the way, '
            'and a ferry is planned with its real departure rather than as a '
            'rough crossing time. The result is an arrival time, a timeline '
            'and a map of the route — not just a distance.',
        'de':
            'DriveTime Arrival plant eine Tour so, wie sie wirklich gefahren wird: Googles Pkw-Zeiten werden je Streckenabschnitt auf Lkw-Tempo gedeckelt, Pausen sowie Tages- und Wochenruhezeiten unterwegs eingeplant, und eine Fähre wird mit ihrer echten Abfahrt gerechnet statt mit einer groben Überfahrtsdauer. Heraus kommen Ankunftszeit, Zeitstrahl und Karte der Strecke — nicht nur eine Entfernung.',
      }),
      // TODO(assets): drivetimearrival still ships the default Flutter icon —
      // no real app icon exists yet. Falls back to the CatLab gradient tile.
      icon: Icons.route_rounded,
      category: AppCategory.logistics,
      categoryLabel: LocalizedText({
        'en': 'Transport · Logistics',
        'de': 'Transport · Logistik',
      }),
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/drive-time-arrival-web/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Truck speed per stretch of road, not a car average',
          'de': 'Lkw-Tempo je Streckenabschnitt statt Pkw-Schnitt',
        }),
        LocalizedText({
          'en': 'Breaks, daily and weekly rests placed along the route',
          'de': 'Pausen, Tages- und Wochenruhezeiten unterwegs eingeplant',
        }),
        LocalizedText({
          'en': 'Ferries planned with their scheduled departure',
          'de': 'Fähren mit ihrer planmäßigen Abfahrt eingeplant',
        }),
        LocalizedText({
          'en': 'Saved routes for corridors a driver knows better',
          'de': 'Gespeicherte Routen für Korridore, die der Fahrer besser kennt',
        }),
        LocalizedText({
          'en': 'Map of the route and a tour summary to share',
          'de': 'Karte der Strecke und Tour-Zusammenfassung zum Teilen',
        }),
      ],
    ),

    // ── CatSlot ────────────────────────────────────────────────────────────
    AppProject(
      id: 'catslot',
      name: 'CatSlot',
      tagline: LocalizedText({
        'en': 'A casual slot machine, staffed entirely by cats.',
        'de': 'Ein Casual-Spielautomat, ausschließlich von Katzen betrieben.',
      }),
      description: LocalizedText({
        'en':
            'CatSlot is a casual slot game with several cat symbol sets, spin '
            'animations, payouts and a running balance. Play money only.',
        'de':
            'CatSlot ist ein Casual-Slotspiel mit mehreren Katzen-Symbolsätzen, Drehanimationen, Gewinnauswertung und laufendem Kontostand. Ausschließlich Spielgeld.',
      }),
      icon: Icons.casino_rounded,
      iconAsset: '$_iconPath/catslot.png',
      category: AppCategory.games,
      categoryLabel: LocalizedText({
        'en': 'Game · Casual',
        'de': 'Spiel · Casual',
      }),
      status: AppStatus.inDevelopment,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/cat-slot-web/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Multiple cat symbol sets',
          'de': 'Mehrere Katzen-Symbolsätze',
        }),
        LocalizedText({
          'en': 'Spin animation with payout evaluation',
          'de': 'Drehanimation mit Gewinnauswertung',
        }),
        LocalizedText({
          'en': 'Running play-money balance',
          'de': 'Laufender Spielgeld-Kontostand',
        }),
      ],
    ),

    // ── Catsdom ────────────────────────────────────────────────────────────
    AppProject(
      id: 'catsdom',
      name: 'Catsdom',
      tagline: LocalizedText({
        'en': 'Match-three on an 8×8 board of cats.',
        'de': 'Match-3 auf einem 8×8-Feld voller Katzen.',
      }),
      description: LocalizedText({
        'en':
            'Catsdom is a casual match-three puzzle: an 8×8 board, six symbol '
            'types, tap and drag controls, cascading matches and a move limit. '
            'Installable as a PWA and playable offline.',
        'de':
            'Catsdom ist ein Casual-Match-3-Puzzle: ein 8×8-Feld, sechs Symboltypen, Steuerung per Tippen und Ziehen, Kettenkombinationen und ein Zuglimit. Als PWA installierbar und offline spielbar.',
      }),
      icon: Icons.grid_view_rounded,
      iconAsset: '$_iconPath/catsdom.png',
      category: AppCategory.games,
      categoryLabel: LocalizedText({
        'en': 'Game · Puzzle',
        'de': 'Spiel · Puzzle',
      }),
      status: AppStatus.prototype,
      platforms: [AppPlatform.web, AppPlatform.android],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/catsdom/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': '8×8 board with six symbol types',
          'de': '8×8-Feld mit sechs Symboltypen',
        }),
        LocalizedText({
          'en': 'Tap and drag controls',
          'de': 'Steuerung per Tippen und Ziehen',
        }),
        LocalizedText({
          'en': 'Cascading matches, scoring and a move limit',
          'de': 'Kettenkombinationen, Punkte und ein Zuglimit',
        }),
        LocalizedText({
          'en': 'Installable PWA, works offline',
          'de': 'Installierbare PWA, funktioniert offline',
        }),
      ],
    ),

    // ── CatSnake ───────────────────────────────────────────────────────────
    AppProject(
      id: 'catsnake',
      name: 'CatSnake',
      tagline: LocalizedText({
        'en': 'Snake, but the snake is a very long cat.',
        'de': 'Snake — nur ist die Schlange eine sehr lange Katze.',
      }),
      description: LocalizedText({
        'en':
            'CatSnake is a small casual take on the classic snake game with cat '
            'artwork, sound effects and music.',
        'de':
            'CatSnake ist eine kleine Casual-Variante des Snake-Klassikers mit Katzengrafiken, Soundeffekten und Musik.',
      }),
      icon: Icons.gesture_rounded,
      iconAsset: '$_iconPath/catsnake.png',
      category: AppCategory.games,
      categoryLabel: LocalizedText({
        'en': 'Game · Casual',
        'de': 'Spiel · Casual',
      }),
      status: AppStatus.prototype,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/cat-snake-web/',
        ),
      ],
      highlights: [
        LocalizedText({
          'en': 'Classic snake loop with cat artwork',
          'de': 'Klassisches Snake-Prinzip mit Katzengrafiken',
        }),
        LocalizedText({
          'en': 'Sound effects and background music',
          'de': 'Soundeffekte und Hintergrundmusik',
        }),
      ],
    ),

    // ── Medical ProCat ─────────────────────────────────────────────────────
    // TODO(project): No repository, assets or specification exist for this yet
    // — it is a named concept only. Everything below stays deliberately vague
    // until there is something real to describe. No icon, no links.
    AppProject(
      id: 'medical_procat',
      name: 'Medical ProCat',
      tagline: LocalizedText({
        'en': 'An AI research assistant for medical information.',
        'de': 'Ein KI-Rechercheassistent für medizinische Informationen.',
      }),
      description: LocalizedText({
        'en':
            'Medical ProCat is an early concept for an AI assistant focused on '
            'finding and organising medical information and research. It is an '
            'information tool — it does not diagnose, treat, or give medical '
            'advice.',
        'de':
            'Medical ProCat ist ein frühes Konzept für einen KI-Assistenten, der medizinische Informationen und Studien findet und ordnet. Es ist ein Informationswerkzeug — es stellt keine Diagnosen, behandelt nicht und gibt keine medizinischen Ratschläge.',
      }),
      icon: Icons.biotech_rounded,
      category: AppCategory.health,
      categoryLabel: LocalizedText({
        'en': 'Health · AI',
        'de': 'Gesundheit · KI',
      }),
      status: AppStatus.concept,
    ),
  ];

  /// Apps highlighted at the top of the portfolio.
  static List<AppProject> get featured =>
      all.where((app) => app.featured).toList();

  /// Categories that actually have at least one app, in enum order.
  static List<AppCategory> get usedCategories => AppCategory.values
      .where((c) => all.any((app) => app.category == c))
      .toList();

  static List<AppProject> byCategory(AppCategory? category) => category == null
      ? all
      : all.where((app) => app.category == category).toList();
}
