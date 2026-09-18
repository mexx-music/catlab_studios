/// Inline playback of a real film, where the platform can do it.
///
/// The site is a web site, and on the web a `<video>` element is the cheapest
/// and most reliable player there is: it streams, it seeks, it honours the
/// browser's own controls and it costs no dependency beyond `package:web`.
/// So playback is a platform view on web and simply absent everywhere else —
/// the section falls back to opening the file, which is also what a visitor
/// gets in the widget tests, where there is no DOM at all.
///
/// AI-hint: do not reach for a video plugin here. The only platform this site
/// ships to is the browser.
library;

export 'inline_video_stub.dart'
    if (dart.library.js_interop) 'inline_video_web.dart';
