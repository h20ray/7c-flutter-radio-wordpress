import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/presentation/dialogs/share_preview_dialog.dart';
import '../radio_quote_share_card.dart';

/// Dialog displaying a daily quote with share functionality.
///
/// This dialog is shown when the user taps on the greeting chip.
/// It displays the quote share card preview with options to share.
class RadioQuoteDialog extends StatelessWidget {
  final String quote;
  final String? albumArtUrl;

  const RadioQuoteDialog({
    super.key,
    required this.quote,
    this.albumArtUrl,
  });

  /// Shows the quote dialog.
  static Future<void> show({
    required BuildContext context,
    required String quote,
    String? albumArtUrl,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => RadioQuoteDialog(
        quote: quote,
        albumArtUrl: albumArtUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SharePreviewDialog(
      previewWidget: RadioQuoteShareCard(
        quote: quote,
        albumArtUrl: albumArtUrl,
      ),
      shareText: quote,
      shareSubject: 'share_quote_subject'.tr(),
      aspectRatio: 9 / 16,
    );
  }
}
