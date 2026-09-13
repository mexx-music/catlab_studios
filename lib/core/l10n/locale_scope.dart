import 'package:flutter/widgets.dart';

import 'package:catlab_studios/core/l10n/app_locales.dart';

/// Holds the language the visitor is reading the site in.
///
/// Null means "follow the browser", which is the starting state: a visitor
/// with a German browser gets German without touching anything. Choosing a
/// language in the switcher pins it for the rest of the visit.
class LocaleController extends ChangeNotifier {
  Locale? _override;

  /// Null while the browser's own language is being followed.
  Locale? get override => _override;

  bool isActive(Locale locale, Locale effective) =>
      locale.languageCode == effective.languageCode;

  void select(Locale locale) {
    if (!AppLocales.isSupported(locale)) return;
    if (_override?.languageCode == locale.languageCode) return;
    _override = locale;
    notifyListeners();
  }
}

/// Makes the [LocaleController] reachable from the switcher without threading
/// a callback through every section.
class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController super.notifier,
    required super.child,
  });

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'No LocaleScope above this widget');
    return scope!.notifier!;
  }
}
