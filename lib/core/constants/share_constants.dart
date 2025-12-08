class ShareConstants {
  static const double defaultPixelRatio = 3.0;
  static const double minPixelRatio = 1.0;
  static const double maxPixelRatio = 3.0;
  static const int maxPaintWaitAttempts = 20;
  static const int paintWaitDelayMs = 50;
  static const int initialCaptureDelayMs = 200;
  static const int finalCaptureDelayMs = 200;
  static const int snackBarDurationSeconds = 2;
  
  // Regular share (stories) - 9:16
  static const double regularShareWidth = 720.0;
  static const double regularShareHeight = 1280.0;
  static const double regularShareAspectRatio = regularShareWidth / regularShareHeight; // 0.5625
  static const double regularSharePixelRatio = 2.0; // yields 1440x2560

  static const double stickerWidth = 500.0;
  static const double stickerHeight = 615.0;
  static const double stickerAspectRatio = 500.0 / 615.0; // ~0.813
  static const double stickerPixelRatio = 3.0;
}

