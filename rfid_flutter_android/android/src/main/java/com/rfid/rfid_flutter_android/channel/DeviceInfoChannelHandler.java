package com.rfid.rfid_flutter_android.channel;

import android.content.Context;

import androidx.annotation.NonNull;

import com.rfid.rfid_flutter_android.utils.DeviceUtil;
import com.rfid.rfid_flutter_android.utils.LogUtil;
import com.rscja.CWDeviceInfo;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DeviceInfoChannelHandler implements MethodChannel.MethodCallHandler {
    private static final String TAG = "DeviceInfo";

    private final Context context;
    private final ExecutorService executor;

    public DeviceInfoChannelHandler(Context context, ExecutorService executor) {
        this.context = context;
        this.executor = executor;
    }

    // 方法处理器映射表
    private final Map<String, MethodHandler> methodHandlers = new HashMap<String, MethodHandler>() {
        {
            put("getSerialNumber", DeviceInfoChannelHandler.this::getSerialNumber);
            put("getImei", DeviceInfoChannelHandler.this::getImei);
            put("isHandset", DeviceInfoChannelHandler.this::isHandset);

        }
    };

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        executor.execute(() -> {
            try {
                LogUtil.i(TAG, "Method: " + methodCall.method + " with args: " + methodCall.arguments);

                MethodHandler handler = methodHandlers.get(methodCall.method);
                if (handler != null) {
                    handler.handle(methodCall, result);
                } else {
                    result.notImplemented();
                }
            } catch (Exception e) {
                // handler.post(() -> result.error(TAG, "Error: " + e.getMessage(), null));
                result.error(TAG, "Error: " + e.getMessage(), null);
                e.printStackTrace();
            }
        });
    }

    private void getSerialNumber(MethodCall methodCall, MethodChannel.Result result) {
        result.success(DeviceUtil.getSerialNum(context));
    }

    private void getImei(MethodCall methodCall, MethodChannel.Result result) {
        String[] imei2 = new String[1];
        String imei1 = DeviceUtil.getImei(context, imei2);
        Map<String, String> map = new HashMap<>();
        map.put("imei1", imei1);
        map.put("imei2", imei2[0]);
        result.success(map);
    }

    // 判断是否是手持机
    // 不是A4就是手持机
    private void isHandset(MethodCall methodCall, MethodChannel.Result result) {
        result.success(
                !CWDeviceInfo.getDeviceInfo().getModelAndCpu().contains("A4") && !CWDeviceInfo.getDeviceInfo().getModelAndCpu().contains("A8")
        );
    }
}
