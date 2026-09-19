import 'package:catlab_studios/core/l10n/localized_text.dart';

/// Every piece of UI chrome on the site, in every language.
///
/// Content — project entries, connected products, vision scenes — is *not*
/// here: it lives on the thing it describes, so a project cannot be added in
/// one language and forgotten in another. This file is only for the copy that
/// belongs to the interface itself.
///
/// AI-hint: a new string goes here with every language filled in; the l10n
/// test fails on a missing translation, so there is no silent English leak.
abstract final class SiteText {
  // ── Hero ────────────────────────────────────────────────────────────────
  static const heroBadge = LocalizedText({
    'en': 'INDEPENDENT SOFTWARE STUDIO',
    'de': 'UNABHÄNGIGES SOFTWARESTUDIO',
  });
  static const heroSubline = LocalizedText({
    'en': 'Practical, creative and AI-powered software.',
    'de': 'Praktische, kreative und KI-gestützte Software.',
  });
  static const heroBody = LocalizedText({
    'en':
        'CatLab Studios is an independent software studio building '
        'applications across mobile, web and desktop — from AI platforms and '
        'business tools to health, logistics and games.',
    'de':
        'CatLab Studios ist ein unabhängiges Softwarestudio und entwickelt '
        'Anwendungen für Mobile, Web und Desktop — von KI-Plattformen und '
        'Business-Werkzeugen bis zu Gesundheit, Logistik und Spielen.',
  });
  static const heroExploreApps = LocalizedText({
    'en': 'Explore Apps',
    'de': 'Apps entdecken',
  });
  static const heroWhatWeBuild = LocalizedText({
    'en': 'What We Build',
    'de': 'Was wir bauen',
  });

  // Hero teaser for the newest field of work. Small on purpose: it points at
  // the product-experience section, it does not compete with the two CTAs.
  static const heroTeaserLabel = LocalizedText({
    'en': 'NEW · PRODUCT EXPERIENCES',
    'de': 'NEU · PRODUCT EXPERIENCES',
  });
  static const heroTeaserLine = LocalizedText({
    'en': 'Real products. Precisely brought to life.',
    'de': 'Echte Produkte. Präzise inszeniert.',
  });
  static const heroTeaserAction = LocalizedText({
    'en': 'Discover',
    'de': 'Entdecken',
  });

  // ── Portfolio ───────────────────────────────────────────────────────────
  static const portfolioTitle = LocalizedText({
    'en': 'Our Apps',
    'de': 'Unsere Apps',
  });
  static const portfolioIntro = LocalizedText({
    'en':
        '{count} projects across AI, business, health, logistics, games and '
        'everyday life — at every stage from shipped to concept.',
    'de':
        '{count} Projekte aus KI, Business, Gesundheit, Logistik, Spielen '
        'und Alltag — in jedem Stadium, von veröffentlicht bis Konzept.',
  });
  static const portfolioFlagship = LocalizedText({
    'en': 'Flagship projects',
    'de': 'Ausgewählte Projekte',
  });
  static const portfolioMore = LocalizedText({
    'en': 'More from the studio',
    'de': 'Mehr aus dem Studio',
  });
  static const filterAll = LocalizedText({'en': 'All', 'de': 'Alle'});

  // ── Connected products ──────────────────────────────────────────────────
  static const connectedTitle = LocalizedText({
    'en': 'Connected Products',
    'de': 'Verbundene Produkte',
  });
  static const connectedIntro = LocalizedText({
    'en':
        'Not everything we build lives on a screen. Sometimes an app comes '
        'with something you can hold.',
    'de':
        'Nicht alles, was wir bauen, lebt auf einem Bildschirm. Manchmal '
        'gehört zu einer App etwas, das man in der Hand hält.',
  });
  static const connectedCompanionApp = LocalizedText({
    'en': 'Companion app',
    'de': 'Passende App',
  });

  // ── Product experiences ─────────────────────────────────────────────────
  static const experienceBadge = LocalizedText({
    'en': 'PROGRAMMED PRODUCT EXPERIENCES',
    'de': 'PROGRAMMIERTE PRODUKTINSZENIERUNG',
  });
  static const experienceTitle = LocalizedText({
    'en': 'Product Experiences',
    'de': 'Produktinszenierung',
  });
  static const experienceClaim = LocalizedText({
    'en': 'Your product. Exactly as it is. Brought to life.',
    'de': 'Ihr Produkt. Genau so, wie es ist. Zum Leben erweckt.',
  });
  static const experienceIntro = LocalizedText({
    'en':
        'Some products need more than a screenshot. We stage real ones — '
        'their own photography, their own logo, their own app screens — and '
        'program the light, the movement, the timing and the sound around '
        'them.',
    'de':
        'Manche Produkte brauchen mehr als einen Screenshot. Wir inszenieren '
        'echte — mit ihren eigenen Fotos, ihrem eigenen Logo, ihren eigenen '
        'App-Screens — und programmieren Licht, Bewegung, Timing und Ton '
        'darum herum.',
  });

  // Principle stage — the same photograph, before and after staging.
  static const experiencePrincipleTitle = LocalizedText({
    'en': 'One image. Everything around it is code.',
    'de': 'Ein Bild. Alles darum herum ist Code.',
  });
  static const experiencePrincipleBody = LocalizedText({
    'en':
        'Both halves below are the same original product photograph. The '
        'right one is not a new picture of the product — it is the product '
        'with light, depth, particles and frequency lines drawn around it, '
        'frame by frame. Drag the handle.',
    'de':
        'Beide Hälften unten zeigen dasselbe originale Produktfoto. Rechts '
        'ist kein neues Bild des Produkts — es ist das Produkt, um das Licht, '
        'Tiefe, Partikel und Frequenzlinien gezeichnet werden, Bild für Bild. '
        'Ziehen Sie den Griff.',
  });
  static const experienceBefore = LocalizedText({
    'en': 'Original asset',
    'de': 'Originalmaterial',
  });
  static const experienceAfter = LocalizedText({
    'en': 'Staged',
    'de': 'Inszeniert',
  });

  // The honest distinction from generative video.
  static const experienceContrastTitle = LocalizedText({
    'en': 'Spectacle where it helps. Precision where it counts.',
    'de': 'Spektakel dort, wo es hilft. Präzision dort, wo es zählt.',
  });
  static const experienceContrastBody = LocalizedText({
    'en':
        'Generative AI makes striking film, and it is the right tool when a '
        'scene may be invented. A product presentation is a different '
        'problem: geometry, logo, interface, wording and functions have to '
        'survive unchanged. So we do not generate the product — we stage the '
        'real one.',
    'de':
        'Generative KI erzeugt beeindruckende Filme und ist das richtige '
        'Werkzeug, wenn eine Szene erfunden werden darf. Eine '
        'Produktpräsentation ist ein anderes Problem: Geometrie, Logo, '
        'Oberfläche, Texte und Funktionen müssen unverändert bleiben. Also '
        'erzeugen wir das Produkt nicht — wir inszenieren das echte.',
  });

  // Reference block.
  static const experienceReferenceLabel = LocalizedText({
    'en': 'REFERENCE',
    'de': 'REFERENZ',
  });
  static const experiencePlay = LocalizedText({
    'en': 'Play film',
    'de': 'Film abspielen',
  });
  static const experienceSoundHint = LocalizedText({
    'en': 'Plays with sound',
    'de': 'Spielt mit Ton',
  });
  static const experienceCardsTitle = LocalizedText({
    'en': 'Campaign cards from the same system',
    'de': 'Kampagnenkarten aus demselben System',
  });
  static const experienceCardsNote = LocalizedText({
    'en':
        'Product staging is the communication itself. Distributing it — as a '
        'Telegram campaign, an ad or a website hero — is a separate step, and '
        'these cards are built to feed it.',
    'de':
        'Produktinszenierung ist die Kommunikation selbst. Ihre Verteilung — '
        'als Telegram-Kampagne, als Anzeige oder als Website-Hero — ist ein '
        'eigener Schritt, und diese Karten sind dafür gemacht.',
  });

  // What comes out of it, and in which shapes.
  static const experienceOutputsTitle = LocalizedText({
    'en': 'What we build from it',
    'de': 'Was daraus entsteht',
  });
  static const experienceFormatsTitle = LocalizedText({
    'en': 'Delivered in the shape the channel needs',
    'de': 'Ausgeliefert in der Form, die der Kanal braucht',
  });
  static const outputLaunchFilm = LocalizedText({
    'en': 'Product launch films',
    'de': 'Produkt-Launchfilme',
  });
  static const outputDeviceShowcase = LocalizedText({
    'en': 'App & device showcases',
    'de': 'App- & Geräte-Showcases',
  });
  static const outputSocialSpot = LocalizedText({
    'en': 'Social product spots',
    'de': 'Social-Produkt-Spots',
  });
  static const outputCampaignCard = LocalizedText({
    'en': 'Campaign cards',
    'de': 'Kampagnenkarten',
  });
  static const outputHeroAnimation = LocalizedText({
    'en': 'Website hero animations',
    'de': 'Website-Hero-Animationen',
  });
  static const outputFeatureDemo = LocalizedText({
    'en': 'Feature demonstrations',
    'de': 'Feature-Demonstrationen',
  });
  static const outputExplainer = LocalizedText({
    'en': 'Product explainers',
    'de': 'Produkt-Explainer',
  });
  static const outputInteractive = LocalizedText({
    'en': 'Interactive product experiences',
    'de': 'Interaktive Produkt-Experiences',
  });

  // ── Capabilities ────────────────────────────────────────────────────────
  static const capabilitiesTitle = LocalizedText({
    'en': 'What We Build',
    'de': 'Was wir bauen',
  });
  static const capabilitiesIntro = LocalizedText({
    'en':
        'The studio started with cats. It still keeps them — but the work '
        'now spans six fields.',
    'de':
        'Das Studio hat mit Katzen angefangen. Die sind geblieben — die '
        'Arbeit umfasst inzwischen sechs Bereiche.',
  });
  static const capabilityAi = LocalizedText({
    'en': 'Chat platforms and assistants that route real work to real tools.',
    'de':
        'Chat-Plattformen und Assistenten, die echte Arbeit an echte '
        'Werkzeuge weiterreichen.',
  });
  static const capabilityBusiness = LocalizedText({
    'en': 'Company knowledge made usable, with sources and human review.',
    'de':
        'Firmenwissen nutzbar gemacht — mit Quellen und menschlicher '
        'Prüfung.',
  });
  static const capabilityHealth = LocalizedText({
    'en': 'Device control and information tools in the health space.',
    'de': 'Gerätesteuerung und Informationswerkzeuge im Gesundheitsbereich.',
  });
  static const capabilityLogistics = LocalizedText({
    'en': 'Load planning and arrival times for people who drive for a living.',
    'de':
        'Ladungsplanung und Ankunftszeiten für Menschen, die beruflich '
        'fahren.',
  });
  static const capabilityGames = LocalizedText({
    'en': 'Casual games — puzzle, arcade and quiz — with our own artwork.',
    'de': 'Casual Games — Puzzle, Arcade und Quiz — mit eigenen Grafiken.',
  });
  static const capabilityLifestyle = LocalizedText({
    'en': 'Everyday apps for sleep, focus, calm and a little curiosity.',
    'de': 'Alltags-Apps für Schlaf, Fokus, Ruhe und ein bisschen Neugier.',
  });

  // ── About ───────────────────────────────────────────────────────────────
  static const aboutTitle = LocalizedText({
    'en': 'About the Studio',
    'de': 'Über das Studio',
  });
  static const aboutBody = LocalizedText({
    'en':
        'CatLab Studios is an independent software studio building '
        'practical, creative and AI-powered applications across mobile, web '
        'and desktop. Most of it is built with Flutter, from one codebase, by '
        'a small team that ships when something is genuinely ready.',
    'de':
        'CatLab Studios ist ein unabhängiges Softwarestudio und entwickelt '
        'praktische, kreative und KI-gestützte Anwendungen für Mobile, Web '
        'und Desktop. Das meiste entsteht mit Flutter, aus einer Codebasis, '
        'in einem kleinen Team, das veröffentlicht, wenn etwas wirklich '
        'fertig ist.',
  });
  static const aboutLegendTitle = LocalizedText({
    'en': 'HOW WE LABEL PROGRESS',
    'de': 'WIE WIR FORTSCHRITT KENNZEICHNEN',
  });
  static const legendAvailable = LocalizedText({
    'en': 'Released and in use.',
    'de': 'Veröffentlicht und im Einsatz.',
  });
  static const legendAdvanced = LocalizedText({
    'en': 'Works end to end, being polished before release.',
    'de':
        'Funktioniert durchgängig, wird vor der Veröffentlichung noch '
        'verfeinert.',
  });
  static const legendInDevelopment = LocalizedText({
    'en': 'Core features work, still being built out.',
    'de': 'Kernfunktionen laufen, der Rest entsteht noch.',
  });
  static const legendPrototype = LocalizedText({
    'en': 'A working proof of concept.',
    'de': 'Ein funktionierender Machbarkeitsnachweis.',
  });
  static const legendConcept = LocalizedText({
    'en': 'Scoped, not yet built.',
    'de': 'Konzipiert, noch nicht gebaut.',
  });

  // ── Footer ──────────────────────────────────────────────────────────────
  static const footerCopyright = LocalizedText({
    'en': '© 2026 CatLab Studios · Built with Flutter',
    'de': '© 2026 CatLab Studios · Gebaut mit Flutter',
  });
  static const footerStats = LocalizedText({
    'en': '{count} projects · 6 fields · mobile, web & desktop',
    'de': '{count} Projekte · 6 Bereiche · Mobile, Web & Desktop',
  });

  // ── Detail sheet ────────────────────────────────────────────────────────
  static const detailWhatItDoes = LocalizedText({
    'en': 'What it does',
    'de': 'Was es kann',
  });
  static const detailPlatforms = LocalizedText({
    'en': 'Platforms',
    'de': 'Plattformen',
  });
  static const detailNoLinks = LocalizedText({
    'en':
        'Not publicly available yet — no download or demo link to share at '
        'this stage.',
    'de':
        'Noch nicht öffentlich verfügbar — zu diesem Zeitpunkt gibt es '
        'keinen Download- oder Demo-Link.',
  });
  static const actionClose = LocalizedText({'en': 'Close', 'de': 'Schließen'});
  static const actionLearnMore = LocalizedText({
    'en': 'Learn more',
    'de': 'Mehr erfahren',
  });

  // ── Vision story entry points ───────────────────────────────────────────
  static const visionCtaLabel = LocalizedText({
    'en': 'THE BIGGER PICTURE',
    'de': 'DAS GRÖSSERE BILD',
  });
  static const visionCtaBody = LocalizedText({
    'en':
        'Everything above is what {project} does today. The vision story '
        'shows where it is heading — and marks clearly which parts are not '
        'built yet.',
    'de':
        'Alles oben ist das, was {project} heute kann. Die Vision Story '
        'zeigt, wohin es geht — und kennzeichnet klar, welche Teile noch '
        'nicht gebaut sind.',
  });
  static const visionCardLabel = LocalizedText({
    'en': 'Vision',
    'de': 'Vision',
  });

  // ── Vision player ───────────────────────────────────────────────────────
  static const visionStoryBadge = LocalizedText({
    'en': 'VISION STORY',
    'de': 'VISION STORY',
  });
  static const visionPlay = LocalizedText({'en': 'Play', 'de': 'Abspielen'});
  static const visionPause = LocalizedText({'en': 'Pause', 'de': 'Pause'});
  static const visionReplay = LocalizedText({
    'en': 'Replay',
    'de': 'Erneut abspielen',
  });
  static const visionPreviousScene = LocalizedText({
    'en': 'Previous scene',
    'de': 'Vorherige Szene',
  });
  static const visionNextScene = LocalizedText({
    'en': 'Next scene',
    'de': 'Nächste Szene',
  });
  static const visionWatchAgain = LocalizedText({
    'en': 'Watch again',
    'de': 'Nochmal ansehen',
  });
  static const visionSeeToday = LocalizedText({
    'en': 'See what exists today',
    'de': 'Was es heute schon gibt',
  });
  static const visionSceneLabel = LocalizedText({
    'en': 'Scene {number}: {title}',
    'de': 'Szene {number}: {title}',
  });

  // ── Beta access ─────────────────────────────────────────────────────────
  static const betaJoinShort = LocalizedText({
    'en': 'Join Android Beta',
    'de': 'Android-Beta beitreten',
  });
  static const betaTitle = LocalizedText({
    'en': 'Join the Android Beta',
    'de': 'Der Android-Beta beitreten',
  });
  static const betaBody = LocalizedText({
    'en':
        'Enter the Google account email address you use on your Android '
        'device to request access to the {app} beta.',
    'de':
        'Geben Sie die E-Mail-Adresse des Google-Kontos an, das Sie auf '
        'Ihrem Android-Gerät verwenden, um Zugang zur {app}-Beta anzufragen.',
  });
  static const betaSubmit = LocalizedText({
    'en': 'Request Beta Access',
    'de': 'Beta-Zugang anfragen',
  });
  static const betaPrivacy = LocalizedText({
    'en':
        'Your address is used only to add you to the Google Play tester '
        'list. It is not stored on this site.',
    'de':
        'Ihre Adresse wird ausschließlich verwendet, um Sie zur '
        'Google-Play-Testerliste hinzuzufügen. Auf dieser Seite wird sie '
        'nicht gespeichert.',
  });
  static const betaEmptyEmail = LocalizedText({
    'en': 'Please enter your Google account email address.',
    'de': 'Bitte geben Sie die E-Mail-Adresse Ihres Google-Kontos an.',
  });
  static const betaInvalidEmail = LocalizedText({
    'en': 'That does not look like an email address.',
    'de': 'Das sieht nicht nach einer E-Mail-Adresse aus.',
  });
  static const betaSentTitle = LocalizedText({
    'en': 'Almost there',
    'de': 'Fast geschafft',
  });
  static const betaSentBody = LocalizedText({
    'en':
        'Your mail app should have opened with the request ready to send. '
        'Once we add your account to the tester list, Google Play will give '
        'you access to the closed test.',
    'de':
        'Ihr E-Mail-Programm sollte sich mit der fertigen Anfrage geöffnet '
        'haben. Sobald wir Ihr Konto zur Testerliste hinzugefügt haben, gibt '
        'Google Play den geschlossenen Test für Sie frei.',
  });
  static const betaDone = LocalizedText({'en': 'Done', 'de': 'Fertig'});
  static const betaClosed = LocalizedText({
    'en':
        'Beta sign-up is not open yet. In the meantime the app is available '
        'on the App Store.',
    'de':
        'Die Beta-Anmeldung ist noch nicht offen. In der Zwischenzeit ist '
        'die App im App Store verfügbar.',
  });

  // ── Language switcher ───────────────────────────────────────────────────
  static const languageLabel = LocalizedText({
    'en': 'Language',
    'de': 'Sprache',
  });
}
