import 'package:flutter/material.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/data/models/app_category.dart';
import 'package:catlab_studios/data/models/app_link.dart';
import 'package:catlab_studios/data/models/app_platform.dart';
import 'package:catlab_studios/data/models/app_status.dart';

/// A single app or project shown in the studio portfolio.
///
/// Everything here is meant to be verifiable. [iconAsset] is null when no real
/// app icon exists yet, in which case the card falls back to [icon] on a CatLab
/// gradient tile. [links] is empty when nothing public exists to link to.
/// AI-hint: Add `screenshots` here once real screenshots exist; the detail
/// sheet already leaves room for them.
class AppProject {
  const AppProject({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.category,
    required this.categoryLabel,
    required this.status,
    this.iconAsset,
    this.platforms = const [],
    this.platformStages = const {},
    this.links = const [],
    this.highlights = const [],
    this.companionProductNote,
    this.featured = false,
  });

  /// Stable slug — also used as the asset file name under app_icons/.
  final String id;

  final String name;

  /// One line, shown on the card.
  final LocalizedText tagline;

  /// Two or three sentences, shown in the detail sheet.
  final LocalizedText description;

  /// Fallback glyph used when [iconAsset] is null.
  final IconData icon;

  /// Real app icon, e.g. `assets/images/app_icons/hb_cure.png`.
  final String? iconAsset;

  /// Filter bucket.
  final AppCategory category;

  /// Richer display label, e.g. 'Health · Device Control'.
  final LocalizedText categoryLabel;

  final AppStatus status;
  final List<AppPlatform> platforms;

  /// Per-platform release stage, for projects that are further along on one
  /// platform than another (live on iOS, closed beta on Android). Platforms
  /// absent from this map inherit the project's overall [status].
  final Map<AppPlatform, PlatformStage> platformStages;
  final List<AppLink> links;

  /// Short factual bullets for the detail sheet.
  final List<LocalizedText> highlights;

  /// Set only where a physical product from [ConnectedProductsRepository]
  /// belongs to this app, so the detail sheet can name that relationship.
  final LocalizedText? companionProductNote;

  /// Gets a larger card in the portfolio grid.
  final bool featured;

  bool get hasIconAsset => iconAsset != null;
  bool get hasLinks => links.isNotEmpty;

  /// True when any platform is in closed testing, which is what puts the
  /// beta-access action on the detail sheet.
  bool get hasBetaPlatform =>
      platformStages.values.contains(PlatformStage.beta);

  /// The link a card's primary button should follow, if any.
  /// Prefers a store listing over a web build.
  AppLink? get primaryLink {
    if (links.isEmpty) return null;
    for (final kind in AppLinkKind.values) {
      for (final link in links) {
        if (link.kind == kind) return link;
      }
    }
    return links.first;
  }
}
