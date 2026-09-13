import 'package:catlab_studios/core/l10n/localized_text.dart';

/// The words drawn inside the vision diagrams, one class per story.
///
/// Separate from [SiteText] because these are not interface copy: they are
/// part of the picture, painted by a [CustomPainter] that has no BuildContext.
/// Each visual resolves them in its builder and hands the painter plain
/// strings, which is why they are short — a node label has no room to grow.
///
/// AI-hint: keep every translation roughly as short as the English, or it will
/// collide with the geometry around it.
abstract final class BusinessBrainDiagramText {
  static const question = LocalizedText({
    'en': 'what should I do next?',
    'de': 'was mache ich als Nächstes?',
  });

  static const sources = [
    LocalizedText({'en': 'PDFs', 'de': 'PDFs'}),
    LocalizedText({'en': 'Threads', 'de': 'Chats'}),
    LocalizedText({'en': 'Emails', 'de': 'E-Mails'}),
    LocalizedText({'en': 'Docs', 'de': 'Dokumente'}),
  ];
  static const groundedAnswer = LocalizedText({
    'en': 'grounded answer',
    'de': 'belegte Antwort',
  });

  static const loopStations = [
    LocalizedText({'en': 'Question', 'de': 'Frage'}),
    LocalizedText({'en': 'Knowledge gap', 'de': 'Wissenslücke'}),
    LocalizedText({'en': 'Proposal', 'de': 'Vorschlag'}),
    LocalizedText({'en': 'Human review', 'de': 'Mensch prüft'}),
  ];
  static const confirmedKnowledge = LocalizedText({
    'en': 'confirmed knowledge',
    'de': 'bestätigtes Wissen',
  });

  static const disciplines = [
    LocalizedText({'en': 'Market', 'de': 'Markt'}),
    LocalizedText({'en': 'Finance', 'de': 'Finanzen'}),
    LocalizedText({'en': 'Customers', 'de': 'Kunden'}),
    LocalizedText({'en': 'Technology', 'de': 'Technik'}),
    LocalizedText({'en': 'Strategy', 'de': 'Strategie'}),
  ];
  static const theQuestion = LocalizedText({
    'en': 'the question',
    'de': 'die Frage',
  });
  static const compared = LocalizedText({'en': 'compared', 'de': 'verglichen'});
  static const lowConfidence = LocalizedText({
    'en': 'low confidence',
    'de': 'unsicher',
  });

  static const actionFacets = [
    LocalizedText({'en': 'why', 'de': 'warum'}),
    LocalizedText({'en': 'benefit', 'de': 'Nutzen'}),
    LocalizedText({'en': 'effort', 'de': 'Aufwand'}),
  ];
  static const step = LocalizedText({'en': 'Step', 'de': 'Schritt'});

  static const companyMemory = LocalizedText({
    'en': 'company memory',
    'de': 'Firmengedächtnis',
  });
}

/// Master Chat's diagram draws interfaces, so its words are the names of
/// surfaces, capabilities and doors rather than of knowledge.
abstract final class MasterChatDiagramText {
  // Scene 1 — the apps a person juggles today. Deliberately generic
  // categories, not this project's own tool ids.
  static const scatteredApps = [
    LocalizedText({'en': 'Chat', 'de': 'Chat'}),
    LocalizedText({'en': 'Calculator', 'de': 'Rechner'}),
    LocalizedText({'en': 'Notes', 'de': 'Notizen'}),
    LocalizedText({'en': 'Tasks', 'de': 'Aufgaben'}),
    LocalizedText({'en': 'Calendar', 'de': 'Kalender'}),
    LocalizedText({'en': 'Docs', 'de': 'Dokumente'}),
    LocalizedText({'en': 'Maps', 'de': 'Karten'}),
    LocalizedText({'en': 'Code', 'de': 'Code'}),
  ];

  static const oneConversation = LocalizedText({
    'en': 'one conversation',
    'de': 'ein Gespräch',
  });

  // Scene 3 — the three availability states the capability registry really
  // reports, with the examples the project's own documentation uses.
  static const capabilityReady = LocalizedText({'en': 'ready', 'de': 'bereit'});
  static const capabilityInactive = LocalizedText({
    'en': 'module not active',
    'de': 'Modul nicht aktiv',
  });
  static const capabilityBlocked = LocalizedText({
    'en': 'app required',
    'de': 'App erforderlich',
  });
  static const capabilityNames = [
    LocalizedText({'en': 'Calculator', 'de': 'Rechner'}),
    LocalizedText({'en': 'Customers', 'de': 'Kunden'}),
    LocalizedText({'en': 'Load planning', 'de': 'Ladungsplanung'}),
    LocalizedText({'en': 'Device control', 'de': 'Gerätesteuerung'}),
  ];

  // Scene 4 — the three hands on one state.
  static const inputTouch = LocalizedText({'en': 'touch', 'de': 'Tippen'});
  static const inputKeys = LocalizedText({'en': 'keys', 'de': 'Tasten'});
  static const inputVoice = LocalizedText({'en': 'voice', 'de': 'Stimme'});
  static const theState = LocalizedText({'en': 'one value', 'de': 'ein Wert'});
  static const snapshot = LocalizedText({'en': 'snapshot', 'de': 'Abbild'});
  static const intent = LocalizedText({'en': 'intent', 'de': 'Absicht'});
  static const model = LocalizedText({'en': 'model', 'de': 'Modell'});

  // Scene 5 — the working context.
  static const workingContext = LocalizedText({
    'en': 'one working context',
    'de': 'ein Arbeitskontext',
  });
  static const separateWindows = LocalizedText({
    'en': 'separate windows',
    'de': 'getrennte Fenster',
  });

  // Scene 6 — the AI layer. The two provider names are in the repository as
  // real adapters; nothing else here is claimed as built.
  static const providers = [
    LocalizedText({'en': 'OpenAI', 'de': 'OpenAI'}),
    LocalizedText({'en': 'Claude', 'de': 'Claude'}),
  ];
  static const providerInterface = LocalizedText({
    'en': 'one interface',
    'de': 'eine Schnittstelle',
  });
  static const specialists = [
    LocalizedText({'en': 'reasoning', 'de': 'Denken'}),
    LocalizedText({'en': 'research', 'de': 'Recherche'}),
    LocalizedText({'en': 'code', 'de': 'Code'}),
    LocalizedText({'en': 'analysis', 'de': 'Analyse'}),
  ];

  // Scene 7 — three doors, one registry.
  static const doors = [
    LocalizedText({'en': 'chat', 'de': 'Chat'}),
    LocalizedText({'en': 'HTTP', 'de': 'HTTP'}),
    LocalizedText({'en': 'MCP', 'de': 'MCP'}),
  ];
  static const registry = LocalizedText({
    'en': 'one registry',
    'de': 'eine Registry',
  });
  static const confirmGate = LocalizedText({
    'en': 'confirm',
    'de': 'bestätigen',
  });

  // Scene 8 — the layers, top to bottom.
  static const stack = [
    LocalizedText({'en': 'you', 'de': 'Sie'}),
    LocalizedText({'en': 'one conversation', 'de': 'ein Gespräch'}),
    LocalizedText({'en': 'context', 'de': 'Kontext'}),
    LocalizedText({'en': 'capabilities', 'de': 'Fähigkeiten'}),
    LocalizedText({'en': 'tools · AI', 'de': 'Werkzeuge · KI'}),
    LocalizedText({'en': 'action', 'de': 'Handlung'}),
  ];
}
