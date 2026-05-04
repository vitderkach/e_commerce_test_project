package com.example.e_commerce_test_project

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.*

class PaymentService : Service() {
    private val channelId = "payment_channel"
    private val notificationId = 101
    private val serviceScope = CoroutineScope(Dispatchers.Default + Job())

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notificationBuilder = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Processing Payment")
            .setContentText("Please wait while we process your request...")
            .setSmallIcon(android.R.drawable.ic_menu_save)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setProgress(100, 0, false)

        // Start as foreground service
        startForeground(notificationId, notificationBuilder.build())

        serviceScope.launch {
            for (progress in 0..100 step 10) {
                delay(800)
                notificationBuilder.setProgress(100, progress, false)
                val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                manager.notify(notificationId, notificationBuilder.build())
            }

            // Final notification
            val finalNotification = NotificationCompat.Builder(this@PaymentService, channelId)
                .setContentTitle("Payment Successful")
                .setContentText("Your mock item has been purchased.")
                .setSmallIcon(android.R.drawable.ic_menu_save)
                .setOngoing(false)
                .setProgress(0, 0, false)
                .build()

            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.notify(notificationId, finalNotification)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_DETACH);
            } else {
                stopForeground(false);
            }
            stopSelf()
        }

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        serviceScope.cancel()
        super.onDestroy()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Payment Processing Channel"
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(channelId, name, importance)
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }
}
