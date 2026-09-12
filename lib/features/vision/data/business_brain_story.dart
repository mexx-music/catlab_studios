import 'package:catlab_studios/features/vision/domain/vision_story.dart';
import 'package:catlab_studios/features/vision/presentation/vision_visuals.dart';

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
  title: 'Business Brain',
  subtitle: 'Where Universal Business is heading',
  scenes: [
    // ── 1 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'question',
      kicker: 'The starting point',
      headline: 'It starts with a question.',
      body:
          'An idea, a problem, or a goal — most often simply "what should I do '
          'next?" The knowledge needed to answer it usually exists inside the '
          'business already. It is just scattered across PDFs, chat threads, '
          'old emails, and one busy person\'s head.',
      visual: visionImpulse,
      duration: Duration(seconds: 9),
    ),

    // ── 2 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'grounded',
      kicker: 'Understand',
      headline: 'Answer from what the business actually knows.',
      body:
          'Business Brain retrieves the company\'s own approved material and '
          'answers only from it. Every answer names the provider, the model, a '
          'request ID, and the exact sources it was bound to — so a reader can '
          'trace it rather than trust it.',
      points: [
        'Grounded in approved company knowledge only',
        'Every answer shows the sources it used',
        'No evidence? An honest knowledge gap, never a guess',
      ],
      stage: VisionStage.today,
      visual: visionGrounding,
      duration: Duration(seconds: 12),
    ),

    // ── 3 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'loop',
      kicker: 'Connect knowledge',
      headline: 'Gaps become knowledge — with a human in the loop.',
      body:
          'What a company knows is not a fixed dataset. Gaps and new material '
          'flow into the Knowledge Builder, where the model drafts proposals. '
          'A person accepts, edits, or rejects each one. Nothing becomes '
          'confirmed company knowledge on its own.',
      points: [
        'The model proposes — it never publishes',
        'A human decides what counts as knowledge',
        'Every confirmed answer improves the next one',
      ],
      stage: VisionStage.today,
      visual: visionLoop,
      duration: Duration(seconds: 12),
    ),

    // ── 4 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'many-minds',
      kicker: 'Multiple intelligence',
      headline: 'One question, several kinds of expertise.',
      body:
          'A real business question is rarely one subject. Market, finance, '
          'customers, technology and strategy each hold a piece of it. The '
          'direction is to let specialised capabilities examine their own part '
          '— then compare the results instead of accepting the first confident '
          'answer.',
      points: [
        'Compare findings rather than adopt them',
        'Name the disagreement instead of averaging it away',
        'Say plainly when the evidence is thin',
      ],
      stage: VisionStage.vision,
      stageNote:
          'Today one grounded answer path runs behind a single server-side '
          'gateway.',
      visual: visionManyMinds,
      duration: Duration(seconds: 13),
    ),

    // ── 5 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'action',
      kicker: 'From insight to action',
      headline: 'The product is the next sensible step.',
      body:
          'An answer changes nothing by itself. The intended output is a '
          'prioritised plan: every recommendation carrying its reasoning, the '
          'benefit expected of it, the effort it costs — and a later check on '
          'whether it actually worked.',
      points: [
        'Reasoning, benefit, effort, priority',
        'Recommendations are computed; decisions are stored',
        'Never re-propose what is already running',
      ],
      stage: VisionStage.vision,
      stageNote:
          'Today Business Brain answers and meters its own usage. The action '
          'plan is direction, not a shipped feature.',
      visual: visionAction,
      duration: Duration(seconds: 13),
    ),

    // ── 6 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'memory',
      kicker: 'Learn and grow',
      headline: 'A memory of what was tried, and what worked.',
      body:
          'Over months the decisions — accepted, postponed, rejected, done — '
          'become the business\'s own record. The value is not the model. It is '
          'that the company\'s experience stops evaporating.',
      points: [
        'Each review states how solid its basis is',
        'Report what was observed, not an effect it cannot prove',
        '"A short human check would be sensible" is a valid answer',
      ],
      stage: VisionStage.vision,
      stageNote:
          'Today knowledge accumulates through human review. The longer '
          'decision record is planned.',
      visual: visionMemory,
      duration: Duration(seconds: 12),
    ),

    // ── 7 ─────────────────────────────────────────────────────────────────
    VisionScene(
      id: 'vision',
      kicker: 'The vision',
      headline: 'From an idea to something real.',
      body:
          'A companion that connects a business\'s own knowledge, the right '
          'kind of intelligence, and the tools to act on both — so the next '
          'sensible step is always visible. Not once. Continuously.',
      stage: VisionStage.vision,
      visual: visionConstellation,
      duration: Duration(seconds: 10),
    ),
  ],
);
