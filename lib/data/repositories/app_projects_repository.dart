import 'package:flutter/material.dart';
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
      tagline: 'Bluetooth control for CureBase and CureClip devices.',
      description:
          'HB Cure connects to CureBase and CureClip hardware over Bluetooth '
          'Low Energy and drives it from the phone: selecting programs, '
          'transferring frequency sequences, starting and stopping runs, and '
          'following the timer while a session is active.',
      icon: Icons.bluetooth_connected_rounded,
      iconAsset: '$_iconPath/hb_cure.png',
      category: AppCategory.health,
      categoryLabel: 'Health · Device Control',
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
          label: 'Healing & Balance',
          longLabel: 'Learn about CureClip & CureBase',
        ),
      ],
      highlights: [
        'BLE connection to CureBase / CureClip hardware',
        'Program library with frequency sequences',
        'Program upload, start, pause and stop from the app',
        'Live session timer and device status',
      ],
      featured: true,
    ),

    // ── Master Chat ────────────────────────────────────────────────────────
    AppProject(
      id: 'master_chat',
      name: 'Master Chat',
      tagline: 'One chat surface that drives every tool in the studio.',
      description:
          'Master Chat is the studio\'s central AI layer: a single chat '
          'interface that routes a request to whichever registered tool can '
          'answer it. The AI provider is pluggable, actions that change '
          'something ask for confirmation first, and the same tools are '
          'reachable by external agents through a gateway.',
      // TODO(assets): masterchat still ships the default Flutter icon — no real
      // app icon exists yet. Falls back to the CatLab gradient tile.
      icon: Icons.forum_rounded,
      category: AppCategory.ai,
      categoryLabel: 'AI · Platform',
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/masterchat-web/',
        ),
      ],
      highlights: [
        'Natural-language routing to registered tools',
        'Vendor-neutral AI provider layer',
        'Confirmation step before any action tool runs',
        'Conversations persist across sessions',
        'Shared tool gateway for external agents',
      ],
      featured: true,
    ),

    // ── Palettenfuchs ──────────────────────────────────────────────────────
    AppProject(
      id: 'palettenfuchs',
      name: 'Palettenfuchs',
      tagline: 'Plan a trailer load before the forklift moves.',
      description:
          'Palettenfuchs works out how a truck trailer can be loaded: it lays '
          'out Euro and industrial pallets row by row, handles mixed rows, '
          'tracks weight distribution, and keeps the load patterns a driver '
          'uses repeatedly.',
      icon: Icons.local_shipping_rounded,
      iconAsset: '$_iconPath/palettenfuchs.png',
      category: AppCategory.logistics,
      categoryLabel: 'Logistics · Business',
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/palettenfuchs/',
        ),
      ],
      highlights: [
        'Euro and industrial pallets, including mixed rows',
        'Visual trailer layout with row arrangements',
        'Weight distribution per row',
        'Saved load patterns for recurring tours',
        'Nine languages: DE, EN, NO, DA, PL, RO, BG, TR, SR',
      ],
      featured: true,
    ),

    // ── Universal Business ─────────────────────────────────────────────────
    AppProject(
      id: 'universal_business',
      name: 'Universal Business',
      tagline: 'Answers grounded in a company\'s own approved knowledge.',
      description:
          'Universal Business turns scattered company knowledge into answers '
          'that cite their sources and decline to guess when the evidence is '
          'missing. Anything uncertain is handed to a human reviewer instead '
          'of being invented.',
      icon: Icons.hub_rounded,
      iconAsset: '$_iconPath/universal_business.png',
      category: AppCategory.business,
      categoryLabel: 'Business · AI',
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://universal-business-bot-platform.pages.dev/jury',
          label: 'Open Demo',
        ),
      ],
      highlights: [
        'Answers grounded in approved company material only',
        'Every answer shows where it came from',
        'Uncertain cases routed to human review',
        'Workspace and account tenancy',
      ],
    ),

    // ── Madame Gatto ───────────────────────────────────────────────────────
    AppProject(
      id: 'madame_gatto',
      name: 'Madame Gatto',
      tagline: 'Tarot, astrology, graphology and palmistry in one reading.',
      description:
          'Madame Gatto is a mystic reading app built around a single persona. '
          'It covers tarot draws, astrology, handwriting analysis and '
          'palmistry, and can combine them into one larger reading.',
      icon: Icons.auto_awesome_rounded,
      iconAsset: '$_iconPath/madame_gatto.png',
      category: AppCategory.lifestyle,
      categoryLabel: 'Lifestyle · Entertainment',
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/-cat_oracle/',
        ),
      ],
      highlights: [
        'Tarot draws with card interpretations',
        'Astrology readings',
        'Graphology — handwriting analysis',
        'Palmistry via hand scan',
        'Combined grand reading across all four',
      ],
    ),

    // ── PurrLove ───────────────────────────────────────────────────────────
    AppProject(
      id: 'purrlove',
      name: 'PurrLove',
      tagline: 'Real cat purrs for sleep, focus and calm.',
      description:
          'PurrLove loops recorded cat purring as a calming soundscape. Pick a '
          'cat, set a timer, adjust the volume — and it keeps playing with the '
          'screen locked.',
      icon: Icons.pets_rounded,
      iconAsset: '$_iconPath/purrlove.png',
      category: AppCategory.lifestyle,
      categoryLabel: 'Lifestyle · Wellbeing',
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
          label: 'Google Play',
          longLabel: 'Get it on Google Play — listed as Cat Purr Relax',
        ),
      ],
      companionProductNote:
          'PurrLove is the app in the SchnurrPurr set — a plush pillow with a '
          'removable purr module.',
      highlights: [
        'Several cats, each with its own purr recording',
        'Sleep timer from 10 to 90 minutes, or endless',
        'Separate volume control',
        'Keeps playing in the background',
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
      tagline: 'Wake up to cats instead of a siren.',
      description:
          'Feline Alarm is a cat-themed alarm clock: a calm, dark clock face '
          'and gentle wake-up sounds rather than a jarring ringtone.',
      icon: Icons.alarm_rounded,
      iconAsset: '$_iconPath/feline_alarm.png',
      category: AppCategory.lifestyle,
      categoryLabel: 'Utility · Lifestyle',
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
        'Cat-themed alarm clock face',
        'Gentle wake-up sound',
        'Dark, low-glare night display',
      ],
    ),

    // ── Transzendent ───────────────────────────────────────────────────────
    AppProject(
      id: 'transzendent',
      name: 'Transzendent',
      tagline: 'Guided hypnosis and relaxation sessions.',
      description:
          'Transzendent plays guided hypnosis and relaxation sessions grouped '
          'by intent — relaxation, sleep, motivation — over ambient background '
          'sound, with a sleep timer and a library to manage them.',
      icon: Icons.blur_on_rounded,
      iconAsset: '$_iconPath/transzendent.png',
      category: AppCategory.lifestyle,
      categoryLabel: 'Lifestyle · Wellbeing',
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/transzendent/',
        ),
      ],
      highlights: [
        'Sessions grouped by category',
        'Positive suggestion scripts',
        'Audio player with ambient background sound',
        'Sleep timer',
        'Session library',
      ],
    ),

    // ── CatQuiz ────────────────────────────────────────────────────────────
    AppProject(
      id: 'catquiz',
      name: 'CatQuiz',
      tagline: 'How much do you really know about cats?',
      description:
          'CatQuiz is a quiz app about cats — breeds, behaviour, body '
          'language and communication — with question sets in German and '
          'English.',
      icon: Icons.quiz_rounded,
      iconAsset: '$_iconPath/catquiz.png',
      category: AppCategory.games,
      categoryLabel: 'Game · Entertainment',
      status: AppStatus.advanced,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/catlab-quiz/',
        ),
      ],
      highlights: [
        'Quiz sets on breeds, behaviour and body language',
        'Beginner through expert difficulty',
        'German and English question sets',
      ],
    ),

    // ── DriveTime Arrival ──────────────────────────────────────────────────
    AppProject(
      id: 'drivetime_arrival',
      name: 'DriveTime Arrival',
      tagline: 'Arrival times that account for how a truck really drives.',
      description:
          'DriveTime Arrival estimates realistic arrival times for '
          'professional drivers, taking route and ferry timetables into '
          'account rather than assuming a car\'s average speed.',
      // TODO(assets): drivetimearrival still ships the default Flutter icon —
      // no real app icon exists yet. Falls back to the CatLab gradient tile.
      icon: Icons.route_rounded,
      category: AppCategory.logistics,
      categoryLabel: 'Transport · Logistics',
      status: AppStatus.inDevelopment,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/drive-time-arrival-web/',
        ),
      ],
      highlights: [
        'Route-based arrival estimation',
        'Ferry timetables factored into the ETA',
        'Built around professional drivers\' tour planning',
      ],
    ),

    // ── CatSlot ────────────────────────────────────────────────────────────
    AppProject(
      id: 'catslot',
      name: 'CatSlot',
      tagline: 'A casual slot machine, staffed entirely by cats.',
      description:
          'CatSlot is a casual slot game with several cat symbol sets, spin '
          'animations, payouts and a running balance. Play money only.',
      icon: Icons.casino_rounded,
      iconAsset: '$_iconPath/catslot.png',
      category: AppCategory.games,
      categoryLabel: 'Game · Casual',
      status: AppStatus.inDevelopment,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/cat-slot-web/',
        ),
      ],
      highlights: [
        'Multiple cat symbol sets',
        'Spin animation with payout evaluation',
        'Running play-money balance',
      ],
    ),

    // ── Catsdom ────────────────────────────────────────────────────────────
    AppProject(
      id: 'catsdom',
      name: 'Catsdom',
      tagline: 'Match-three on an 8×8 board of cats.',
      description:
          'Catsdom is a casual match-three puzzle: an 8×8 board, six symbol '
          'types, tap and drag controls, cascading matches and a move limit. '
          'Installable as a PWA and playable offline.',
      icon: Icons.grid_view_rounded,
      iconAsset: '$_iconPath/catsdom.png',
      category: AppCategory.games,
      categoryLabel: 'Game · Puzzle',
      status: AppStatus.prototype,
      platforms: [AppPlatform.web, AppPlatform.android],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/catsdom/',
        ),
      ],
      highlights: [
        '8×8 board with six symbol types',
        'Tap and drag controls',
        'Cascading matches, scoring and a move limit',
        'Installable PWA, works offline',
      ],
    ),

    // ── CatSnake ───────────────────────────────────────────────────────────
    AppProject(
      id: 'catsnake',
      name: 'CatSnake',
      tagline: 'Snake, but the snake is a very long cat.',
      description:
          'CatSnake is a small casual take on the classic snake game with cat '
          'artwork, sound effects and music.',
      icon: Icons.gesture_rounded,
      iconAsset: '$_iconPath/catsnake.png',
      category: AppCategory.games,
      categoryLabel: 'Game · Casual',
      status: AppStatus.prototype,
      platforms: [AppPlatform.web],
      links: [
        AppLink(
          kind: AppLinkKind.web,
          url: 'https://mexx-music.github.io/cat-snake-web/',
        ),
      ],
      highlights: [
        'Classic snake loop with cat artwork',
        'Sound effects and background music',
      ],
    ),

    // ── Medical ProCat ─────────────────────────────────────────────────────
    // TODO(project): No repository, assets or specification exist for this yet
    // — it is a named concept only. Everything below stays deliberately vague
    // until there is something real to describe. No icon, no links.
    AppProject(
      id: 'medical_procat',
      name: 'Medical ProCat',
      tagline: 'An AI research assistant for medical information.',
      description:
          'Medical ProCat is an early concept for an AI assistant focused on '
          'finding and organising medical information and research. It is an '
          'information tool — it does not diagnose, treat, or give medical '
          'advice.',
      icon: Icons.biotech_rounded,
      category: AppCategory.health,
      categoryLabel: 'Health · AI',
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
