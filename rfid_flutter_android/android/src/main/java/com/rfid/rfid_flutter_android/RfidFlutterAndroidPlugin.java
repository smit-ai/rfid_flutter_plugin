package com.rfid.rfid_flutter_android;

import android.content.Context;

import androidx.annotation.NonNull;

import com.rfid.rfid_flutter_android.channel.DeviceInfoChannelHandler;
import com.rfid.rfid_flutter_android.channel.UARTChannelHandler;
import com.rfid.rfid_flutter_android.channel.UARTEventHandler;
import com.rfid.rfid_flutter_android.channel.URA4ChannelHandler;
import com.rfid.rfid_flutter_android.channel.URA4EventHandler;
import com.rscja.team.qcom.utility.LogUtility_qcom;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class RfidFlutterAndroidPlugin implements FlutterPlugin {
    private static final String TAG = "RfidFlutter";

    private Context context;

    private ExecutorService executor;

    // 插件初始化
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        executor = Executors.newCachedThreadPool();

        MethodChannel channelURAT = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "rfid_flutter_android/uart");
        channelURAT.setMethodCallHandler(new UARTChannelHandler(context, executor));
        EventChannel uartEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "rfid_flutter_android/uartEvent");
        uartEventChannel.setStreamHandler(new UARTEventHandler());

        MethodChannel channelURA4 = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "rfid_flutter_android/ura4");
        channelURA4.setMethodCallHandler(new URA4ChannelHandler(context, executor));
        EventChannel ura4eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "rfid_flutter_android/ura4Event");
        ura4eventChannel.setStreamHandler(new URA4EventHandler());

        MethodChannel channelDeviceInfo = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "rfid_flutter_android/deviceInfo");
        channelDeviceInfo.setMethodCallHandler(new DeviceInfoChannelHandler(context, executor));

        LogUtility_qcom.setDebug(true);
    }


    // 插件卸载
    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        context = null;
        executor.shutdown();
        executor = null;
    }

}
