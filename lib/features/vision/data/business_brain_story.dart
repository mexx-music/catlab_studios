import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/business_brain_visuals.dart';

/// The vision story for Universal Business / Business Brain.
///
/// Sourced from the project's own repository documents — its README (what runs
/// in production today) and README-VISION (the intended direction) — not from
/// marketing copy. The split is deliberate and load-bearing:
///
///   * [VisionStage.today] scenes describe behaviour that is verifiable in the
///     live jury demo: grounded answers bound to cited sources, honest
///     knowledge gaps, and the Knowledge Builder's human-review gate.
///   * [VisionStage.vision] scenes describe direction only. Each one carries a
///     [VisionScene.stageNote] naming what exists today, so an ambitious slide
///     can never be read as a shipped feature.
///
/// The project itself refuses to claim autonomous AI operations, and this story
/// holds the same line.
///
/// AI-hint: never promote a scene to `today` without a verifiable behaviour in
/// the Business Brain repository to point at.
final VisionStory businessBrainStory = VisionStory(
  projectId: 'universal_business',
  title: LocalizedText({'en': 'Business Brain', 'de': 'Business Brain'}),
  subtitle: LocalizedText({
    'en': 'Where Universal Business is heading',
    'de': 'Wohin sich Universal Business entwickelt',
  }),
  scenes: [
    // ── 1 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'question',
      kicker: LocalizedText({
        'en': 'The starting point',
        'de': 'Der Ausgangspunkt',
      }),
      headline: LocalizedText({
        'en': 'It starts with a question.',
        'de': 'Am Anfang steht eine Frage.',
      }),
      body: LocalizedText({
        'en':
            'An idea, a problem, or a goal — most often simply "what should '
            'I do next?" The knowledge needed to answer it usually exists '
            'inside the business already. It is just scattered across PDFs, '
            'chat threads, old emails, and one busy person\'s head.',
        'de':
            'Eine Idee, ein Problem oder ein Ziel — meist schlicht: „Was '
            'soll ich als Nächstes tun?" Das Wissen für die Antwort steckt in '
            'der Regel längst im Unternehmen. Es liegt nur verstreut in PDFs, '
            'Chatverläufen, alten E-Mails und im Kopf einer vielbeschäftigten '
            'Person.',
      }),
      visual: visionImpulse,
      duration: Duration(seconds: 9),
    ),

    // ── 2 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'grounded',
      kicker: LocalizedText({'en': 'Understand', 'de': 'Verstehen'}),
      headline: LocalizedText({
        'en': 'Answer from what the business actually knows.',
        'de': 'Antworten aus dem, was das Unternehmen wirklich weiß.',
      }),
      body: LocalizedText({
        'en':
            'Business Brain retrieves the company\'s own approved material '
            'and answers only from it. Every answer names the provider, the '
            'model, a request ID, and the exact sources it was bound to — so '
            'a reader can trace it rather than trust it.',
        'de':
            'Business Brain holt das freigegebene Material des Unternehmens '
            'und antwortet ausschließlich daraus. Jede Antwort nennt den '
            'Anbieter, das Modell, eine Request-ID und die genauen Quellen, an '
            'die sie gebunden war — damit man sie nachvollziehen kann, statt '
            'ihr glauben zu müssen.',
      }),
      points: [
        LocalizedText({
          'en': 'Grounded in approved company knowledge only',
          'de': 'Ausschließlich auf freigegebenem Firmenwissen',
        }),
        LocalizedText({
          'en': 'Every answer shows the sources it used',
          'de': 'Jede Antwort zeigt die verwendeten Quellen',
        }),
        LocalizedText({
          'en': 'No evidence? An honest knowledge gap, never a guess',
          'de': 'Keine Belege? Eine ehrliche Wissenslücke, niemals geraten',
        }),
      ],
      stage: VisionStage.today,
      visual: visionGrounding,
      duration: Duration(seconds: 12),
    ),

    // ── 3 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'loop',
      kicker: LocalizedText({
        'en': 'Connect knowledge',
        'de': 'Wissen verbinden',
      }),
      headline: LocalizedText({
        'en': 'Gaps become knowledge — with a human in the loop.',
        'de': 'Aus Lücken wird Wissen — mit einem Menschen dazwischen.',
      }),
      body: LocalizedText({
        'en':
            'What a company knows is not a fixed dataset. Gaps and new '
            'material flow into the Knowledge Builder, where the model drafts '
            'proposals. A person accepts, edits, or rejects each one. Nothing '
            'becomes confirmed company knowledge on its own.',
        'de':
            'Was ein Unternehmen weiß, ist kein fester Datenbestand. Lücken '
            'und neues Material fließen in den Knowledge Builder, wo das '
            'Modell Vorschläge entwirft. Ein Mensch nimmt jeden an, bearbeitet '
            'ihn oder lehnt ihn ab. Nichts wird von allein zu bestätigtem '
            'Firmenwissen.',
      }),
      points: [
        LocalizedText({
          'en': 'The model proposes — it never publishes',
          'de': 'Das Modell schlägt vor — es veröffentlicht nie',
        }),
        LocalizedText({
          'en': 'A human decides what counts as knowledge',
          'de': 'Ein Mensch entscheidet, was als Wissen gilt',
        }),
        LocalizedText({
          'en': 'Every confirmed answer improves the next one',
          'de': 'Jede bestätigte Antwort verbessert die nächste',
        }),
      ],
      stage: VisionStage.today,
      visual: visionLoop,
      duration: Duration(seconds: 12),
    ),

    // ── 4 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'many-minds',
      kicker: LocalizedText({
        'en': 'Multiple intelligence',
        'de': 'Mehrere Intelligenzen',
      }),
      headline: LocalizedText({
        'en': 'One question, several kinds of expertise.',
        'de': 'Eine Frage, mehrere Fachrichtungen.',
      }),
      body: LocalizedText({
        'en':
            'A real business question is rarely one subject. Market, '
            'finance, customers, technology and strategy each hold a piece of '
            'it. The direction is to let specialised capabilities examine '
            'their own part — then compare the results instead of accepting '
            'the first confident answer.',
        'de':
            'Eine echte unternehmerische Frage betrifft selten nur ein '
            'Fachgebiet. Markt, Finanzen, Kunden, Technik und Strategie halten '
            'jeweils ein Stück davon. Die Richtung: spezialisierte Fähigkeiten '
            'untersuchen ihren eigenen Teil — und die Ergebnisse werden '
            'verglichen, statt die erste selbstbewusste Antwort zu übernehmen.',
      }),
      points: [
        LocalizedText({
          'en': 'Compare findings rather than adopt them',
          'de': 'Ergebnisse vergleichen statt übernehmen',
        }),
        LocalizedText({
          'en': 'Name the disagreement instead of averaging it away',
          'de': 'Widerspruch benennen, statt ihn wegzumitteln',
        }),
        LocalizedText({
          'en': 'Say plainly when the evidence is thin',
          'de': 'Klar sagen, wenn die Belege dünn sind',
        }),
      ],
      stage: VisionStage.vision,
      stageNote: LocalizedText({
        'en':
            'Today one grounded answer path runs behind a single '
            'server-side gateway.',
        'de':
            'Heute läuft ein einziger belegter Antwortpfad hinter einem '
            'serverseitigen Gateway.',
      }),
      visual: visionManyMinds,
      duration: Duration(seconds: 13),
    ),

    // ── 5 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'action',
      kicker: LocalizedText({
        'en': 'From insight to action',
        'de': 'Von der Erkenntnis zur Umsetzung',
      }),
      headline: LocalizedText({
        'en': 'The product is the next sensible step.',
        'de': 'Das Produkt ist der nächste sinnvolle Schritt.',
      }),
      body: LocalizedText({
        'en':
            'An answer changes nothing by itself. The intended output is a '
            'prioritised plan: every recommendation carrying its reasoning, '
            'the benefit expected of it, the effort it costs — and a later '
            'check on whether it actually worked.',
        'de':
            'Eine Antwort allein verändert nichts. Das angestrebte Ergebnis '
            'ist ein priorisierter Plan: jede Empfehlung mit ihrer Begründung, '
            'dem erwarteten Nutzen, dem nötigen Aufwand — und einer späteren '
            'Prüfung, ob sie tatsächlich gewirkt hat.',
      }),
      points: [
        LocalizedText({
          'en': 'Reasoning, benefit, effort, priority',
          'de': 'Begründung, Nutzen, Aufwand, Priorität',
        }),
        LocalizedText({
          'en': 'Recommendations are computed; decisions are stored',
          'de': 'Empfehlungen werden berechnet, Entscheidungen gespeichert',
        }),
        LocalizedText({
          'en': 'Never re-propose what is already running',
          'de': 'Nie erneut vorschlagen, was bereits läuft',
        }),
      ],
      stage: VisionStage.vision,
      stageNote: LocalizedText({
        'en':
            'Today Business Brain answers and meters its own usage. The '
            'action plan is direction, not a shipped feature.',
        'de':
            'Heute beantwortet Business Brain Fragen und misst die eigene '
            'Nutzung. Der Maßnahmenplan ist Richtung, keine ausgelieferte '
            'Funktion.',
      }),
      visual: visionAction,
      duration: Duration(seconds: 13),
    ),

    // ── 6 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'memory',
      kicker: LocalizedText({
        'en': 'Learn and grow',
        'de': 'Lernen und wachsen',
      }),
      headline: LocalizedText({
        'en': 'A memory of what was tried, and what worked.',
        'de': 'Ein Gedächtnis dafür, was versucht wurde — und was gewirkt hat.',
      }),
      body: LocalizedText({
        'en':
            'Over months the decisions — accepted, postponed, rejected, '
            'done — become the business\'s own record. The value is not the '
            'model. It is that the company\'s experience stops evaporating.',
        'de':
            'Über Monate werden die Entscheidungen — angenommen, verschoben, '
            'abgelehnt, umgesetzt — zur eigenen Chronik des Unternehmens. Der '
            'Wert liegt nicht im Modell. Er liegt darin, dass die Erfahrung '
            'des Unternehmens nicht mehr verdunstet.',
      }),
      points: [
        LocalizedText({
          'en': 'Each review states how solid its basis is',
          'de': 'Jede Auswertung sagt, wie belastbar ihre Grundlage ist',
        }),
        LocalizedText({
          'en': 'Report what was observed, not an effect it cannot prove',
          'de':
              'Berichten, was beobachtet wurde — nicht eine Wirkung, die '
              'sich nicht belegen lässt',
        }),
        LocalizedText({
          'en': '"A short human check would be sensible" is a valid answer',
          'de':
              '„Eine kurze menschliche Prüfung wäre sinnvoll" ist eine '
              'gültige Antwort',
        }),
      ],
      stage: VisionStage.vision,
      stageNote: LocalizedText({
        'en':
            'Today knowledge accumulates through human review. The longer '
            'decision record is planned.',
        'de':
            'Heute wächst das Wissen über die menschliche Prüfung. Die '
            'längere Entscheidungschronik ist geplant.',
      }),
      visual: visionMemory,
      duration: Duration(seconds: 12),
    ),

    // ── 7 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'vision',
      kicker: LocalizedText({'en': 'The vision', 'de': 'Die Vision'}),
      headline: LocalizedText({
        'en': 'From an idea to something real.',
        'de': 'Von einer Idee zu etwas Wirklichem.',
      }),
      body: LocalizedText({
        'en':
            'A companion that connects a business\'s own knowledge, the '
            'right kind of intelligence, and the tools to act on both — so '
            'the next sensible step is always visible. Not once. '
            'Continuously.',
        'de':
            'Ein Begleiter, der das eigene Wissen eines Unternehmens, die '
            'passende Intelligenz und die Werkzeuge zum Handeln verbindet — '
            'damit der nächste sinnvolle Schritt immer sichtbar ist. Nicht '
            'einmal. Dauerhaft.',
      }),
      stage: VisionStage.vision,
      visual: visionConstellation,
      duration: Duration(seconds: 10),
    ),
  ],
);
