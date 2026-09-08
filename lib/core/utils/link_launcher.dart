import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens verified outbound links in a new tab / the platform browser.
///
/// Failures are swallowed on purpose: a link that will not open should not
/// throw into the widget tree of a marketing site.
/// AI-hint: Route analytics through here if link tracking is ever added.
abstract final class LinkLauncher {
  /// Test seam: lets a test observe the URL that would be opened instead of
  /// handing it to the platform. Null in production.
  @visibleForTesting
  static Future<void> Function(String url)? debugOverrideOpen;

  static Future<void> open(String url) async {
    final override = debugOverrideOpen;
    if (override != null) {
      await override(url);
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error) {
      debugPrint('Could not open $url: $error');
    }
  }
}
