package com.rfid.rfid_flutter_android.channel;

import android.os.Handler;
import android.os.Looper;
import android.view.KeyEvent;

import com.rfid.rfid_flutter_android.utils.WindowCallback;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class WindowEventHandler extends WindowCallback implements EventChannel.StreamHandler {
    private static final String TAG = "WindowEventHandler";

    private EventChannel.EventSink eventSink;
    private final Handler handler = new Handler(Looper.getMainLooper());

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;

    }

    @Override
    public void onCancel(Object o) {
        this.eventSink = null;
        handler.removeCallbacksAndMessages(null);
    }


    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        //Log.i(TAG, " ----------- dispatchKeyEvent: " + event);
        if (event.getKeyCode() != KeyEvent.KEYCODE_UNKNOWN) {
            Map<String, Object> map = new HashMap<>();
            map.put("type", "KEY_EVENT");
            map.put("keyCode", event.getKeyCode());
            map.put("keyCodeName", KeyEvent.keyCodeToString(event.getKeyCode()));
            map.put("action", event.getAction());
            handler.post(() -> {
                if (eventSink != null) {
                    eventSink.success(map);
                }
            });
        }
        return super.dispatchKeyEvent(event);
    }

}
