import 'package:flutter/material.dart';
import '../../../../core/widgets/app_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:math';
import '../../../../core/themes/component_tokens.dart';
import '../../domain/entities/radio_entity.dart';

class RadioBannerDisplay extends StatelessWidget {
  final List<RadioBanner> banners;

  const RadioBannerDisplay({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RadioBannerTokens.of(context);
    // If no banners configured, show placeholder
    if (banners.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: tokens.placeholderBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: tokens.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'No banners configured',
            style: TextStyle(
              color: tokens.placeholderText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    // Randomly select one banner
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final selectedBanner = banners[random.nextInt(banners.length)];

    return GestureDetector(
      onTap: () => _launchUrl(selectedBanner.targetUrl),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: tokens.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AppNetworkImage(
            imageUrl: selectedBanner.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: tokens.placeholderBackground,
            ),
            errorWidget: (context, url, error) => Container(
              color: tokens.placeholderBackground,
              child: Center(
                child: Icon(
                  LucideIcons.circle_alert,
                  color: tokens.placeholderText,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // Handle URL launch error silently
      // In a production app, you might want to show a toast or log the error
    }
  }
}

