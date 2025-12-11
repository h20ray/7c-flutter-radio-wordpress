package com.tujuhcahaya.wprs.widget

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.unit.ColorProvider
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File

/**
 * TamTama Home Screen Widget Receiver
 * 
 * Displays the virtual pet sprite on a beautiful background.
 * Tap to open the app.
 */
class TamtamaWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = TamtamaWidget()
}

class TamtamaWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        // Read widget data from home_widget SharedPreferences (set by Flutter)
        val prefs = HomeWidgetPlugin.getData(context)
        val spritePath = prefs.getString("sprite_path", null)

        provideContent {
            GlanceTheme {
                TamtamaWidgetContent(
                    context = context,
                    spritePath = spritePath,
                )
            }
        }
    }
}

@Composable
private fun TamtamaWidgetContent(
    context: Context,
    spritePath: String?,
) {
    // M3 Expressive background color (soft purple)
    val backgroundColor = Color(0xFFE8DEF8)
    
    Box(
        modifier = GlanceModifier
            .fillMaxSize()
            .cornerRadius(28.dp)
            .background(ColorProvider(backgroundColor))
            .clickable(onClick = actionLaunchApp(context))
            .padding(16.dp),
        contentAlignment = Alignment.Center,
    ) {
        // Pet Sprite - centered and prominent
        if (spritePath != null && File(spritePath).exists()) {
            val bitmap = BitmapFactory.decodeFile(spritePath)
            if (bitmap != null) {
                Image(
                    provider = ImageProvider(bitmap),
                    contentDescription = "TamTama pet",
                    modifier = GlanceModifier.fillMaxSize(),
                )
            } else {
                DefaultPetIcon()
            }
        } else {
            DefaultPetIcon()
        }
    }
}

@Composable
private fun DefaultPetIcon() {
    Text(
        text = "🥚",
        style = TextStyle(
            fontSize = 64.sp,
        ),
    )
}

/**
 * Create an action to launch the main app home
 */
private fun actionLaunchApp(context: Context): androidx.glance.action.Action {
    val intent = Intent(Intent.ACTION_MAIN).apply {
        component = ComponentName(
            context.packageName,
            "com.tujuhcahaya.wprs.MainActivity"
        )
        addCategory(Intent.CATEGORY_LAUNCHER)
        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
    }
    return actionStartActivity(intent)
}
