import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/features/home/presentation/sections/about_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/capabilities_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/featured_apps_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/footer_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/hero_section.dart';

/// Landing page — composes all sections in order.
///
/// Section anchors are plain GlobalKeys rather than a router: the site is one
/// scroll surface, so the hero CTAs only need `ensureVisible`.
/// AI-hint: Add go_router here if real sub-pages are ever introduced.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _portfolioKey = GlobalKey();
  final _capabilitiesKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(
              onExploreApps: () => _scrollTo(_portfolioKey),
              onWhatWeBuild: () => _scrollTo(_capabilitiesKey),
            ),
            FeaturedAppsSection(
              key: _portfolioKey,
              apps: AppProjectsRepository.all,
            ),
            CapabilitiesSection(key: _capabilitiesKey),
            const AboutSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
