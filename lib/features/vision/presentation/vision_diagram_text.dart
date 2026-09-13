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
/// everyday tasks rather than of architecture.
///
/// AI-hint: nothing here may need a software background to read. The
/// architecture behind these pictures is documented in the Master Chat
/// repository; this is the public story, and it speaks plainly on purpose.
abstract final class MasterChatDiagramText {
  // Scene 1 — the apps a person juggles today, named by what they are for.
  static const scatteredApps = [
    LocalizedText({'en': 'Calculate', 'de': 'Rechnen'}),
    LocalizedText({'en': 'Notes', 'de': 'Notizen'}),
    LocalizedText({'en': 'Plan', 'de': 'Planen'}),
    LocalizedText({'en': 'Search', 'de': 'Suchen'}),
    LocalizedText({'en': 'Write', 'de': 'Schreiben'}),
    LocalizedText({'en': 'Calendar', 'de': 'Kalender'}),
    LocalizedText({'en': 'Maps', 'de': 'Karten'}),
    LocalizedText({'en': 'Documents', 'de': 'Dokumente'}),
  ];

  static const oneConversation = LocalizedText({
    'en': 'one conversation',
    'de': 'ein Gespräch',
  });

  // Scene 3 — the task arrives, and the capability that fits lights up.
  static const yourTask = LocalizedText({
    'en': 'your task',
    'de': 'deine Aufgabe',
  });
  static const capabilityNames = [
    LocalizedText({'en': 'Calculate', 'de': 'Rechnen'}),
    LocalizedText({'en': 'Notes', 'de': 'Notizen'}),
    LocalizedText({'en': 'Plan', 'de': 'Planen'}),
    LocalizedText({'en': 'Search', 'de': 'Suchen'}),
  ];

  // Scene 4 — spoken in, calculator out. The words on screen are the ones
  // the visitor would actually say and see.
  static const spokenPhrase = LocalizedText({
    'en': '"59 plus 7"',
    'de': '„59 plus 7"',
  });
  static const inputVoice = LocalizedText({'en': 'voice', 'de': 'Stimme'});
  static const inputKeyboard = LocalizedText({
    'en': 'keyboard',
    'de': 'Tastatur',
  });
  static const inputKeys = LocalizedText({'en': 'keypad', 'de': 'Tasten'});

  // Scene 5 — three steps of one piece of work.
  static const flowSteps = [
    LocalizedText({'en': 'Calculate', 'de': 'Rechnen'}),
    LocalizedText({'en': 'Note it', 'de': 'Notieren'}),
    LocalizedText({'en': 'Plan', 'de': 'Planen'}),
  ];
  static const workingContext = LocalizedText({
    'en': 'one piece of work',
    'de': 'eine zusammenhängende Arbeit',
  });
  static const separateWindows = LocalizedText({
    'en': 'separate windows',
    'de': 'getrennte Fenster',
  });

  // Scene 6 — specialists, described by what they are good at.
  static const specialists = [
    LocalizedText({'en': 'research', 'de': 'Recherche'}),
    LocalizedText({'en': 'analysis', 'de': 'Analyse'}),
    LocalizedText({'en': 'writing', 'de': 'Text'}),
    LocalizedText({'en': 'planning', 'de': 'Planung'}),
  ];
  static const broughtTogether = LocalizedText({
    'en': 'brought together',
    'de': 'zusammengeführt',
  });

  // Scene 7 — the four beats of doing something, and the one gate where the
  // person decides.
  static const actionSteps = [
    LocalizedText({'en': 'Understand', 'de': 'Verstehen'}),
    LocalizedText({'en': 'Choose', 'de': 'Werkzeug wählen'}),
    LocalizedText({'en': 'Act', 'de': 'Ausführen'}),
    LocalizedText({'en': 'Result', 'de': 'Ergebnis'}),
  ];
  static const youDecide = LocalizedText({
    'en': 'you decide',
    'de': 'du entscheidest',
  });

  // Scene 8 — the layers, top to bottom.
  static const stack = [
    LocalizedText({'en': 'You', 'de': 'Du'}),
    LocalizedText({'en': 'one conversation', 'de': 'ein Gespräch'}),
    LocalizedText({'en': 'capabilities', 'de': 'Fähigkeiten'}),
    LocalizedText({'en': 'tools & AI', 'de': 'Werkzeuge & KI'}),
    LocalizedText({'en': 'result', 'de': 'Ergebnis'}),
  ];
}
