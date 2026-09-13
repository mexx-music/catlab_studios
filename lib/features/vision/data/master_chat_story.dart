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
///     which `customer_search_tool.dart` says in as many words. Scene seven
///     states that outright rather than letting the gateway diagram imply
///     otherwise.
///   * Splitting a task across several intelligences, and a context that
///     outlives a bounded window, are **direction** — there is no planner and
///     no multi-agent orchestration in the repository.
///
/// AI-hint: promote nothing here to `today` without a implementation to point
/// at; this project's documentation is honest about its own gaps, and the
/// story has to be at least as honest.
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
        'en': 'We built an app for everything.',
        'de': 'Für alles wurde eine App gebaut.',
      }),
      body: LocalizedText({
        'en':
            'Calculator, notes, tasks, calendar, documents, business '
            'software, development tools — each with its own window and its '
            'own idea of what you were doing. But nobody thinks in apps. '
            'People think "work this out", "write that down", "remind me on '
            'Tuesday".',
        'de':
            'Rechner, Notizen, Aufgaben, Kalender, Dokumente, '
            'Businesssoftware, Entwicklungswerkzeuge — jedes mit eigenem '
            'Fenster und eigener Vorstellung davon, woran gerade gearbeitet '
            'wird. Nur denkt niemand in Apps. Menschen denken: „Rechne das '
            'aus", „Schreib das auf", „Erinnere mich am Dienstag".',
      }),
      visual: masterChatScatteredApps,
      duration: Duration(seconds: 9),
    ),

    // ── 2 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'one-surface',
      kicker: LocalizedText({'en': 'One surface', 'de': 'Eine Oberfläche'}),
      headline: LocalizedText({
        'en': 'One conversation. One context.',
        'de': 'Ein Gespräch. Ein Kontext.',
      }),
      body: LocalizedText({
        'en':
            'Master Chat is a single chat layer that applications plug into. '
            'You describe the goal; the system resolves which registered '
            'capability can reach it. There is no module grid and no tool '
            'catalogue to learn — the permanent interface is a prompt and a '
            'microphone, and everything else appears only while it is needed.',
        'de':
            'Master Chat ist eine einzige Chat-Schicht, an die sich '
            'Anwendungen anschließen. Sie beschreiben das Ziel; das System '
            'ermittelt, welche registrierte Fähigkeit es erreichen kann. Es '
            'gibt kein Modulraster und keinen Werkzeugkatalog zu lernen — die '
            'dauerhafte Oberfläche ist eine Eingabe und ein Mikrofon, alles '
            'andere erscheint nur, solange es gebraucht wird.',
      }),
      points: [
        LocalizedText({
          'en': 'Natural language in, registered tools out',
          'de': 'Natürliche Sprache hinein, registrierte Werkzeuge hinaus',
        }),
        LocalizedText({
          'en': 'The interface shows only what the task needs',
          'de': 'Die Oberfläche zeigt nur, was die Aufgabe braucht',
        }),
        LocalizedText({
          'en': 'A spoken sentence and a typed one are the same sentence',
          'de': 'Ein gesprochener und ein getippter Satz sind derselbe Satz',
        }),
      ],
      stage: VisionStage.today,
      visual: masterChatOneSurface,
      duration: Duration(seconds: 11),
    ),

    // ── 3 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'capabilities',
      kicker: LocalizedText({
        'en': 'The right capability',
        'de': 'Die passende Fähigkeit',
      }),
      headline: LocalizedText({
        'en': 'What it could offer, and what it can run right now.',
        'de': 'Was möglich wäre — und was gerade läuft.',
      }),
      body: LocalizedText({
        'en':
            'Two registries, on purpose. One answers "what can execute?", '
            'the other "what could this system offer?" — a superset, because a '
            'capability can be known before anything can run it. Availability '
            'is computed at runtime, the most restrictive answer wins, and '
            'anything the app cannot verify blocks instead of being assumed.',
        'de':
            'Zwei Registries, mit Absicht. Die eine beantwortet „Was kann '
            'ausgeführt werden?", die andere „Was könnte dieses System '
            'anbieten?" — eine Obermenge, denn eine Fähigkeit kann bekannt '
            'sein, bevor irgendetwas sie ausführen kann. Verfügbarkeit wird zur '
            'Laufzeit ermittelt, die restriktivste Antwort gewinnt, und was '
            'die App nicht prüfen kann, blockiert, statt angenommen zu werden.',
      }),
      points: [
        LocalizedText({
          'en': '"I cannot do that" becomes "that module is not active"',
          'de': '„Das kann ich nicht" wird zu „Dieses Modul ist nicht aktiv"',
        }),
        LocalizedText({
          'en': 'Unverifiable means blocked, never assumed',
          'de': 'Nicht prüfbar heißt blockiert, nie angenommen',
        }),
        LocalizedText({
          'en': 'Discovery never grants permission',
          'de': 'Etwas zu finden erteilt keine Berechtigung',
        }),
      ],
      stage: VisionStage.today,
      visual: masterChatCapabilities,
      duration: Duration(seconds: 12),
    ),

    // ── 4 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'one-state',
      kicker: LocalizedText({
        'en': 'The interface adapts',
        'de': 'Die Oberfläche passt sich an',
      }),
      headline: LocalizedText({
        'en': 'One state. Many hands.',
        'de': 'Ein Zustand. Viele Hände.',
      }),
      body: LocalizedText({
        'en':
            'Say "59 plus 7" and a calculator appears — not a picture of '
            'one. Keypad, keyboard and voice all edit the same value, because '
            'there is only ever one. The model is never handed a copy to '
            'reason from: it reads a snapshot and acts by sending back an '
            'intent like "multiply by two".',
        'de':
            'Sagen Sie „59 plus 7", und ein Rechner erscheint — kein Bild '
            'von einem. Tastenfeld, Tastatur und Stimme bearbeiten denselben '
            'Wert, weil es immer nur einen gibt. Das Modell bekommt nie eine '
            'Kopie zum Nachdenken: Es liest ein Abbild und handelt, indem es '
            'eine Absicht zurückschickt — etwa „mal zwei".',
      }),
      points: [
        LocalizedText({
          'en': 'Actions say what should happen, never which pixel to press',
          'de': 'Aktionen sagen, was geschehen soll — nie, welches Pixel',
        }),
        LocalizedText({
          'en': 'While a surface is open, it owns the microphone',
          'de': 'Solange eine Oberfläche offen ist, gehört ihr das Mikrofon',
        }),
        LocalizedText({
          'en': 'Calculator, notes, tasks, timer and a loading plan run on it',
          'de':
              'Rechner, Notizen, Aufgaben, Timer und ein Ladeplan laufen '
              'darauf',
        }),
      ],
      stage: VisionStage.today,
      visual: masterChatOneState,
      duration: Duration(seconds: 12),
    ),

    // ── 5 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'shared-context',
      kicker: LocalizedText({
        'en': 'One shared context',
        'de': 'Ein gemeinsamer Kontext',
      }),
      headline: LocalizedText({
        'en': 'Not a launcher for other apps.',
        'de': 'Kein Starter für andere Apps.',
      }),
      body: LocalizedText({
        'en':
            'The direction is that what one capability produces stays '
            'available to the next — inside one continuous piece of work, '
            'bounded by what permissions and security allow. Not "chat opens '
            'calculator, chat opens notes", but one task that happens to need '
            'several things.',
        'de':
            'Die Richtung: Was eine Fähigkeit hervorbringt, bleibt für die '
            'nächste verfügbar — innerhalb einer zusammenhängenden Arbeit, '
            'begrenzt durch das, was Berechtigungen und Sicherheit zulassen. '
            'Nicht „Chat öffnet Rechner, Chat öffnet Notizen", sondern eine '
            'Aufgabe, die eben mehreres braucht.',
      }),
      points: [
        LocalizedText({
          'en': 'Results stay available to the next step',
          'de': 'Ergebnisse bleiben für den nächsten Schritt verfügbar',
        }),
        LocalizedText({
          'en': 'Bounded by permission, not by convenience',
          'de': 'Begrenzt durch Berechtigung, nicht durch Bequemlichkeit',
        }),
      ],
      stage: VisionStage.vision,
      stageNote: LocalizedText({
        'en':
            'Today a conversation keeps a bounded window of recent turns '
            'plus the active surface, survives a restart, and syncs per '
            'workspace when signed in. Summarisation and long-term memory are '
            'later phases.',
        'de':
            'Heute behält ein Gespräch ein begrenztes Fenster der letzten '
            'Züge plus die aktive Oberfläche, übersteht einen Neustart und '
            'synchronisiert pro Workspace, wenn man angemeldet ist. '
            'Zusammenfassung und Langzeitgedächtnis sind spätere Phasen.',
      }),
      visual: masterChatContext,
      duration: Duration(seconds: 12),
    ),

    // ── 6 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'many-intelligences',
      kicker: LocalizedText({
        'en': 'Many intelligences',
        'de': 'Viele Intelligenzen',
      }),
      headline: LocalizedText({
        'en': 'One interface does not mean one intelligence.',
        'de': 'Eine Oberfläche heißt nicht eine Intelligenz.',
      }),
      body: LocalizedText({
        'en':
            'The AI layer is vendor-neutral by construction: OpenAI and '
            'Claude are two adapters behind one interface, and switching '
            'between them is a build flag rather than a rewrite. The direction '
            'is to let a task be split across specialised systems and have the '
            'parts come back together.',
        'de':
            'Die KI-Schicht ist von Grund auf herstellerneutral: OpenAI und '
            'Claude sind zwei Adapter hinter einer Schnittstelle, und der '
            'Wechsel ist ein Build-Schalter statt einer Neuentwicklung. Die '
            'Richtung: eine Aufgabe auf spezialisierte Systeme aufteilen und '
            'die Teile wieder zusammenführen.',
      }),
      points: [
        LocalizedText({
          'en': 'The provider is an adapter, not an assumption',
          'de': 'Der Anbieter ist ein Adapter, keine Annahme',
        }),
        LocalizedText({
          'en': 'The cheapest reliable layer answers first',
          'de': 'Die einfachste verlässliche Ebene antwortet zuerst',
        }),
      ],
      stage: VisionStage.vision,
      stageNote: LocalizedText({
        'en':
            'Today one provider answers at a time and tool calls run in '
            'order. There is no planner and no multi-agent orchestration.',
        'de':
            'Heute antwortet ein Anbieter zur Zeit, und Werkzeugaufrufe '
            'laufen der Reihe nach. Es gibt keinen Planer und keine '
            'Multi-Agenten-Orchestrierung.',
      }),
      visual: masterChatIntelligences,
      duration: Duration(seconds: 12),
    ),

    // ── 7 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'action',
      kicker: LocalizedText({
        'en': 'From answer to action',
        'de': 'Von der Antwort zur Handlung',
      }),
      headline: LocalizedText({
        'en': "Don't just tell me how. Help me do it.",
        'de': 'Sag mir nicht nur wie. Hilf mir, es zu tun.',
      }),
      body: LocalizedText({
        'en':
            'A capability is written once and registered once. The chat, an '
            'HTTP client and any MCP-compatible agent resolve it in the same '
            'registry — there is no separate "API tool". Anything that changes '
            'something stops first: the gateway parks the action behind a '
            'one-time confirmation, exactly as the chat shows a confirmation '
            'card.',
        'de':
            'Eine Fähigkeit wird einmal geschrieben und einmal registriert. '
            'Der Chat, ein HTTP-Client und jeder MCP-fähige Agent lösen sie in '
            'derselben Registry auf — es gibt kein eigenes „API-Werkzeug". Was '
            'etwas verändert, hält vorher an: Das Gateway parkt die Aktion '
            'hinter einer einmaligen Bestätigung, genau wie der Chat eine '
            'Bestätigungskarte zeigt.',
      }),
      points: [
        LocalizedText({
          'en': 'Written once — reachable from chat, HTTP and MCP',
          'de': 'Einmal geschrieben — erreichbar aus Chat, HTTP und MCP',
        }),
        LocalizedText({
          'en': 'No scope removes a confirmation requirement',
          'de': 'Kein Scope hebt eine Bestätigungspflicht auf',
        }),
        // The honest boundary, stated where the gateway diagram could
        // otherwise imply that every connected tool does real work.
        LocalizedText({
          'en':
              'The built-in essentials do real work; the connected demo '
              'tools return sample data',
          'de':
              'Die eingebauten Essentials leisten echte Arbeit; die '
              'angebundenen Demo-Werkzeuge liefern Beispieldaten',
        }),
      ],
      stage: VisionStage.today,
      visual: masterChatRegistry,
      duration: Duration(seconds: 12),
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
            'The apps do not disappear, and neither do their capabilities. '
            'What goes away is having to orchestrate them by hand — deciding '
            'which window to open before the work can start. One conversation, '
            'many capabilities, one shared goal.',
        'de':
            'Die Apps verschwinden nicht, und ihre Fähigkeiten auch nicht. '
            'Was verschwindet, ist die Notwendigkeit, sie von Hand zu '
            'dirigieren — erst zu entscheiden, welches Fenster man öffnet, '
            'bevor die Arbeit beginnen kann. Ein Gespräch, viele Fähigkeiten, '
            'ein gemeinsames Ziel.',
      }),
      stage: VisionStage.vision,
      visual: masterChatStack,
      duration: Duration(seconds: 9),
    ),
  ],
);
