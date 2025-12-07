import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/share_constants.dart';

class ImageCaptureService {
  Future<File?> captureWidgetToFile(
    GlobalKey key, {
    double? pixelRatio,
    int? maxWaitAttempts,
    int? waitDelayMs,
    int? initialDelayMs,
    int? finalDelayMs,
    String? fileNamePrefix,
  }) async {
    try {
      if (initialDelayMs != null && initialDelayMs > 0) {
        await Future.delayed(Duration(milliseconds: initialDelayMs));
      }

      final boundary = key.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('ImageCaptureService: Could not find render boundary');
        return null;
      }

      final maxAttempts = maxWaitAttempts ?? ShareConstants.maxPaintWaitAttempts;
      final delayMs = waitDelayMs ?? ShareConstants.paintWaitDelayMs;
      int attempts = 0;
      while (boundary.debugNeedsPaint && attempts < maxAttempts) {
        await Future.delayed(Duration(milliseconds: delayMs));
        attempts++;
      }

      if (finalDelayMs != null && finalDelayMs > 0) {
        await Future.delayed(Duration(milliseconds: finalDelayMs));
      }

      final effectivePixelRatio = pixelRatio ?? ShareConstants.defaultPixelRatio;
      final image = await boundary.toImage(pixelRatio: effectivePixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) {
        debugPrint('ImageCaptureService: Could not generate PNG bytes');
        return null;
      }

      final directory = await getTemporaryDirectory();
      final prefix = fileNamePrefix ?? 'share';
      final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e, stackTrace) {
      debugPrint('ImageCaptureService: Error capturing widget: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> captureAndShare({
    required GlobalKey key,
    required String text,
    String? subject,
    double? pixelRatio,
    int? maxWaitAttempts,
    int? waitDelayMs,
    int? initialDelayMs,
    int? finalDelayMs,
  }) async {
    final file = await captureWidgetToFile(
      key,
      pixelRatio: pixelRatio,
      maxWaitAttempts: maxWaitAttempts,
      waitDelayMs: waitDelayMs,
      initialDelayMs: initialDelayMs,
      finalDelayMs: finalDelayMs,
    );

    if (file == null) {
      throw Exception('Failed to capture image');
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: text,
        subject: subject,
      ),
    );
  }

  double getOptimalPixelRatio(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return devicePixelRatio
        .clamp(
          ShareConstants.minPixelRatio,
          ShareConstants.maxPixelRatio,
        )
        .toDouble();
  }
}

