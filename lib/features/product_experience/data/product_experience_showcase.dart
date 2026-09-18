import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/features/product_experience/domain/staged_media.dart';

/// The one reference the product-experience section is built on.
///
/// Healing & Balance is real work: the films, the campaign cards and the
/// product cut-outs below were produced in the studio's promo project for
/// the CureBase and CureClip devices and the HB Cure app, which is already
/// in the portfolio. Every file listed here exists in this repository —
/// the films under `web/media/`, the stills under `assets/images/showcase/`,
/// all of them exports of the real production rather than illustrations of
/// it.
///
/// AI-hint: a second reference goes here the same way — real exports first,
/// copy second. Never the other way round.
abstract final class ProductExperienceShowcase {
  static const _stills = 'assets/images/showcase';
  static const _films = 'media';

  /// The client this reference was made for, named plainly because the work
  /// is public.
  static const referenceName = 'Healing & Balance';

  static const referenceNote = LocalizedText({
    'en':
        'CureBase, CureClip and the HB Cure app — staged from the original '
        'product photography, the real logo and real app screens. Nothing in '
        'these films was generated.',
    'de':
        'CureBase, CureClip und die HB Cure App — inszeniert aus den '
        'originalen Produktfotos, dem echten Logo und echten App-Screens. '
        'Nichts in diesen Filmen ist generiert.',
  });

  /// Rendered films, shortest first would bury the best one — so the system
  /// explainer, the piece that shows product, app and hardware working as one
  /// thing, leads.
  static const List<StagedFilm> films = [
    StagedFilm(
      id: 'hb_system',
      title: LocalizedText({'en': 'System film', 'de': 'Systemfilm'}),
      note: LocalizedText({
        'en': 'Device, app and wearable as one system, with sound on the cut.',
        'de':
            'Gerät, App und Wearable als ein System, mit Ton auf dem Schnitt.',
      }),
      posterAsset: '$_stills/hb_system_poster.jpg',
      videoUrl: '$_films/hb_system_9x16.mp4',
      duration: Duration(seconds: 20),
    ),
    StagedFilm(
      id: 'hb_opening',
      title: LocalizedText({'en': 'Programme opening', 'de': 'Programm-Opening'}),
      note: LocalizedText({
        'en': 'Real app screens, moving in a light field built in code.',
        'de': 'Echte App-Screens, bewegt in einem programmierten Lichtfeld.',
      }),
      posterAsset: '$_stills/hb_opening_poster.jpg',
      videoUrl: '$_films/hb_opening_9x16.mp4',
      duration: Duration(seconds: 16),
    ),
    StagedFilm(
      id: 'hb_curebase',
      title: LocalizedText({'en': 'Product spot', 'de': 'Produkt-Spot'}),
      note: LocalizedText({
        'en': 'Eight seconds on one device — the short form for social.',
        'de': 'Acht Sekunden auf einem Gerät — die Kurzform für Social.',
      }),
      posterAsset: '$_stills/hb_curebase_poster.jpg',
      videoUrl: '$_films/hb_curebase_9x16.mp4',
      duration: Duration(seconds: 8),
    ),
  ];

  /// Published campaign cards, in the 4:5 shape they go out in.
  static const List<CampaignCard> cards = [
    CampaignCard(
      id: 'curebase',
      title: LocalizedText({'en': 'CureBase', 'de': 'CureBase'}),
      imageAsset: '$_stills/hb_card_curebase.jpg',
      aspectRatio: 1080 / 1350,
    ),
    CampaignCard(
      id: 'cureclip',
      title: LocalizedText({'en': 'CureClip', 'de': 'CureClip'}),
      imageAsset: '$_stills/hb_card_cureclip.jpg',
      aspectRatio: 1080 / 1350,
    ),
    CampaignCard(
      id: 'hb_cure_app',
      title: LocalizedText({'en': 'HB Cure app', 'de': 'HB Cure App'}),
      imageAsset: '$_stills/hb_card_hb_cure_app.jpg',
      aspectRatio: 1080 / 1350,
    ),
    CampaignCard(
      id: 'final',
      title: LocalizedText({'en': 'The system', 'de': 'Das System'}),
      imageAsset: '$_stills/hb_card_final.jpg',
      aspectRatio: 1080 / 1350,
    ),
  ];

  /// The original CureBase product photograph, cut out — the same file the
  /// films are built from, which is the whole point of the principle stage:
  /// left and right show one image, not two renderings.
  static const productCutout = '$_stills/hb_curebase_product.png';

  /// Delivery shapes, drawn to scale.
  static const List<OutputFormat> formats = [
    OutputFormat(
      '9:16',
      9 / 16,
      LocalizedText({'en': 'Stories, Reels, TikTok', 'de': 'Stories, Reels, TikTok'}),
    ),
    OutputFormat(
      '4:5',
      4 / 5,
      LocalizedText({'en': 'Feed posts, campaign cards', 'de': 'Feed-Posts, Kampagnenkarten'}),
    ),
    OutputFormat(
      '1:1',
      1,
      LocalizedText({'en': 'Ads, messengers', 'de': 'Anzeigen, Messenger'}),
    ),
    OutputFormat(
      '16:9',
      16 / 9,
      LocalizedText({'en': 'Website heroes, presentations', 'de': 'Website-Heros, Präsentationen'}),
    ),
  ];
}
