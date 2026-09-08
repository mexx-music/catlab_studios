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
      tagline: 'A purr you can actually hold.',
      description:
          'A soft pillow with a hidden pocket, and a small purr module that '
          'slips inside it — sound, gentle vibration and something to hug, in '
          'one object. PurrLove is the app that belongs to the set.',
      imageAsset: '$_imagePath/schnurrpurr_pillow.png',
      secondaryImageAsset: '$_imagePath/schnurrpurr_module.png',
      highlights: [
        'Plush pillow with a hidden module pocket',
        'Rechargeable module, tuned to the 25–150 Hz purr range',
        'Slips into any pillow with a pocket',
      ],
      links: [
        AppLink(
          kind: AppLinkKind.external,
          url: 'https://schnurrpurr.com',
          label: 'Discover SchnurrPurr',
          longLabel: 'Discover SchnurrPurr',
        ),
      ],
      companionAppId: 'purrlove',
      companionAppNote: 'Companion app: PurrLove',
    ),
  ];
}
