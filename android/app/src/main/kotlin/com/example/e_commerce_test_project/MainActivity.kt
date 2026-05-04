package com.example.e_commerce_test_project

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.display.DisplayManager
import android.os.Build
import android.view.Display
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.e_commerce_test_project/security"
    private val mainScope = CoroutineScope(Dispatchers.Main + Job())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isRooted" -> {
                    mainScope.launch {
                        val isRooted = withContext(Dispatchers.IO) { isRooted() }
                        result.success(isRooted)
                    }
                }
                "isScreenRecording" -> {
                    mainScope.launch {
                        val isRecording = withContext(Dispatchers.IO) { isScreenRecording(this@MainActivity) }
                        result.success(isRecording)
                    }
                }
                "setSecureFlag" -> {
                    val enable = call.argument<Boolean>("enable") ?: false
                    setSecureFlag(enable)
                    result.success(null)
                }
                "startPayment" -> {
                    startPaymentService()
                    result.success(null)
                }
                "requestNotificationPermission" -> {
                    requestNotificationPermission()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        mainScope.cancel()
        super.onDestroy()
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (this.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                this.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 101)
            }
        }
    }

    private fun startPaymentService() {
        val intent = Intent(this, PaymentService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            this.startForegroundService(intent)
        } else {
            this.startService(intent)
        }
    }

    private fun setSecureFlag(enable: Boolean) {
        if (enable) {
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
    }

    private fun isRooted(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su"
        )
        for (path in paths) {
            if (File(path).exists()) return true
        }
        val buildTags = Build.TAGS
        if (buildTags != null && buildTags.contains("test-keys")) return true
        return false
    }

    private fun isScreenRecording(context: Context): Boolean {
        val displayManager = context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        
        // Check for presentation displays (common for HDMI/Cast)
        val displays = displayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)
        if (displays.isNotEmpty()) {
            return true
        }
        
        // Check for virtual displays (common for screen recorders)
        val allDisplays = displayManager.displays
        for (display in allDisplays) {
            if (display.displayId != Display.DEFAULT_DISPLAY) {
                return true
            }
        }
        return false
    }
}
