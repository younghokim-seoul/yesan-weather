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
        val url = BuildConfig.SERVER_V1
        Log.d(this.javaClass.name, "url..." + url)
        val handler =
            MethodChannel.MethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
                if (methodCall.method == "getAppUrl") {
                    val url = BuildConfig.SERVER_V1
                    Log.d(this.javaClass.name, url)
                    result.success(BuildConfig.SERVER_V1)
                } else {
                    result.notImplemented()
                }
            }
        channel = MethodChannel(flutterEngine.dartExecutor, CHANNEL)

        channel!!.setMethodCallHandler(handler)
    }
}
