import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';

/// Root widget of the CatLab Studios app.
/// AI-hint: Add go_router or named routes here when navigation grows.
class CatLabApp extends StatelessWidget {
  const CatLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatLab Studios',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}
