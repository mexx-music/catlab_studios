import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/master_chat_visuals.dart';

/// The vision story for Master Chat.
///
/// Sourced from the project's own repository — its README (phases 1–16), the
/// architecture document, `MASTER_CHAT_PRINCIPLES.md` and `HYBRID_SURFACES.md`
/// — and checked against the code rather than the prose. The honest line runs
/// straight through the middle of this project:
///
///   * The **plumbing is real and unusually complete**: the registry, the
///     vendor-neutral AI layer with OpenAI and Claude adapters, confirmation
///     for action tools, local session persistence, the capability registry
///     with runtime availability, hybrid surfaces where a human and a model
///     edit one state, voice as an input channel, and a deployable trusted
///     gateway that also speaks MCP.
///   * The **built-in essentials** — calculator, notes, tasks, timer,
///     conversion, date/time, contacts — are real implementations.
///   * The **connected demo projects** (BusinessBrain, Palettenfuchs, Fuel)
///     are architecture demonstrations: their tool bodies return canned data,
///     which `customer_search_tool.dart` says in as many words. The story
///     therefore never claims that a connected business tool does real work;
///     the capabilities it shows by name — calculating, noting, planning —
///     are the built-in ones that genuinely do.
///   * Splitting a task across several intelligences, and a context that
///     outlives a bounded window, are **direction** — there is no planner and
///     no multi-agent orchestration in the repository.
///
/// The copy is deliberately non-technical. This story is read by people who
/// do not write software, and a sentence that has to be read twice has failed
/// — so registries, gateways, adapters, scopes and protocol names stay in the
/// Master Chat repository's own documentation, where they belong and where
/// they remain in full. Nothing was deleted; it was moved out of the shop
/// window. What survives here is the *claim*, in plain words, with the same
/// TODAY/VISION line drawn in exactly the same place.
///
/// AI-hint: promote nothing here to `today` without an implementation to
/// point at — and add no term a non-developer would have to look up.
final VisionStory masterChatStory = VisionStory(
  projectId: 'master_chat',
  title: LocalizedText({'en': 'Master Chat', 'de': 'Master Chat'}),
  subtitle: LocalizedText({
    'en': 'Where Master Chat is heading',
    'de': 'Wohin sich Master Chat entwickelt',
  }),
  scenes: [
    // ── 1 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'too-many-tools',
      kicker: LocalizedText({
        'en': 'The starting point',
        'de': 'Der Ausgangspunkt',
      }),
      headline: LocalizedText({
        'en': "Today there's an app for almost everything.",
        'de': 'Für fast alles gibt es heute eine eigene App.',
      }),
      body: LocalizedText({
        'en':
            'Calculate. Take notes. Plan. Search. Write. But people do not '
            'think in apps. They think about what they want to get done.',
        'de':
            'Rechnen. Notieren. Planen. Suchen. Schreiben. Aber Menschen '
            'denken nicht in Apps. Sie denken daran, was sie erledigen '
            'möchten.',
      }),
      visual: masterChatScatteredApps,
      duration: Duration(seconds: 8),
    ),

    // ── 2 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'one-surface',
      kicker: LocalizedText({'en': 'One interface', 'de': 'Eine Oberfläche'}),
      headline: LocalizedText({
        'en': 'Just say what you want to do.',
        'de': 'Sag einfach, was du machen möchtest.',
      }),
      body: LocalizedText({
        'en':
            'Master Chat is the one place you start. You do not have to find '
            'the right tool first — it understands the task and brings up what '
            'you need.',
        'de':
            'Master Chat ist die zentrale Oberfläche. Du musst nicht zuerst '
            'das richtige Werkzeug suchen — Master Chat erkennt deine Aufgabe '
            'und stellt dir die passende Funktion bereit.',
      }),
      points: [
        LocalizedText({
          'en': 'One conversation. One place to start.',
          'de': 'Ein Gespräch. Ein gemeinsamer Ausgangspunkt.',
        }),
      ],
      stage: VisionStage.today,
      visual: masterChatOneSurface,
      duration: Duration(seconds: 9),
    ),

    // ── 3 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'capabilities',
      kicker: LocalizedText({
        'en': 'The right capability',
        'de': 'Die richtige Fähigkeit',
      }),
      headline: LocalizedText({
        'en': 'Every task needs something different.',
        'de': 'Jede Aufgabe braucht etwas anderes.',
      }),
      body: LocalizedText({
        'en':
            'Need to work something out? Note it down? Plan it? Master Chat '
            'recognises which of its capabilities can help.',
        'de':
            'Etwas ausrechnen? Etwas notieren? Etwas planen? Master Chat '
            'erkennt, welche seiner Fähigkeiten dafür gebraucht wird.',
      }),
      points: [
        LocalizedText({
          'en': 'You describe the goal. The system takes care of the rest.',
          'de':
              'Du beschreibst dein Ziel. Das System kümmert sich um den '
              'Rest.',
        }),
      ],
      stage: VisionStage.today,
      visual: masterChatCapabilities,
      duration: Duration(seconds: 9),
    ),

    // ── 4 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'one-state',
      kicker: LocalizedText({
        'en': 'The interface adapts',
        'de': 'Die Oberfläche passt sich an',
      }),
      headline: LocalizedText({
        'en': "Sometimes a chat isn't enough.",
        'de': 'Manchmal reicht ein Chat nicht.',
      }),
      body: LocalizedText({
        'en':
            'Say "59 plus 7" and the calculator appears. Voice, keyboard and '
            'the calculator keys all work on the same thing.',
        'de':
            'Sag „59 plus 7" — und der Rechner erscheint. Sprache, Tastatur '
            'und Rechner-Tasten arbeiten dabei am selben.',
      }),
      points: [
        LocalizedText({
          'en': 'The interface you need, when you need it.',
          'de': 'Genau die Oberfläche, die du gerade brauchst.',
        }),
      ],
      stage: VisionStage.today,
      visual: masterChatOneState,
      duration: Duration(seconds: 10),
    ),

    // ── 5 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'shared-context',
      kicker: LocalizedText({
        'en': 'Everything works together',
        'de': 'Alles arbeitet zusammen',
      }),
      headline: LocalizedText({
        'en': 'A task rarely ends with one tool.',
        'de': 'Eine Aufgabe endet selten bei einem Werkzeug.',
      }),
      body: LocalizedText({
        'en':
            'You might work something out, save the result, and plan the '
            'next step from it. The vision: Master Chat joins those steps into '
            'one continuous piece of work.',
        'de':
            'Vielleicht rechnest du zuerst etwas aus, notierst das Ergebnis '
            'und planst daraus den nächsten Schritt. Die Vision: Master Chat '
            'verbindet diese Schritte zu einer zusammenhängenden Arbeit.',
      }),
      points: [
        LocalizedText({
          'en': 'You keep your goal in sight. Master Chat keeps the thread.',
          'de':
              'Du behältst dein Ziel im Blick. Master Chat behält den '
              'Zusammenhang.',
        }),
      ],
      stage: VisionStage.vision,
      stageNote: LocalizedText({
        'en':
            'Today a conversation remembers what you are working on right '
            'now. Carrying that across many steps is still ahead.',
        'de':
            'Heute merkt sich ein Gespräch, woran gerade gearbeitet wird. '
            'Das über viele Schritte hinweg zu tragen, steht noch bevor.',
      }),
      visual: masterChatContext,
      duration: Duration(seconds: 10),
    ),

    // ── 6 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'many-intelligences',
      kicker: LocalizedText({
        'en': 'More than one AI',
        'de': 'Mehr als eine KI',
      }),
      headline: LocalizedText({
        'en': 'No single AI is best at everything.',
        'de': 'Keine KI ist in allem die beste.',
      }),
      body: LocalizedText({
        'en':
            'So the vision is not to leave it all to one system. Different '
            'AI systems and specialised skills can be used where they fit '
            'best — and Master Chat brings the results back together.',
        'de':
            'Die Vision ist deshalb nicht, alles einem einzigen System zu '
            'überlassen. Unterschiedliche KI-Systeme und spezialisierte '
            'Fähigkeiten können dort eingesetzt werden, wo sie am besten '
            'passen — Master Chat führt die Ergebnisse wieder zusammen.',
      }),
      points: [
        LocalizedText({
          'en': 'One interface. Many specialists.',
          'de': 'Eine Oberfläche. Viele Spezialisten.',
        }),
      ],
      stage: VisionStage.vision,
      stageNote: LocalizedText({
        'en':
            'Today one system answers at a time. Several of them working on '
            'the same task is the next step.',
        'de':
            'Heute antwortet ein System nach dem anderen. Dass mehrere an '
            'derselben Aufgabe arbeiten, ist der nächste Schritt.',
      }),
      visual: masterChatIntelligences,
      duration: Duration(seconds: 9),
    ),

    // ── 7 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'action',
      kicker: LocalizedText({
        'en': 'Beyond answers',
        'de': 'Nicht nur antworten',
      }),
      headline: LocalizedText({
        'en': 'A good answer is often only the beginning.',
        'de': 'Eine gute Antwort ist oft erst der Anfang.',
      }),
      body: LocalizedText({
        'en':
            'A normal chat tells you how something is done. Master Chat is '
            'built to help you actually do it — and when something important '
            'is about to happen, you decide.',
        'de':
            'Ein klassischer Chat sagt dir, wie etwas geht. Master Chat soll '
            'dir helfen, es tatsächlich zu tun — und wenn etwas Wichtiges '
            'passieren soll, entscheidest du.',
      }),
      points: [
        LocalizedText({
          'en': 'Understand. Choose. Act. Result.',
          'de': 'Verstehen. Werkzeug wählen. Ausführen. Ergebnis.',
        }),
      ],
      stage: VisionStage.today,
      // A today scene that still points forward: part of this works now, and
      // the honest thing is to say how far it reaches.
      stageNote: LocalizedText({
        'en':
            'Today Master Chat carries out single tasks this way. Turning '
            'them into whole pieces of work is the vision.',
        'de':
            'Heute führt Master Chat einzelne Aufgaben so aus. Daraus ganze '
            'Arbeitsabläufe zu machen, ist die Vision.',
      }),
      visual: masterChatFlow,
      duration: Duration(seconds: 10),
    ),

    // ── 8 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'vision',
      kicker: LocalizedText({'en': 'The vision', 'de': 'Die Vision'}),
      headline: LocalizedText({
        'en': 'Technology adapts to the human.',
        'de': 'Die Technik passt sich dem Menschen an.',
      }),
      body: LocalizedText({
        'en':
            'You should not have to stop and ask which app you need, which '
            'tool to open, or which AI is right for this. You simply say what '
            'you want to achieve — one conversation, many capabilities, one '
            'shared goal.',
        'de':
            'Du sollst nicht mehr überlegen müssen, welche App du brauchst, '
            'welches Werkzeug du öffnest oder welche KI dafür geeignet ist. Du '
            'sagst einfach, was du erreichen möchtest — ein Gespräch, viele '
            'Fähigkeiten, ein gemeinsames Ziel.',
      }),
      stage: VisionStage.vision,
      visual: masterChatStack,
      duration: Duration(seconds: 8),
    ),
  ],
);
