package com.tujuhcahaya.wprs

import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "instagram_sticker_share"
    private val instagramPackageName = "com.instagram.android"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareToInstagramStories" -> {
                    val imagePath = call.argument<String>("imagePath")
                    val topColor = call.argument<String>("topBackgroundColor")
                    val bottomColor = call.argument<String>("bottomBackgroundColor")
                    
                    if (imagePath != null) {
                        val shareResult = shareToInstagramStories(imagePath, topColor, bottomColor)
                        result.success(shareResult)
                    } else {
                        result.error("invalid_argument", "Image path is required", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun shareToInstagramStories(
        imagePath: String,
        topColor: String?,
        bottomColor: String?
    ): String {
        return try {
            // Debug logging
            android.util.Log.d("InstagramShare", "Top color: $topColor, Bottom color: $bottomColor")
            
            val imageFile = File(imagePath)
            if (!imageFile.exists()) {
                return "sharing_failed"
            }

            if (!isInstagramInstalled()) {
                return "instagram_not_installed"
            }

            val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                FileProvider.getUriForFile(
                    this@MainActivity,
                    "${applicationContext.packageName}.fileprovider",
                    imageFile
                )
            } else {
                Uri.fromFile(imageFile)
            }

            grantUriPermission(
                instagramPackageName,
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )

            val intent = Intent("com.instagram.share.ADD_TO_STORY").apply {
                setPackage(instagramPackageName)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                type = "image/png"
                
                // Use interactive_asset_uri for sticker (movable/resizable)
                putExtra("interactive_asset_uri", uri)
                
                // IMPORTANT: source_application (Facebook App ID) is REQUIRED for background colors to work
                // Without this, Instagram ignores the background color parameters
                // You can use any valid Facebook App ID or your own if you have one
                putExtra("source_application", applicationContext.packageName)
                
                // Set gradient background colors from palette
                // NOTE: Colors must be hex format like "#RRGGBB"
                if (topColor != null) {
                    android.util.Log.d("InstagramShare", "Setting top_background_color: $topColor")
                    putExtra("top_background_color", topColor)
                }
                if (bottomColor != null) {
                    android.util.Log.d("InstagramShare", "Setting bottom_background_color: $bottomColor")
                    putExtra("bottom_background_color", bottomColor)
                }
            }

            if (intent.resolveActivity(packageManager) != null) {
                startActivity(intent)
                "success"
            } else {
                "instagram_not_installed"
            }
        } catch (e: Exception) {
            e.printStackTrace()
            "sharing_failed"
        }
    }

    private fun isInstagramInstalled(): Boolean {
        return try {
            packageManager.getPackageInfo(instagramPackageName, 0)
            true
        } catch (e: Exception) {
            false
        }
    }
}

