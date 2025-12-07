package com.tujuhcahaya.tujuhcahaya_wprs

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
                    if (imagePath != null) {
                        val shareResult = shareToInstagramStories(imagePath)
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

    private fun shareToInstagramStories(imagePath: String): String {
        return try {
            val imageFile = File(imagePath)
            if (!imageFile.exists()) {
                return "sharing_failed"
            }

            if (!isInstagramInstalled()) {
                return "instagram_not_installed"
            }

            val intent = Intent("com.instagram.share.ADD_TO_STORY").apply {
                setPackage(instagramPackageName)
                flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
                type = "image/png"
                
                val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    FileProvider.getUriForFile(
                        this@MainActivity,
                        "${applicationContext.packageName}.fileprovider",
                        imageFile
                    )
                } else {
                    Uri.fromFile(imageFile)
                }
                
                putExtra("interactive_asset_uri", uri)
                putExtra("content_url", "")
                putExtra("top_background_color", "#000000")
                putExtra("bottom_background_color", "#000000")
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
