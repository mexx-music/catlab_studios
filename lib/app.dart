import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/l10n/app_locales.dart';
import 'core/l10n/locale_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';

/// Root widget of the CatLab Studios app.
///
/// Holds the language the site is being read in. A visitor arrives in their
/// browser's language when the site is published in it, and the switcher in
/// the hero pins a different one for the rest of the visit.
/// AI-hint: Add go_router or named routes here when navigation grows.
class CatLabApp extends StatefulWidget {
  const CatLabApp({super.key});

  @override
  State<CatLabApp> createState() => _CatLabAppState();
}

class _CatLabAppState extends State<CatLabApp> {
  final LocaleController _locale = LocaleController();

  @override
  void dispose() {
    _locale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      notifier: _locale,
      child: AnimatedBuilder(
        animation: _locale,
        builder: (context, _) => MaterialApp(
          title: 'CatLab Studios',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          // Null until the visitor picks one, which is what lets the browser
          // language win by default.
          locale: _locale.override,
          supportedLocales: AppLocales.supported,
          localeResolutionCallback: AppLocales.resolve,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomePage(),
        ),
      ),
    );
  }
}
