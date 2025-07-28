package com.rfid.rfid_flutter_android.utils;

import static android.os.Build.VERSION.SDK_INT;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.SystemClock;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

import com.rscja.CWDeviceInfo;
import com.rscja.team.qcom.DeviceConfiguration_qcom;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.lang.reflect.Method;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;


public class DeviceUtil {
    private static final String TAG = "DeviceUtil";

    public static String getImei(Context context, String[] imei2) {
        LogUtil.i("DeviceUtil", "getImei " + CWDeviceInfo.getDeviceInfo().getModel() + " " + DeviceConfiguration_qcom.getModel());
        if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_QCM2150_100)) {
            return getImeiC60(context, imei2);
        } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_SMD450_100)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_MTK_6765_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C61P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66_SMD450_90)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
                || CWDeviceInfo.getDeviceInfo().getModelAndCpu().equals(CWDeviceInfo.MC51_4350_140)
        ) {
            return getImeiC60_smd450(context, imei2);
        } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            return getImei_mtk(context, imei2);
        } else {
            LogUtil.i("DeviceUtil", "into else");
            try {
                TelephonyManager manager = (TelephonyManager) context.getSystemService(context.TELEPHONY_SERVICE);
                Class clazz = manager.getClass();
                Method getImei = clazz.getDeclaredMethod("getImei", int.class);//(int slotId)
                //获得IMEI 1的信息：
                Object imei_1 = getImei.invoke(manager, 0);
                //获得IMEI 2的信息：
                Object imei_2 = getImei.invoke(manager, 1);

                if (imei_1 != null && imei_2 != null) {
                    if (imei2 != null && imei2.length > 0) {
                        imei2[0] = imei_2.toString();
                    }
                    return imei_1.toString();
                } else if (imei_1 != null) {
                    return imei_1.toString();
                } else if (imei_2 != null) {
                    return imei_2.toString();
                } else {
                    return null;
                }
            } catch (Exception ignored) {
            }
            return null;
        }
    }


    private static String getImei_mtk(Context context, String[] imei2) {
        String imei1 = Settings.Global.getString(context.getContentResolver(), "Imei1");
        String imei_2 = Settings.Global.getString(context.getContentResolver(), "Imei2");
        if (!TextUtils.isEmpty(imei1)) {
            if (!TextUtils.isEmpty(imei_2)) {
                imei2[0] = imei_2;
            }
        }
        return imei1;
    }

    private static String getImeiC60_smd450(Context context, String[] imei2) {
        String imei1 = Settings.System.getString(context.getContentResolver(), "cw_imei_one");
        String strIMEI2 = Settings.System.getString(context.getContentResolver(), "cw_imei_two");
        if (strIMEI2 != null && imei2 != null && imei2.length > 0) {
            imei2[0] = strIMEI2;
        }
        LogUtil.i(TAG, "getImeiC60_smd450 imei1=" + imei1 + " imei2=" + (imei2 == null ? "null" : imei2[0]));
        return imei1;
    }

    private static String getImeiC60(Context context, String[] imei2) {
        String imei1 = getSystemProperties("persist.quectel.imei1");
        String strIMEI2 = getSystemProperties("persist.quectel.imei2");
        if (strIMEI2 != null && imei2 != null && imei2.length > 0) {
            imei2[0] = strIMEI2;
        }
        return imei1;
    }

    public static String getSystemProperties(String properties) {
        String strState = "";
        try {
            Class systemProperties = Class.forName("android.os.SystemProperties");
            if (systemProperties != null) {
                Method get = systemProperties.getDeclaredMethod("get", String.class);
                if (get != null) {
                    strState = (String) get.invoke(null, properties);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        LogUtil.i("DeviceUtil", "getSystemProperties " + properties + " = " + strState);
        return strState;
    }


    /**
     * 获取设备序列号
     */
    public static String getSerialNum(Context context) {
        try {
            if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)) {
                return getAndroid90Sn();
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_QCM2150_100)
                    || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C61P_SM6115_110)
                    || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66P_SM6115_110)
            ) {
                return getSystemProperties("persist.quectel.sn");
            } else if (CWDeviceInfo.getDeviceInfo().getModelAndCpu().equals(CWDeviceInfo.MC51_4350_140)) {
                return getSystemProperties("persist.sys.quectel.sn");
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_SMD450_100)) {
                return getSNC60_smd450(context);
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_MTK_6765_110)
                    || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
            ) {
                String sn = getSystemProperties("vendor.gsm.serial");
                sn = sn.substring(0, sn.indexOf(" "));
                LogUtil.i("SN", "sn=" + sn + " sn.length=" + sn.length());
                return sn;
            } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
                return Settings.Global.getString(context.getContentResolver(), "Serial");
            } else {
                if (Build.VERSION.SDK_INT >= 26) {
                    return Build.getSerial();
                } else {
                    return Build.SERIAL;
                }
            }
        } catch (Exception e) {
            LogUtil.e("DeviceUtil", "getSerialNum error:" + e);
            return "";
        }
    }

    public static String getAndroid90Sn() {
        Class systemProperties = null;
        Method get = null;
        String strState = "";
        try {
            systemProperties = Class.forName("android.os.SystemProperties");
            if (systemProperties != null)
                get = systemProperties.getDeclaredMethod("get", String.class);
            if (get != null) {
                strState = (String) get.invoke(null, "persist.radio.sn");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        LogUtil.i(TAG, "getAndroid90Sn sn=" + strState);
        return strState;
    }

    private static String getSNC60_smd450(Context context) {
        return Settings.System.getString(context.getContentResolver(), "cw_sn_num");
    }


    public static String getBluetoothAddress(Context context) {
        if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            // need android:sharedUserId="android.uid.system"
            BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();
            if (bluetooth != null) {
                if (!bluetooth.isEnabled()) {
                    return "";
                }
                String btMac = Settings.Global.getString(context.getContentResolver(), "BtMac");
                if (btMac != null && !btMac.isEmpty()) {
                    LogUtil.i(TAG, "btMac=" + btMac);
                    return btMac;
                }
                String address = bluetooth.getAddress();
                if (!TextUtils.isEmpty(address)) {
                    LogUtil.i(TAG, "btMac address=" + address);
                    return address.toLowerCase();
                } else {
                    return "";
                }
            }
            return "";
        } else {
            boolean isSystemApp = isSystemSign(context, context.getPackageName());
            LogUtil.i(TAG, "getBluetoothAddress isSystemApp=" + isSystemApp);
            if (isSystemApp || SDK_INT <= 22) {
                BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();
                LogUtil.i(TAG, "getBluetoothAddress=" + bluetooth);
                if (bluetooth != null) {
                    String address = bluetooth.getAddress();
                    LogUtil.i(TAG, "getBluetoothAddress address=" + address);
                    return address;
                }
                return null;
            }

            String data = Settings.System.getString(context.getContentResolver(), "cw_bt_address");
            LogUtil.i(TAG, "getBluetoothAddress address=" + data);
            if (TextUtils.isEmpty(data)) {
                Intent intent = new Intent();
                intent.setPackage("com.cw.getbtmac");
                intent.setAction("com.cw.getbtmac.READ_BT_MAC");
                context.startService(intent);
                SystemClock.sleep(200);
                data = Settings.System.getString(context.getContentResolver(), "cw_bt_address");
                if (TextUtils.isEmpty(data)) {
                    return "";
                }
            }
            return data;
        }
    }

    public static boolean isSystemSign(Context context, String packageName) {
        PackageManager packageManager = context.getPackageManager();
        int uid1 = getUid(context, packageName);
        int systemUID = 1000;
        if (packageManager.checkSignatures(uid1, systemUID) == PackageManager.SIGNATURE_MATCH) {
            LogUtil.i(TAG, "isSystemApplication: true");
            return true;
        }
        LogUtil.i(TAG, "isSystemApplication: false");
        return false;
    }

    public static int getUid(Context context, String packageName) {
        try {
            PackageManager pm = context.getPackageManager();
            ApplicationInfo ai = pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA);
            //LogUtil.i(TAG, "ai.uid: " + ai.uid);
            return ai.uid;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return -1;
    }


    @SuppressLint("MissingPermission")
    public static String getWifiMac(Context context, boolean isDisabWifi) {

        if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C61P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_MTK_6765_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.MC50_4350_120)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
        ) {
            String mac = Settings.System.getString(context.getContentResolver(), "cw_wifi_mac");
            String mac2 = getSharedPreferences(context, "cw_wifi_mac");
            LogUtil.i(TAG, "getWifiMac mac=" + mac + "  mac2=" + mac2);

            if (TextUtils.isEmpty(mac)) {
                if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)) {
                    mac = getLocalMacAddress6Above();
                }
            }
            LogUtil.i(TAG, "Wifi mac=" + mac);
            //校验是否是我们自己写的地址
            if (!TextUtils.isEmpty(mac)) {
                if (mac.toLowerCase().startsWith("cc") || mac.toLowerCase().startsWith("6c:15:24")) {
                    //系统每次开机都会清除   AppConfig.getAppConfig(getApplicationContext()).setSharedPreferences("cw_wifi_mac",mac); 所以，appcenter把这个值记录一下
                    setSharedPreferences(context, "cw_wifi_mac", mac);
                    return mac;
                }
                return mac;
            }
            if (!TextUtils.isEmpty(mac2)) {
                return mac2;
            }
            return "";
        } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            try {
                String wifiMac = Settings.Global.getString(context.getContentResolver(), "WiFiMac");
                if (wifiMac != null && !wifiMac.isEmpty()) {
                    return wifiMac;
                }
                List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
                for (NetworkInterface nif : all) {
                    if (!nif.getName().equalsIgnoreCase("wlan0")) continue;

                    byte[] macBytes = nif.getHardwareAddress();
                    if (macBytes == null) {
                        return "";
                    }

                    StringBuilder res1 = new StringBuilder();
                    for (byte b : macBytes) {
                        res1.append(String.format("%02X:", b));
                    }

                    if (res1.length() > 0) {
                        res1.deleteCharAt(res1.length() - 1);
                    }
                    return res1.toString();
                }
            } catch (Exception ex) {
            }
            return "02:00:00:00:00:00";
        } else {
            if (Build.VERSION.SDK_INT >= 23) {
                String macAdress = getLocalMacAddress6Above();
                return macAdress;
            }
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
                return getMac();
            }
            WifiManager wifi = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
            WifiInfo info = wifi.getConnectionInfo();
            return (info == null) ? "NULL" : info.getMacAddress();
        }
    }

    public static synchronized boolean isWifiEnabled(Context context) {
        WifiManager mWifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        int state = mWifiManager.getWifiState();
        LogUtil.i(TAG, "getWifiState state=" + state);
        return state == WifiManager.WIFI_STATE_ENABLED || state == WifiManager.WIFI_STATE_ENABLING;
    }

    public static synchronized void enableWifi(Context context) {
        if (isWifiEnabled(context)) {
            return;
        }
        LogUtil.i(TAG, "enableWifi 打开wifi");
        WifiManager mWifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        mWifiManager.setWifiEnabled(true);
    }

    private static String getLocalMacAddress6Above() {
        try {
            List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface nif : all) {
                if (!nif.getName().equalsIgnoreCase("wlan0")) continue;

                byte[] macBytes = nif.getHardwareAddress();
                if (macBytes == null) {
                    return "";
                }
                StringBuilder res1 = new StringBuilder();
                for (byte b : macBytes) {
                    res1.append(String.format("%02X:", b));
                }

                if (res1.length() > 0) {
                    res1.deleteCharAt(res1.length() - 1);
                }
                return res1.toString();
            }
        } catch (Exception ex) {
        }
        return "02:00:00:00:00:00";
    }

    private static String getMac() {
        String macSerial = null;
        String str = "";
        InputStreamReader ir = null;
        LineNumberReader input = null;
        try {
            Process pp = Runtime.getRuntime().exec("cat /sys/class/net/wlan0/address");
            ir = new InputStreamReader(pp.getInputStream());
            input = new LineNumberReader(ir);
            for (; null != str; ) {
                str = input.readLine();
                if (str != null) {
                    macSerial = str.trim();
                    break;
                }
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (ir != null)
                    ir.close();

                if (input != null)
                    input.close();
            } catch (Exception e) {
            }
        }
        return macSerial;
    }

    private static String getSharedPreferences(Context context, String key) {
        return getSP(context).getString(key, "");
    }

    private static SharedPreferences getSP(Context context) {
        return context.getSharedPreferences("config", Context.MODE_PRIVATE);
    }

    private static void setSharedPreferences(Context context, String key, String value) {
        SharedPreferences.Editor editor = getSP(context).edit();
        editor.putString(key, value);
        editor.commit();
    }
}
