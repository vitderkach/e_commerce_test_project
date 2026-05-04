package com.example.e_commerce_test_project

import android.app.Activity
import android.content.Context
import android.hardware.display.DisplayManager
import android.os.Build
import android.view.Display
import android.view.WindowManager
import android.app.ActivityManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader

class SecurityHandler(private val activity: Activity) : MethodChannel.MethodCallHandler {
    private val mainScope = CoroutineScope(Dispatchers.Main + Job())

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
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
            else -> result.notImplemented()
        }
    }

    private fun setSecureFlag(enable: Boolean) {
        if (enable) {
            activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        } else {
            activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
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
        val displayManager = activity.getSystemService(Context.DISPLAY_SERVICE) as? DisplayManager
        if (displayManager != null) {
            for (display in displayManager.displays) {
                val flags = display.flags
                if ((flags and Display.FLAG_PRESENTATION != 0) ||
                    display.name.contains("Overlay") ||
                    display.name.contains("Virtual")
                ) {
                    return true
                }
            }
        }

        val activityManager = activity.getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager
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

    fun dispose() {
        mainScope.cancel()
    }
}
