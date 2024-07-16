package com.smart.cctv

import android.util.Log

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.smart.cctv"
    private var channel: MethodChannel? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val handler = MethodChannel.MethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
                if (methodCall.method == "getAppUrl") {
                    result.success(BuildConfig.SERVER_URL + "," + BuildConfig.SERVER_CCTV)
                } else {
                    result.notImplemented()
                }
            }
        channel = MethodChannel(flutterEngine.dartExecutor, CHANNEL)

        channel!!.setMethodCallHandler(handler)
    }
}
