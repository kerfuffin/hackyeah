package com.kerfuffin.achievo

import io.flutter.embedding.android.FlutterActivity
import android.view.View

// make window fullscreen

class MainActivity: FlutterActivity() {
    override fun onPostResume() {
        super.onPostResume()
        window.setFlags(android.view.WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, android.view.WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
    }
}