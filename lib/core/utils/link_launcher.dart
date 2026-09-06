import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens verified outbound links in a new tab / the platform browser.
///
/// Failures are swallowed on purpose: a link that will not open should not
/// throw into the widget tree of a marketing site.
/// AI-hint: Route analytics through here if link tracking is ever added.
abstract final class LinkLauncher {
  static Future<void> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error) {
      debugPrint('Could not open $url: $error');
    }
  }
}
