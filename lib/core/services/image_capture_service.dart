import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
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

  Future<File?> captureWidgetToStickerFile(
    GlobalKey key, {
    double? pixelRatio,
    int? maxWaitAttempts,
    int? waitDelayMs,
    int? initialDelayMs,
    int? finalDelayMs,
    String? fileNamePrefix,
  }) async {
    try {
      await SchedulerBinding.instance.endOfFrame;
      
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
        await SchedulerBinding.instance.endOfFrame;
        await Future.delayed(Duration(milliseconds: delayMs));
        attempts++;
      }

      if (boundary.debugNeedsPaint) {
        debugPrint('ImageCaptureService: Widget still needs paint after max attempts');
        await SchedulerBinding.instance.endOfFrame;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (finalDelayMs != null && finalDelayMs > 0) {
        await Future.delayed(Duration(milliseconds: finalDelayMs));
      }

      final effectivePixelRatio = pixelRatio ?? ShareConstants.stickerPixelRatio;
      final image = await boundary.toImage(pixelRatio: effectivePixelRatio);
      
      final imageWidth = image.width.toDouble();
      final imageHeight = image.height.toDouble();
      
      // Target dimensions at the pixel ratio scale
      final targetWidth = ShareConstants.stickerWidth * effectivePixelRatio;
      final targetHeight = ShareConstants.stickerHeight * effectivePixelRatio;
      
      // Calculate crop to center the target aspect ratio
      const targetAspectRatio = ShareConstants.stickerAspectRatio;
      final imageAspectRatio = imageWidth / imageHeight;
      
      double cropWidth, cropHeight, cropX, cropY;
      
      if (imageAspectRatio > targetAspectRatio) {
        // Image is wider than target - fit to height
        cropHeight = imageHeight;
        cropWidth = cropHeight * targetAspectRatio;
        cropX = (imageWidth - cropWidth) / 2;
        cropY = 0;
      } else {
        // Image is taller than target - fit to width
        cropWidth = imageWidth;
        cropHeight = cropWidth / targetAspectRatio;
        cropX = 0;
        cropY = (imageHeight - cropHeight) / 2;
      }
      
      // Ensure we don't exceed image bounds
      cropWidth = cropWidth.clamp(0, imageWidth);
      cropHeight = cropHeight.clamp(0, imageHeight);
      cropX = cropX.clamp(0, imageWidth - cropWidth);
      cropY = cropY.clamp(0, imageHeight - cropHeight);
      
      final croppedImage = await _cropImage(
        image,
        cropX.toInt(),
        cropY.toInt(),
        cropWidth.toInt(),
        cropHeight.toInt(),
      );
      
      // Resize to exact target dimensions if needed
      final finalImage = croppedImage.width != targetWidth.toInt() || 
                         croppedImage.height != targetHeight.toInt()
          ? await _resizeImage(croppedImage, targetWidth.toInt(), targetHeight.toInt())
          : croppedImage;
      
      final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) {
        debugPrint('ImageCaptureService: Could not generate PNG bytes');
        return null;
      }

      final directory = await getTemporaryDirectory();
      final prefix = fileNamePrefix ?? 'sticker';
      final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e, stackTrace) {
      debugPrint('ImageCaptureService: Error capturing sticker: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<ui.Image> _cropImage(
    ui.Image image,
    int x,
    int y,
    int width,
    int height,
  ) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(x.toDouble(), y.toDouble(), width.toDouble(), height.toDouble()),
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint(),
    );
    
    final picture = pictureRecorder.endRecording();
    return await picture.toImage(width, height);
  }

  Future<ui.Image> _resizeImage(
    ui.Image image,
    int targetWidth,
    int targetHeight,
  ) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      Paint()..filterQuality = FilterQuality.high,
    );
    
    final picture = pictureRecorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
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

