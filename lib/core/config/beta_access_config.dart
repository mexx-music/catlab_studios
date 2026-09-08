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
/// This is a studio address on our own domain, published deliberately — it is
/// a contact address, not a credential, and no private account is exposed.
/// Blanking [requestEmail] disables the flow again: the form still renders but
/// cannot be submitted and says so, rather than pretending to work.
///
/// AI-hint: Setting [requestEmail] to a real address is the whole integration.
/// Swapping to a hosted form endpoint (Formspree/Getform/Cloudflare Worker)
/// means replacing the mailto branch in BetaAccessDialog._submit — the endpoint
/// URL is public by design and is not a secret, but it does need rate limiting.
abstract final class BetaAccessConfig {
  /// Receives Android closed-test requests. Set to '' to turn the flow off.
  static const String requestEmail = 'beta@catlabstudios.com';

  static bool get isConfigured => requestEmail.contains('@');
}
