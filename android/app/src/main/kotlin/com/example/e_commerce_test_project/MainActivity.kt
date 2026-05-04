package com.example.e_commerce_test_project

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader
import kotlinx.coroutines.*
import android.app.ActivityManager
import android.hardware.display.DisplayManager
import android.view.Display

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
                        val isRecording = withContext(Dispatchers.IO) { isScreenRecording() }
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

    private fun startPaymentService() {
        val intent = Intent(this, PaymentService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            this.startForegroundService(intent)
        } else {
            this.startService(intent)
        }
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 101)
            }
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
        return (checkRootedFiles() || checkRootedProcesses() || checkTagsAndKeys())
    }

    private fun checkRootedFiles(): Boolean {
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
        return false
    }

    private fun checkRootedProcesses(): Boolean {
        var process: Process? = null
        return try {
            process = Runtime.getRuntime().exec(arrayOf("/system/xbin/which", "su"))
            val `in` = BufferedReader(InputStreamReader(process.inputStream))
            `in`.readLine() != null
        } catch (t: Throwable) {
            false
        } finally {
            process?.destroy()
        }
    }

    private fun checkTagsAndKeys(): Boolean {
        val buildTags = Build.TAGS
        return buildTags != null && buildTags.contains("test-keys")
    }

    private fun isScreenRecording(): Boolean {
        // Method 1: Check for virtual displays
        val displayManager = getSystemService(Context.DISPLAY_SERVICE) as? DisplayManager
        if (displayManager != null) {
            val displays = displayManager.displays
            for (display in displays) {
                val flags = display.flags
                if ((flags and Display.FLAG_PRESENTATION != 0) ||
                    display.name.contains("Overlay") || 
                    display.name.contains("Virtual")) {
                    return true
                }
            }
        }

        // Method 2:  Heuristic approach
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager
        if (activityManager != null) {
            val processes = activityManager.runningAppProcesses
            if (processes != null) {
                val knownRecorders = listOf("screenrecorder", "screen_record", "recorder")
                for (process in processes) {
                    for (recorder in knownRecorders) {
                        if (process.processName.contains(recorder, ignoreCase = true)) {
                            return true
                        }
                    }
                }
            }
        }

        return false
    }
}
