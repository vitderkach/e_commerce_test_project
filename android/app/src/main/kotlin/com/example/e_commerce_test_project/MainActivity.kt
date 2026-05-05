package com.example.e_commerce_test_project

import com.example.e_commerce_test_project.handlers.PermissionHandler
import com.example.e_commerce_test_project.handlers.PaymentHandler
import com.example.e_commerce_test_project.handlers.SecurityHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var securityHandler: SecurityHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        securityHandler = SecurityHandler(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.e_commerce_test_project/security")
            .setMethodCallHandler(securityHandler)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.e_commerce_test_project/permissions")
            .setMethodCallHandler(PermissionHandler(this))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.e_commerce_test_project/payments")
            .setMethodCallHandler(PaymentHandler(this))
    }

    override fun onDestroy() {
        securityHandler?.dispose()
        super.onDestroy()
    }
}
