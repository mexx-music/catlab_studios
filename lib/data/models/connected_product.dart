import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/data/models/app_link.dart';

/// A physical product that has software from the portfolio attached to it.
///
/// Deliberately separate from [AppProject]: a pillow is not an app, and
/// forcing it into the portfolio grid would give it a status, a platform row
/// and a category it has no meaning for. Connected products get their own
/// small section instead.
///
/// AI-hint: Keep this list short. It exists to show that the studio also
/// builds things you can hold — not as a second portfolio.
class ConnectedProduct {
  const ConnectedProduct({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageAsset,
    this.secondaryImageAsset,
    this.highlights = const [],
    this.links = const [],
    this.companionAppId,
    this.companionAppNote,
  });

  final String id;
  final String name;

  /// One warm line, shown under the name.
  final LocalizedText tagline;

  /// Two or three sentences. Only claims backed by the product's own site or
  /// its source project — no invented capabilities.
  final LocalizedText description;

  /// The main product shot.
  final String imageAsset;

  /// Optional second shot, layered smaller in front of [imageAsset].
  final String? secondaryImageAsset;

  final List<LocalizedText> highlights;
  final List<AppLink> links;

  /// Id of the [AppProject] that belongs to this product, so the section can
  /// open that app's detail sheet directly.
  final String? companionAppId;

  /// How the app relates to the product, in the product's own terms.
  final LocalizedText? companionAppNote;

  bool get hasCompanionApp => companionAppId != null;
}
