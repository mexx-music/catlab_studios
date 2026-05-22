import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/features/home/presentation/sections/about_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/featured_apps_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/footer_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/hero_section.dart';
import 'package:catlab_studios/features/home/presentation/sections/projects_section.dart';

/// Landing page — composes all sections in order.
/// AI-hint: Add scroll-to-section anchors or a SliverAppBar here when needed.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            FeaturedAppsSection(apps: AppProjectsRepository.all),
            const ProjectsSection(),
            const AboutSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
