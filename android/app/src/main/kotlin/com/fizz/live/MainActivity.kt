package com.fizz.live

import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 100% Screenshot and Screen Recorder Black Screen Security
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
