import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "instagram_sticker_share",
      binaryMessenger: controller.binaryMessenger
    )
    
    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard call.method == "shareToInstagramStories" else {
        result(FlutterMethodNotImplemented)
        return
      }
      
      guard let args = call.arguments as? [String: Any],
            let imagePath = args["imagePath"] as? String else {
        result(FlutterError(
          code: "invalid_argument",
          message: "Image path is required",
          details: nil
        ))
        return
      }
      
      self?.shareToInstagramStories(imagePath: imagePath, result: result)
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func shareToInstagramStories(imagePath: String, result: @escaping FlutterResult) {
    guard let imageUrl = URL(string: "file://\(imagePath)"),
          let imageData = try? Data(contentsOf: imageUrl) else {
      result("sharing_failed")
      return
    }
    
    guard let instagramUrl = URL(string: "instagram-stories://share") else {
      result("sharing_failed")
      return
    }
    
    guard UIApplication.shared.canOpenURL(instagramUrl) else {
      result("instagram_not_installed")
      return
    }
    
    let pasteboard = UIPasteboard(name: UIPasteboard.Name(rawValue: "com.instagram.sharedSticker"), create: true) ?? UIPasteboard.general
    pasteboard.setData(imageData, forPasteboardType: "public.png")
    
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(instagramUrl, options: [:]) { success in
        DispatchQueue.main.async {
          if success {
            result("success")
          } else {
            result("sharing_failed")
          }
        }
      }
    } else {
      let opened = UIApplication.shared.openURL(instagramUrl)
      result(opened ? "success" : "sharing_failed")
    }
  }
}
