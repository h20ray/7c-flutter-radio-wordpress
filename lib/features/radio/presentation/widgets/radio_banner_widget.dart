import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../../domain/entities/radio_entity.dart';

class RadioBannerWidget extends StatelessWidget {
  final List<RadioBanner> banners;

  const RadioBannerWidget({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    // If no banners configured, show placeholder
    if (banners.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF625191),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No banners configured',
            style: TextStyle(
              color: Colors.white70,
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
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: CachedNetworkImage(
            imageUrl: selectedBanner.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: const Color(0xFF625191),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: const Color(0xFF625191),
              child: const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white70,
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

