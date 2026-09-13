import 'package:flutter/material.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/core/l10n/site_text.dart';
import 'package:catlab_studios/data/models/connected_product.dart';
import 'package:catlab_studios/data/repositories/app_projects_repository.dart';
import 'package:catlab_studios/data/repositories/connected_products_repository.dart';
import 'package:catlab_studios/shared/widgets/app_detail_sheet.dart';
import 'package:catlab_studios/shared/widgets/link_button.dart';
import 'package:catlab_studios/shared/widgets/section_container.dart';

/// Physical products with studio software attached.
///
/// Sits directly under the portfolio because it is the same story continued —
/// but it uses a wide two-column card rather than the app grid, so a pillow is
/// never mistaken for the fifteenth app. Warmer accents, same tokens.
/// AI-hint: One product today. If this ever grows past three, revisit the
/// layout rather than stacking wide cards forever.
class ConnectedProductsSection extends StatelessWidget {
  const ConnectedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.sizeOf(context).width < 640;
    final products = ConnectedProductsRepository.all;

    if (products.isEmpty) return const SizedBox.shrink();

    return SectionContainer(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 20 : 24,
        vertical: isNarrow ? 64 : 96,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t(SiteText.connectedTitle),
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: isNarrow ? 30 : 40,
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              context.t(SiteText.connectedIntro),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: isNarrow ? 32 : 44),
          for (final product in products)
            _ProductCard(product: product, isNarrow: isNarrow),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wide product card — image beside copy on desktop, stacked on phones
// ---------------------------------------------------------------------------
class _ProductCard extends StatefulWidget {
  const _ProductCard({required this.product, required this.isNarrow});

  final ConnectedProduct product;
  final bool isNarrow;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;

  void _openCompanionApp() {
    final id = widget.product.companionAppId;
    if (id == null) return;
    final app = AppProjectsRepository.all.where((a) => a.id == id).firstOrNull;
    if (app == null) return;
    AppDetailSheet.show(context, app);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isNarrow = widget.isNarrow;

    final visual = _ProductVisual(product: product, hovered: _hovered);
    final copy = _ProductCopy(
      product: product,
      isNarrow: isNarrow,
      onOpenCompanionApp: product.hasCompanionApp ? _openCompanionApp : null,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(isNarrow ? 22 : 32),
        decoration: BoxDecoration(
          // A touch warmer than the app cards, without leaving the palette.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              Color.alphaBlend(
                AppColors.accent.withAlpha(_hovered ? 18 : 10),
                AppColors.surface,
              ),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withAlpha(110)
                : AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_hovered ? 70 : 40),
              blurRadius: _hovered ? 32 : 14,
              offset: const Offset(0, 10),
            ),
            if (_hovered)
              BoxShadow(
                color: AppColors.accent.withAlpha(30),
                blurRadius: 40,
                spreadRadius: -8,
                offset: const Offset(0, 14),
              ),
          ],
        ),
        child: isNarrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 210, child: visual),
                  const SizedBox(height: 24),
                  copy,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 300, height: 250, child: visual),
                  const SizedBox(width: 40),
                  Expanded(child: copy),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pillow with the module layered in front — the product is two things
// ---------------------------------------------------------------------------
class _ProductVisual extends StatelessWidget {
  const _ProductVisual({required this.product, required this.hovered});

  final ConnectedProduct product;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Warm halo, so a cut-out product does not float on flat navy.
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            width: hovered ? 250 : 235,
            height: hovered ? 250 : 235,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withAlpha(hovered ? 40 : 26),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            scale: hovered ? 1.04 : 1.0,
            child: Image.asset(
              product.imageAsset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        if (product.secondaryImageAsset != null)
          Positioned(
            right: 4,
            bottom: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              offset: hovered ? const Offset(0, -0.06) : Offset.zero,
              child: Image.asset(
                product.secondaryImageAsset!,
                height: 84,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Name, tagline, description, highlights, companion app and the product link
// ---------------------------------------------------------------------------
class _ProductCopy extends StatelessWidget {
  const _ProductCopy({
    required this.product,
    required this.isNarrow,
    this.onOpenCompanionApp,
  });

  final ConnectedProduct product;
  final bool isNarrow;
  final VoidCallback? onOpenCompanionApp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.name,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isNarrow ? 24 : 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.t(product.tagline),
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          context.t(product.description),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.5,
            height: 1.65,
          ),
        ),
        if (product.highlights.isNotEmpty) ...[
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final highlight in product.highlights)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background.withAlpha(140),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text(
                    context.t(highlight),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final link in product.links)
              LinkButton(link: link, filled: true, useLongLabel: true),
            if (onOpenCompanionApp != null)
              _CompanionAppChip(
                note: context.t(
                  product.companionAppNote ?? SiteText.connectedCompanionApp,
                ),
                onTap: onOpenCompanionApp!,
              ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Opens the companion app's own detail sheet, so the link goes both ways
// ---------------------------------------------------------------------------
class _CompanionAppChip extends StatelessWidget {
  const _CompanionAppChip({required this.note, required this.onTap});

  final String note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.pets_rounded, size: 16),
      label: Text(note),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        backgroundColor: AppColors.background.withAlpha(120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
    );
  }
}
