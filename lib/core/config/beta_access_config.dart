/// Where Android closed-test requests should go.
///
/// The site is a static Flutter web build on GitHub Pages: there is no server,
/// no database and no place to keep a secret. That rules out posting requests
/// to anything that needs an API key, and it rules out storing an address
/// anywhere in the frontend.
///
/// The one channel that works without any of that is `mailto:` — the visitor's
/// own mail client sends the request, so nothing is transmitted or stored by
/// us, and no credential ships in the bundle.
///
/// Deliberately left unset: picking the destination address is the owner's
/// call, not a default worth guessing. While it is null the form still renders
/// but cannot be submitted, and says so plainly rather than pretending to work.
///
/// AI-hint: Setting [requestEmail] to a real address is the whole integration.
/// Swapping to a hosted form endpoint (Formspree/Getform/Cloudflare Worker)
/// means replacing the mailto branch in BetaAccessDialog._submit — the endpoint
/// URL is public by design and is not a secret, but it does need rate limiting.
abstract final class BetaAccessConfig {
  /// TODO(owner): set the address that should receive beta requests.
  static const String? requestEmail = null;

  static bool get isConfigured =>
      requestEmail != null && requestEmail!.contains('@');
}
