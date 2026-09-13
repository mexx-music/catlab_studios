import 'package:catlab_studios/core/l10n/localized_text.dart';

/// The words drawn inside the vision diagrams.
///
/// Separate from [SiteText] because these are not interface copy: they are
/// part of the picture, painted by a [CustomPainter] that has no BuildContext.
/// Each visual resolves them in its builder and hands the painter plain
/// strings, which is why they are short — a node label has no room to grow.
///
/// AI-hint: keep every translation roughly as short as the English, or it will
/// collide with the geometry around it.
abstract final class VisionDiagramText {
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
