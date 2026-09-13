import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/data/models/app_link.dart';
import 'package:catlab_studios/data/models/connected_product.dart';

/// Physical products the studio has software attached to.
///
/// Same rule as the app portfolio: nothing here is claimed unless the
/// product's own site or its source project backs it up.
///
/// Note on SchnurrPurr and Bluetooth: the product site describes pairing the
/// module over Bluetooth, and the module is a Bluetooth audio device. The
/// PurrLove app itself has no Bluetooth capability — no BLE dependency, no
/// Bluetooth permission, and its entitlement service documents module
/// detection as "Phase 2", still unimplemented. So the copy below stops at
/// what the product is, and never claims the app connects to or controls it.
abstract final class ConnectedProductsRepository {
  static const _imagePath = 'assets/images/products';

  static const List<ConnectedProduct> all = [
    ConnectedProduct(
      id: 'schnurrpurr',
      name: 'SchnurrPurr',
      tagline: LocalizedText({
        'en': 'A purr you can actually hold.',
        'de': 'Ein Schnurren, das man wirklich halten kann.',
      }),
      description: LocalizedText({
        'en':
            'A soft pillow with a hidden pocket, and a small purr module that '
            'slips inside it — sound, gentle vibration and something to hug, in '
            'one object. PurrLove is the app that belongs to the set.',
        'de':
            'Ein weiches Kissen mit verborgener Tasche und ein kleines Schnurrmodul, das hineingleitet — Klang, sanfte Vibration und etwas zum Kuscheln in einem Objekt. PurrLove ist die App, die zum Set gehört.',
      }),
      imageAsset: '$_imagePath/schnurrpurr_pillow.png',
      secondaryImageAsset: '$_imagePath/schnurrpurr_module.png',
      highlights: [
        LocalizedText({
          'en': 'Plush pillow with a hidden module pocket',
          'de': 'Plüschkissen mit verborgener Modultasche',
        }),
        LocalizedText({
          'en': 'Rechargeable module, tuned to the 25–150 Hz purr range',
          'de':
              'Wiederaufladbares Modul, abgestimmt auf den Schnurrbereich von 25–150 Hz',
        }),
        LocalizedText({
          'en': 'Slips into any pillow with a pocket',
          'de': 'Passt in jedes Kissen mit Tasche',
        }),
      ],
      links: [
        AppLink(
          kind: AppLinkKind.external,
          url: 'https://schnurrpurr.com',
          label: LocalizedText({
            'en': 'Discover SchnurrPurr',
            'de': 'SchnurrPurr entdecken',
          }),
          longLabel: LocalizedText({
            'en': 'Discover SchnurrPurr',
            'de': 'SchnurrPurr entdecken',
          }),
        ),
      ],
      companionAppId: 'purrlove',
      companionAppNote: LocalizedText({
        'en': 'Companion app: PurrLove',
        'de': 'Passende App: PurrLove',
      }),
    ),
  ];
}
